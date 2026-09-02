import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/models.dart';
import '../../../arena/application/game_notifier.dart';
import '../../application/match_setup_provider.dart';
import '../widgets/player_config_card.dart';

/// Screen for configuring AI competitors, tuning reasoning parameters, and launching matches.
class SetupMatchScreen extends ConsumerWidget {
  const SetupMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(matchSetupProvider);
    final setupNotifier = ref.read(matchSetupProvider.notifier);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Setup & Roster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Swap Sides (White ↔ Black)',
            onPressed: () => setupNotifier.swapPlayers(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Model Catalog',
            onPressed: () => setupNotifier.loadModels(),
          ),
        ],
      ),
      body: setupState.isLoadingModels && setupState.availableModels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. White Player Card
                  PlayerConfigCard(
                    config: setupState.whitePlayer,
                    color: PlayerColor.white,
                    availableModels: setupState.availableModels,
                    onChanged: (cfg) => setupNotifier.updateWhitePlayer(cfg),
                  ),

                  // Swap Sides Floating Pill
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton.icon(
                        onPressed: () => setupNotifier.swapPlayers(),
                        icon: const Icon(Icons.swap_vert_rounded, size: 18),
                        label: const Text('Swap White ↔ Black'),
                      ),
                    ),
                  ),

                  // 2. Black Player Card
                  PlayerConfigCard(
                    config: setupState.blackPlayer,
                    color: PlayerColor.black,
                    availableModels: setupState.availableModels,
                    onChanged: (cfg) => setupNotifier.updateBlackPlayer(cfg),
                  ),
                  const SizedBox(height: 16),

                  // 3. Move Delay Slider
                  Container(
                    padding: const EdgeInsets.all(16),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Move Delay Interval',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${setupState.moveDelaySeconds} seconds',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: setupState.moveDelaySeconds.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          onChanged: (val) {
                            setupNotifier.updateMoveDelay(val.round());
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Launch Battle Button
                  ElevatedButton.icon(
                    onPressed: () {
                      gameNotifier.startMatch(
                        whitePlayer: setupState.whitePlayer,
                        blackPlayer: setupState.blackPlayer,
                        moveDelaySeconds: setupState.moveDelaySeconds,
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.sports_esports_rounded),
                    label: const Text('Launch AI Battle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
