import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/models.dart';
import '../../arena/application/api_client_provider.dart';

class PastGamesNotifier extends AsyncNotifier<List<GameSummary>> {
  @override
  Future<List<GameSummary>> build() async {
    final gamesApi = ref.watch(gamesApiProvider);
    return gamesApi.getPastGames();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final gamesApi = ref.read(gamesApiProvider);
      return gamesApi.getPastGames();
    });
  }

  Future<bool> deleteMatch(String gameId) async {
    try {
      final gamesApi = ref.read(gamesApiProvider);
      final success = await gamesApi.deleteGame(gameId);
      if (success) {
        final currentList = state.value ?? [];
        state = AsyncValue.data(
          currentList.where((g) => g.gameId != gameId).toList(),
        );
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}

final pastGamesProvider =
    AsyncNotifierProvider<PastGamesNotifier, List<GameSummary>>(
  () => PastGamesNotifier(),
);
