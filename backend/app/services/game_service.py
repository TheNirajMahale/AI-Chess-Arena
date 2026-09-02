"""
AI Chess Arena - Game Orchestration & WebSocket State Service
==============================================================
This module coordinates the entire chess battle lifecycle between two AI models:
1. Turn Orchestration: Alternates moves between White and Black AI players.
2. Real-Time Streaming: Streams LLM chain-of-thought tokens directly to the frontend via WebSockets.
3. Move Validation: Validates proposed moves against official FIDE rules via python-chess.
4. Delay & Countdown: Manages move delay intervals (e.g. 10s) with ticking countdown timers.
5. Lifecycle Controls: Handles Start, Pause, Resume, Step (single move), and Reset/Stop actions.
6. Match Persistence: Automatically saves finished matches (PGN, moves, timestamps) to disk.
"""

import asyncio
import uuid
import time
from typing import Set, Optional, Dict, Any, List
from fastapi import WebSocket, HTTPException

from app.core.chess_engine import ChessEngine
from app.models.schemas import (
    GameState, GameStatus, PlayerColor, PlayerConfig,
    MoveData, GameResult, ProviderType, SettingsPayload
)
from app.models.ai_providers import generate_ai_move_stream
from app.prompts.chess_prompts import build_retry_prompt
from app.services.history_service import save_game, get_game
from app.core.config import load_settings, PROVIDER_VERIFICATION


# ---------------------------------------------------------------------------
# Key Guardrail Validation Helper
# ---------------------------------------------------------------------------

def validate_player_key(player: PlayerConfig, settings: SettingsPayload, role: str):
    """
    Ensures that an API key is present in user settings for the requested player's
    provider BEFORE permitting a match to begin. Raises an HTTP 400 error if missing.

    Args:
        player: The PlayerConfig containing the provider and model name.
        settings: The current stored SettingsPayload containing API keys.
        role: Description string for error messages (e.g. "White Player (AI 1)").
    """
    provider = player.provider
    provider_info = PROVIDER_VERIFICATION.get(provider)
    if not provider_info:
        return

    # Extract the corresponding key string from settings (e.g. settings.keys.deepseek_key)
    key_field = provider_info.get("key_field", "")
    key_val = getattr(settings.keys, key_field, "") if key_field else ""
    provider_name = provider_info.get("name", provider.value)

    # If key is empty or whitespace-only, abort match start with user-friendly instructions
    if not key_val.strip():
        raise HTTPException(
            status_code=400,
            detail=f"{role} ({player.name}) requires a {provider_name} API key. Please enter and save your {provider_name} key in Settings & Keys."
        )


# ---------------------------------------------------------------------------
# Game Service Class
# ---------------------------------------------------------------------------

