import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/sanitizer_utils.dart';
import '../../../data/models/models.dart';
import '../../arena/application/api_client_provider.dart';
import '../../setup/application/match_setup_provider.dart';

class SettingsScreenState {
  final SettingsPayload settings;
  final ApiKeysConfig maskedKeys;
  final bool isLoading;
  final bool isSaving;
  final bool isSyncing;
  final String? statusMessage;
  final Map<ProviderType, ({bool isValid, String message})> keyTestResults;

  const SettingsScreenState({
    this.settings = const SettingsPayload(),
    this.maskedKeys = const ApiKeysConfig(),
    this.isLoading = false,
    this.isSaving = false,
    this.isSyncing = false,
    this.statusMessage,
    this.keyTestResults = const {},
  });

  SettingsScreenState copyWith({
    SettingsPayload? settings,
    ApiKeysConfig? maskedKeys,
    bool? isLoading,
    bool? isSaving,
    bool? isSyncing,
    String? statusMessage,
    Map<ProviderType, ({bool isValid, String message})>? keyTestResults,
    bool clearStatus = false,
  }) {
    return SettingsScreenState(
      settings: settings ?? this.settings,
      maskedKeys: maskedKeys ?? this.maskedKeys,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSyncing: isSyncing ?? this.isSyncing,
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      keyTestResults: keyTestResults ?? this.keyTestResults,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsScreenState> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(const SettingsScreenState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, clearStatus: true);
    try {
      final settingsApi = _ref.read(settingsApiProvider);
      final result = await settingsApi.getSettings();
      state = state.copyWith(
        settings: result.settings,
        maskedKeys: result.maskedKeys,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        statusMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  void updateKeys(ApiKeysConfig newKeys) {
    state = state.copyWith(
      settings: state.settings.copyWith(keys: newKeys),
    );
  }

  void updateIncludeAscii(bool value) {
    state = state.copyWith(
      settings: state.settings.copyWith(includeAsciiBoard: value),
    );
  }

  void updateContextLimit(int limit) {
    state = state.copyWith(
      settings: state.settings.copyWith(historyContextLimit: limit),
    );
  }

  void updateMaxOutputTokens(int tokens) {
    state = state.copyWith(
      settings: state.settings.copyWith(maxOutputTokens: tokens),
    );
  }

  void updateDefaultDelay(int delay) {
    state = state.copyWith(
      settings: state.settings.copyWith(defaultDelay: delay),
    );
  }

  Future<bool> saveSettings() async {
    state = state.copyWith(isSaving: true, clearStatus: true);
    try {
      final settingsApi = _ref.read(settingsApiProvider);
      await settingsApi.updateSettings(state.settings);
      state = state.copyWith(
        isSaving: false,
        statusMessage: 'Settings saved successfully!',
      );
      // Refresh masked keys preview
      await loadSettings();
      // Sync models and match setup
      _ref.read(matchSetupProvider.notifier).loadModels();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        statusMessage: SanitizerUtils.formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<void> testKey(ProviderType provider, String key) async {
    try {
      final settingsApi = _ref.read(settingsApiProvider);
      final result = await settingsApi.testApiKey(
        provider: provider,
        apiKey: key,
      );

      final updatedTests = Map<ProviderType, ({bool isValid, String message})>.from(state.keyTestResults);
      updatedTests[provider] = result;

      // Auto-save setting if key is verified valid!
      if (result.isValid) {
        await settingsApi.updateSettings(state.settings);
        final models = await settingsApi.syncModels();
        state = state.copyWith(
          keyTestResults: updatedTests,
          settings: state.settings.copyWith(models: models),
          statusMessage: 'Verified & saved ${provider.displayName} key successfully!',
        );
        _ref.read(matchSetupProvider.notifier).loadModels();
        return;
      }

      state = state.copyWith(keyTestResults: updatedTests);
    } catch (e) {
      final updatedTests = Map<ProviderType, ({bool isValid, String message})>.from(state.keyTestResults);
      updatedTests[provider] = (isValid: false, message: SanitizerUtils.formatErrorMessage(e));
      state = state.copyWith(keyTestResults: updatedTests);
    }
  }

  Future<void> syncAllModels() async {
    state = state.copyWith(isSyncing: true, clearStatus: true);
    try {
      final settingsApi = _ref.read(settingsApiProvider);
      final updatedModels = await settingsApi.syncModels();
      state = state.copyWith(
        settings: state.settings.copyWith(models: updatedModels),
        isSyncing: false,
        statusMessage: 'Synchronized ${updatedModels.length} models across configured providers!',
      );
      _ref.read(matchSetupProvider.notifier).loadModels();
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        statusMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsScreenState>((ref) {
  return SettingsNotifier(ref);
});
