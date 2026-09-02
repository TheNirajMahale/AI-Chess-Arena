"""
AI Chess Arena - Live Model Catalog Synchronization Service
============================================================
Fetches real-time available models directly from AI provider APIs (DeepSeek,
Gemini, OpenAI, Groq, OpenRouter, Anthropic) using user API keys.
Reuses provider endpoint configurations and preserves official vendor model names.
"""

import httpx
from datetime import date
from typing import List, Dict, Any, Callable
from fastapi import HTTPException
from app.models.schemas import ProviderType
from app.core.config import PROVIDER_VERIFICATION


# ---------------------------------------------------------------------------
# Provider Response Parsers
# ---------------------------------------------------------------------------

def parse_deepseek(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses DeepSeek `/models` response.
    - DeepSeek retired legacy models (deepseek-chat/reasoner) in favor of the V4 series.
    - All current active models (deepseek-v4-flash, deepseek-v4-pro, vision variants)
      natively support Thinking Mode (toggled via extra_body={'thinking': {'type': 'enabled'}}).
    """
    models = []
    for m in data.get("data", []):
        mid = m.get("id", "")
        models.append({
            "id": f"deepseek/{mid}",
            "name": mid,
            "provider": ProviderType.DEEPSEEK,
            "supports_thinking": True,
            "description": f"DeepSeek model: {mid}"
        })
    return models


def parse_gemini(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses Google Gemini `/v1beta/models` response.
    - Requires `generateContent` in `supportedGenerationMethods`.
    - Strictly filters out non-text/specialized models (image, banana, tts, audio, transcribe,
      veo, lyria, embedding, aqa, robotics, computer-use, deep-research, customtools, antigravity, learnlm).
    - Only includes chat/text generation models (gemini-* and gemma-* instruction models).
    - Checks native `thinking` boolean flag from Google Gemini API metadata.
    """
    models = []
    non_text_keywords = [
        "image", "banana", "tts", "audio", "transcribe", "veo", "lyria",
        "embedding", "aqa", "robotics", "computer-use", "deep-research",
        "customtools", "antigravity", "imagen", "learnlm", "live"
    ]
    for m in data.get("models", []):
        raw_name = m.get("name", "").replace("models/", "")
        raw_lower = raw_name.lower()
        methods = m.get("supportedGenerationMethods") or []
        
        # Must support standard generateContent
        if "generateContent" not in methods:
            continue
            
        # Filter out all non-text models
        if any(skip in raw_lower for skip in non_text_keywords):
            continue
            
        # Must be a valid Gemini or Gemma text/chat model family
        if not (raw_lower.startswith("gemini-") or raw_lower.startswith("gemma-") or "gemini" in raw_lower):
            continue
        
        # Native flag provided by Google Gemini API
        is_thinking = bool(m.get("thinking", False)) or any(tag in raw_lower for tag in ["thinking", "2.5", "3.", "3-", "3.5", "3.6", "3.7"])
        models.append({
            "id": f"gemini/{raw_name}",
            "name": m.get("displayName", raw_name),
            "provider": ProviderType.GEMINI,
            "supports_thinking": is_thinking,
            "description": (m.get("description") or "Google Gemini model")[:120]
        })
    return models


def parse_openai(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses OpenAI `/v1/models` response.
    - OpenAI tracks deprecation via `shutdown_date` (no 'deprecated' or 'status' boolean exists).
      Models with `shutdown_date <= today` are filtered out.
    - Skips audio, realtime, transcribe, tts, image, embeddings, and moderation endpoints.
    - Recognizes o1, o3, o4, and gpt-5 reasoning families with explicit name boundaries.
    """
    models = []
    today = date.today().isoformat()
    for m in data.get("data", []):
        mid = m.get("id", "")
        # Filter out models that are already shut down
        shutdown = m.get("shutdown_date")
        if shutdown and shutdown <= today:
            continue

        mid_lower = mid.lower()
        if any(skip in mid_lower for skip in ["audio", "realtime", "transcribe", "tts", "image", "codex", "embedding", "moderation"]):
            continue

        # Only include valid text/chat model families
        is_text_model = (
            mid_lower.startswith(("gpt-", "chatgpt-", "chat-", "o1-", "o3-", "o4-"))
            or mid_lower in {"o1", "o3", "o4"}
        )
        if not is_text_model:
            continue

        # Explicitly match reasoning families (o1, o3, o4 with hyphen boundaries, and gpt-5)
        is_thinking = (
            mid_lower in {"o1", "o3", "o4"}
            or mid_lower.startswith(("o1-", "o3-", "o4-", "gpt-5"))
        )

        models.append({
            "id": mid,
            "name": mid,
            "provider": ProviderType.OPENAI,
            "supports_thinking": is_thinking,
            "description": f"OpenAI {mid} model"
        })
    return models


def parse_groq(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses Groq `/openai/v1/models` response.
    - Requires 'text' in `output_modalities` (excludes whisper transcription and orpheus speech models).
    - Filters out moderation guard classifiers (e.g. llama-prompt-guard).
    - Groq API natively returns `"supported_features": ["reasoning", ...]` on reasoning models.
    """
    models = []
    for m in data.get("data", []):
        mid = m.get("id", "")
        out_modalities = m.get("output_modalities") or []
        if out_modalities and "text" not in out_modalities:
            continue
        if any(skip in mid.lower() for skip in ["whisper", "guard", "tts", "embedding"]):
            continue

        # Groq API natively returns `"supported_features": ["reasoning", ...]`
        features = m.get("supported_features") or []
        is_thinking = "reasoning" in features
        models.append({
            "id": f"groq/{mid}",
            "name": mid,
            "provider": ProviderType.GROQ,
            "supports_thinking": is_thinking,
            "description": f"Groq inference: {mid}"
        })
    return models


def parse_openrouter(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses OpenRouter `/api/v1/models` response.
    - OpenRouter indicates reasoning support via two native properties:
      1. A non-null `reasoning` config dictionary (e.g. {"mandatory": false, "default_enabled": true}).
      2. The presence of 'reasoning' or 'include_reasoning' in `supported_parameters`.
    """
    models = []
    for m in data.get("data", []):
        mid = m.get("id", "")
        supported_params = m.get("supported_parameters") or []
        has_reasoning = bool(m.get("reasoning")) or ("include_reasoning" in supported_params) or ("reasoning" in supported_params)
        models.append({
            "id": f"openrouter/{mid}",
            "name": m.get("name", mid),
            "provider": ProviderType.OPENROUTER,
            "supports_thinking": has_reasoning,
            "description": (m.get("description") or f"OpenRouter: {mid}")[:120]
        })
    return models


def parse_anthropic(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Parses Anthropic `/v1/models` response.
    - Requires mandatory 'anthropic-version: 2023-06-01' header.
    - Anthropic API natively returns `"capabilities": {"thinking": {"supported": true}}`
      across Claude 3.7, 4.x, and Claude 5 models.
    """
    models = []
    for m in data.get("data", []):
        mid = m.get("id", "")
        disp = m.get("display_name", mid)
        caps = m.get("capabilities") or {}
        is_thinking = (caps.get("thinking") or {}).get("supported") is True
        models.append({
            "id": f"anthropic/{mid}",
            "name": disp,
            "provider": ProviderType.ANTHROPIC,
            "supports_thinking": is_thinking,
            "description": f"Anthropic: {disp}"
        })
    return models


MODEL_PARSERS: Dict[ProviderType, Callable[[Dict[str, Any]], List[Dict[str, Any]]]] = {
    ProviderType.DEEPSEEK: parse_deepseek,
    ProviderType.GEMINI: parse_gemini,
    ProviderType.OPENAI: parse_openai,
    ProviderType.GROQ: parse_groq,
    ProviderType.OPENROUTER: parse_openrouter,
    ProviderType.ANTHROPIC: parse_anthropic,
}


# ---------------------------------------------------------------------------
# Reusable Fetch Logic
# ---------------------------------------------------------------------------

async def fetch_remote_models(provider: ProviderType, key: str) -> List[Dict[str, Any]]:
    """
    Reuses PROVIDER_VERIFICATION endpoint configuration to fetch and parse
    live models in a unified HTTP pipeline.
    """
    config = PROVIDER_VERIFICATION.get(provider)
    parser = MODEL_PARSERS.get(provider)
    if not config or not parser:
        raise HTTPException(status_code=400, detail=f"Provider {provider} not supported for live fetching")

    url = config["url"](key) if callable(config["url"]) else config["url"]
    headers = config["headers"](key)

    try:
        async with httpx.AsyncClient(timeout=12.0) as client:
            res = await client.get(url, headers=headers)
            if res.status_code == 200:
                return parser(res.json())
            
            raise HTTPException(status_code=res.status_code, detail=f"{config['name']} API Error: {res.text[:150]}")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


async def sync_all_provider_models(settings: Any) -> List[Any]:
    """
    Auto-syncs live models concurrently from all configured providers using their saved API keys.
    Completely replaces old/stale models for re-synced providers with the fresh live catalog.
    """
    import asyncio
    from app.models.schemas import ModelOption
    from app.core.config import save_settings
    
    key_mapping = {
        ProviderType.DEEPSEEK: getattr(settings.keys, "deepseek_key", ""),
        ProviderType.OPENAI: getattr(settings.keys, "openai_key", ""),
        ProviderType.GEMINI: getattr(settings.keys, "gemini_key", ""),
        ProviderType.ANTHROPIC: getattr(settings.keys, "anthropic_key", ""),
        ProviderType.GROQ: getattr(settings.keys, "groq_key", ""),
        ProviderType.OPENROUTER: getattr(settings.keys, "openrouter_key", ""),
    }

    synced_providers = set()

    async def fetch_one(prov: ProviderType, k: str):
        try:
            res = await fetch_remote_models(prov, k.strip())
            return prov, res
        except Exception as e:
            print(f"[Auto-Sync] Warning: Failed to sync {prov.value}: {e}")
            return prov, None

    tasks = [
        fetch_one(provider, key)
        for provider, key in key_mapping.items()
        if key and key.strip() and "..." not in key and "***" not in key
    ]

    fresh_models_by_provider = {}
    if tasks:
        results = await asyncio.gather(*tasks, return_exceptions=True)
        for item in results:
            if isinstance(item, tuple) and len(item) == 2:
                prov, models_list = item
                if models_list is not None and len(models_list) > 0:
                    synced_providers.add(prov)
                    fresh_models_by_provider[prov] = [ModelOption(**m) for m in models_list]

    # Reconstruct models list: retain existing models for un-synced providers,
    # and replace with fresh models for all successfully synced providers.
    updated_models = [
        m for m in settings.models
        if m.provider not in synced_providers
    ]

    for prov in synced_providers:
        updated_models.extend(fresh_models_by_provider.get(prov, []))

    settings.models = updated_models
    save_settings(settings)
    return settings.models

