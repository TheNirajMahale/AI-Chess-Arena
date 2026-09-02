import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/models.dart';
import '../../arena/application/api_client_provider.dart';

class MatchSetupState {
  final PlayerConfig whitePlayer;
  final PlayerConfig blackPlayer;
  final int moveDelaySeconds;
  final List<ModelOption> availableModels;
  final bool isLoadingModels;
  final String? errorMessage;

  const MatchSetupState({
    required this.whitePlayer,
    required this.blackPlayer,
    this.moveDelaySeconds = 10,
    this.availableModels = const [],
    this.isLoadingModels = false,
    this.errorMessage,
  });

  MatchSetupState copyWith({
    PlayerConfig? whitePlayer,
    PlayerConfig? blackPlayer,
    int? moveDelaySeconds,
    List<ModelOption>? availableModels,
    bool? isLoadingModels,
    String? errorMessage,
  }) {
    return MatchSetupState(
      whitePlayer: whitePlayer ?? this.whitePlayer,
      blackPlayer: blackPlayer ?? this.blackPlayer,
      moveDelaySeconds: moveDelaySeconds ?? this.moveDelaySeconds,
      availableModels: availableModels ?? this.availableModels,
      isLoadingModels: isLoadingModels ?? this.isLoadingModels,
      errorMessage: errorMessage,
    );
  }
}

class MatchSetupNotifier extends StateNotifier<MatchSetupState> {
  final Ref _ref;

  MatchSetupNotifier(this._ref)
      : super(
          const MatchSetupState(
            whitePlayer: PlayerConfig(
              name: 'DeepSeek Engine',
              provider: ProviderType.deepseek,
              modelId: 'deepseek/deepseek-chat',
              temperature: 0.7,
              thinkingMode: 'medium',
              color: PlayerColor.white,
            ),
            blackPlayer: PlayerConfig(
              name: 'Gemini Flash',
              provider: ProviderType.gemini,
              modelId: 'gemini/gemini-2.5-flash',
              temperature: 0.7,
              thinkingMode: 'medium',
              color: PlayerColor.black,
            ),
          ),
        ) {
    loadModels();
  }

  Future<void> loadModels() async {
    state = state.copyWith(isLoadingModels: true, errorMessage: null);
    try {
      final settingsApi = _ref.read(settingsApiProvider);
      final models = await settingsApi.getAvailableModels();

      // Auto-assign configured models if current player is not configured
      final configured = models.where((m) => m.isConfigured).toList();
      var updatedWhite = state.whitePlayer;
      var updatedBlack = state.blackPlayer;

      if (configured.isNotEmpty) {
        final isWhiteConfigured = models.any((m) => m.provider == updatedWhite.provider && m.isConfigured);
        if (!isWhiteConfigured) {
          final first = configured.first;
          updatedWhite = updatedWhite.copyWith(
            name: first.name,
            provider: first.provider,
            modelId: first.id,
          );
        }

        final isBlackConfigured = models.any((m) => m.provider == updatedBlack.provider && m.isConfigured);
        if (!isBlackConfigured) {
          final chosen = configured.length > 1 ? configured[1] : configured.first;
          updatedBlack = updatedBlack.copyWith(
            name: chosen.name,
            provider: chosen.provider,
            modelId: chosen.id,
          );
        }
      }

      state = state.copyWith(
        availableModels: models,
        whitePlayer: updatedWhite,
        blackPlayer: updatedBlack,
        isLoadingModels: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingModels: false,
        errorMessage: 'Failed to fetch model catalog: $e',
      );
    }
  }

  void updateWhitePlayer(PlayerConfig config) {
    state = state.copyWith(whitePlayer: config.copyWith(color: PlayerColor.white));
  }

  void updateBlackPlayer(PlayerConfig config) {
    state = state.copyWith(blackPlayer: config.copyWith(color: PlayerColor.black));
  }

  void updateMoveDelay(int delay) {
    state = state.copyWith(moveDelaySeconds: delay);
  }

  void swapPlayers() {
    final oldWhite = state.whitePlayer;
    final oldBlack = state.blackPlayer;
    state = state.copyWith(
      whitePlayer: oldBlack.copyWith(color: PlayerColor.white),
      blackPlayer: oldWhite.copyWith(color: PlayerColor.black),
    );
  }
}

final matchSetupProvider =
    StateNotifierProvider<MatchSetupNotifier, MatchSetupState>((ref) {
  return MatchSetupNotifier(ref);
});
