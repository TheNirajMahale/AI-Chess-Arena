"""
AI Chess Arena - Chess Rule Engine & Game Manager
==================================================
This module wraps the industry-standard `python-chess` library to provide:
- Strict FIDE chess rule enforcement (legal move generation, check, checkmate, stalemate)
- Flexible move parsing (Standard Algebraic Notation like "Nf3", UCI like "g1f3", and tolerant fuzzy parsing)
- Move history, captured pieces tracking, and material evaluation
- Board serialization (FEN strings, ASCII 2D visual boards with rank/file labels)
- Comprehensive Portable Game Notation (PGN) generation with embedded AI reasoning comments
"""

import chess
import chess.pgn
import datetime
from typing import List, Tuple, Optional, Dict, Any
from app.models.schemas import PlayerColor, MoveData, GameResult

# Human-readable piece name mappings
PIECE_NAMES = {
    chess.PAWN: "pawn",
    chess.KNIGHT: "knight",
    chess.BISHOP: "bishop",
    chess.ROOK: "rook",
    chess.QUEEN: "queen",
    chess.KING: "king"
}

# Standard single-character piece symbols
PIECE_SYMBOLS = {
    chess.PAWN: "P",
    chess.KNIGHT: "N",
    chess.BISHOP: "B",
    chess.ROOK: "R",
    chess.QUEEN: "Q",
    chess.KING: "K"
}


