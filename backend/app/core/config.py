"""
AI Chess Arena - Application Configuration & Persistence
=========================================================
This module manages:
- File paths for settings and match storage
- Default model roster and supported provider mappings
- Loading, saving, and syncing API keys with environment variables for LiteLLM
"""

import os
import json
from pathlib import Path
from typing import Dict, Any, List
from app.models.schemas import ApiKeysConfig, SettingsPayload, ModelOption, ProviderType

# Base directory paths
BASE_DIR = Path(__file__).resolve().parent.parent.parent
DATA_DIR = BASE_DIR / "data"
GAMES_DIR = DATA_DIR / "games"
SETTINGS_FILE = DATA_DIR / "settings.json"


# ---------------------------------------------------------------------------
# Provider Verification Endpoints
# ---------------------------------------------------------------------------
PROVIDER_VERIFICATION = {
    ProviderType.DEEPSEEK: {
        "url": "https://api.deepseek.com/models",
        "headers": lambda k: {"Authorization": f"Bearer {k}"},
        "name": "DeepSeek",
        "key_field": "deepseek_key",
    },
    ProviderType.GEMINI: {
        "url": lambda k: f"https://generativelanguage.googleapis.com/v1beta/models?key={k}",
        "headers": lambda k: {},
        "name": "Google Gemini",
        "key_field": "gemini_key",
    },
    ProviderType.OPENAI: {
        "url": "https://api.openai.com/v1/models",
        "headers": lambda k: {"Authorization": f"Bearer {k}"},
        "name": "OpenAI",
        "key_field": "openai_key",
    },
    ProviderType.GROQ: {
        "url": "https://api.groq.com/openai/v1/models",
        "headers": lambda k: {"Authorization": f"Bearer {k}"},
        "name": "Groq",
        "key_field": "groq_key",
    },
    ProviderType.OPENROUTER: {
        "url": "https://openrouter.ai/api/v1/models",
        "headers": lambda k: {"Authorization": f"Bearer {k}"},
        "name": "OpenRouter",
        "key_field": "openrouter_key",
    },
    ProviderType.ANTHROPIC: {
        "url": "https://api.anthropic.com/v1/models",
        "headers": lambda k: {"x-api-key": k, "anthropic-version": "2023-06-01"},
        "name": "Anthropic",
        "key_field": "anthropic_key",
    },
}
# Storage & Settings Operations
# ---------------------------------------------------------------------------

def ensure_directories():
    """Ensures that data and games storage directories exist on disk."""
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    GAMES_DIR.mkdir(parents=True, exist_ok=True)


def load_settings() -> SettingsPayload:
    """
    Loads user settings from data/settings.json.
    If the file does not exist, initializes default settings without preloaded keys.
    """
    ensure_directories()
    if SETTINGS_FILE.exists():
        try:
            with open(SETTINGS_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
                return SettingsPayload(**data)
        except Exception as e:
            print(f"Error loading settings: {e}")
    
    # Default settings - keys are empty by default unless present in OS environment
    settings = SettingsPayload(
        keys=ApiKeysConfig(
            deepseek_key=os.getenv("DEEPSEEK_API_KEY", ""),
            openai_key=os.getenv("OPENAI_API_KEY", ""),
            gemini_key=os.getenv("GEMINI_API_KEY", ""),
            anthropic_key=os.getenv("ANTHROPIC_API_KEY", ""),
            groq_key=os.getenv("GROQ_API_KEY", ""),
            openrouter_key=os.getenv("OPENROUTER_API_KEY", ""),
        ),
        default_delay=10,
        models=[],
        include_ascii_board=True,
        history_context_limit=0,
        max_output_tokens=500
    )
    save_settings(settings)
    return settings


def save_settings(settings: SettingsPayload) -> None:
    """
    Persists updated settings to data/settings.json and syncs environment keys.
    """
    ensure_directories()
    with open(SETTINGS_FILE, "w", encoding="utf-8") as f:
        json.dump(settings.model_dump(), f, indent=2)
    sync_env_keys(settings.keys)


def sync_env_keys(keys: ApiKeysConfig):
    """
    Synchronizes configured API keys into the Python process environment variables
    so LiteLLM and vendor SDKs can discover them automatically.
    """
    if keys.deepseek_key:
        os.environ["DEEPSEEK_API_KEY"] = keys.deepseek_key
    if keys.openai_key:
        os.environ["OPENAI_API_KEY"] = keys.openai_key
    if keys.gemini_key:
        os.environ["GEMINI_API_KEY"] = keys.gemini_key
    if keys.anthropic_key:
        os.environ["ANTHROPIC_API_KEY"] = keys.anthropic_key
    if keys.groq_key:
        os.environ["GROQ_API_KEY"] = keys.groq_key
    if keys.openrouter_key:
        os.environ["OPENROUTER_API_KEY"] = keys.openrouter_key

