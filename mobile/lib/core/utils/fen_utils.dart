import '../../data/models/models.dart';

/// Utilities for parsing and translating FEN (Forsyth–Edwards Notation) strings and chess board coordinates.
class FenUtils {
  FenUtils._();

  static const String initialFen =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  /// Parses the board placement section of a FEN string into an 8x8 matrix.
  /// Row 0 represents Rank 8, Row 7 represents Rank 1.
  /// Col 0 represents File 'a', Col 7 represents File 'h'.
  static List<List<String?>> parseBoard(String fen) {
    final board = List.generate(8, (_) => List<String?>.filled(8, null));
    final parts = fen.trim().split(' ');
    if (parts.isEmpty) return board;

    final placement = parts[0];
    final ranks = placement.split('/');

    for (int r = 0; r < ranks.length && r < 8; r++) {
      int c = 0;
      for (int i = 0; i < ranks[r].length && c < 8; i++) {
        final char = ranks[r][i];
        final digit = int.tryParse(char);
        if (digit != null) {
          c += digit;
        } else {
          board[r][c] = char;
          c++;
        }
      }
    }

    return board;
  }

  /// Converts algebraic notation (e.g. "e4") to (row, col) indices in the 8x8 matrix.
  static ({int row, int col})? squareToIndex(String square) {
    if (square.length < 2) return null;
    final fileChar = square[0].toLowerCase();
    final rankChar = square[1];

    final col = fileChar.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = int.tryParse(rankChar);
    if (col < 0 || col > 7 || rank == null || rank < 1 || rank > 8) return null;

    final row = 8 - rank;
    return (row: row, col: col);
  }

  /// Converts (row, col) matrix indices to algebraic square notation (e.g. "e4").
  static String indexToSquare(int row, int col) {
    if (row < 0 || row > 7 || col < 0 || col > 7) return '';
    final file = String.fromCharCode('a'.codeUnitAt(0) + col);
    final rank = 8 - row;
    return '$file$rank';
  }

  /// Locates the square containing the King for a given player color.
  static String? findKingSquare(String fen, PlayerColor color) {
    final targetPiece = color == PlayerColor.white ? 'K' : 'k';
    final board = parseBoard(fen);

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == targetPiece) {
          return indexToSquare(r, c);
        }
      }
    }
    return null;
  }
}
