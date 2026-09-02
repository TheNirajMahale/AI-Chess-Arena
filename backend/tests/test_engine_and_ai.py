import sys
import os
import asyncio
import chess

from app.core.chess_engine import ChessEngine
from app.prompts.chess_prompts import build_system_prompt, build_user_prompt
from app.models.schemas import PlayerConfig, PlayerColor, ProviderType
from app.models.ai_providers import extract_move_and_reasoning
from app.core.config import load_settings, save_settings
from app.services.game_service import validate_player_key
from fastapi import HTTPException


def test_chess_engine():
    engine = ChessEngine()
    assert engine.current_turn == PlayerColor.WHITE
    assert engine.current_move_number == 1
    
    legal_san = engine.get_legal_moves_san()
    assert "e4" in legal_san
    assert "Nf3" in legal_san
    
    move_e4 = engine.parse_move("e4")
    assert move_e4 is not None
    
    move_data = engine.make_move(move_e4, "White Player", "test-model", "Opening")
    assert move_data.san == "e4"
    assert move_data.turn == PlayerColor.WHITE
    assert engine.current_turn == PlayerColor.BLACK
    
    move_e5 = engine.parse_move("e5")
    assert move_e5 is not None
    engine.make_move(move_e5, "Black Player", "test-model-2", "Opening")
    
    fools_engine = ChessEngine()
    fools_engine.make_move(fools_engine.parse_move("f3"), "W", "m1")
    fools_engine.make_move(fools_engine.parse_move("e5"), "B", "m2")
    fools_engine.make_move(fools_engine.parse_move("g4"), "W", "m1")
    fools_engine.make_move(fools_engine.parse_move("Qh4+"), "B", "m2")
    
    res = fools_engine.check_game_over()
    assert res is not None
    assert res.reason == "checkmate"
    assert res.winner == PlayerColor.BLACK


def test_extract_move_and_reasoning():
    legal_san = ["e4", "d4", "Nf3", "c4"]
    legal_uci = ["e2e4", "d2d4", "g1f3", "c2c4"]

    raw1 = "<thought>Center control.</thought><move>Nf3</move>"
    r1, m1 = extract_move_and_reasoning(raw1, legal_san, legal_uci)
    assert m1 == "Nf3"

    raw2 = 'I pick e4. {"move": "e4"}'
    r2, m2 = extract_move_and_reasoning(raw2, legal_san, legal_uci)
    assert m2 == "e4"

    raw3 = "Selected move: d4."
    r3, m3 = extract_move_and_reasoning(raw3, legal_san, legal_uci)
    assert m3 == "d4"


def test_token_optimizations():
    engine = ChessEngine()
    engine.make_move(engine.parse_move("e4"), "W", "m1")
    engine.make_move(engine.parse_move("e5"), "B", "m2")
    engine.make_move(engine.parse_move("Nf3"), "W", "m1")
    engine.make_move(engine.parse_move("Nc6"), "B", "m2")
    engine.make_move(engine.parse_move("Bc4"), "W", "m1")
    engine.make_move(engine.parse_move("Bc5"), "B", "m2")

    full_hist = engine.get_formatted_move_history_san(limit=0)
    assert "1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5" in full_hist

    window_hist = engine.get_formatted_move_history_san(limit=2)
    assert "[... earlier moves truncated" in window_hist
    assert "3. Bc4 Bc5" in window_hist
    assert "1. e4" not in window_hist

    prompt_with_ascii = build_user_prompt(PlayerColor.WHITE, engine.fen, engine.get_ascii_board(), full_hist, ["d3", "O-O"], include_ascii=True)
    assert "Board Visual" in prompt_with_ascii

    prompt_no_ascii = build_user_prompt(PlayerColor.WHITE, engine.fen, engine.get_ascii_board(), full_hist, ["d3", "O-O"], include_ascii=False)
    assert "Board Visual" not in prompt_no_ascii


