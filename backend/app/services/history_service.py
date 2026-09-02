"""
AI Chess Arena - Game History Persistence & Replay Service
===========================================================
This module handles saving and retrieving completed chess games:
- Saves game state as structured JSON files in `backend/data/games/`
- Saves annotated PGN files with AI reasoning comments
- Lists match archives with metadata (players, models, move counts, outcomes)
- Retrieves past matches for replay and transcript inspection
"""

import json
import datetime
from pathlib import Path
from typing import List, Optional, Dict, Any
from app.core.config import GAMES_DIR
from app.models.schemas import GameState, MoveData, PlayerConfig, GameResult


def save_game(game_state: GameState) -> str:
    """
    Persists a finished chess match to disk in both JSON and standard PGN formats.
    Returns the unique game ID.
    """
    GAMES_DIR.mkdir(parents=True, exist_ok=True)
    game_id = game_state.game_id
    
    # 1. Save full structured JSON data (moves, thoughts, durations, states)
    json_path = GAMES_DIR / f"{game_id}.json"
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(game_state.model_dump(), f, indent=2)

    # 2. Save annotated standard PGN file
    if game_state.pgn:
        pgn_path = GAMES_DIR / f"{game_id}.pgn"
        with open(pgn_path, "w", encoding="utf-8") as f:
            f.write(game_state.pgn)

    return game_id


def list_games() -> List[Dict[str, Any]]:
    """
    Retrieves summary metadata for all saved matches, sorted in reverse
    chronological order (newest first).
    """
    GAMES_DIR.mkdir(parents=True, exist_ok=True)
    games_list = []
    
    for json_file in sorted(GAMES_DIR.glob("*.json"), key=lambda p: p.stat().st_mtime, reverse=True):
        try:
            with open(json_file, "r", encoding="utf-8") as f:
                data = json.load(f)
                games_list.append({
                    "game_id": data.get("game_id", json_file.stem),
                    "date": json_file.stat().st_mtime,
                    "white_player": data.get("white_player", {}).get("name", "White"),
                    "white_model": data.get("white_player", {}).get("model_id", ""),
                    "black_player": data.get("black_player", {}).get("name", "Black"),
                    "black_model": data.get("black_player", {}).get("model_id", ""),
                    "moves_count": len(data.get("move_history", [])),
                    "result": data.get("result", {}),
                    "fen": data.get("fen", "")
                })
        except Exception as e:
            print(f"Error reading game file {json_file}: {e}")

    return games_list


def get_game(game_id: str) -> Optional[Dict[str, Any]]:
    """
    Loads and returns the complete saved game state dictionary from disk for a given game ID.
    """
    json_path = GAMES_DIR / f"{game_id}.json"
    if not json_path.exists():
        return None
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading game {game_id}: {e}")
        return None


def delete_game(game_id: str) -> bool:
    """
    Deletes a saved match JSON and PGN file from disk.
    """
    json_path = GAMES_DIR / f"{game_id}.json"
    pgn_path = GAMES_DIR / f"{game_id}.pgn"
    deleted = False
    if json_path.exists():
        json_path.unlink()
        deleted = True
    if pgn_path.exists():
        pgn_path.unlink()
    return deleted

