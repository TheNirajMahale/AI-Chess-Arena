import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';

/// Collapsible card showing original historical configuration, models, and outcome details.
class HistoricalSpecCard extends StatelessWidget {
  final GameState game;

  const HistoricalSpecCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final white = game.whitePlayer;
    final black = game.blackPlayer;
    final res = game.result;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: ExpansionTile(
        title: Text(
          'Historical Match Specifications',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Game ID: ${game.gameId} • Outcome: ${res?.reason ?? "concluded"}',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 8),

          // White specs
          _PlayerSpecRow(
            side: '♔ White',
            name: white?.name ?? 'White AI',
            model: white?.modelId ?? 'Unknown',
            temp: white?.temperature ?? 0.7,
            prompt: white?.systemPrompt,
          ),
          const SizedBox(height: 10),

          // Black specs
          _PlayerSpecRow(
            side: '♚ Black',
            name: black?.name ?? 'Black AI',
            model: black?.modelId ?? 'Unknown',
            temp: black?.temperature ?? 0.7,
            prompt: black?.systemPrompt,
          ),
        ],
      ),
    );
  }
}

class _PlayerSpecRow extends StatelessWidget {
  final String side;
  final String name;
  final String model;
  final double temp;
  final String? prompt;

  const _PlayerSpecRow({
    required this.side,
    required this.name,
    required this.model,
    required this.temp,
    this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$side: $name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            Text(
              'Temp: $temp',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ),
        Text(
          'Model: $model',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, color: theme.colorScheme.primary),
        ),
        if (prompt != null && prompt!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Prompt: $prompt',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.5, fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
