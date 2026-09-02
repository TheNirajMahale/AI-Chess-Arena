"""
AI Chess Arena - Structured Prompt Engineering & Guardrails
============================================================
This module constructs optimized prompts for AI chess players:
- System prompts that configure tactical style, custom instructions, and reasoning depth
- User prompts supplying full spatial board state (ASCII diagram + FEN + move history)
- Explicit legal move lists in SAN/UCI to prevent illegal hallucinations
- Retry prompts with diagnostic feedback if a model attempts an invalid move format
"""

from typing import List
from app.models.schemas import PlayerConfig, PlayerColor

# Default optimal grandmaster system prompt
DEFAULT_SYSTEM_PROMPT = (
    "You are a World Chess Grandmaster and precision chess engine. "
    "Carefully analyze past moves, candidate lines, tactical threats, and positional advantages, "
    "and choose the most optimal legal move to be played this turn."
)


def build_system_prompt(player_config: PlayerConfig) -> str:
    """
    Builds the system instruction prompt tailored to the player's custom system prompt,
    assigned color (White/Black), and requested thinking effort level.
    Enforces natural, concise 3-5 line commentary explaining the reasoning behind the move.
    """
    # Use per-player custom prompt if provided, else use the optimal default prompt
    if player_config.system_prompt and player_config.system_prompt.strip():
        custom_role = player_config.system_prompt.strip()
    else:
        custom_role = DEFAULT_SYSTEM_PROMPT
    
    # Adjust thinking depth guidance
    if player_config.thinking_mode == "high":
        thinking_instructions = "Provide insightful chess reasoning in a concise 3-5 line explanation."
    elif player_config.thinking_mode == "low":
        thinking_instructions = "Keep your reasoning very brief (1-3 lines), focusing directly on the chosen move."
    else:
        thinking_instructions = "Explain your strategic and tactical reasoning in a natural 3-5 line commentary."

    return f"""{custom_role}

You are playing as {player_config.color.upper()} in a competitive chess match.
Your objective is to evaluate the position, formulate your plan, choose the best legal move, and explain your reasoning clearly and naturally.
{thinking_instructions}

STRICT OUTPUT FORMAT:
- Do NOT describe the board or reconstruct piece locations.
- Provide ONLY your 3-5 line natural reasoning inside <thought>...</thought> (or <reasoning>...</reasoning>).
- State your chosen move inside <move>...</move> tags (must match one of the listed legal moves).

Example output:
<thought>
White claims central space with 1. e4, controlling d5 and opening lines for the bishop and queen. I respond with 1... e5 to directly contest central dominance, activate the dark-squared bishop, and transition into a classical, solid opening structure.
</thought>
<move>e5</move>
"""


def build_user_prompt(
    player_color: PlayerColor,
    fen: str,
    ascii_board: str,
    move_history_str: str,
    legal_moves_san: List[str],
    is_check: bool = False,
    include_ascii: bool = True
) -> str:
    """
    Constructs the turn-by-turn user prompt containing the current board position,
    optional visual board ASCII grid, move history, and full list of legal moves.
    """
    check_warning = "\n⚠️ WARNING: YOUR KING IS CURRENTLY IN CHECK! You must make a legal move to escape check." if is_check else ""
    legal_moves_formatted = ", ".join(f"'{m}'" for m in legal_moves_san)
    board_visual_section = f"\nBoard Visual (White at bottom, Black at top):\n{ascii_board}\n" if include_ascii else ""
    
    return f"""Current Board State:
FEN: {fen}
{board_visual_section}
Move History:
{move_history_str}

It is your turn to move as {player_color.upper()}.{check_warning}

All Legal Moves available to you:
[{legal_moves_formatted}]

CRITICAL INSTRUCTIONS:
1. Explain the reasoning behind your chosen move in 3-5 natural lines inside <thought>...</thought>.
2. Output your EXACT chosen move from the legal move list above inside <move>...</move>.
"""


def build_retry_prompt(
    player_color: PlayerColor,
    attempted_move: str,
    error_reason: str,
    legal_moves_san: List[str]
) -> str:
    """
    Constructs a corrective retry prompt if the model produces an invalid format
    or attempts an illegal move.
    """
    legal_moves_formatted = ", ".join(f"'{m}'" for m in legal_moves_san)
    
    return f"""ERROR: Your proposed move '{attempted_move}' is invalid or illegal: {error_reason}.

Please re-evaluate the position and select a valid legal move strictly from the following legal move list:
[{legal_moves_formatted}]

Provide your revised thought in <thought>...</thought> and your chosen legal move in <move>...</move>.
"""
