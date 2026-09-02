import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';

/// Interactive move history list displaying numbered SAN turns and supporting move inspection.
class MoveHistoryList extends StatelessWidget {
  final List<MoveData> moves;
  final ValueChanged<MoveData>? onSelectMove;
  final MoveData? selectedMove;

  const MoveHistoryList({
    super.key,
    required this.moves,
    this.onSelectMove,
    this.selectedMove,
  });

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return const Center(
        child: Text(
          'No moves played yet.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }

    final theme = Theme.of(context);
    final pairedMoves = <({int moveNumber, MoveData? whiteMove, MoveData? blackMove})>[];

    for (int i = 0; i < moves.length; i++) {
      final move = moves[i];
      if (move.turn == PlayerColor.white) {
        pairedMoves.add((
          moveNumber: move.moveNumber,
          whiteMove: move,
          blackMove: null,
        ));
      } else {
        if (pairedMoves.isNotEmpty && pairedMoves.last.blackMove == null) {
          final last = pairedMoves.removeLast();
          pairedMoves.add((
            moveNumber: last.moveNumber,
            whiteMove: last.whiteMove,
            blackMove: move,
          ));
        } else {
          pairedMoves.add((
            moveNumber: move.moveNumber,
            whiteMove: null,
            blackMove: move,
          ));
        }
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: pairedMoves.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: theme.dividerTheme.color?.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        final pair = pairedMoves[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Move Number
              SizedBox(
                width: 32,
                child: Text(
                  '${pair.moveNumber}.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),

              // White Move Button
              Expanded(
                child: pair.whiteMove != null
                    ? _MoveChip(
                        move: pair.whiteMove!,
                        isSelected: selectedMove == pair.whiteMove,
                        onTap: () => onSelectMove?.call(pair.whiteMove!),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),

              // Black Move Button
              Expanded(
                child: pair.blackMove != null
                    ? _MoveChip(
                        move: pair.blackMove!,
                        isSelected: selectedMove == pair.blackMove,
                        onTap: () => onSelectMove?.call(pair.blackMove!),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MoveChip extends StatelessWidget {
  final MoveData move;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoveChip({
    required this.move,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCheck = move.isCheck;
    final isCheckmate = move.isCheckmate;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              move.san,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
            if (isCheckmate)
              const Text('♟#', style: TextStyle(fontSize: 10, color: Colors.red))
            else if (isCheck)
              const Text('+', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}
