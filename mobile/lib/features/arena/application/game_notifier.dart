import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/sanitizer_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/ws/game_socket_service.dart';
import '../../../data/api/game_control_api.dart';
import '../../setup/application/match_setup_provider.dart';
import 'api_client_provider.dart';
import 'game_socket_provider.dart';

class LiveGameState {
  final GameState? gameState;
  final String liveThinking;
  final double? countdownSeconds;
  final bool isConnected;
  final bool isActionInProgress;
  final String? errorMessage;
  final bool isBoardFlipped;
  final MoveData? inspectedMove;

  const LiveGameState({
    this.gameState,
    this.liveThinking = '',
    this.countdownSeconds,
    this.isConnected = false,
    this.isActionInProgress = false,
    this.errorMessage,
    this.isBoardFlipped = false,
    this.inspectedMove,
  });

  LiveGameState copyWith({
    GameState? gameState,
    String? liveThinking,
    double? countdownSeconds,
    bool? isConnected,
    bool? isActionInProgress,
    String? errorMessage,
    bool? isBoardFlipped,
    MoveData? inspectedMove,
    bool clearInspectedMove = false,
    bool clearError = false,
  }) {
    return LiveGameState(
      gameState: gameState ?? this.gameState,
      liveThinking: liveThinking ?? this.liveThinking,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      isConnected: isConnected ?? this.isConnected,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isBoardFlipped: isBoardFlipped ?? this.isBoardFlipped,
      inspectedMove: clearInspectedMove ? null : (inspectedMove ?? this.inspectedMove),
    );
  }
}

class GameNotifier extends StateNotifier<LiveGameState> {
  final GameSocketService _wsService;
  final GameControlApi _gameControlApi;
  final Ref _ref;
  StreamSubscription<WsEvent>? _wsSubscription;
  StreamSubscription<SocketConnectionState>? _socketStatusSubscription;

  GameNotifier(
    this._wsService,
    this._gameControlApi,
    this._ref,
  ) : super(const LiveGameState()) {
    _init();
  }

  void _init() {
    // Listen to connection state
    _socketStatusSubscription = _wsService.stateStream.listen((status) {
      state = state.copyWith(
        isConnected: status == SocketConnectionState.connected,
      );
    });

    // Connect to WebSocket channel
    _wsService.connect();

    // Listen to incoming match events
    _wsSubscription = _wsService.eventStream.listen((event) {
      event.when(
        gameState: (s) {
          state = state.copyWith(
            gameState: s,
            liveThinking: s.liveThinking,
            countdownSeconds: s.countdownSeconds,
            isConnected: true,
            isActionInProgress: false,
          );
        },
        thinkingChunk: (chunk, fullText, player) {
          state = state.copyWith(
            liveThinking: fullText,
          );
        },
        moveMade: (move) {
          final current = state.gameState;
          if (current != null) {
            final updatedMoves = [...current.moveHistory, move];
            final updatedState = current.copyWith(
              fen: move.fenAfter,
              moveHistory: updatedMoves,
              lastMoveUci: move.uci,
              isThinking: false,
              liveThinking: '',
            );
            state = state.copyWith(
              gameState: updatedState,
              liveThinking: '',
            );
          }
        },
        gameOver: (result) {
          final current = state.gameState;
          if (current != null) {
            final updatedState = current.copyWith(
              status: GameStatus.finished,
              result: result,
              isThinking: false,
              countdownSeconds: null,
            );
            state = state.copyWith(
              gameState: updatedState,
              liveThinking: '',
            );
          }
        },
        error: (message) {
          final friendlyError = SanitizerUtils.formatErrorMessage(message);
          state = state.copyWith(
            errorMessage: friendlyError,
            isActionInProgress: false,
          );
        },
        pong: () {
          state = state.copyWith(isConnected: true);
        },
        unknown: (_) {},
      );
    });
  }

  void toggleBoardFlip() {
    state = state.copyWith(isBoardFlipped: !state.isBoardFlipped);
  }

  void setInspectedMove(MoveData? move) {
    if (move == null) {
      state = state.copyWith(clearInspectedMove: true);
    } else {
      state = state.copyWith(inspectedMove: move);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> startMatch({
    PlayerConfig? whitePlayer,
    PlayerConfig? blackPlayer,
    int? moveDelaySeconds,
  }) async {
    final setup = _ref.read(matchSetupProvider);
    final white = whitePlayer ??
        state.gameState?.whitePlayer ??
        setup.whitePlayer;
    final black = blackPlayer ??
        state.gameState?.blackPlayer ??
        setup.blackPlayer;
    final delay = moveDelaySeconds ?? state.gameState?.moveDelaySeconds ?? setup.moveDelaySeconds;

    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.sendControl(
        action: 'start',
        whitePlayer: white,
        blackPlayer: black,
        moveDelaySeconds: delay,
      );
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
        liveThinking: '',
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  Future<void> pauseMatch() async {
    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.sendControl(action: 'pause');
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  Future<void> resumeMatch() async {
    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.sendControl(action: 'resume');
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  Future<void> stepMatch() async {
    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.sendControl(action: 'step');
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  Future<void> stopMatch() async {
    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.sendControl(action: 'stop');
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
        liveThinking: '',
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  Future<void> loadGame(String gameId) async {
    state = state.copyWith(isActionInProgress: true, clearError: true);
    try {
      final updatedState = await _gameControlApi.loadGame(gameId);
      state = state.copyWith(
        gameState: updatedState,
        isActionInProgress: false,
        liveThinking: '',
      );
    } catch (e) {
      state = state.copyWith(
        isActionInProgress: false,
        errorMessage: SanitizerUtils.formatErrorMessage(e),
      );
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _socketStatusSubscription?.cancel();
    super.dispose();
  }
}

final gameNotifierProvider =
    StateNotifierProvider<GameNotifier, LiveGameState>((ref) {
  final wsService = ref.watch(gameSocketServiceProvider);
  final controlApi = ref.watch(gameControlApiProvider);
  return GameNotifier(
    wsService,
    controlApi,
    ref,
  );
});
