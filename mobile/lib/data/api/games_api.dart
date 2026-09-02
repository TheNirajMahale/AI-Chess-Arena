import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_client.dart';

/// REST API service for querying, retrieving, and deleting archived matches.
class GamesApi {
  final ApiClient _client;

  GamesApi(this._client);

  /// Retrieves list of all archived past matches sorted in reverse chronological order.
  Future<List<GameSummary>> getPastGames() async {
    final response = await _client.dio.get(ApiEndpoints.games);
    final data = response.data as List<dynamic>? ?? [];

    return data
        .map((item) => GameSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Retrieves the complete game state and reasoning transcript for a specific past game ID.
  Future<GameState> getGameDetail(String gameId) async {
    final response = await _client.dio.get(ApiEndpoints.gameDetail(gameId));
    final data = response.data as Map<String, dynamic>;
    return GameState.fromJson(data);
  }

  /// Deletes a saved match from disk storage.
  Future<bool> deleteGame(String gameId) async {
    final response = await _client.dio.delete(ApiEndpoints.gameDetail(gameId));
    final data = response.data as Map<String, dynamic>? ?? {};
    return data['status'] == 'success';
  }
}
