import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../../data/models/models.dart';

/// Victory celebration overlay triggering confetti particles and presenting match conclusion outcome.
class VictoryOverlay extends StatefulWidget {
  final GameResult? result;
  final String? whitePlayerName;
  final String? blackPlayerName;
  final VoidCallback onNewMatch;

  const VictoryOverlay({
    super.key,
    this.result,
    this.whitePlayerName,
    this.blackPlayerName,
    required this.onNewMatch,
  });

  @override
  State<VictoryOverlay> createState() => _VictoryOverlayState();
}

class _VictoryOverlayState extends State<VictoryOverlay> {
  late ConfettiController _confettiController;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (widget.result != null) {
      _triggerCelebration();
    }
  }

  @override
  void didUpdateWidget(covariant VictoryOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.result != null && oldWidget.result != widget.result) {
      _triggerCelebration();
    }
  }

  void _triggerCelebration() {
    if (widget.result?.winner != null) {
      _confettiController.play();
    }
    if (!_dialogShown && widget.result != null) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showResultDialog();
      });
    }
  }

  void _showResultDialog() {
    final res = widget.result;
    if (res == null || !mounted) return;

    final isWhiteWin = res.winner == PlayerColor.white;
    final isBlackWin = res.winner == PlayerColor.black;
    final isDraw = res.winner == null;

    final winnerName = isWhiteWin
        ? (widget.whitePlayerName ?? 'White')
        : isBlackWin
            ? (widget.blackPlayerName ?? 'Black')
            : 'Draw';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Text(
                isDraw ? '🤝' : '🏆',
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isDraw ? 'Game Drawn' : '$winnerName Wins!',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (res.description != null && res.description!.isNotEmpty)
                    ? res.description!
                    : 'Match concluded by ${res.reason}.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Reason: ${res.reason}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Review Board'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onNewMatch();
              },
              child: const Text('New Match'),
            ),
          ],
        );
      },
    ).then((_) {
      _dialogShown = false;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Colors.amber,
        ],
      ),
    );
  }
}
