import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/models.dart';

/// Modal inspection sheet showing AI reasoning transcript and technical specs for a move.
class MoveInspectorSheet extends StatelessWidget {
  final MoveData move;

  const MoveInspectorSheet({
    super.key,
    required this.move,
  });

  static Future<void> show(BuildContext context, MoveData move) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MoveInspectorSheet(move: move),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWhite = move.turn == PlayerColor.white;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerTheme.color?.withOpacity(0.6) ?? Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Move SAN, UCI, and Turn Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isWhite ? Colors.white : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                ),
                child: Text(
                  isWhite ? '♔ White' : '♚ Black',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isWhite ? const Color(0xFF1E293B) : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${move.moveNumber}. ${move.san}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${move.uci})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Metadata Chips (Duration, Model, Flags)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _InfoChip(label: 'Model', value: move.modelId),
              _InfoChip(label: 'Duration', value: '${move.durationMs} ms'),
              if (move.isCapture)
                _InfoChip(
                  label: 'Captured',
                  value: move.capturedPiece ?? 'Piece',
                  color: Colors.orange,
                ),
              if (move.isCheckmate)
                const _InfoChip(label: 'Status', value: 'Checkmate', color: Colors.red)
              else if (move.isCheck)
                const _InfoChip(label: 'Status', value: 'Check', color: Colors.amber),
            ],
          ),
          const SizedBox(height: 14),

          // Chain of Thought Reasoning Section
          Text(
            'Chain-of-Thought Reasoning',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  move.reasoning.isNotEmpty
                      ? move.reasoning
                      : 'No explicit reasoning transcript recorded for this turn.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // PGN / FEN Copy Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: move.fenAfter));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('FEN copied to clipboard')),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy FEN', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: move.reasoning));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reasoning copied to clipboard')),
                    );
                  },
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('Copy Thoughts', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoChip({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
    );
  }
}
