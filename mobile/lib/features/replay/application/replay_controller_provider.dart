import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/fen_utils.dart';
import '../../../core/utils/material_eval.dart';
import '../../../data/models/models.dart';
import '../../arena/application/api_client_provider.dart';

class ReplayState {
  final GameState? fullGame;
  final int currentPly;
  final bool isAutoPlaying;
  final double paceSeconds;
  final bool isLoading;
  final String? errorMessage;
  final bool isBoardFlipped;

  const ReplayState({
    this.fullGame,
    this.currentPly = 0,
    this.isAutoPlaying = false,
    this.paceSeconds = 2.0,
    this.isLoading = false,
    this.errorMessage,
    this.isBoardFlipped = false,
  });

  int get totalPlies => fullGame?.moveHistory.length ?? 0;

  String get currentFen {
    if (fullGame == null || totalPlies == 0 || currentPly == 0) {
      return fullGame?.moveHistory.isNotEmpty == true
          ? fullGame!.moveHistory.first.fenBefore
          : FenUtils.initialFen;
    }
    final moveIndex = (currentPly - 1).clamp(0, totalPlies - 1);
    return fullGame!.moveHistory[moveIndex].fenAfter;
  }

  MoveData? get currentMove {
    if (fullGame == null || currentPly == 0 || totalPlies == 0) return null;
    final moveIndex = (currentPly - 1).clamp(0, totalPlies - 1);
    return fullGame!.moveHistory[moveIndex];
  }

  String? get lastMoveUci => currentMove?.uci;

  int get materialAdvantage {
    // Reconstruct captured pieces up to currentPly
    if (fullGame == null || currentPly == 0) return 0;
    final whiteCaps = <String>[];
    final blackCaps = <String>[];

    for (int i = 0; i < currentPly && i < totalPlies; i++) {
      final m = fullGame!.moveHistory[i];
      if (m.isCapture && m.capturedPiece != null) {
        if (m.turn.name == 'white') {
          whiteCaps.add(m.capturedPiece!);
        } else {
          blackCaps.add(m.capturedPiece!);
        }
      }
    }
    return MaterialEval.calculateAdvantage(
      capturedByWhite: whiteCaps,
      capturedByBlack: blackCaps,
    );
  }

  ReplayState copyWith({
    GameState? fullGame,
    int? currentPly,
    bool? isAutoPlaying,
    double? paceSeconds,
    bool? isLoading,
    String? errorMessage,
    bool? isBoardFlipped,
  }) {
    return ReplayState(
      fullGame: fullGame ?? this.fullGame,
      currentPly: currentPly ?? this.currentPly,
      isAutoPlaying: isAutoPlaying ?? this.isAutoPlaying,
      paceSeconds: paceSeconds ?? this.paceSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isBoardFlipped: isBoardFlipped ?? this.isBoardFlipped,
    );
  }
}

class ReplayController extends StateNotifier<ReplayState> {
  final Ref _ref;
  Timer? _autoPlayTimer;

  ReplayController(this._ref) : super(const ReplayState());

  Future<void> loadGame(String gameId) async {
    _stopAutoPlay();
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final gamesApi = _ref.read(gamesApiProvider);
      final fullGame = await gamesApi.getGameDetail(gameId);
      state = state.copyWith(
        fullGame: fullGame,
        currentPly: fullGame.moveHistory.length, // start at the end of the match
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load game replay: $e',
      );
    }
  }

  void setPly(int ply) {
    final clamped = ply.clamp(0, state.totalPlies);
    state = state.copyWith(currentPly: clamped);
    if (clamped >= state.totalPlies) {
      _stopAutoPlay();
    }
  }

  void nextPly() {
    if (state.currentPly < state.totalPlies) {
      setPly(state.currentPly + 1);
    } else {
      _stopAutoPlay();
    }
  }

  void prevPly() {
    if (state.currentPly > 0) {
      setPly(state.currentPly - 1);
    }
  }

  void firstPly() => setPly(0);
  void lastPly() => setPly(state.totalPlies);

  void toggleBoardFlip() {
    state = state.copyWith(isBoardFlipped: !state.isBoardFlipped);
  }

  void setPace(double seconds) {
    state = state.copyWith(paceSeconds: seconds);
    if (state.isAutoPlaying) {
      _startAutoPlay();
    }
  }

  void toggleAutoPlay() {
    if (state.isAutoPlaying) {
      _stopAutoPlay();
    } else {
      if (state.currentPly >= state.totalPlies) {
        setPly(0);
      }
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    state = state.copyWith(isAutoPlaying: true);
    _autoPlayTimer = Timer.periodic(
      Duration(milliseconds: (state.paceSeconds * 1000).toInt()),
      (_) => nextPly(),
    );
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    state = state.copyWith(isAutoPlaying: false);
  }

  @override
  void dispose() {
    _stopAutoPlay();
    super.dispose();
  }
}

final replayControllerProvider =
    StateNotifierProvider.autoDispose<ReplayController, ReplayState>((ref) {
  return ReplayController(ref);
});
