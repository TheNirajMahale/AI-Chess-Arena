/// Centralized REST and WebSocket API endpoint constants for Chess Arena backend.
class ApiEndpoints {
  ApiEndpoints._();

  static const String defaultBaseUrl = 'http://127.0.0.1:8000';
  static const String defaultWsUrl = 'ws://127.0.0.1:8000/ws/game';

  // REST Endpoints
  static const String settings = '/api/settings';
  static const String models = '/api/models';
  static const String syncModels = '/api/sync-models';
  static const String testKey = '/api/test-key';
  static const String fetchLiveModels = '/api/fetch-live-models';
  static const String gameControl = '/api/game/control';
  static const String gameDelay = '/api/game/delay';
  static const String games = '/api/games';
  
  static String gameDetail(String gameId) => '/api/games/$gameId';
  static String gameLoad(String gameId) => '/api/games/$gameId/load';
}
