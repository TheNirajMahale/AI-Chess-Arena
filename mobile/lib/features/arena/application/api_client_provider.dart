import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/game_control_api.dart';
import '../../../data/api/settings_api.dart';
import '../../../data/api/games_api.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(appSettingsProvider.select((s) => s.baseUrl));
  return ApiClient(baseUrl: baseUrl);
});

final gameControlApiProvider = Provider<GameControlApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return GameControlApi(client);
});

final settingsApiProvider = Provider<SettingsApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return SettingsApi(client);
});

final gamesApiProvider = Provider<GamesApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return GamesApi(client);
});
