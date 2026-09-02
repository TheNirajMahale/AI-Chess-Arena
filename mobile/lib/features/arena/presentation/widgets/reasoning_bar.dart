import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';
import 'reasoning_sheet.dart';

/// Enhanced bottom reasoning dock (height: 72dp) previewing rich multi-line thoughts and embedded controls.
class ReasoningBar extends ConsumerWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStep;
  final VoidCallback onStop;

  const ReasoningBar({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStep,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final gameState = state.gameState;
    final liveThinking = state.liveThinking;
    final isThinking = gameState?.isThinking ?? false;
    final moves = gameState?.moveHistory ?? <MoveData>[];
    final thinkingPlayer = gameState?.thinkingPlayer;
    final countdownSeconds = gameState?.countdownSeconds;
    final status = gameState?.status ?? GameStatus.idle;
    final isActionInProgress = state.isActionInProgress;
    final theme = Theme.of(context);

    final cleanSnippet = SanitizerUtils.sanitizeThoughtText(liveThinking)
        .replaceAll('\n', ' ')
        .trim();
    final lastMove = moves.isNotEmpty ? moves.last : null;
    final lastMoveReasoning = lastMove != null && lastMove.reasoning.isNotEmpty
        ? SanitizerUtils.sanitizeThoughtText(lastMove.reasoning).replaceAll('\n', ' ').trim()
        : '';

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -6) {
          ReasoningSheet.show(context);
        }
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isThinking
                ? theme.colorScheme.primary.withOpacity(0.55)
                : (theme.dividerTheme.color ?? Colors.transparent),
            width: isThinking ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. Left & Center Tappable & Draggable Rich Reasoning Preview
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ReasoningSheet.show(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Top Header Row
                        Row(
                          children: [
                            if (isThinking) ...[
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${thinkingPlayer == PlayerColor.white ? "White" : "Black"} AI Thinking',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ] else if (countdownSeconds != null && countdownSeconds > 0) ...[
                              Icon(Icons.hourglass_top_rounded, size: 13, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Delay: ${countdownSeconds}s • Next Turn',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[700],
                                ),
                              ),
                            ] else ...[
                              const Icon(Icons.psychology_outlined, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Reasoning & Move History (${moves.length})',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Expand',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: 14,
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),

                        // Bottom Multi-Line Content Preview
                        if (isThinking)
                          Text(
                            cleanSnippet.isNotEmpty ? cleanSnippet : 'Generating reasoning & calculating candidate moves...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                              color: theme.colorScheme.onSurface.withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (lastMove != null)
                          Text(
                            lastMoveReasoning.isNotEmpty
                                ? '${lastMove.moveNumber}. ${lastMove.san}: "$lastMoveReasoning"'
                                : '${lastMove.moveNumber}. ${lastMove.san} • ${lastMove.playerName} (${lastMove.durationMs}ms)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                              color: theme.colorScheme.onSurface.withOpacity(0.75),
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            'Tap or drag up for live token stream & move logs',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                              color: theme.colorScheme.onSurface.withOpacity(0.55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 2. Subtle Divider
            Container(
              height: 44,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2),
            ),

            // 3. Embedded Small Circular Action Buttons
            _EmbeddedActionControls(
              status: status,
              isActionInProgress: isActionInProgress,
              onStart: onStart,
              onPause: onPause,
              onResume: onResume,
              onStep: onStep,
              onStop: onStop,
            ),
          ],
        ),
      ),
    );
  }
}

/// Embedded small circular action buttons matching current compact sizes.
class _EmbeddedActionControls extends StatelessWidget {
  final GameStatus status;
  final bool isActionInProgress;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStep;
  final VoidCallback onStop;

  const _EmbeddedActionControls({
    required this.status,
    required this.isActionInProgress,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStep,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isActionInProgress) {
      return Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    switch (status) {
      case GameStatus.idle:
      case GameStatus.finished:
        return _CompactRoundButton(
          size: 40,
          icon: Icons.play_arrow_rounded,
          iconSize: 26,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          tooltip: 'Start Match',
          onPressed: onStart,
        );

      case GameStatus.playing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CompactRoundButton(
              size: 34,
              icon: Icons.stop_rounded,
              iconSize: 18,
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              tooltip: 'Stop Match',
              onPressed: onStop,
            ),
            const SizedBox(width: 6),
            _CompactRoundButton(
              size: 40,
              icon: Icons.pause_rounded,
              iconSize: 24,
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              tooltip: 'Pause',
              onPressed: onPause,
            ),
          ],
        );

      case GameStatus.paused:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CompactRoundButton(
              size: 32,
              icon: Icons.stop_rounded,
              iconSize: 16,
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              tooltip: 'Reset Match',
              onPressed: onStop,
            ),
            const SizedBox(width: 4),
            _CompactRoundButton(
              size: 32,
              icon: Icons.skip_next_rounded,
              iconSize: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              tooltip: 'Step Turn',
              onPressed: onStep,
            ),
            const SizedBox(width: 4),
            _CompactRoundButton(
              size: 40,
              icon: Icons.play_arrow_rounded,
              iconSize: 24,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              tooltip: 'Resume',
              onPressed: onResume,
            ),
          ],
        );
    }
  }
}

class _CompactRoundButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final VoidCallback onPressed;

  const _CompactRoundButton({
    required this.size,
    required this.icon,
    required this.iconSize,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: iconSize,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
