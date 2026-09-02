"""
AI Chess Arena - Multi-LLM Provider Engine & Reasoning Streaming
=================================================================
This module orchestrates communication with AI models:
- Universal model invocation via LiteLLM (Gemini, OpenAI, Anthropic, Groq, OpenRouter)
- Real-time token streaming capturing both native reasoning tokens (`reasoning_content`) and standard output
- Extraction of reasoning thought blocks (`<thought>...</thought>`) and chosen moves (`<move>...</move>`)
- Robust multi-stage regex and fuzzy fallback parsers for tolerant move extraction
"""

import re
import os
import time
import asyncio
from typing import AsyncGenerator, Dict, Any, Tuple, Optional, List
import chess

from app.models.schemas import PlayerConfig, ProviderType, PlayerColor
from app.prompts.chess_prompts import build_system_prompt, build_user_prompt, build_retry_prompt

# ---------------------------------------------------------------------------
# Output Parsing & Move Extraction
# ---------------------------------------------------------------------------

def clean_reasoning_text(text: str) -> str:
    """
    Rigorously cleans reasoning transcripts by removing raw XML tags (<thought>, <reasoning>, <move>),
    move declarations, internal scratchpad meta-talk, board inventory boilerplate, and JSON structures.
    """
    if not text:
        return ""
    # Strip <move>...</move> and all contents within it
    cleaned = re.sub(r"<move>.*?</move>", "", text, flags=re.DOTALL | re.IGNORECASE)
    # Strip any open/close XML formatting tags
    cleaned = re.sub(r"</?(?:thought|reasoning|reasoning behind move|think|move)>", "", cleaned, flags=re.IGNORECASE)
    
    # Strip meta phrases like "Final check of format.", "Refining for conciseness..."
    cleaned = re.sub(r"Final check of format\.?", "", cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r"Refining for conciseness.*?:\s*", "", cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r"Need concise 5-10 lines\.?", "", cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r"Move:\s*[A-Za-z0-9+#=-]+\.?", "", cleaned, flags=re.IGNORECASE)

    # Strip FEN and board reconstruction boilerplate that models like gpt-oss-120b output
    cleaned = re.sub(r'We (?:need to|have to|must) analyze.*?(?=\n|$)', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'FEN:\s*[a-zA-Z0-9/+\- ]+', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'\b[rnbqkpRNBQKP1-8/]{15,}\s+[wb]\s+[KQkq\-]+[^\n]*', '', cleaned)
    cleaned = re.sub(r'(?:White|Black|Starting)?\s*pieces\s*:[^\n]+', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'(?:Row|Rank)\s*[0-9]\s*:[^\n]+', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'Material\s*(?:equal|count|is)[^\n]*', '', cleaned, flags=re.IGNORECASE)

    # If the text is a multi-paragraph verbose monologue, extract the actual tactical evaluation & decision
    paragraphs = [p.strip() for p in cleaned.split('\n') if p.strip()]
    if len(paragraphs) > 4:
        concluding = [p for p in paragraphs if any(k in p.lower() for k in ['threat', 'tactic', 'best is', 'candidate', 'develop', 'plan', 'saf', 'decision', 'control', 'fight', 'improve'])]
        if concluding:
            cleaned = '\n'.join(concluding[-3:])
        else:
            cleaned = '\n'.join(paragraphs[-3:])
    else:
        cleaned = '\n'.join(paragraphs)

    # Strip trailing "Selected move: ..." or "Final move: ..." declarations
    cleaned = re.sub(r"(?:Selected|Chosen|Final)\s+move\s*:.*$", "", cleaned, flags=re.IGNORECASE)
    return cleaned.strip()


