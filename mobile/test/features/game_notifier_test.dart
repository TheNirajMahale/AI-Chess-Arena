import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chess_arena/data/models/models.dart';
import 'package:chess_arena/data/ws/game_socket_service.dart';
import 'package:chess_arena/data/api/game_control_api.dart';
import 'package:chess_arena/features/arena/application/game_notifier.dart';
import 'package:chess_arena/features/setup/application/match_setup_provider.dart';

class MockGameSocketService extends Mock implements GameSocketService {}
class MockGameControlApi extends Mock implements GameControlApi {}
class MockRef extends Mock implements Ref {}

void main() {
  late MockGameSocketService mockWsService;
  late MockGameControlApi mockGameControlApi;
  late MockRef mockRef;
  late StreamController<WsEvent> eventController;
  late StreamController<SocketConnectionState> stateController;
  late GameNotifier notifier;

  setUp(() {
    mockWsService = MockGameSocketService();
    mockGameControlApi = MockGameControlApi();
    mockRef = MockRef();
    eventController = StreamController<WsEvent>.broadcast();
    stateController = StreamController<SocketConnectionState>.broadcast();

    when(() => mockWsService.eventStream).thenAnswer((_) => eventController.stream);
    when(() => mockWsService.stateStream).thenAnswer((_) => stateController.stream);
    when(() => mockRef.read(matchSetupProvider)).thenReturn(
      const MatchSetupState(
        whitePlayer: PlayerConfig(
          name: 'Test White',
          provider: ProviderType.deepseek,
          modelId: 'deepseek-chat',
          color: PlayerColor.white,
        ),
        blackPlayer: PlayerConfig(
          name: 'Test Black',
          provider: ProviderType.gemini,
          modelId: 'gemini-2.5-flash',
          color: PlayerColor.black,
        ),
      ),
    );

    notifier = GameNotifier(
      mockWsService,
      mockGameControlApi,
      mockRef,
    );
  });

  tearDown(() {
    notifier.dispose();
    eventController.close();
    stateController.close();
  });

  group('GameNotifier State Transition Tests', () {
    test('Updates state when WsEvent.gameState is received', () async {
      const testState = GameState(
        gameId: 'test_game_1',
        status: GameStatus.playing,
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        liveThinking: 'Thinking about c5...',
        isThinking: true,
      );

      eventController.add(const WsEvent.gameState(testState));
      await pumpEventQueue();

      expect(notifier.state.gameState?.gameId, 'test_game_1');
      expect(notifier.state.gameState?.status, GameStatus.playing);
      expect(notifier.state.liveThinking, 'Thinking about c5...');
      expect(notifier.state.isConnected, true);
    });

    test('Buffers live thinking chunks when WsEvent.thinkingChunk arrives', () async {
      eventController.add(const WsEvent.thinkingChunk(
        chunk: 'Evaluating',
        fullText: 'Evaluating knight moves to d5...',
        player: PlayerColor.white,
      ));
      await pumpEventQueue();

      expect(notifier.state.liveThinking, 'Evaluating knight moves to d5...');
    });

    test('Updates move history and fen when WsEvent.moveMade arrives', () async {
      const initial = GameState(
        gameId: 'test_game_1',
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        moveHistory: [],
      );
      eventController.add(const WsEvent.gameState(initial));
      await pumpEventQueue();

      const move = MoveData(
        moveNumber: 1,
        turn: PlayerColor.white,
        san: 'e4',
        uci: 'e2e4',
        fenBefore: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        fenAfter: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        reasoning: 'Control the center with standard King pawn opening.',
        playerName: 'DeepSeek AI',
        modelId: 'deepseek-chat',
        durationMs: 450,
        timestamp: '2026-09-02T10:00:00Z',
      );

      eventController.add(const WsEvent.moveMade(move));
      await pumpEventQueue();

      expect(notifier.state.gameState?.moveHistory.length, 1);
      expect(notifier.state.gameState?.moveHistory.first.san, 'e4');
      expect(notifier.state.gameState?.lastMoveUci, 'e2e4');
      expect(notifier.state.gameState?.fen, 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1');
      expect(notifier.state.liveThinking, '');
    });

    test('Transitions to finished status when WsEvent.gameOver arrives', () async {
      const initial = GameState(
        gameId: 'test_game_1',
        status: GameStatus.playing,
      );
      eventController.add(const WsEvent.gameState(initial));
      await pumpEventQueue();

      const result = GameResult(
        winner: PlayerColor.white,
        reason: 'checkmate',
      );

      eventController.add(const WsEvent.gameOver(result));
      await pumpEventQueue();

      expect(notifier.state.gameState?.status, GameStatus.finished);
      expect(notifier.state.gameState?.result?.winner, PlayerColor.white);
      expect(notifier.state.gameState?.result?.reason, 'checkmate');
    });

    test('Dispatches start control request to API client', () async {
      const expectedResponse = GameState(
        gameId: 'match_123',
        status: GameStatus.playing,
      );

      when(() => mockGameControlApi.sendControl(
            action: 'start',
            whitePlayer: any(named: 'whitePlayer'),
            blackPlayer: any(named: 'blackPlayer'),
            moveDelaySeconds: any(named: 'moveDelaySeconds'),
          )).thenAnswer((_) async => expectedResponse);

      await notifier.startMatch();

      expect(notifier.state.gameState?.gameId, 'match_123');
      expect(notifier.state.gameState?.status, GameStatus.playing);
      verify(() => mockGameControlApi.sendControl(
            action: 'start',
            whitePlayer: any(named: 'whitePlayer'),
            blackPlayer: any(named: 'blackPlayer'),
            moveDelaySeconds: any(named: 'moveDelaySeconds'),
          )).called(1);
    });

    test('Sets error message when API request fails', () async {
      when(() => mockGameControlApi.sendControl(action: 'pause'))
          .thenThrow(Exception('Backend network timeout'));

      await notifier.pauseMatch();

      expect(notifier.state.errorMessage, isNotNull);
      expect(notifier.state.errorMessage, contains('Backend network timeout'));
      expect(notifier.state.isActionInProgress, false);
    });
  });
}
