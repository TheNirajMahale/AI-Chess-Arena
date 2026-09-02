import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chess_arena/data/models/models.dart';
import 'package:chess_arena/data/api/games_api.dart';
import 'package:chess_arena/features/arena/application/api_client_provider.dart';
import 'package:chess_arena/features/replay/application/replay_controller_provider.dart';

class MockGamesApi extends Mock implements GamesApi {}

void main() {
  late MockGamesApi mockGamesApi;
  late ProviderContainer container;

  final sampleMoves = [
    MoveData(
      moveNumber: 1,
      turn: PlayerColor.white,
      san: 'e4',
      uci: 'e2e4',
      fenBefore: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      fenAfter: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      playerName: 'Player 1',
      modelId: 'm1',
      timestamp: '2026-09-01T12:00:00Z',
    ),
    MoveData(
      moveNumber: 1,
      turn: PlayerColor.black,
      san: 'c5',
      uci: 'c7c5',
      fenBefore: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      fenAfter: 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
      playerName: 'Player 2',
      modelId: 'm2',
      timestamp: '2026-09-01T12:00:05Z',
    ),
  ];

  final sampleGame = GameState(
    gameId: 'replay_test_1',
    status: GameStatus.finished,
    moveHistory: sampleMoves,
    fen: sampleMoves.last.fenAfter,
  );

  setUp(() {
    mockGamesApi = MockGamesApi();
    container = ProviderContainer(
      overrides: [
        gamesApiProvider.overrideWithValue(mockGamesApi),
      ],
    );

    when(() => mockGamesApi.getGameDetail('replay_test_1'))
        .thenAnswer((_) async => sampleGame);
  });

  tearDown(() {
    container.dispose();
  });

  group('ReplayController Navigation & Stepping Tests', () {
    test('Loads game and starts at the final position ply', () async {
      final controller = container.read(replayControllerProvider.notifier);
      await controller.loadGame('replay_test_1');

      final state = container.read(replayControllerProvider);
      expect(state.fullGame?.gameId, 'replay_test_1');
      expect(state.totalPlies, 2);
      expect(state.currentPly, 2);
      expect(state.currentFen, sampleMoves.last.fenAfter);
      expect(state.lastMoveUci, 'c7c5');
    });

    test('Navigates backwards and forwards through plies', () async {
      final controller = container.read(replayControllerProvider.notifier);
      await controller.loadGame('replay_test_1');

      // Step back to ply 1 (1. e4)
      controller.prevPly();
      var state = container.read(replayControllerProvider);
      expect(state.currentPly, 1);
      expect(state.currentFen, sampleMoves.first.fenAfter);
      expect(state.lastMoveUci, 'e2e4');

      // Step back to ply 0 (Initial position)
      controller.prevPly();
      state = container.read(replayControllerProvider);
      expect(state.currentPly, 0);
      expect(state.currentFen, sampleMoves.first.fenBefore);
      expect(state.lastMoveUci, null);

      // Jump to last ply
      controller.lastPly();
      state = container.read(replayControllerProvider);
      expect(state.currentPly, 2);
    });

    test('Toggles auto-play and adjusts pace', () async {
      final controller = container.read(replayControllerProvider.notifier);
      await controller.loadGame('replay_test_1');

      controller.setPace(1.5);
      expect(container.read(replayControllerProvider).paceSeconds, 1.5);

      controller.toggleAutoPlay();
      expect(container.read(replayControllerProvider).isAutoPlaying, true);

      controller.toggleAutoPlay();
      expect(container.read(replayControllerProvider).isAutoPlaying, false);
    });
  });
}