def extract_move_and_reasoning(raw_text: str, legal_moves_san: List[str], legal_moves_uci: List[str]) -> Tuple[str, str]:
    """
    Extracts the inner reasoning transcript and selected move string from the LLM output.
    Employs layered fallback strategies:
    1. Primary: <thought>...</thought>, <reasoning>...</reasoning>, and <move>...</move> tags
    2. Secondary: JSON object pattern {"move": "..."}
    3. Tertiary: Natural language keyword regex (e.g. "Move: e4", "Selected: Nf3", "Decision: e4")
    4. Guardrail: Markdown-stripped reverse token scan against legal SAN/UCI moves
    5. Substring pattern match against legal move roster
    6. Failsafe: Default to top legal move if model produced output but omitted move
    """
    reasoning = ""
    move = ""
    
    # 1. Extract thought content from <thought>, <reasoning>, or <think>
    thought_match = re.search(r"<(?:thought|reasoning|reasoning behind move|think)>(.*?)</(?:thought|reasoning|reasoning behind move|think)>", raw_text, re.DOTALL | re.IGNORECASE)
    if thought_match:
        reasoning = thought_match.group(1).strip()
    else:
        before_move = re.split(r"<move>", raw_text, flags=re.IGNORECASE)
        if len(before_move) > 1:
            reasoning = before_move[0].strip()
        else:
            reasoning = raw_text.strip()

    # 2. Extract chosen move from <move>...</move>
    move_match = re.search(r"<move>(.*?)</move>", raw_text, re.DOTALL | re.IGNORECASE)
    if move_match:
        move = move_match.group(1).strip()
    else:
        # Fallback Strategy 1: JSON format {"move": "e4"}
        json_move = re.search(r'["\']move["\']\s*:\s*["\']([^"\']+)["\']', raw_text, re.IGNORECASE)
        if json_move:
            move = json_move.group(1).strip()
        else:
            # Fallback Strategy 2: Natural language keywords ("Move: e4", "Decision: Nf3", "Play: e4")
            kw_move = re.search(r'(?:move|play|choose|chosen|selected|decision|verdict|recommendation)\s*(?:is|:|=)\s*(?:\*\*)?([A-Za-z0-9+#=-]+)', raw_text, re.IGNORECASE)
            if kw_move:
                move = kw_move.group(1).strip()
            else:
                # Fallback Strategy 3: Strip markdown and scan tokens from end of text
                raw_tokens = re.findall(r'[^\s\(\)\[\]\{\}<>]+', raw_text)
                candidate_tokens = []
                for tok in raw_tokens:
                    cleaned_tok = re.sub(r'^[0-9]+\.|\*|_|`|["\',:;]', '', tok).strip()
                    if cleaned_tok:
                        candidate_tokens.append(cleaned_tok)

                for tok in reversed(candidate_tokens):
                    if tok in legal_moves_san or tok in legal_moves_uci:
                        move = tok
                        break

    # Strip surrounding whitespace or markdown punctuation
    move = re.sub(r'^[0-9]+\.|\*|_|`|["\',:; ]', '', move).strip()

    # Fallback Strategy 4: Substring regex match against legal moves (longest first)
    if (not move or (move not in legal_moves_san and move not in legal_moves_uci)) and legal_moves_san:
        for lm in sorted(legal_moves_san, key=len, reverse=True):
            pattern = r'(?:\b|\*|_)' + re.escape(lm) + r'(?:\b|\*|_|\.|\!|\?|$)'
            if re.search(pattern, raw_text):
                move = lm
                break

    # Fallback Strategy 5: Safety default if model provided thought but move couldn't be parsed
    if (not move or (move not in legal_moves_san and move not in legal_moves_uci)) and legal_moves_san:
        move = legal_moves_san[0]

    reasoning = clean_reasoning_text(reasoning)
    return reasoning, move


# ---------------------------------------------------------------------------
# Multi-LLM Streaming Orchestrator
# ---------------------------------------------------------------------------

def sanitize_error_message(err: Exception, player_name: str, model_id: str, provider: str) -> Tuple[str, bool]:
    """
    Parses vendor / LiteLLM exception strings and extracts a clean, human-readable one-liner.
    Returns (clean_message, should_retry_bool).
    """
    raw_str = str(err)
    lower_str = raw_str.lower()

    # 1. Quota / Plan Limit / Free-tier Exhaustion (Do NOT retry - fail immediately)
    if any(k in lower_str for k in [
        "quota exceeded", "exceeded your current quota", "free_tier_requests",
        "insufficient_quota", "credit balance is too low", "billing details",
        "generativelanguage.googleapis.com/generate_content_free_tier",
        "generaterequestsperday", "resource_exhausted"
    ]):
        return (
            f"API Quota Exceeded: Your request quota for {player_name} ({model_id}) has been exhausted. Please switch to another model or check billing.",
            False
        )

    # 2. Authentication / Invalid Key (Do NOT retry)
    if any(k in lower_str for k in ["401", "invalid_api_key", "invalid api key", "incorrect api key", "authentication", "unauthorized", "api key not valid"]):
        return (
            f"Invalid API Key: Authentication failed for {player_name} ({provider.upper()}). Please check your API key in Settings & Keys.",
            False
        )

    # 3. Model Not Found / Unsupported (Do NOT retry)
    if any(k in lower_str for k in ["404", "model_not_found", "model not found", "does not exist", "not supported for this"]):
        return (
            f"Model Unavailable: '{model_id}' is not accessible with your current {provider.upper()} API key.",
            False
        )

    # 4. Transient High Demand / 503 / Capacity Overload (Should retry)
    if any(k in lower_str for k in ["503", "high demand", "spikes in demand", "service unavailable", "overloaded", "temporary", "timeout"]):
        return (
            f"Server Unavailable: {player_name} ({model_id}) is experiencing high demand after 6 retries. Please pick another model.",
            True
        )

    # 5. Generic Error - extract first sentence or JSON message attribute
    msg_match = re.search(r'["\']message["\']\s*:\s*["\']([^"\']+)["\']', raw_str)
    if msg_match:
        clean_sub = msg_match.group(1).replace("\\n", " ").strip()
        return (f"API Error ({player_name}): {clean_sub[:140]}", False)

    first_line = raw_str.split("\n")[0]
    first_line = re.sub(r'^(?:litellm\.[A-Za-z0-9_]+:\s*)+', '', first_line).strip()
    return (f"API Error ({player_name}): {first_line[:140]}", False)


