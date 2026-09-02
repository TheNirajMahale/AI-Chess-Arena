import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/models.dart';

/// Card tile for browsing an archived match summary with actions to replay, resume, or delete.
class GameSummaryTile extends StatelessWidget {
  final GameSummary game;
  final VoidCallback onReplay;
  final VoidCallback onLoadIntoLiveEngine;
  final VoidCallback onDelete;

  const GameSummaryTile({
    super.key,
    required this.game,
    required this.onReplay,
    required this.onLoadIntoLiveEngine,
    required this.onDelete,
  });

  String _formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Archived Match';
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMM d, yyyy • h:mm a').format(date);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatTimestamp(game.startTime);
    final winner = game.result?.winner;
    final reason = game.result?.reason ?? '';

    final isWhiteWin = winner == PlayerColor.white;
    final isBlackWin = winner == PlayerColor.black;
    final isDraw = winner == null && reason.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onReplay,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Date & Outcome Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.65),
                      fontSize: 11,
                    ),
                  ),
                  if (isWhiteWin)
                    const _OutcomeBadge(label: 'White Won', color: Color(0xFF10B981))
                  else if (isBlackWin)
                    const _OutcomeBadge(label: 'Black Won', color: Color(0xFF6366F1))
                  else if (isDraw)
                    _OutcomeBadge(label: 'Draw', color: Colors.amber[700]!)
                  else
                    const _OutcomeBadge(label: 'Incomplete', color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),

              // Match Competitors
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('♔ ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                game.whitePlayer,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          (game.whiteModel != null && game.whiteModel!.isNotEmpty)
                              ? game.whiteModel!
                              : 'Custom AI',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'VS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                game.blackPlayer,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Text(' ♚', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Text(
                          (game.blackModel != null && game.blackModel!.isNotEmpty)
                              ? game.blackModel!
                              : 'Custom AI',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Bottom Stats Row & Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${game.movesCount} moves • ${reason.isNotEmpty ? reason : "concluded"}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 11.5,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Resume / Load match into live arena
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                        tooltip: 'Load in Live Engine',
                        onPressed: onLoadIntoLiveEngine,
                      ),
                      // Replay Inspector button
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                        tooltip: 'Open Replay Inspector',
                        onPressed: onReplay,
                      ),
                      // Delete match record
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        tooltip: 'Delete Game',
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _OutcomeBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