def test_key_validation():
    s = load_settings()
    s.keys.gemini_key = ""
    p_unconfigured = PlayerConfig(name="Gemini Flash", provider=ProviderType.GEMINI, model_id="gemini/gemini-2.5-flash")
    
    raised = False
    try:
        validate_player_key(p_unconfigured, s, "White Player")
    except HTTPException:
        raised = True
    assert raised

    s.keys.deepseek_key = ""
    p_deepseek = PlayerConfig(name="DeepSeek R1", provider=ProviderType.DEEPSEEK, model_id="deepseek/deepseek-v4-pro")
    raised_deepseek = False
    try:
        validate_player_key(p_deepseek, s, "White Player")
    except HTTPException:
        raised_deepseek = True
    assert raised_deepseek


def test_system_prompts():
    p_default = PlayerConfig(name="Gemini Flash", provider=ProviderType.GEMINI, model_id="gemini/gemini-2.5-flash", color=PlayerColor.WHITE)
    sys_default = build_system_prompt(p_default)
    assert "precision chess engine" in sys_default
    assert "WHITE" in sys_default

    p_custom = PlayerConfig(
        name="Tal Bot",
        provider=ProviderType.OPENAI,
        model_id="gpt-4o",
        color=PlayerColor.BLACK,
        system_prompt="Play wildly aggressive sacrifices like Mikhail Tal."
    )
    sys_custom = build_system_prompt(p_custom)
    assert "Play wildly aggressive sacrifices like Mikhail Tal." in sys_custom
    assert "BLACK" in sys_custom


def test_settings():
    s = load_settings()
    assert s.default_delay >= 5


def test_game_history_persistence_and_restore():
    from app.services.game_service import game_service
    from app.services.history_service import get_game, delete_game
    from app.models.schemas import GameStatus

    async def _test():
        p1 = PlayerConfig(name="DeepSeek Bot", provider=ProviderType.DEEPSEEK, model_id="deepseek/deepseek-v4-pro", color=PlayerColor.WHITE)
        p2 = PlayerConfig(name="Gemini Bot", provider=ProviderType.GEMINI, model_id="gemini/gemini-2.5-flash", color=PlayerColor.BLACK)

        # 1. Start a match and make 2 moves
        await game_service.start_game(p1, p2, move_delay_seconds=5)
        m1 = game_service.engine.parse_move("e4")
        game_service.engine.make_move(m1, "DeepSeek Bot", "deepseek/deepseek-v4-pro", "Opening e4")
        game_service.state.move_history = game_service.engine.move_history
        game_service.state.fen = game_service.engine.fen

        m2 = game_service.engine.parse_move("e5")
        game_service.engine.make_move(m2, "Gemini Bot", "gemini/gemini-2.5-flash", "Contesting center")
        game_service.state.move_history = game_service.engine.move_history
        game_service.state.fen = game_service.engine.fen

        saved_id = game_service.state.game_id

        # 2. Stop/kill the match mid-game
        await game_service.reset_game()
        assert game_service.state.status == GameStatus.IDLE
        assert len(game_service.state.move_history) == 0

        # 3. Verify match was automatically saved to history with 'stopped' status
        saved_data = get_game(saved_id)
        assert saved_data is not None
        assert len(saved_data["move_history"]) == 2
        assert saved_data["result"]["reason"] == "stopped"

        # 4. Load the saved match from history
        restored_state = await game_service.load_saved_game(saved_id)
        assert restored_state.game_id == saved_id
        assert restored_state.status == GameStatus.PAUSED
        assert len(restored_state.move_history) == 2
        assert restored_state.white_player.name == "DeepSeek Bot"
        assert restored_state.black_player.name == "Gemini Bot"
        assert restored_state.turn == PlayerColor.WHITE
        assert "e4" in restored_state.pgn and "e5" in restored_state.pgn
        assert restored_state.fen == "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2"

        # 5. Clean up test game file
        assert delete_game(saved_id) is True
        assert get_game(saved_id) is None

    asyncio.run(_test())


if __name__ == "__main__":
    test_chess_engine()
    test_extract_move_and_reasoning()
    test_token_optimizations()
    test_key_validation()
    test_system_prompts()
    test_settings()
    test_game_history_persistence_and_restore()
    print("ALL TESTS PASSED")
