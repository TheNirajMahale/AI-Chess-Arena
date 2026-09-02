"""
AI Chess Arena - FastAPI Application Server
===========================================
This module serves as the central HTTP and WebSocket server for the platform:
- REST API endpoints for settings, key validation, model catalog, and match archives
- WebSocket endpoint `/ws/game` for bi-directional real-time match streaming
- Strict API key guardrails preventing match startup without valid credentials
"""

import os
import re
import asyncio
import httpx
from pathlib import Path
from typing import List, Dict, Any
from dotenv import load_dotenv
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware

# Load environment variables on initialization
load_dotenv()

def validate_game_id(game_id: str) -> str:
    """Validates game_id to prevent path traversal vulnerabilities."""
    if not game_id or not re.match(r"^[a-zA-Z0-9_-]+$", game_id):
        raise HTTPException(status_code=400, detail="Invalid game ID format")
    return game_id

from app.models.schemas import (
    SettingsPayload, GameControlRequest, TestKeyRequest,
    ModelOption, ProviderType, PlayerConfig
)
from app.core.config import (
    load_settings, save_settings, sync_env_keys,
    BASE_DIR, PROVIDER_VERIFICATION
)
from app.services.game_service import game_service, validate_player_key
from app.services.history_service import list_games, get_game, delete_game
from app.services.model_service import fetch_remote_models, sync_all_provider_models

# Initialize FastAPI application
app = FastAPI(
    title="AI Chess Arena Backend",
    description="Real-time multi-LLM chess battleground and reasoning visualizer",
    version="1.0.0"
)

# Configure Cross-Origin Resource Sharing (CORS) for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------------------------------------------------------------------------
# Application Lifecycle
# ---------------------------------------------------------------------------

@app.on_event("startup")
async def startup_event():
    """Initializes configuration and syncs stored API keys to OS environment on launch."""
    settings = load_settings()
    sync_env_keys(settings.keys)


# ---------------------------------------------------------------------------
# Settings & Model Catalog Endpoints
# ---------------------------------------------------------------------------

@app.get("/api/settings")
def get_settings():
    """
    Returns stored application settings for presentation and editing in the user interface.
    """
    settings = load_settings()
    masked_keys = settings.keys.model_copy()
    
    # Mask API key strings for preview
    if masked_keys.deepseek_key:
        masked_keys.deepseek_key = masked_keys.deepseek_key[:6] + "..." + masked_keys.deepseek_key[-4:] if len(masked_keys.deepseek_key) > 10 else "***"
    if masked_keys.openai_key:
        masked_keys.openai_key = masked_keys.openai_key[:6] + "..." + masked_keys.openai_key[-4:] if len(masked_keys.openai_key) > 10 else "***"
    if masked_keys.gemini_key:
        masked_keys.gemini_key = masked_keys.gemini_key[:6] + "..." + masked_keys.gemini_key[-4:] if len(masked_keys.gemini_key) > 10 else "***"
    if masked_keys.anthropic_key:
        masked_keys.anthropic_key = masked_keys.anthropic_key[:6] + "..." + masked_keys.anthropic_key[-4:] if len(masked_keys.anthropic_key) > 10 else "***"
    if masked_keys.groq_key:
        masked_keys.groq_key = masked_keys.groq_key[:6] + "..." + masked_keys.groq_key[-4:] if len(masked_keys.groq_key) > 10 else "***"
    if masked_keys.openrouter_key:
        masked_keys.openrouter_key = masked_keys.openrouter_key[:6] + "..." + masked_keys.openrouter_key[-4:] if len(masked_keys.openrouter_key) > 10 else "***"
    
    return {
        "settings": settings,
        "masked_keys": masked_keys
    }


@app.post("/api/settings")
async def update_settings(payload: SettingsPayload):
    """
    Updates and persists application settings. Retains existing unmasked keys
    if the incoming payload contains masked placeholder tokens ('...' or '***').
    Immediately returns success while auto-syncing model catalogs asynchronously in the background.
    """
    current = load_settings()
    key_fields = ["deepseek_key", "openai_key", "gemini_key", "anthropic_key", "groq_key", "openrouter_key"]
    for field in key_fields:
        val = getattr(payload.keys, field, "")
        if "..." in val or "***" in val:
            setattr(payload.keys, field, getattr(current.keys, field, ""))

    save_settings(payload)
    
    # Run auto-sync asynchronously in the background so save returns in milliseconds
    async def bg_sync():
        try:
            await sync_all_provider_models(payload)
        except Exception as e:
            print(f"[Settings Background Sync] Warning: {e}")

    asyncio.create_task(bg_sync())

    return {"status": "success", "message": "Settings saved instantly"}


