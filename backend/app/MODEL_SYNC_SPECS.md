# AI Chess Arena — Live Model Catalog & Reasoning Architecture Specifications

==================================================================================

This document is the authoritative, unified reference for live model catalog discovery, API endpoint verification, payload schemas, prompt engineering architecture, reasoning effort configurations, token headroom mathematics, and design rationale across all supported AI providers (**Anthropic Claude**, **OpenAI**, **Google Gemini**, **DeepSeek**, **OpenRouter**, and **Groq Cloud**).

---

## Table of Contents

1. [Core Architecture & Dynamic Live Sync](#1-core-architecture--dynamic-live-sync)
2. [Prompt Engineering Architecture (Per-Player Custom Prompts & Optimal Default)](#2-prompt-engineering-architecture-per-player-custom-prompts--optimal-default)
3. [Catalog Verification Endpoints & Live JSON Schemas](#3-catalog-verification-endpoints--live-json-schemas)
   - [DeepSeek](#31-deepseek)
   - [Google Gemini](#32-google-gemini)
   - [OpenAI](#33-openai)
   - [Groq Cloud](#34-groq-cloud)
   - [OpenRouter](#35-openrouter)
   - [Anthropic Claude](#36-anthropic-claude)
4. [Reasoning Depth vs. Token Ceilings (Why Both Are Required)](#4-reasoning-depth-vs-token-ceilings-why-both-are-required)
5. [The Unified Token Headroom Formula](#5-the-unified-token-headroom-formula)
6. [Provider-by-Provider Reasoning Request Protocols](#6-provider-by-provider-reasoning-request-protocols)
   - [Anthropic (Extended Thinking & Integer Budget)](#61-anthropic-extended-thinking--integer-budget)
   - [OpenAI (Reasoning Family vs. Standard GPT-4 Chat Family)](#62-openai-reasoning-family-vs-standard-gpt-4-chat-family)
   - [Google Gemini (2.0 Flash Thinking vs. 2.5 / 3.x)](#63-google-gemini-20-flash-thinking-vs-25--3x)
   - [DeepSeek (V4 & Reasoner Two-Phase Stream)](#64-deepseek-v4--reasoner-two-phase-stream)
   - [OpenRouter (Universal Reasoning Gateway)](#65-openrouter-universal-reasoning-gateway)
   - [Groq Cloud (Low-Latency Inference)](#66-groq-cloud-low-latency-inference)
7. [Frontend UI/UX Design Decisions](#7-frontend-uiux-design-decisions)
8. [Comprehensive Multi-Provider Specification Matrix](#8-comprehensive-multi-provider-specification-matrix)
9. [Automated Verification & Test Suite](#9-automated-verification--test-suite)

---

## 1. Core Architecture & Dynamic Live Sync

The AI Chess Arena orchestrates real-time chess play and reasoning streaming across disparate LLM providers using these core principles:

1. **Dynamic Live Sync**: No static or hardcoded default model lists. When a user enters or verifies an API key, models are queried in real time directly from the vendor's upstream gateway.
2. **Official Vendor Identifiers**: Model IDs and display names returned by upstream APIs are preserved as-is.
3. **Native Capability Discovery**: Wherever available, the system relies on native metadata flags (e.g. `capabilities.thinking`, `supported_features: ["reasoning"]`, OpenRouter `reasoning` objects) returned by the provider APIs rather than brittle heuristic regex name guessing.
4. **Safety & Modality Filtering**: Non-text models (audio transcription, speech synthesis, image-only generation, video rendering, embeddings, moderation guards) and retired/shut-down models are automatically filtered out.
5. **Safety & Truncation Guardrails**: Token limits are dynamically scaled when reasoning is active so models never exhaust their allowance mid-calculation.

---

## 2. Prompt Engineering Architecture (Per-Player Custom Prompts & Optimal Default)

System prompts are configured **per player** inside each AI duelist's "Tune" drawer rather than as a rigid global preset.

### 1. Optimal Grandmaster Default Prompt

If no custom instructions are supplied for a player, the backend automatically applies an optimal grandmaster evaluation prompt:

```
"Act like a chess master. Carefully analyze past moves, candidate lines, tactical threats, and positional advantages, and choose the best possible legal move."
```

### 2. Independent Per-Player Instructions

Users can configure completely independent tactical personalities for each side:

- **White AI**: e.g., _"Play aggressively like Mikhail Tal. Seek tactical fireworks and dynamic sacrifices against the enemy king."_
- **Black AI**: e.g., _"Play solid positional defense like Anatoly Karpov. Restrict White counterplay and accumulate small endgame advantages."_

### 3. Guardrail Enforcement

Regardless of custom instructions, the system prompt strictly preserves the structured XML output envelope:

- Reasoning must be enclosed in `<thought>...</thought>`.
- Chosen move must be enclosed in `<move>...</move>` and match one of the listed legal moves.

---

## 3. Catalog Verification Endpoints & Live JSON Schemas

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                 PROVIDER API MATRIX                                    │
├─────────────┬──────────────────────────────────────────┬───────────────────────────────┤
│ Provider    │ Verification & Catalog Endpoint          │ Capability Detection Method   │
├─────────────┼──────────────────────────────────────────┼───────────────────────────────┤
│ DeepSeek    │ https://api.deepseek.com/models          │ Active catalog / V4 native    │
│ Gemini      │ https://generativelanguage.googleapis.com│ Native `"thinking": true`     │
│ OpenAI      │ https://api.openai.com/v1/models         │ `shutdown_date` + o-series    │
│ Groq        │ https://api.groq.com/openai/v1/models    │ Native `supported_features`   │
│ OpenRouter  │ https://openrouter.ai/api/v1/models      │ Native `reasoning` & params   │
│ Anthropic   │ https://api.anthropic.com/v1/models      │ Native `capabilities.thinking`│
└─────────────┴──────────────────────────────────────────┴───────────────────────────────┘
```

---

### 3.1. DeepSeek

- **Endpoint**: `GET https://api.deepseek.com/models`
- **Headers**: `Authorization: Bearer <DEEPSEEK_API_KEY>`

#### Live Response Sample

```json
{
  "object": "list",
  "data": [
    {
      "id": "deepseek-v4-flash",
      "object": "model",
      "owned_by": "deepseek"
    },
    {
      "id": "deepseek-v4-pro",
      "object": "model",
      "owned_by": "deepseek"
    },
    {
      "id": "deepseek-v4-flash-vision-exp",
      "object": "model",
      "owned_by": "deepseek"
    }
  ]
}
```

---

### 3.2. Google Gemini

- **Endpoint**: `GET https://generativelanguage.googleapis.com/v1beta/models?key=<GEMINI_API_KEY>`
- **Alternative Header**: `x-goog-api-key: <GEMINI_API_KEY>`

#### Live Response Sample

```json
{
  "models": [
    {
      "name": "models/gemini-2.5-flash",
      "version": "001",
      "displayName": "Gemini 2.5 Flash",
      "supportedGenerationMethods": ["generateContent", "countTokens"],
      "thinking": true
    },
    {
      "name": "models/gemini-2.5-flash-preview-tts",
      "displayName": "Gemini 2.5 Flash Preview TTS",
      "supportedGenerationMethods": ["generateContent"]
    },
    {
      "name": "models/veo-3.1-generate-preview",
      "supportedGenerationMethods": ["predictLongRunning"]
    },
    {
      "name": "models/gemini-embedding-001",
      "supportedGenerationMethods": ["embedContent"]
    }
  ]
}
```

---

### 3.3. OpenAI

- **Endpoint**: `GET https://api.openai.com/v1/models`
- **Headers**: `Authorization: Bearer <OPENAI_API_KEY>`

#### Live Response Sample

```json
{
  "object": "list",
  "data": [
    {
      "id": "o3-mini",
      "object": "model",
      "created": 1737672203,
      "owned_by": "system",
      "shutdown_date": null
    },
    {
      "id": "gpt-4-0613",
      "object": "model",
      "created": 1686588896,
      "owned_by": "openai",
      "shutdown_date": "2026-10-23"
    },
    {
      "id": "gpt-4-0314",
      "object": "model",
      "shutdown_date": "2024-06-13"
    },
    {
      "id": "whisper-1",
      "object": "model",
      "owned_by": "openai-internal"
    }
  ]
}
```

---

### 3.4. Groq Cloud

- **Endpoint**: `GET https://api.groq.com/openai/v1/models`
- **Headers**: `Authorization: Bearer <GROQ_API_KEY>`

#### Live Response Sample

```json
{
  "data": [
    {
      "id": "qwen/qwen3.8-27b",
      "output_modalities": ["text"],
      "supported_features": ["tools", "json_mode", "reasoning"]
    },
    {
      "id": "openai/gpt-oss-120b",
      "output_modalities": ["text"],
      "supported_features": [
        "tools",
        "json_mode",
        "structured_outputs",
        "reasoning"
      ]
    },
    {
      "id": "whisper-large-v3-turbo",
      "output_modalities": ["transcription"]
    },
    {
      "id": "canopylabs/orpheus-v1-english",
      "output_modalities": ["speech"]
    },
    {
      "id": "meta-llama/llama-prompt-guard-2-22m",
      "context_window": 512
    }
  ]
}
```

---

### 3.5. OpenRouter

- **Endpoint**: `GET https://openrouter.ai/api/v1/models`
- **Headers**: `Authorization: Bearer <OPENROUTER_API_KEY>`

#### Live Response Sample

```json
{
  "data": [
    {
      "id": "inclusionai/ling-3.0-flash-fin:free",
      "name": "Ling 3.0 Flash Fin (free)",
      "supported_parameters": [
        "include_reasoning",
        "reasoning",
        "temperature",
        "max_tokens"
      ],
      "reasoning": {
        "mandatory": false,
        "default_enabled": true
      }
    },
    {
      "id": "z-ai/glm-5.3-flash",
      "name": "Z.ai: GLM 5.3 Flash",
      "supported_parameters": [
        "include_reasoning",
        "reasoning",
        "reasoning_effort"
      ],
      "reasoning": {
        "mandatory": true,
        "default_enabled": true,
        "supported_efforts": ["max", "high", "low"]
      }
    },
    {
      "id": "tencent/hy-mt2-1.8b",
      "name": "Tencent: Hy-MT2-1.8B",
      "supported_parameters": ["max_tokens", "stop", "temperature"],
      "reasoning": null
    }
  ]
}
```

---

### 3.6. Anthropic Claude

- **Endpoint**: `GET https://api.anthropic.com/v1/models`
- **Mandatory Headers**:
  - `x-api-key: <ANTHROPIC_API_KEY>`
  - `anthropic-version: 2023-06-01`

#### Live Response Sample

```json
{
  "data": [
    {
      "id": "claude-opus-5",
      "display_name": "Claude Opus 5",
      "capabilities": {
        "thinking": {
          "supported": true,
          "types": {
            "enabled": { "supported": false },
            "adaptive": { "supported": true }
          }
        },
        "effort": {
          "supported": true
        }
      }
    },
    {
      "id": "claude-sonnet-4-5-20250929",
      "display_name": "Claude Sonnet 4.5",
      "capabilities": {
        "thinking": {
          "supported": true,
          "types": {
            "enabled": { "supported": true },
            "adaptive": { "supported": false }
          }
        },
        "effort": {
          "supported": false
        }
      }
    }
  ]
}
```

---

## 4. Reasoning Depth vs. Token Ceilings (Why Both Are Required)

### The Fundamental Difference

$$\textbf{Thinking Mode / Effort (Algorithm Search Depth)} \neq \textbf{Max Output Tokens (Cost Ceiling)}$$

- **`max_tokens` / `max_completion_tokens` is a Cost & Length Boundary**:
  It defines a hard stopping point (_"Do not generate more than N total tokens under any circumstance"_). It does **not** instruct the model to explore deeper chess variations. Given `max_tokens = 16000` with no reasoning effort instruction, a model evaluating `1. e4` may conclude after 150 tokens: _"1. e4 controls the center. Done."_ and return immediately.
- **Thinking Mode (`low` / `medium` / `high`) is a Search & Verification Policy**:
  It directs the internal inference engine to explore multiple candidate lines, analyze tactical replies, verify king safety, and backtrack through suboptimal branches before committing to a decision.

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                   REASONING EFFORT VS. TOKEN CEILING                                   │
├────────────────────┬───────────────────────────────────────────────────────────────────────────────────┤
│ Setting            │ Internal Model Behavior (Search & Verification Depth)                             │
├────────────────────┼───────────────────────────────────────────────────────────────────────────────────┤
│ `off`              │ • Direct generation (no hidden chain-of-thought phase)                            │
│                    │ • Lowest latency, standard move + commentary output                               │
├────────────────────┼───────────────────────────────────────────────────────────────────────────────────┤
│ `low`              │ • Single-pass tactical evaluation                                                 │
│                    │ • Checks obvious captures and 1-ply threats (~1,024 thinking tokens)              │
├────────────────────┼───────────────────────────────────────────────────────────────────────────────────┤
│ `medium`           │ • Compares 2-3 candidate moves and positional pawn structures                     │
│                    │ • Balanced calculation depth (~4,096 thinking tokens)                             │
├────────────────────┼───────────────────────────────────────────────────────────────────────────────────┤
│ `high`             │ • Multi-branch tree search with exhaustive tactical verification                  │
│                    │ • Explores sacrificial lines, endgames, and king safety (~16,384 thinking tokens) │
└────────────────────┴───────────────────────────────────────────────────────────────────────────────────┘
```

### The Truncation Trap (Why Token Headroom Must Scale)

Reasoning models (such as OpenAI o3-mini or DeepSeek-V4) share a single completion token pool between **hidden reasoning tokens** and **final visible output tokens**:
$$\text{Total Completion Tokens} = \text{Hidden Reasoning Tokens} + \text{Visible Output (Move + Thought)}$$

- **The Problem**: If a user sets `high` reasoning effort but keeps `max_tokens = 500`, the model consumes all 500 tokens inside its internal thought process and runs out of budget before emitting `<move>e4</move>`, resulting in an empty response with `"finish_reason": "length"`.
- **The Solution**: The backend automatically expands the completion token limit when thinking mode is enabled.

---

## 5. The Unified Token Headroom Formula

In `backend/app/models/ai_providers.py`, token limits are calculated as follows:

```python
# Base output tokens allocated strictly for final move and commentary
base_output_tokens = max(150, min(4096, max_output_tokens))  # Default: 500 tokens

# Thinking token budget tiers
budget_map = {
    "low": 1024,
    "medium": 4096,
    "high": 16384
}
```

### Token Allocation Rules

1. **Non-Thinking Models / `thinking_mode == "off"`**:
   $$\text{kwargs["max\_tokens"]} = \text{base\_output\_tokens} = 500 \text{ tokens}$$
   _(Fast direct generation, low cost, strict cap on commentary length)_

2. **Thinking Models (`thinking_mode != "off"`)**:
   $$\text{kwargs["max\_tokens"]} = \text{budget} + \text{base\_output\_tokens}$$
   - **`low`**: $1024 + 500 = \mathbf{1,524 \text{ tokens}}$
   - **`medium`**: $4096 + 500 = \mathbf{4,596 \text{ tokens}}$
   - **`high`**: $16384 + 500 = \mathbf{16,884 \text{ tokens}}$

This guarantees that reasoning models have ample space for multi-branch exploration while preserving a dedicated 500-token window for the final move and commentary.

---

## 6. Provider-by-Provider Reasoning Request Protocols

### 6.1. Anthropic (Extended Thinking & Integer Budget)

```json
{
  "model": "claude-3-7-sonnet-20250219",
  "max_tokens": 4596,
  "temperature": 1.0,
  "thinking": {
    "type": "enabled",
    "budget_tokens": 4096
  },
  "messages": [...]
}
```

- **Minimum Budget**: `budget_tokens` must be $\ge 1,024$.
- **`max_tokens > budget_tokens`**: Mandatory.
- **Fixed Temperature**: Must be set to `1.0`.

---

### 6.2. OpenAI (Reasoning Family vs. Standard GPT-4 Chat Family)

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                       OPENAI MODEL FAMILIES                                            │
├──────────────────────┬──────────────────────────────────────────┬──────────────────────────────────────┤
│ Family               │ Models Included                          │ API Rules & Parameter Behavior       │
├──────────────────────┼──────────────────────────────────────────┼──────────────────────────────────────┤
│ 1. Reasoning Models  │ • GPT-5 series: `gpt-5`, `gpt-5-mini`,   │ • Uses `reasoning_effort`            │
│                      │   `gpt-5.6-sol`, `gpt-5.6-terra`,        │   ("low", "medium", "high")          │
│                      │   `gpt-5.6-luna`                         │ • Disallows custom `temperature`     │
│                      │ • o-series: `o1`, `o1-mini`, `o3`,       │ • Uses `max_completion_tokens`       │
│                      │   `o3-mini`, `o4`, `o4-mini`             │                                      │
├──────────────────────┼──────────────────────────────────────────┼──────────────────────────────────────┤
│ 2. Standard Models   │ • `gpt-4.6`, `gpt-4.5-preview`           │ • Supports full `temperature`        │
│    (Direct Chat)     │ • `gpt-4o`, `gpt-4o-mini`                │   tuning (0.0 to 2.0)                │
│                      │ • `gpt-4-turbo`, `chatgpt-4o-latest`     │ • Standard `max_tokens`              │
│                      │                                          │ • Rejects `reasoning_effort` (HTTP   │
│                      │                                          │   400 error if supplied)             │
└──────────────────────┴──────────────────────────────────────────┴──────────────────────────────────────┘
```

---

### 6.3. Google Gemini (2.0 Flash Thinking vs. 2.5 / 3.x)

- **Gemini 2.0 Flash Thinking**: Configured via integer token budget `thinkingConfig: {"thinkingBudget": 4096, "includeThoughts": true}`.
- **Gemini 2.5 & Gemini 3**: Configured via categorical level `thinking_level: "low" | "medium" | "high"`.
- **Streaming Protocol**: Stream delivers thoughts as `Part` objects with `"thought": true`, which LiteLLM standardizes to `delta.reasoning_content`.

---

### 6.4. DeepSeek (V4 & Reasoner Two-Phase Stream)

```json
{
  "model": "deepseek-v4-pro",
  "extra_body": {
    "thinking": { "type": "enabled" }
  },
  "reasoning_effort": "high",
  "max_tokens": 16884,
  "messages": [...]
}
```

- **Explicit Disable**: When thinking is turned off: `extra_body: {"thinking": {"type": "disabled"}}`.
- **Disallowed Parameters**: `temperature` and `top_p` are ignored/disallowed in thinking mode.
- **Streaming Protocol**: Sequential two-phase stream: `delta.reasoning_content` $\rightarrow$ `delta.content`.

---

### 6.5. OpenRouter (Universal Reasoning Gateway)

```json
{
  "model": "deepseek/deepseek-r1",
  "extra_body": {
    "reasoning": {
      "effort": "high",
      "exclude": false
    }
  },
  "max_tokens": 16884,
  "messages": [...]
}
```

---

### 6.6. Groq Cloud (Low-Latency Inference)

- **Catalog Endpoint**: `GET https://api.groq.com/openai/v1/models`
- **Reasoning Discovery**: Groq natively returns `"reasoning"` inside `supported_features`.

---

## 7. Frontend UI/UX Design Decisions

1. **Preset Chips Over Manual Token Input**:
   - **`Off`** (`500 base`): Fast standard generation.
   - **`Low`** (`+1k think`): Brief tactical sanity check.
   - **`Med`** (`+4k think`): Balanced positional calculation (default).
   - **`High`** (`+16k think`): Deep multi-branch variation tree search.
2. **Standard Model Capability Indicator**:
   When a standard direct-generation model is selected (`gpt-4o`, `gpt-4.6`, `llama-3.3-70b`), the UI displays:
   `ℹ️ Standard chat model — uses direct generation.`
3. **Per-Player System Prompt Tuning**:
   Custom instructions can be defined independently for White AI and Black AI directly within each player's Tune drawer.

---

## 8. Comprehensive Multi-Provider Specification Matrix

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                           COMPREHENSIVE PROVIDER MATRIX                                                     │
├─────────────┬──────────────────────────┬─────────────────────────────┬──────────────────┬─────────────────┬─────────────────┤
│ Provider    │ Reasoning Parameter      │ Temperature Policy          │ Stream Delta     │ Catalog Method  │ Headroom Math   │
├─────────────┼──────────────────────────┼─────────────────────────────┼──────────────────┼─────────────────┼─────────────────┤
│ Anthropic   │ `thinking.budget_tokens` │ Locked to 1.0               │ `delta.thinking` │ `/v1/models`    │ $500 + \text{B}$│
│ OpenAI      │ `reasoning_effort`       │ Omitted / locked            │ `delta.content`  │ `/v1/models`    │ $500 + \text{B}$│
│ Gemini      │ `thinking_level`/`budget`│ Supported                   │ `reasoning_cont` │ `/v1beta/models`│ $500 + \text{B}$│
│ DeepSeek    │ `extra_body.thinking`    │ Omitted / stripped          │ `reasoning_cont` │ `/models`       │ $500 + \text{B}$│
│ OpenRouter  │ `extra_body.reasoning`   │ Passthrough to model        │ `delta.reasoning`│ `/api/v1/models`│ $500 + \text{B}$│
│ Groq        │ Provider passthrough     │ Supported on non-thinking   │ `delta.content`  │ `/openai/v1/mdl`│ $500 + \text{B}$│
└─────────────┴──────────────────────────┴─────────────────────────────┴──────────────────┴─────────────────┴─────────────────┘
```

---

## 9. Automated Verification & Test Suite

All provider parsers, live verification endpoints, system prompt generators, and token optimization guardrails are tested and validated via automated unit and integration tests:

- **Test File**: `backend/tests/test_engine_and_ai.py`
- **Test Command**:
  ```bash
  $env:PYTHONPATH="."; python tests/test_engine_and_ai.py
  # Output: ALL TESTS PASSED
  ```
