import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../application/game_notifier.dart';

/// Tactical control bar for starting, pausing, stepping, resuming, and resetting matches.
class TacticalActionBar extends ConsumerWidget {
  final VoidCallback onOpenSetup;

  const TacticalActionBar({
    super.key,
    required this.onOpenSetup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(gameNotifierProvider.select((s) => s.gameState?.status ?? GameStatus.idle));
    final isActionInProgress = ref.watch(gameNotifierProvider.select((s) => s.isActionInProgress));
    final notifier = ref.read(gameNotifierProvider.notifier);
    final theme = Theme.of(context);

    final isPlaying = status == GameStatus.playing;
    final isPaused = status == GameStatus.paused;
    final isIdle = status == GameStatus.idle || status == GameStatus.finished;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Primary Action Button (Start / Pause / Resume)
          if (isIdle)
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: isActionInProgress ? null : onOpenSetup,
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text('Start Match'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
              ),
            )
          else if (isPlaying)
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: isActionInProgress ? null : () => notifier.pauseMatch(),
                icon: const Icon(Icons.pause_rounded, size: 20),
                label: const Text('Pause'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                ),
              ),
            )
          else if (isPaused)
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: isActionInProgress ? null : () => notifier.resumeMatch(),
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text('Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // 2. Step Button (Only visible when paused)
          if (isPaused) ...[
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: isActionInProgress ? null : () => notifier.stepMatch(),
                icon: const Icon(Icons.redo_rounded, size: 16),
                label: const Text('Step'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // 3. Reset / Stop Button (Visible during active or paused match)
          if (!isIdle)
            IconButton.filledTonal(
              onPressed: isActionInProgress ? null : () => notifier.stopMatch(),
              icon: const Icon(Icons.stop_rounded, color: Color(0xFFEF4444)),
              tooltip: 'Reset / Stop Match',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444).withOpacity(0.15),
              ),
            )
          else
            IconButton.filledTonal(
              onPressed: isActionInProgress ? null : onOpenSetup,
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Configure Players',
            ),
        ],
      ),
    );
  }
}