@app.post("/api/sync-models")
async def sync_models_endpoint():
    """
    Explicitly triggers auto-sync of live model catalogs across all configured AI providers.
    """
    settings = load_settings()
    updated_models = await sync_all_provider_models(settings)
    return {"status": "success", "models": updated_models}


@app.get("/api/models")
def get_available_models():
    """
    Returns the list of AI models, annotating each model with `is_configured: True`
    ONLY if the user has provided the corresponding provider's API key.
    """
    settings = load_settings()
    keys = settings.keys
    
    # Check which providers have valid non-empty credentials
    has_deepseek = bool(keys.deepseek_key.strip())
    has_openai = bool(keys.openai_key.strip())
    has_gemini = bool(keys.gemini_key.strip())
    has_anthropic = bool(keys.anthropic_key.strip())
    has_groq = bool(keys.groq_key.strip())
    has_openrouter = bool(keys.openrouter_key.strip())

    all_models = settings.models
    
    result = []
    configured_models = []

    for m in all_models:
        configured = False
        if m.provider == ProviderType.DEEPSEEK and has_deepseek:
            configured = True
        elif m.provider == ProviderType.OPENAI and has_openai:
            configured = True
        elif m.provider == ProviderType.GEMINI and has_gemini:
            configured = True
        elif m.provider == ProviderType.ANTHROPIC and has_anthropic:
            configured = True
        elif m.provider == ProviderType.GROQ and has_groq:
            configured = True
        elif m.provider == ProviderType.OPENROUTER and has_openrouter:
            configured = True

        item = {
            **m.model_dump(),
            "is_configured": configured
        }
        result.append(item)
        if configured:
            configured_models.append(item)

    return {
        "models": result,
        "configured_models": configured_models,
        "configured_count": len(configured_models)
    }


@app.post("/api/test-key")
async def test_api_key(req: TestKeyRequest):
    """
    Performs a lightweight verification ping against the selected AI provider's API
    to check key validity and returns immediate diagnostic feedback.
    """
    provider = req.provider
    key = req.api_key.strip()
    
    # If the key passed is a masked placeholder, resolve the unmasked key from storage
    if "..." in key or "***" in key or not key:
        saved_settings = load_settings()
        key_attr = f"{provider.value}_key"
        key = getattr(saved_settings.keys, key_attr, "").strip()

    if not key:
        return {"valid": False, "message": "API key cannot be empty"}

    config = PROVIDER_VERIFICATION.get(provider)
    if not config:
        return {"valid": False, "message": f"Unknown provider: {provider}"}

    url = config["url"](key) if callable(config["url"]) else config["url"]
    headers = config["headers"](key)

    try:
        async with httpx.AsyncClient(timeout=8.0) as client:
            res = await client.get(url, headers=headers)
            if res.status_code == 200:
                return {"valid": True, "message": f"{config['name']} API key is valid!"}
            
            # Extract readable error message from API response
            err_msg = res.text[:150]
            try:
                data = res.json()
                if "error" in data:
                    err_val = data["error"]
                    err_msg = err_val.get("message", str(err_val)) if isinstance(err_val, dict) else str(err_val)
            except Exception:
                pass

            return {"valid": False, "message": f"{config['name']} Error ({res.status_code}): {err_msg[:120]}"}
    except Exception as e:
        return {"valid": False, "message": f"Connection test failed: {str(e)}"}


@app.post("/api/fetch-live-models")
async def fetch_live_models(req: TestKeyRequest):
    """
    Fetches the live real-time model catalog directly from the provider's API
    using the user's provided API key.
    """
    provider = req.provider
    key = req.api_key.strip()
    
    if "..." in key or "***" in key or not key:
        saved_settings = load_settings()
        key_attr = f"{provider.value}_key"
        key = getattr(saved_settings.keys, key_attr, "").strip()
    
    if not key:
        raise HTTPException(status_code=400, detail="API key is required to fetch models")

    try:
        models = await fetch_remote_models(provider, key)
        return {"status": "success", "models": models}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ---------------------------------------------------------------------------
# Match Lifecycle & Controls API
# ---------------------------------------------------------------------------

