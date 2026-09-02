import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';

/// Collapsible AI tuning panel for thinking effort, temperature, and custom persona instructions.
class AiTuningExpansionTile extends StatelessWidget {
  final PlayerConfig config;
  final ValueChanged<PlayerConfig> onChanged;

  const AiTuningExpansionTile({
    super.key,
    required this.config,
    required this.onChanged,
  });

  static const Map<String, String> personaPresets = {
    'Grandmaster':
        'You are an elite chess Grandmaster. Think deeply about positional advantages, king safety, and endgame structures.',
    'Aggressive Attacker':
        'You are Mikhail Tal. Play aggressively, sacrifice pieces for initiative, and launch violent attacks against the opponent king.',
    'Solid Positional':
        'You are Anatoly Karpov. Play defensively, minimize weaknesses, restrict opponent counterplay, and squeeze out micro-advantages.',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentThinking = config.thinkingMode.toLowerCase();

    return ExpansionTile(
      title: Text(
        'Advanced AI Tuning',
        style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        'Thinking effort: ${config.thinkingMode.toUpperCase()} • Temp: ${config.temperature.toStringAsFixed(2)}',
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        // 1. Thinking Effort Segmented Button (MD3 Zero-Overflow Full-Width)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reasoning Effort Level',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'off',
                    label: Text('OFF', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ),
                  ButtonSegment<String>(
                    value: 'low',
                    label: Text('LOW', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ),
                  ButtonSegment<String>(
                    value: 'medium',
                    label: Text('MED', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ),
                  ButtonSegment<String>(
                    value: 'high',
                    label: Text('HIGH', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  ),
                ],
                selected: {
                  ['off', 'low', 'medium', 'high'].contains(currentThinking)
                      ? currentThinking
                      : 'medium',
                },
                showSelectedIcon: false,
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onSelectionChanged: (newSelection) {
                  if (newSelection.isNotEmpty) {
                    onChanged(config.copyWith(thinkingMode: newSelection.first));
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. Temperature Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sampling Temperature',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  config.temperature.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: config.temperature,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (val) {
                onChanged(config.copyWith(temperature: double.parse(val.toStringAsFixed(2))));
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 3. System Prompt & Persona Presets
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Persona & System Prompt',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: personaPresets.entries.map((entry) {
                return ActionChip(
                  label: Text(entry.key, style: const TextStyle(fontSize: 10.5)),
                  onPressed: () {
                    onChanged(config.copyWith(systemPrompt: entry.value));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: config.systemPrompt ?? '',
              maxLines: 3,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Enter custom Grandmaster system prompt or instructions...',
              ),
              onChanged: (text) {
                onChanged(config.copyWith(systemPrompt: text.trim().isEmpty ? null : text));
              },
            ),
          ],
        ),
      ],
    );
  }
}