class GameService:
    """
    Singleton orchestrator maintaining the live chess match state, connected WebSockets,
    and the asynchronous background game loop.
    """

    def __init__(self):
        # The underlying FIDE-compliant chess engine (manages board, moves, FEN, PGN)
        self.engine = ChessEngine()
        
        # Pool of all currently connected frontend WebSocket clients
        self.active_connections: Set[WebSocket] = set()
        
        # Reference to the running asyncio background task executing _game_loop()
        self.game_task: Optional[asyncio.Task] = None
        
        # Lifecycle execution control flags
        self.is_paused: bool = False
        self.step_mode: bool = False
        
        # Active White and Black player configurations (set when match starts)
        self.white_player: Optional[PlayerConfig] = None
        self.black_player: Optional[PlayerConfig] = None
        
        # Authoritative snapshot of the match state (broadcasted to UI)
        self.state = GameState(
            game_id=str(uuid.uuid4())[:8],
            status=GameStatus.IDLE,
            fen=self.engine.fen,
            turn=self.engine.current_turn,
            white_player=None,
            black_player=None,
            move_delay_seconds=10,
            current_move_number=1,
            move_history=[],
            captured_by_white=[],
            captured_by_black=[],
            pgn="",
            live_thinking="",
            is_thinking=False,
            thinking_player=None,
            countdown_seconds=None,
            last_move_uci=None
        )

    # -----------------------------------------------------------------------
    # WebSocket Client Management & Event Broadcasting
    # -----------------------------------------------------------------------

    async def connect_ws(self, websocket: WebSocket):
        """
        Accepts and registers a new frontend WebSocket connection, immediately
        sending the current authoritative match state so the UI renders instantly.
        """
        await websocket.accept()
        self.active_connections.add(websocket)
        try:
            await websocket.send_json({
                "type": "game_state",
                "state": self.state.model_dump()
            })
        except Exception:
            self.active_connections.discard(websocket)

    def disconnect_ws(self, websocket: WebSocket):
        """Unregisters a disconnected WebSocket client from the broadcast pool."""
        self.active_connections.discard(websocket)

    async def broadcast(self, message: Dict[str, Any]):
        """
        Sends a JSON event payload to all connected clients.
        Uses a snapshot list to safely iterate even if clients connect/disconnect concurrently.
        """
        dead_connections = []
        clients = list(self.active_connections)
        for ws in clients:
            try:
                await ws.send_json(message)
            except Exception:
                dead_connections.append(ws)
        
        # Clean up any broken/closed connections
        if dead_connections:
            for dead in dead_connections:
                self.active_connections.discard(dead)

    async def broadcast_state(self):
        """
        Pulls the latest board state (FEN, turn, PGN, move list, captured pieces)
        from the chess engine into self.state and broadcasts it to all clients.
        """
        self.state.fen = self.engine.fen
        self.state.turn = self.engine.current_turn
        self.state.current_move_number = self.engine.current_move_number
        self.state.move_history = self.engine.move_history
        self.state.captured_by_white = self.engine.captured_by_white
        self.state.captured_by_black = self.engine.captured_by_black
        self.state.pgn = self.engine.get_pgn_string()
        
        await self.broadcast({
            "type": "game_state",
            "state": self.state.model_dump()
        })

    # -----------------------------------------------------------------------
    # Match Lifecycle Controls (Start, Pause, Resume, Step, Reset)
    # -----------------------------------------------------------------------

    async def start_game(
        self,
        white_player: Optional[PlayerConfig] = None,
        black_player: Optional[PlayerConfig] = None,
        move_delay_seconds: Optional[int] = None
    ):
        """
        Initializes a fresh chess match and launches the background loop task.
        - Stops any currently active match loop.
        - Configures White and Black player assignments.
        - Resets the chess engine board to starting FEN.
        - Spawns asyncio background task for _game_loop().
        """
        await self.stop_game()
        
        if white_player:
            white_player.color = PlayerColor.WHITE
            self.white_player = white_player
        if black_player:
            black_player.color = PlayerColor.BLACK
            self.black_player = black_player
        if move_delay_seconds is not None:
            self.state.move_delay_seconds = max(1, min(300, move_delay_seconds))

        # Reset chess engine with player name labels for PGN headers
        self.engine.reset(
            white_name=f"{self.white_player.name} ({self.white_player.model_id})",
            black_name=f"{self.black_player.name} ({self.black_player.model_id})"
        )
        
        # Initialize fresh state
        self.state.game_id = str(uuid.uuid4())[:8]
        self.state.status = GameStatus.PLAYING
        self.state.white_player = self.white_player
        self.state.black_player = self.black_player
        self.state.result = None
        self.state.live_thinking = ""
        self.state.is_thinking = False
        self.state.thinking_player = None
        self.state.countdown_seconds = None
        self.state.last_move_uci = None
        self.is_paused = False
        self.step_mode = False

        # Broadcast initial state and launch match loop
        await self.broadcast_state()
        self.game_task = asyncio.create_task(self._game_loop())

    async def pause_game(self):
        """Pauses the actively running match loop mid-game."""
        if self.state.status == GameStatus.PLAYING:
            self.is_paused = True
            if self.state.is_thinking:
                self.state.status = GameStatus.PAUSING
            else:
                self.state.status = GameStatus.PAUSED
            await self.broadcast_state()

    async def resume_game(self, white_player: Optional[PlayerConfig] = None, black_player: Optional[PlayerConfig] = None):
        """Resumes a paused match and ensures the loop task is running."""
        if self.state.status in [GameStatus.PAUSED, GameStatus.PAUSING]:
            if white_player:
                white_player.color = PlayerColor.WHITE
                self.white_player = white_player
                self.state.white_player = white_player
            if black_player:
                black_player.color = PlayerColor.BLACK
                self.black_player = black_player
                self.state.black_player = black_player
            if self.state.result and self.state.result.reason == "stopped":
                self.state.result = None
            self.is_paused = False
            self.state.status = GameStatus.PLAYING
            await self.broadcast_state()
            if not self.game_task or self.game_task.done():
                self.game_task = asyncio.create_task(self._game_loop())

    async def step_game(self):
        """
        Single-Step Mode: Executes exactly one turn for the active AI player,
        applies the move, and automatically pauses before the opponent moves.
        """
        if self.state.result and self.state.result.reason == "stopped":
            self.state.result = None
        if self.state.status in [GameStatus.IDLE, GameStatus.FINISHED]:
            await self.start_game(self.white_player, self.black_player, self.state.move_delay_seconds)
            self.is_paused = True
            self.state.status = GameStatus.PAUSED
        
        self.step_mode = True
        self.is_paused = False
        self.state.status = GameStatus.PLAYING
        await self.broadcast_state()
        if not self.game_task or self.game_task.done():
            self.game_task = asyncio.create_task(self._game_loop())

    async def reset_game(self):
        """
        Instant Kill Switch: Immediately cancels the background match task,
        persists in-progress game to match history if moves were played,
        resets the chessboard, and restores state to IDLE.
        """
        # Cancel running async loop task if active
        if self.game_task and not self.game_task.done():
            self.game_task.cancel()
            try:
                await self.game_task
            except asyncio.CancelledError:
                pass
            self.game_task = None
        
        # If match had moves played, save it to history before clearing
        if self.state.move_history and len(self.state.move_history) > 0:
            if not self.state.result:
                self.state.result = GameResult(
                    winner=None,
                    reason="stopped",
                    description=f"Match stopped at move {len(self.state.move_history)} (Incomplete)"
                )
            save_game(self.state)

        # Reset engine and match state to initial defaults
        self.engine.reset()
        self.is_paused = False
        self.step_mode = False
        self.state.game_id = str(uuid.uuid4())[:8]
        self.state.status = GameStatus.IDLE
        self.state.fen = self.engine.fen
        self.state.turn = self.engine.current_turn
        self.state.current_move_number = 1
        self.state.move_history = []
        self.state.captured_by_white = []
        self.state.captured_by_black = []
        self.state.pgn = ""
        self.state.result = None
        self.state.live_thinking = ""
        self.state.is_thinking = False
        self.state.thinking_player = None
        self.state.countdown_seconds = None
        self.state.last_move_uci = None
        await self.broadcast_state()

    async def load_saved_game(self, game_id: str) -> GameState:
        """
        Loads an archived or in-progress match from disk, reconstructs the
        chess board, moves, captures, PGN, and player configurations, sets
        the match state to PAUSED, and broadcasts the state to all connected clients.
        """
        data = get_game(game_id)
        if not data:
            raise HTTPException(status_code=404, detail=f"Match archive '{game_id}' not found")

        # Cancel any active running match task
        if self.game_task and not self.game_task.done():
            self.game_task.cancel()
            try:
                await self.game_task
            except asyncio.CancelledError:
                pass
            self.game_task = None

        # Reset and reconstruct the chess engine
        self.engine.reset()

        # Reconstruct player configs
        w_data = data.get("white_player")
        b_data = data.get("black_player")
        self.white_player = PlayerConfig(**w_data) if w_data else None
        self.black_player = PlayerConfig(**b_data) if b_data else None

        # Replay move history to build exact board state, PGN tree, and captures
        move_history_raw = data.get("move_history", [])
        if move_history_raw:
            for m in move_history_raw:
                san_move = m.get("san")
                uci_move = m.get("uci")
                player_name = m.get("player_name", "AI")
                model_id = m.get("model_id", "")
                reasoning = m.get("reasoning", "")
                duration_ms = m.get("duration_ms", 0)

                parsed = None
                if san_move:
                    parsed = self.engine.parse_move(san_move)
                if not parsed and uci_move:
                    parsed = self.engine.parse_move(uci_move)

                if parsed:
                    self.engine.make_move(
                        move=parsed,
                        player_name=player_name,
                        model_id=model_id,
                        reasoning=reasoning,
                        duration_ms=duration_ms
                    )
        elif data.get("fen"):
            # Fallback: if no move history list, set FEN directly
            self.engine.board.set_fen(data.get("fen"))

        # Reconstruct GameState in PAUSED state
        self.is_paused = True
        self.step_mode = False
        
        res_data = data.get("result")
        game_res = GameResult(**res_data) if res_data else None
        if game_res and game_res.reason == "stopped":
            game_res = None

        self.state = GameState(
            game_id=data.get("game_id", game_id),
            status=GameStatus.PAUSED,
            fen=self.engine.fen,
            turn=self.engine.current_turn,
            white_player=self.white_player,
            black_player=self.black_player,
            move_delay_seconds=data.get("move_delay_seconds", 10),
            current_move_number=self.engine.current_move_number,
            move_history=self.engine.move_history,
            captured_by_white=self.engine.captured_by_white,
            captured_by_black=self.engine.captured_by_black,
            pgn=self.engine.get_pgn_string(),
            result=game_res,
            live_thinking="",
            is_thinking=False,
            thinking_player=None,
            countdown_seconds=None,
            last_move_uci=self.engine.move_history[-1].uci if self.engine.move_history else None
        )

        await self.broadcast_state()
        return self.state

    async def stop_game(self):
        """Alias for reset_game to guarantee clean termination."""
        await self.reset_game()

    async def set_delay(self, seconds: int):
        """Dynamically adjusts the move delay interval (1s to 300s) mid-game."""
        self.state.move_delay_seconds = max(1, min(300, seconds))
        await self.broadcast_state()

    # -----------------------------------------------------------------------
    # Asynchronous Turn-by-Turn Game Loop
    # -----------------------------------------------------------------------

    async def _game_loop(self):
        """
        Core async execution loop running continuously while status is PLAYING:
        
        Step 1: Check if game is over (Checkmate, Stalemate, Draw rules).
        Step 2: Determine active side (White vs Black) and active model config.
        Step 3: Call generate_ai_move_stream() to stream LLM reasoning & move tokens.
        Step 4: Handle fatal provider errors (e.g. rate limits, quota exceeded).
        Step 5: Parse and validate the extracted move against legal FIDE moves.
        Step 6: Apply the move onto the board, record time, update PGN & captures.
        Step 7: Check post-move game over conditions (Checkmate/Draw).
        Step 8: Tick down move delay countdown timer (e.g. 10s) before next turn.
        """
        try:
            while (self.state.status == GameStatus.PLAYING or self.state.status == GameStatus.PAUSING):
                
                # ---------------------------------------------------------------
                # 1. Check Pre-Turn Game Over (Checkmate, Stalemate, 75-move rule)
                # ---------------------------------------------------------------
                game_result = self.engine.check_game_over()
                if game_result:
                    self.state.result = game_result
                    self.state.status = GameStatus.FINISHED
                    self.state.is_thinking = False
                    self.state.countdown_seconds = None
                    save_game(self.state)  # Persist match to JSON archive
                    await self.broadcast_state()
                    await self.broadcast({
                        "type": "game_over",
                        "result": game_result.model_dump()
                    })
                    break

                # ---------------------------------------------------------------
                # 2. Identify Active Player (White or Black)
                # ---------------------------------------------------------------
                active_color = self.engine.current_turn
                active_player = self.white_player if active_color == PlayerColor.WHITE else self.black_player
                
                # Broadcast thinking indicator to UI
                self.state.is_thinking = True
                self.state.thinking_player = active_color
                self.state.live_thinking = ""
                self.state.countdown_seconds = None
                await self.broadcast_state()

                # ---------------------------------------------------------------
                # 3. Assemble Prompt & Stream LLM Reasoning Tokens
                # ---------------------------------------------------------------
                app_settings = load_settings()
                history_limit = app_settings.history_context_limit
                include_ascii = app_settings.include_ascii_board
                max_output_tokens = app_settings.max_output_tokens

                # Prepare FIDE legal move lists for prompt and validation
                legal_san = self.engine.get_legal_moves_san()
                legal_uci = self.engine.get_legal_moves_uci()
                ascii_board = self.engine.get_ascii_board() if include_ascii else ""
                move_history_str = self.engine.get_formatted_move_history_san(limit=history_limit)
                
                start_time = time.time()
                final_move_str = ""
                final_reasoning = ""
                stream_error = None

                # Stream tokens asynchronously chunk-by-chunk from LiteLLM
                async for chunk in generate_ai_move_stream(
                    board=self.engine.board,
                    player_config=active_player,
                    ascii_board=ascii_board,
                    move_history_str=move_history_str,
                    legal_moves_san=legal_san,
                    legal_moves_uci=legal_uci,
                    include_ascii=include_ascii,
                    max_output_tokens=max_output_tokens
                ):
                    # Live reasoning token: broadcast to ThinkingStream panel
                    if chunk["type"] == "thought_chunk":
                        self.state.live_thinking += chunk["content"]
                        await self.broadcast({
                            "type": "thinking_chunk",
                            "chunk": chunk["content"],
                            "full_text": self.state.live_thinking,
                            "player": active_color
                        })
                    # Final result: model finished generating move and reasoning
                    elif chunk["type"] == "final_result":
                        final_reasoning = chunk.get("reasoning", "")
                        final_move_str = chunk.get("move", "")
                    # Stream error: API quota, authentication, or network failure
                    elif chunk["type"] == "error":
                        stream_error = chunk.get("error", "Unknown error")

                duration_ms = int((time.time() - start_time) * 1000)

                # ---------------------------------------------------------------
                # 4. Handle Fatal API Provider Errors
                # ---------------------------------------------------------------
                if stream_error:
                    self.state.is_thinking = False
                    self.state.thinking_player = None
                    self.state.status = GameStatus.PAUSED
                    self.is_paused = True
                    error_detail = f"API Error ({active_player.name} - {active_player.model_id}): {stream_error}"
                    self.state.live_thinking = f"⚠️ [Match Paused - {error_detail}]"
                    await self.broadcast({
                        "type": "error",
                        "message": error_detail
                    })
                    await self.broadcast_state()
                    break

                # ---------------------------------------------------------------
                # 5. Parse and Validate Move Legality
                # ---------------------------------------------------------------
                parsed_move = None
                if final_move_str:
                    parsed_move = self.engine.parse_move(final_move_str)

                # If model failed to produce a legal move, pause match and report error
                if not parsed_move:
                    self.state.is_thinking = False
                    self.state.thinking_player = None
                    self.state.status = GameStatus.PAUSED
                    self.is_paused = True
                    invalid_err = f"Move Error ({active_player.name}): Could not parse '{final_move_str or 'empty output'}' as a valid legal move in this position."
                    self.state.live_thinking = f"⚠️ [Match Paused - {invalid_err}]"
                    await self.broadcast({
                        "type": "error",
                        "message": invalid_err
                    })
                    await self.broadcast_state()
                    break

                # ---------------------------------------------------------------
                # 6. Apply Validated Move to Chessboard
                # ---------------------------------------------------------------
                move_data = self.engine.make_move(
                    move=parsed_move,
                    player_name=active_player.name,
                    model_id=active_player.model_id,
                    reasoning=final_reasoning,
                    duration_ms=duration_ms
                )
                
                self.state.last_move_uci = move_data.uci
                self.state.is_thinking = False
                self.state.thinking_player = None
                
                # Broadcast move execution event and updated board state
                await self.broadcast({
                    "type": "move_made",
                    "move": move_data.model_dump()
                })
                await self.broadcast_state()
                save_game(self.state)  # Auto-save game progress to disk in real-time

                # ---------------------------------------------------------------
                # 7. Check Post-Move Game Over (Checkmate, Stalemate, Draw)
                # ---------------------------------------------------------------
                game_result = self.engine.check_game_over()
                if game_result:
                    self.state.result = game_result
                    self.state.status = GameStatus.FINISHED
                    self.state.countdown_seconds = None
                    save_game(self.state)
                    await self.broadcast_state()
                    await self.broadcast({
                        "type": "game_over",
                        "result": game_result.model_dump()
                    })
                    break

                # If paused/pausing or in single-step mode, transition to PAUSED and stop
                if self.is_paused or self.state.status in [GameStatus.PAUSED, GameStatus.PAUSING] or self.step_mode:
                    self.step_mode = False
                    self.is_paused = True
                    self.state.status = GameStatus.PAUSED
                    self.state.is_thinking = False
                    self.state.thinking_player = None
                    await self.broadcast_state()
                    break

                # 1.0 second natural pause between turns with responsive 100ms interrupt check
                for _ in range(10):
                    if self.is_paused or self.state.status != GameStatus.PLAYING:
                        break
                    await asyncio.sleep(0.1)

        except asyncio.CancelledError:
            # Graceful cancellation when reset/stop is called
            self.state.is_thinking = False
            self.state.countdown_seconds = None
        except Exception as e:
            print(f"Error in game loop: {e}")
            self.state.is_thinking = False
            self.state.countdown_seconds = None
            self.state.status = GameStatus.PAUSED
            self.is_paused = True
            await self.broadcast_state()
            await self.broadcast({
                "type": "error",
                "message": str(e)
            })


# Global singleton instance of GameService
game_service = GameService()
