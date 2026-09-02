import 'package:flutter/material.dart';
import '../../core/theme/board_themes.dart';
import '../../core/utils/fen_utils.dart';
import '../../data/models/models.dart';

/// High-performance CustomPainter chessboard canvas supporting themes, last-move highlights,
/// check overlays, perspective flipping, and vector pieces.
class ChessBoardView extends StatelessWidget {
  final String fen;
  final BoardTheme theme;
  final String? lastMoveUci;
  final bool isCheck;
  final PlayerColor? activeTurn;
  final bool isFlipped;
  final double size;

  const ChessBoardView({
    super.key,
    required this.fen,
    required this.theme,
    this.lastMoveUci,
    this.isCheck = false,
    this.activeTurn,
    this.isFlipped = false,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomPaint(
          size: Size(size, size),
          painter: _ChessBoardPainter(
            fen: fen,
            theme: theme,
            lastMoveUci: lastMoveUci,
            isCheck: isCheck,
            activeTurn: activeTurn,
            isFlipped: isFlipped,
          ),
        ),
      ),
    );
  }
}

class _ChessBoardPainter extends CustomPainter {
  final String fen;
  final BoardTheme theme;
  final String? lastMoveUci;
  final bool isCheck;
  final PlayerColor? activeTurn;
  final bool isFlipped;

  _ChessBoardPainter({
    required this.fen,
    required this.theme,
    this.lastMoveUci,
    required this.isCheck,
    this.activeTurn,
    required this.isFlipped,
  });

  static const Map<String, String> _unicodePieces = {
    'K': '♔', 'Q': '♕', 'R': '♖', 'B': '♗', 'N': '♘', 'P': '♙',
    'k': '♚', 'q': '♛', 'r': '♜', 'b': '♝', 'n': '♞', 'p': '♟',
  };

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = size.width / 8;
    final boardMatrix = FenUtils.parseBoard(fen);

    // 1. Identify highlighted squares from last move
    ({int row, int col})? fromSquare;
    ({int row, int col})? toSquare;
    if (lastMoveUci != null && lastMoveUci!.length >= 4) {
      final fromStr = lastMoveUci!.substring(0, 2);
      final toStr = lastMoveUci!.substring(2, 4);
      fromSquare = FenUtils.squareToIndex(fromStr);
      toSquare = FenUtils.squareToIndex(toStr);
    }

    // 2. Identify King square if in check
    ({int row, int col})? checkKingSquare;
    if (isCheck && activeTurn != null) {
      final kingCoord = FenUtils.findKingSquare(fen, activeTurn!);
      if (kingCoord != null) {
        checkKingSquare = FenUtils.squareToIndex(kingCoord);
      }
    }

    final lightPaint = Paint()..color = theme.lightSquare;
    final darkPaint = Paint()..color = theme.darkSquare;
    final highlightPaint = Paint()
      ..color = theme.highlight.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final checkGlowPaint = Paint()
      ..color = theme.checkGlow.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // 3. Draw Squares & Highlights
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final drawRow = isFlipped ? 7 - r : r;
        final drawCol = isFlipped ? 7 - c : c;
        final rect = Rect.fromLTWH(
          drawCol * squareSize,
          drawRow * squareSize,
          squareSize,
          squareSize,
        );

        final isLight = (r + c) % 2 == 0;
        canvas.drawRect(rect, isLight ? lightPaint : darkPaint);

        // Highlight last move
        final isLastMoveOrigin = fromSquare != null && fromSquare.row == r && fromSquare.col == c;
        final isLastMoveDest = toSquare != null && toSquare.row == r && toSquare.col == c;
        if (isLastMoveOrigin || isLastMoveDest) {
          canvas.drawRect(rect, highlightPaint);
        }

        // Draw King check glow
        if (checkKingSquare != null && checkKingSquare.row == r && checkKingSquare.col == c) {
          canvas.drawRect(rect, checkGlowPaint);
        }
      }
    }

    // 4. Draw Coordinate Labels
    final labelStyle = TextStyle(
      fontSize: squareSize * 0.2,
      fontWeight: FontWeight.w700,
      color: Colors.black.withOpacity(0.35),
    );

    for (int i = 0; i < 8; i++) {
      final rankNum = isFlipped ? (i + 1).toString() : (8 - i).toString();
      final fileChar = isFlipped
          ? String.fromCharCode('h'.codeUnitAt(0) - i)
          : String.fromCharCode('a'.codeUnitAt(0) + i);

      // Rank numbers on left edge
      final rankPainter = TextPainter(
        text: TextSpan(text: rankNum, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      rankPainter.paint(canvas, Offset(3, i * squareSize + 3));

      // File letters on bottom edge
      final filePainter = TextPainter(
        text: TextSpan(text: fileChar, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      filePainter.paint(
        canvas,
        Offset(
          (i + 1) * squareSize - filePainter.width - 3,
          size.height - filePainter.height - 2,
        ),
      );
    }

    // 5. Draw Pieces
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = boardMatrix[r][c];
        if (piece == null) continue;

        final drawRow = isFlipped ? 7 - r : r;
        final drawCol = isFlipped ? 7 - c : c;
        final glyph = _unicodePieces[piece] ?? piece;
        final isWhitePiece = piece == piece.toUpperCase();

        final piecePainter = TextPainter(
          text: TextSpan(
            text: glyph,
            style: TextStyle(
              fontSize: squareSize * 0.78,
              height: 1.0,
              color: isWhitePiece ? const Color(0xFFFFFFFF) : const Color(0xFF18181B),
              shadows: [
                Shadow(
                  color: isWhitePiece
                      ? const Color(0xFF000000).withOpacity(0.65)
                      : const Color(0xFFFFFFFF).withOpacity(0.35),
                  blurRadius: 2.5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final offset = Offset(
          drawCol * squareSize + (squareSize - piecePainter.width) / 2,
          drawRow * squareSize + (squareSize - piecePainter.height) / 2,
        );

        piecePainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChessBoardPainter oldDelegate) {
    return oldDelegate.fen != fen ||
        oldDelegate.theme.id != theme.id ||
        oldDelegate.lastMoveUci != lastMoveUci ||
        oldDelegate.isCheck != isCheck ||
        oldDelegate.activeTurn != activeTurn ||
        oldDelegate.isFlipped != isFlipped;
  }
}
