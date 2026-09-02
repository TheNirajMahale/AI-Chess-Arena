import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_client.dart';

/// REST API client for application settings, API key verification, and model sync.
class SettingsApi {
  final ApiClient _client;

  SettingsApi(this._client);

  /// Fetches stored application settings and masked API keys.
  Future<({SettingsPayload settings, ApiKeysConfig maskedKeys})> getSettings() async {
    final response = await _client.dio.get(ApiEndpoints.settings);
    final data = response.data as Map<String, dynamic>;

    final settingsJson = data['settings'] as Map<String, dynamic>;
    final maskedKeysJson = data['masked_keys'] as Map<String, dynamic>? ?? {};

    return (
      settings: SettingsPayload.fromJson(settingsJson),
      maskedKeys: ApiKeysConfig.fromJson(maskedKeysJson),
    );
  }

  /// Persists updated application settings and API keys to the server.
  Future<void> updateSettings(SettingsPayload payload) async {
    await _client.dio.post(
      ApiEndpoints.settings,
      data: payload.toJson(),
    );
  }

  /// Retrieves available models catalog annotated with configured credentials status.
  Future<List<ModelOption>> getAvailableModels() async {
    final response = await _client.dio.get(ApiEndpoints.models);
    final data = response.data as Map<String, dynamic>;
    final modelsList = data['models'] as List<dynamic>? ?? [];

    return modelsList
        .map((item) => ModelOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Validates connectivity and credentials for a single AI provider.
  Future<({bool isValid, String message})> testApiKey({
    required ProviderType provider,
    required String apiKey,
  }) async {
    final request = TestKeyRequest(provider: provider, apiKey: apiKey);
    final response = await _client.dio.post(
      ApiEndpoints.testKey,
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return (
      isValid: data['valid'] as bool? ?? false,
      message: data['message'] as String? ?? '',
    );
  }

  /// Triggers a live catalog sync across all configured providers.
  Future<List<ModelOption>> syncModels() async {
    final response = await _client.dio.post(ApiEndpoints.syncModels);
    final data = response.data as Map<String, dynamic>;
    final modelsList = data['models'] as List<dynamic>? ?? [];

    return modelsList
        .map((item) => ModelOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
