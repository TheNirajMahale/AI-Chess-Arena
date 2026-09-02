import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Control bar for autoplaying moves and setting replay pace.
class ReplayControls extends StatelessWidget {
  final bool isAutoPlaying;
  final double paceSeconds;
  final String pgn;
  final VoidCallback onToggleAutoPlay;
  final ValueChanged<double> onPaceChanged;

  const ReplayControls({
    super.key,
    required this.isAutoPlaying,
    required this.paceSeconds,
    required this.pgn,
    required this.onToggleAutoPlay,
    required this.onPaceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Auto-play Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onToggleAutoPlay,
                  icon: Icon(
                    isAutoPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 20,
                  ),
                  label: Text(isAutoPlaying ? 'Pause Autoplay' : 'Autoplay Match'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAutoPlaying ? const Color(0xFFF59E0B) : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // PGN Copy Action
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: pgn));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PGN copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy PGN', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Pace Slider
          Row(
            children: [
              const Text('Pace: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(
                '${paceSeconds.toStringAsFixed(1)}s/move',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
              Expanded(
                child: Slider(
                  value: paceSeconds,
                  min: 0.5,
                  max: 10.0,
                  divisions: 19,
                  onChanged: onPaceChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