class ChessEngine:
    """
    Stateful manager for an individual chess game instance.
    Maintains the board state, move history, captured pieces, and PGN tree.
    """

    def __init__(self, fen: Optional[str] = None):
        """Initializes the chess board from a starting FEN or standard initial setup."""
        self.board = chess.Board(fen) if fen else chess.Board()
        self.move_history: List[MoveData] = []
        self.pgn_game = chess.pgn.Game()
        self.pgn_node = self.pgn_game
        self.captured_by_white: List[str] = []
        self.captured_by_black: List[str] = []
        
    def reset(self, white_name: str = "White", black_name: str = "Black"):
        """Resets the board back to the initial starting position and clears history."""
        self.board = chess.Board()
        self.move_history = []
        self.pgn_game = chess.pgn.Game()
        self.pgn_game.headers["Event"] = "AI Chess Arena Match"
        self.pgn_game.headers["Site"] = "AI Chess Arena"
        self.pgn_game.headers["Date"] = datetime.datetime.now().strftime("%Y.%m.%d")
        self.pgn_game.headers["White"] = white_name
        self.pgn_game.headers["Black"] = black_name
        self.pgn_node = self.pgn_game
        self.captured_by_white = []
        self.captured_by_black = []

    @property
    def current_turn(self) -> PlayerColor:
        """Returns which side's turn it is to move (White or Black)."""
        return PlayerColor.WHITE if self.board.turn == chess.WHITE else PlayerColor.BLACK

    @property
    def current_move_number(self) -> int:
        """Returns the current fullmove number (starts at 1 and increments after Black moves)."""
        return self.board.fullmove_number

    @property
    def fen(self) -> str:
        """Returns the Forsyth-Edwards Notation (FEN) string representing current position."""
        return self.board.fen()

    def get_legal_moves_san(self) -> List[str]:
        """Returns all legal moves in Standard Algebraic Notation (e.g. ['e4', 'Nf3', 'O-O'])."""
        return [self.board.san(move) for move in self.board.legal_moves]

    def get_legal_moves_uci(self) -> List[str]:
        """Returns all legal moves in UCI format (e.g. ['e2e4', 'g1f3', 'e1g1'])."""
        return [move.uci() for move in self.board.legal_moves]

    def get_legal_moves_map(self) -> Dict[str, chess.Move]:
        """
        Builds a comprehensive lookup map containing case-insensitive SAN, UCI,
        and punctuation-stripped variations for fast, tolerant move parsing.
        """
        mapping = {}
        for move in self.board.legal_moves:
            san = self.board.san(move)
            uci = move.uci()
            mapping[san.lower()] = move
            mapping[uci.lower()] = move
            mapping[san] = move
            mapping[uci] = move
            # Handle check/checkmate symbols tolerance ('+' or '#')
            clean_san = san.replace("+", "").replace("#", "")
            mapping[clean_san.lower()] = move
            mapping[clean_san] = move
        return mapping

    def parse_move(self, move_str: str) -> Optional[chess.Move]:
        """
        Attempts to parse a candidate move string from an LLM into a valid chess.Move.
        Handles multiple formats: SAN, UCI, and fuzzy alphanumeric cleanup.
        """
        move_str = move_str.strip()
        legal_map = self.get_legal_moves_map()
        
        # 1. Direct match in legal map
        if move_str in legal_map:
            return legal_map[move_str]
        if move_str.lower() in legal_map:
            return legal_map[move_str.lower()]

        # 2. Standard SAN parser fallback
        try:
            return self.board.parse_san(move_str)
        except Exception:
            pass

        # 3. UCI parser fallback
        try:
            return self.board.parse_uci(move_str)
        except Exception:
            pass

        # 4. Clean extra punctuation characters and retry
        cleaned = "".join(c for c in move_str if c.isalnum() or c in "+-=#")
        if cleaned in legal_map:
            return legal_map[cleaned]
        if cleaned.lower() in legal_map:
            return legal_map[cleaned.lower()]

        return None

    def make_move(
        self,
        move: chess.Move,
        player_name: str,
        model_id: str,
        reasoning: str = "",
        duration_ms: int = 0
    ) -> MoveData:
        """
        Executes a legal move on the board, records capture data, updates PGN with
        reasoning comments, and appends to move history.
        """
        fen_before = self.board.fen()
        turn = self.current_turn
        move_number = self.current_move_number
        san = self.board.san(move)
        uci = move.uci()
        
        # Determine if a piece was captured
        is_capture = self.board.is_capture(move)
        captured_piece_str = None
        if is_capture:
            if self.board.is_en_passant(move):
                captured_piece_str = "p" if turn == PlayerColor.WHITE else "P"
            else:
                target_piece = self.board.piece_at(move.to_square)
                if target_piece:
                    captured_piece_str = target_piece.symbol()
            
            # Record captured piece in appropriate player list
            if captured_piece_str:
                if turn == PlayerColor.WHITE:
                    self.captured_by_white.append(captured_piece_str)
                else:
                    self.captured_by_black.append(captured_piece_str)

        # Apply move onto the board
        self.board.push(move)
        fen_after = self.board.fen()
        is_check = self.board.is_check()
        is_checkmate = self.board.is_checkmate()

        # Update PGN game tree with move and AI thought annotations
        self.pgn_node = self.pgn_node.add_variation(move)
        if reasoning:
            # Replace curly braces to prevent PGN syntax collisions
            clean_reason = reasoning.replace("{", "[").replace("}", "]")
            self.pgn_node.comment = clean_reason

        move_data = MoveData(
            move_number=move_number,
            turn=turn,
            san=san,
            uci=uci,
            fen_before=fen_before,
            fen_after=fen_after,
            reasoning=reasoning,
            player_name=player_name,
            model_id=model_id,
            duration_ms=duration_ms,
            timestamp=datetime.datetime.now().isoformat(),
            is_check=is_check,
            is_checkmate=is_checkmate,
            is_capture=is_capture,
            captured_piece=captured_piece_str
        )
        self.move_history.append(move_data)
        return move_data

    def check_game_over(self) -> Optional[GameResult]:
        """
        Checks all standard FIDE game termination conditions:
        - Checkmate
        - Stalemate
        - Insufficient Material
        - 75-Move Rule & 50-Move Rule
        - Fivefold Repetition & Threefold Repetition
        """
        if self.board.is_checkmate():
            # The active side is checkmated, so the opposing player wins
            winner = PlayerColor.BLACK if self.board.turn == chess.WHITE else PlayerColor.WHITE
            winner_str = "White" if winner == PlayerColor.WHITE else "Black"
            return GameResult(
                winner=winner,
                reason="checkmate",
                description=f"Checkmate! {winner_str} wins the game."
            )
        if self.board.is_stalemate():
            return GameResult(winner=None, reason="stalemate", description="Stalemate! Game is a draw.")
        if self.board.is_insufficient_material():
            return GameResult(winner=None, reason="insufficient_material", description="Draw by insufficient material.")
        if self.board.is_seventyfive_moves():
            return GameResult(winner=None, reason="75_moves", description="Draw by 75-move rule without pawn move or capture.")
        if self.board.is_fivefold_repetition():
            return GameResult(winner=None, reason="5_fold_repetition", description="Draw by fivefold repetition.")
        if self.board.can_claim_threefold_repetition():
            return GameResult(winner=None, reason="3_fold_repetition", description="Draw claimed by threefold repetition.")
        if self.board.can_claim_fifty_moves():
            return GameResult(winner=None, reason="50_moves", description="Draw claimed by 50-move rule.")
        
        return None

    def get_pgn_string(self) -> str:
        """Exports full game notation with headers and reasoning commentary in standard PGN format."""
        exporter = chess.pgn.StringExporter(headers=True, variations=True, comments=True)
        return self.pgn_game.accept(exporter)

    def get_ascii_board(self) -> str:
        """
        Generates an 8x8 ASCII representation of the board with rank and file labels
        for optimal spatial understanding in LLM prompts.
        """
        ranks = str(self.board).split("\n")
        formatted_ranks = []
        for i, rank in enumerate(ranks):
            rank_num = 8 - i
            formatted_ranks.append(f"{rank_num} | {rank}")
        board_str = "\n".join(formatted_ranks)
        board_str += "\n  +----------------"
        board_str += "\n    a b c d e f g h"
        return board_str

    def get_formatted_move_history_san(self, limit: int = 0) -> str:
        """
        Formats the move history into a clean algebraic notation string (e.g. 1. e4 e5 2. Nf3 Nc6).
        If limit > 0 and history exceeds limit, formats only the most recent N moves to save prompt tokens.
        """
        if not self.move_history:
            return "No moves made yet (starting position)."
        
        if limit <= 0 or len(self.move_history) <= limit:
            lines = []
            for i in range(0, len(self.move_history), 2):
                w_move = self.move_history[i]
                move_num = w_move.move_number
                if i + 1 < len(self.move_history):
                    b_move = self.move_history[i + 1]
                    lines.append(f"{move_num}. {w_move.san} {b_move.san}")
                else:
                    lines.append(f"{move_num}. {w_move.san}")
            return " ".join(lines)

        recent_moves = self.move_history[-limit:]
        prefix = f"[... earlier moves truncated; showing last {limit} moves ...]\n"
        tokens = []
        for m in recent_moves:
            if m.turn == PlayerColor.WHITE:
                tokens.append(f"{m.move_number}. {m.san}")
            else:
                if not tokens or not tokens[-1].startswith(f"{m.move_number}."):
                    tokens.append(f"{m.move_number}... {m.san}")
                else:
                    tokens.append(f"{m.san}")
        return prefix + " ".join(tokens)
