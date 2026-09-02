import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chess_arena/data/models/models.dart';
import 'package:chess_arena/data/ws/game_socket_service.dart';
import 'package:chess_arena/data/api/game_control_api.dart';
import 'package:chess_arena/data/api/settings_api.dart';
import 'package:chess_arena/features/arena/application/game_socket_provider.dart';
import 'package:chess_arena/features/arena/application/api_client_provider.dart';
import 'package:chess_arena/features/arena/presentation/screens/arena_screen.dart';

class MockGameSocketService extends Mock implements GameSocketService {}
class MockGameControlApi extends Mock implements GameControlApi {}
class MockSettingsApi extends Mock implements SettingsApi {}

void main() {
  late MockGameSocketService mockWsService;
  late MockGameControlApi mockGameControlApi;
  late MockSettingsApi mockSettingsApi;
  late StreamController<WsEvent> eventController;
  late StreamController<SocketConnectionState> stateController;

  setUp(() {
    mockWsService = MockGameSocketService();
    mockGameControlApi = MockGameControlApi();
    mockSettingsApi = MockSettingsApi();
    eventController = StreamController<WsEvent>.broadcast();
    stateController = StreamController<SocketConnectionState>.broadcast();

    when(() => mockWsService.eventStream).thenAnswer((_) => eventController.stream);
    when(() => mockWsService.stateStream).thenAnswer((_) => stateController.stream);
    when(() => mockWsService.connect()).thenReturn(null);
    when(() => mockWsService.dispose()).thenReturn(null);
    when(() => mockWsService.isConnected).thenReturn(false);
    when(() => mockWsService.connectionState).thenReturn(SocketConnectionState.disconnected);

    when(() => mockSettingsApi.getAvailableModels()).thenAnswer((_) async => []);
  });

  tearDown(() {
    eventController.close();
    stateController.close();
  });

  testWidgets('ArenaScreen renders title, players, and Start Match button when idle', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameSocketServiceProvider.overrideWithValue(mockWsService),
          gameControlApiProvider.overrideWithValue(mockGameControlApi),
          settingsApiProvider.overrideWithValue(mockSettingsApi),
        ],
        child: MaterialApp(
          home: ArenaScreen(
            onOpenSetup: () {},
          ),
        ),
      ),
    );

    // Initial check
    expect(find.text('AI Chess Arena'), findsOneWidget);
    expect(find.byTooltip('Start Match'), findsOneWidget);
    expect(find.text('DeepSeek Engine'), findsOneWidget);
    expect(find.text('Gemini Flash'), findsOneWidget);

    // Push active game state event
    eventController.add(const WsEvent.gameState(
      GameState(
        gameId: 'arena_match_1',
        status: GameStatus.playing,
        whitePlayer: PlayerConfig(
          name: 'Grandmaster DeepSeek',
          provider: ProviderType.deepseek,
          modelId: 'deepseek-chat',
        ),
        blackPlayer: PlayerConfig(
          name: 'Grandmaster Gemini',
          provider: ProviderType.gemini,
          modelId: 'gemini-2.5-flash',
        ),
        isThinking: true,
      ),
    ));

    await tester.pump();

    // Verify dynamic UI updates
    expect(find.text('Grandmaster DeepSeek'), findsOneWidget);
    expect(find.text('Grandmaster Gemini'), findsOneWidget);
    expect(find.byTooltip('Pause'), findsOneWidget);
  });
}
