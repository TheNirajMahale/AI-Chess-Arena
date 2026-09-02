/// Material evaluation calculations and piece weight definitions.
class MaterialEval {
  MaterialEval._();

  static const Map<String, int> pieceWeights = {
    'p': 1, 'P': 1,
    'n': 3, 'N': 3,
    'b': 3, 'B': 3,
    'r': 5, 'R': 5,
    'q': 9, 'Q': 9,
    'k': 0, 'K': 0,
  };

  static const Map<String, String> pieceSymbols = {
    'p': '♟', 'n': '♞', 'b': '♝', 'r': '♜', 'q': '♛', 'k': '♚',
    'P': '♙', 'N': '♘', 'B': '♗', 'R': '♖', 'Q': '♕', 'K': '♔',
  };

  /// Calculates total piece score for a list of captured piece characters.
  static int calculateScore(List<String> capturedPieces) {
    return capturedPieces.fold(0, (sum, piece) => sum + (pieceWeights[piece] ?? 0));
  }

  /// Returns material difference (positive = White leads, negative = Black leads).
  static int calculateAdvantage({
    required List<String> capturedByWhite,
    required List<String> capturedByBlack,
  }) {
    final whiteScore = calculateScore(capturedByWhite);
    final blackScore = calculateScore(capturedByBlack);
    return whiteScore - blackScore;
  }
}
