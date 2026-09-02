import 'package:flutter/material.dart';

/// Ambient circular ring showing remaining seconds in the move delay interval.
class CountdownRing extends StatelessWidget {
  final double? remainingSeconds;
  final int totalDelaySeconds;

  const CountdownRing({
    super.key,
    required this.remainingSeconds,
    required this.totalDelaySeconds,
  });

  @override
  Widget build(BuildContext context) {
    if (remainingSeconds == null || remainingSeconds! <= 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final progress = (remainingSeconds! / totalDelaySeconds).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${remainingSeconds!.toStringAsFixed(1)}s',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
