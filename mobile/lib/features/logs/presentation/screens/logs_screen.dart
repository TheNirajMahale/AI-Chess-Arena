import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../arena/application/game_notifier.dart';
import '../../application/past_games_provider.dart';
import '../widgets/game_summary_tile.dart';

/// Screen listing archived chess games with capabilities to replay, resume in live engine, or delete.
class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastGamesAsync = ref.watch(pastGamesProvider);
    final pastGamesNotifier = ref.read(pastGamesProvider.notifier);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Matches Archive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Archive',
            onPressed: () => pastGamesNotifier.refresh(),
          ),
        ],
      ),
      body: pastGamesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  SanitizerUtils.formatErrorMessage(err.toString()),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  onPressed: () => pastGamesNotifier.refresh(),
                  label: const Text('Retry Connection'),
                ),
              ],
            ),
          ),
        ),
        data: (games) {
          if (games.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => pastGamesNotifier.refresh(),
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.history_edu_outlined, size: 48, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No archived games found.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => pastGamesNotifier.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Dismissible(
                  key: Key(game.gameId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Saved Game?'),
                        content: Text('Are you sure you want to delete match ${game.gameId}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    pastGamesNotifier.deleteMatch(game.gameId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Game ${game.gameId} deleted')),
                    );
                  },
                  child: GameSummaryTile(
                    game: game,
                    onReplay: () {
                      context.push('/replay/${game.gameId}');
                    },
                    onLoadIntoLiveEngine: () {
                      gameNotifier.loadGame(game.gameId);
                      context.go('/arena');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Loaded ${game.gameId} into Live Arena')),
                      );
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Saved Game?'),
                          content: Text('Are you sure you want to delete match ${game.gameId}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        pastGamesNotifier.deleteMatch(game.gameId);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