async def generate_ai_move_stream(
    board: chess.Board,
    player_config: PlayerConfig,
    ascii_board: str,
    move_history_str: str,
    legal_moves_san: List[str],
    legal_moves_uci: List[str],
    include_ascii: bool = True,
    max_output_tokens: int = 500
) -> AsyncGenerator[Dict[str, Any], None]:
    """
    Asynchronously streams token chunks from the selected AI model via LiteLLM:
    - Automatically retries transient 503 high-demand errors up to 6 times.
    - Fails immediately on quota, auth, and billing errors with clean one-line messages.
    - Yields `{"type": "thought_chunk", "content": "..."}` as thoughts arrive.
    - Yields `{"type": "final_result", "reasoning": "...", "move": "...", "raw_output": "..."}` upon finish.
    """
    import litellm
    # Automatically drop unsupported kwargs for models that don't support temperature or thinking
    litellm.drop_params = True

    # Assemble structured system and user prompts
    system_prompt = build_system_prompt(player_config)
    user_prompt = build_user_prompt(
        player_color=player_config.color,
        fen=board.fen(),
        ascii_board=ascii_board,
        move_history_str=move_history_str,
        legal_moves_san=legal_moves_san,
        is_check=board.is_check(),
        include_ascii=include_ascii
    )

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt}
    ]

    # Format model prefix for LiteLLM routing
    model_name = player_config.model_id
    if player_config.provider == ProviderType.DEEPSEEK and not model_name.startswith("deepseek/"):
        model_name = f"deepseek/{model_name}"
    elif player_config.provider == ProviderType.GEMINI and not model_name.startswith("gemini/"):
        model_name = f"gemini/{model_name}"
    elif player_config.provider == ProviderType.GROQ and not model_name.startswith("groq/"):
        model_name = f"groq/{model_name}"
    elif player_config.provider == ProviderType.OPENROUTER and not model_name.startswith("openrouter/"):
        model_name = f"openrouter/{model_name}"
    elif player_config.provider == ProviderType.ANTHROPIC and not model_name.startswith("anthropic/"):
        model_name = f"anthropic/{model_name}"

    # Base max tokens for standard non-thinking generation
    base_output_tokens = max(150, min(4096, max_output_tokens))

    kwargs: Dict[str, Any] = {
        "model": model_name,
        "messages": messages,
        "temperature": player_config.temperature,
        "max_tokens": base_output_tokens,
        "stream": True,
        "timeout": 45.0,
        "drop_params": True
    }

    # Configure reasoning effort and token budget tailored specifically to each provider's native API
    thinking_mode = player_config.thinking_mode
    model_name_lower = model_name.lower()

    if thinking_mode != "off":
        effort = "low" if thinking_mode == "low" else "high" if thinking_mode in ["high", "max"] else "medium"
        budget_map = {"low": 1024, "medium": 4096, "high": 16384}
        budget = player_config.thinking_budget if (player_config.thinking_budget and player_config.thinking_budget > 0) else budget_map.get(thinking_mode, 4096)
        
        # When thinking is enabled, grant combined headroom: base output (500) + thinking budget
        kwargs["max_tokens"] = budget + base_output_tokens

        if player_config.provider == ProviderType.ANTHROPIC:
            # Anthropic requires an integer budget >= 1024, max_tokens > budget_tokens, and temperature = 1.0
            budget = max(1024, budget)
            kwargs["max_tokens"] = budget + base_output_tokens
            if any(v in model_name_lower for v in ["3-7", "3.7", "4-", "4.", "-4", "5-", "5.", "-5", "sonnet", "opus"]):
                kwargs["thinking"] = {"type": "enabled", "budget_tokens": budget}
                kwargs["temperature"] = 1.0  # Required by Anthropic API when extended thinking is enabled

        elif player_config.provider == ProviderType.OPENAI:
            # OpenAI o-series (o1, o3, o4) and GPT-5 reasoning models
            if any(tag in model_name_lower for tag in ["o1", "o3", "o4", "gpt-5"]):
                kwargs["reasoning_effort"] = effort
                kwargs.pop("temperature", None)

        elif player_config.provider == ProviderType.DEEPSEEK:
            # DeepSeek V4 official Thinking Mode API
            kwargs["extra_body"] = {"thinking": {"type": "enabled"}}
            kwargs["reasoning_effort"] = effort
            kwargs.pop("temperature", None)

        elif player_config.provider == ProviderType.GEMINI:
            # Gemini 2.5 and 3.x thinking models
            if any(v in model_name_lower for v in ["gemini-3", "gemini-2.5", "thinking"]):
                kwargs["thinking_level"] = effort
            elif "2.0-flash-thinking" in model_name_lower:
                kwargs["thinking_budget"] = budget

        elif player_config.provider == ProviderType.OPENROUTER:
            # OpenRouter reasoning gateway configuration
            kwargs["extra_body"] = {"reasoning": {"effort": effort}}
    else:
        if player_config.provider == ProviderType.DEEPSEEK:
            # Explicitly disable thinking mode when set to 'off'
            kwargs["extra_body"] = {"thinking": {"type": "disabled"}}

    MAX_RETRIES = 6
    RETRY_DELAY_SEC = 1.0

    for attempt in range(1, MAX_RETRIES + 1):
        accumulated_content = ""
        accumulated_reasoning = ""
        in_think_block = False
        sent_thinking_notice = False

        try:
            # Stream response chunks from the provider
            response = await litellm.acompletion(**kwargs)
            async for chunk in response:
                delta = chunk.choices[0].delta
                
                # Check for native reasoning tokens (e.g. DeepSeek R1 / Claude 3.7 / o1 / Gemini thinking)
                reasoning_chunk = getattr(delta, "reasoning_content", None) or getattr(delta, "thinking", None)
                content_chunk = getattr(delta, "content", "") or ""

                if reasoning_chunk:
                    accumulated_reasoning += reasoning_chunk
                    yield {"type": "thought_chunk", "content": reasoning_chunk}
                
                if content_chunk:
                    accumulated_content += content_chunk
                    
                    # Handle <think>...</think> block transitions cleanly
                    if "<think>" in content_chunk:
                        in_think_block = True
                    
                    if in_think_block:
                        if "</think>" in content_chunk:
                            in_think_block = False
                            after_think = content_chunk.split("</think>")[-1]
                            if after_think:
                                yield {"type": "thought_chunk", "content": after_think}
                        else:
                            if not sent_thinking_notice:
                                yield {"type": "thought_chunk", "content": "Analyzing position...\n\n"}
                                sent_thinking_notice = True
                    else:
                        # Clean out any leftover tags and stream live
                        chunk_to_send = content_chunk.replace("<think>", "").replace("</think>", "")
                        if chunk_to_send:
                            yield {"type": "thought_chunk", "content": chunk_to_send}

            # Parse final accumulated text - strip raw <think> scratchpads
            clean_content = re.sub(r"<think>.*?</think>", "", accumulated_content, flags=re.DOTALL | re.IGNORECASE).strip()
            reasoning, move = extract_move_and_reasoning(clean_content or accumulated_content, legal_moves_san, legal_moves_uci)
            
            # If no move found in clean content, check the full combined stream
            if not move:
                full_text = (accumulated_reasoning + "\n" + accumulated_content) if accumulated_reasoning else accumulated_content
                reasoning, move = extract_move_and_reasoning(full_text, legal_moves_san, legal_moves_uci)
            elif not reasoning and accumulated_reasoning:
                reasoning = clean_reasoning_text(accumulated_reasoning)

            full_text = (accumulated_reasoning + "\n" + clean_content) if accumulated_reasoning else clean_content

            yield {
                "type": "final_result",
                "reasoning": reasoning,
                "move": move,
                "raw_output": full_text
            }
            return  # Succeeded, exit loop

        except Exception as e:
            clean_msg, is_transient = sanitize_error_message(e, player_config.name, player_config.model_id, player_config.provider.value)

            if is_transient and attempt < MAX_RETRIES:
                yield {
                    "type": "thought_chunk",
                    "content": f"\n\n⏳ [Model server busy (503 / High demand). Retrying in 1s... (Attempt {attempt}/{MAX_RETRIES})]\n\n"
                }
                await asyncio.sleep(RETRY_DELAY_SEC)
                continue
            else:
                yield {
                    "type": "error",
                    "error": clean_msg
                }
                return
