import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_client.dart';

/// REST API service for controlling match lifecycle actions and speed delay.
class GameControlApi {
  final ApiClient _client;

  GameControlApi(this._client);

  /// Dispatches a game control action (start, pause, resume, step, stop, reset, load).
  Future<GameState> sendControl({
    required String action,
    PlayerConfig? whitePlayer,
    PlayerConfig? blackPlayer,
    int? moveDelaySeconds,
    String? gameId,
  }) async {
    final request = GameControlRequest(
      action: action,
      whitePlayer: whitePlayer,
      blackPlayer: blackPlayer,
      moveDelaySeconds: moveDelaySeconds,
      gameId: gameId,
    );

    final response = await _client.dio.post(
      ApiEndpoints.gameControl,
      data: request.toJson(),
    );

    final data = response.data as Map<String, dynamic>;
    return GameState.fromJson(data['state'] as Map<String, dynamic>);
  }

  /// Dynamically updates the delay interval between moves mid-match.
  Future<int> updateDelay(int delaySeconds) async {
    final response = await _client.dio.post(
      ApiEndpoints.gameDelay,
      data: {'delay': delaySeconds},
    );
    final data = response.data as Map<String, dynamic>;
    return data['delay'] as int? ?? delaySeconds;
  }

  /// Restores a specific saved match from history and synchronizes it with the engine.
  Future<GameState> loadGame(String gameId) async {
    final response = await _client.dio.post(
      ApiEndpoints.gameLoad(gameId),
    );
    final data = response.data as Map<String, dynamic>;
    return GameState.fromJson(data['state'] as Map<String, dynamic>);
  }
}
