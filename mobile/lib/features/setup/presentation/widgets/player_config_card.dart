import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';
import 'ai_tuning_expansion_tile.dart';

/// Card component for configuring an individual AI player side (White or Black).
class PlayerConfigCard extends StatelessWidget {
  final PlayerConfig config;
  final PlayerColor color;
  final List<ModelOption> availableModels;
  final ValueChanged<PlayerConfig> onChanged;

  const PlayerConfigCard({
    super.key,
    required this.config,
    required this.color,
    required this.availableModels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWhite = color == PlayerColor.white;

    // Filter models for selected provider
    final providerModels = availableModels
        .where((m) => m.provider == config.provider)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Side Badge & Display Name)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
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
                      fontWeight: FontWeight.w800,
                      color: isWhite ? const Color(0xFF1E293B) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: config.name,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (name) {
                      onChanged(config.copyWith(name: name.trim().isEmpty ? 'AI Player' : name));
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. Provider Selection Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: DropdownButtonFormField<ProviderType>(
              value: config.provider,
              decoration: const InputDecoration(
                labelText: 'AI Provider',
                isDense: true,
              ),
              items: ProviderType.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.displayName, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (newProvider) {
                if (newProvider != null) {
                  // Pick first available model for this provider if available
                  final firstModel = availableModels.firstWhere(
                    (m) => m.provider == newProvider,
                    orElse: () => ModelOption(
                      id: '${newProvider.name}/default',
                      name: '${newProvider.displayName} Default',
                      provider: newProvider,
                    ),
                  );
                  onChanged(config.copyWith(
                    provider: newProvider,
                    modelId: firstModel.id,
                  ));
                }
              },
            ),
          ),

          // 3. Model Identifier Dropdown / Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: providerModels.isNotEmpty
                ? DropdownButtonFormField<String>(
                    value: providerModels.any((m) => m.id == config.modelId)
                        ? config.modelId
                        : providerModels.first.id,
                    decoration: const InputDecoration(
                      labelText: 'AI Model',
                      isDense: true,
                    ),
                    items: providerModels.map((m) {
                      return DropdownMenuItem(
                        value: m.id,
                        child: Row(
                          children: [
                            Text(m.name, style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 6),
                            if (m.isConfigured)
                              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981))
                            else
                              Text(
                                '(No Key)',
                                style: TextStyle(fontSize: 10, color: Colors.amber[700]),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newModelId) {
                      if (newModelId != null) {
                        onChanged(config.copyWith(modelId: newModelId));
                      }
                    },
                  )
                : TextFormField(
                    initialValue: config.modelId,
                    decoration: const InputDecoration(
                      labelText: 'Custom Model ID',
                      isDense: true,
                    ),
                    onChanged: (newId) {
                      onChanged(config.copyWith(modelId: newId.trim()));
                    },
                  ),
          ),

          // 4. Embedded Advanced AI Tuning Tile
          AiTuningExpansionTile(
            config: config,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
