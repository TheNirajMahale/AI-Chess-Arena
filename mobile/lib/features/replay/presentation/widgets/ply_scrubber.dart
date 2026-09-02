import 'package:flutter/material.dart';

/// Interactive move scrubber for stepping through past match plies with slider and stepping buttons.
class PlyScrubber extends StatelessWidget {
  final int currentPly;
  final int totalPlies;
  final ValueChanged<int> onPlyChanged;
  final VoidCallback onFirst;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onLast;

  const PlyScrubber({
    super.key,
    required this.currentPly,
    required this.totalPlies,
    required this.onPlyChanged,
    required this.onFirst,
    required this.onPrev,
    required this.onNext,
    required this.onLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPrev = currentPly > 0;
    final canNext = currentPly < totalPlies;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: Column(
        children: [
          // 1. Slider & Counter
          Row(
            children: [
              Text(
                'Ply $currentPly / $totalPlies',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: currentPly.toDouble(),
                  min: 0,
                  max: totalPlies > 0 ? totalPlies.toDouble() : 1.0,
                  divisions: totalPlies > 0 ? totalPlies : 1,
                  onChanged: totalPlies > 0 ? (val) => onPlyChanged(val.round()) : null,
                ),
              ),
            ],
          ),

          // 2. Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.first_page_rounded, size: 20),
                tooltip: 'Start (Ply 0)',
                onPressed: canPrev ? onFirst : null,
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.navigate_before_rounded, size: 22),
                tooltip: 'Previous Move',
                onPressed: canPrev ? onPrev : null,
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.navigate_next_rounded, size: 22),
                tooltip: 'Next Move',
                onPressed: canNext ? onNext : null,
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.last_page_rounded, size: 20),
                tooltip: 'Final Position',
                onPressed: canNext ? onLast : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