@app.post("/api/game/control")
async def game_control(req: GameControlRequest):
    """
    Handles match controls: start, pause, resume, step, stop, reset.
    Enforces API key presence on start.
    """
    action = req.action.lower()
    if action == "start":
        if not req.white_player or not req.black_player:
            raise HTTPException(status_code=400, detail="Both White and Black players must be configured.")
        
        settings = load_settings()
        # Enforce key guardrails
        validate_player_key(req.white_player, settings, "White Player (AI 1)")
        validate_player_key(req.black_player, settings, "Black Player (AI 2)")

        await game_service.start_game(
            white_player=req.white_player,
            black_player=req.black_player,
            move_delay_seconds=req.move_delay_seconds
        )
    elif action == "pause":
        await game_service.pause_game()
    elif action == "resume":
        if req.white_player and req.black_player:
            settings = load_settings()
            validate_player_key(req.white_player, settings, "White Player (AI 1)")
            validate_player_key(req.black_player, settings, "Black Player (AI 2)")
            await game_service.resume_game(white_player=req.white_player, black_player=req.black_player)
        else:
            await game_service.resume_game()
    elif action == "step":
        if req.white_player and req.black_player:
            settings = load_settings()
            validate_player_key(req.white_player, settings, "White Player (AI 1)")
            validate_player_key(req.black_player, settings, "Black Player (AI 2)")
            await game_service.start_game(req.white_player, req.black_player, req.move_delay_seconds)
            await game_service.step_game()
        else:
            await game_service.step_game()
    elif action in ["stop", "reset", "kill", "terminate"]:
        await game_service.reset_game()
    elif action == "load":
        game_id = validate_game_id(req.game_id or "")
        await game_service.load_saved_game(game_id)
    else:
        raise HTTPException(status_code=400, detail=f"Unknown action {action}")
    
    return {"status": "ok", "state": game_service.state.model_dump()}


@app.post("/api/game/load")
async def load_game_endpoint(payload: Dict[str, Any] = Body(...)):
    """
    Loads a saved game from history into the active game orchestrator,
    reconstructing the board position, player configs, and PGN in PAUSED mode.
    """
    game_id = validate_game_id(payload.get("game_id", ""))
    state = await game_service.load_saved_game(game_id)
    return {"status": "ok", "state": state.model_dump()}


@app.post("/api/games/{game_id}/load")
async def load_specific_game(game_id: str):
    """
    Restores a specific saved match from history and synchronizes it with all clients.
    """
    valid_id = validate_game_id(game_id)
    state = await game_service.load_saved_game(valid_id)
    return {"status": "ok", "state": state.model_dump()}


@app.post("/api/game/delay")
async def set_game_delay(delay: int = Body(..., embed=True)):
    """Dynamically updates the delay interval between moves mid-game."""
    await game_service.set_delay(delay)
    return {"status": "ok", "delay": delay}


@app.get("/api/games")
def get_past_games():
    """Returns list of all archived past matches."""
    return list_games()


@app.get("/api/games/{game_id}")
def get_past_game(game_id: str):
    """Returns full game replay data and reasoning transcripts for a specific game ID."""
    valid_id = validate_game_id(game_id)
    data = get_game(valid_id)
    if not data:
        raise HTTPException(status_code=404, detail="Game not found")
    return data


@app.delete("/api/games/{game_id}")
def delete_past_game(game_id: str):
    """Deletes an archived game from disk storage."""
    valid_id = validate_game_id(game_id)
    success = delete_game(valid_id)
    if not success:
        raise HTTPException(status_code=404, detail="Game not found")
    return {"status": "success", "message": f"Game {valid_id} deleted successfully"}


# ---------------------------------------------------------------------------
# WebSocket Endpoint for Live Streaming
# ---------------------------------------------------------------------------

@app.websocket("/ws/game")
async def websocket_endpoint(websocket: WebSocket):
    """
    Main WebSocket endpoint:
    - Streams live reasoning thoughts token-by-token
    - Broadcasts move updates, timer countdowns, and game over results
    """
    await game_service.connect_ws(websocket)
    try:
        while True:
            data = await websocket.receive_json()
            action = data.get("action")
            if action == "ping":
                await websocket.send_json({"type": "pong"})
    except WebSocketDisconnect:
        game_service.disconnect_ws(websocket)
    except Exception:
        game_service.disconnect_ws(websocket)


# ---------------------------------------------------------------------------
# Root API Status Endpoint
# ---------------------------------------------------------------------------

@app.get("/")
async def root():
    """Root health and service discovery endpoint for mobile client."""
    return {
        "status": "online",
        "service": "AI Chess Arena Backend API",
        "version": "1.0.0",
        "endpoints": {
            "ws": "/ws/game",
            "settings": "/api/settings",
            "models": "/api/models",
            "control": "/api/game/control",
            "history": "/api/game/history"
        }
    }
