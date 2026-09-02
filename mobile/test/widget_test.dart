import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chess_arena/app.dart';
import 'package:chess_arena/data/ws/game_socket_service.dart';
import 'package:chess_arena/data/api/game_control_api.dart';
import 'package:chess_arena/data/api/settings_api.dart';
import 'package:chess_arena/features/arena/application/game_socket_provider.dart';
import 'package:chess_arena/features/arena/application/api_client_provider.dart';

class MockGameSocketService extends Mock implements GameSocketService {}
class MockGameControlApi extends Mock implements GameControlApi {}
class MockSettingsApi extends Mock implements SettingsApi {}

void main() {
  testWidgets('App smoke test renders AI Chess Arena', (WidgetTester tester) async {
    final mockWs = MockGameSocketService();
    final mockControl = MockGameControlApi();
    final mockSettings = MockSettingsApi();

    when(() => mockWs.eventStream).thenAnswer((_) => const Stream.empty());
    when(() => mockWs.stateStream).thenAnswer((_) => const Stream.empty());
    when(() => mockWs.connect()).thenReturn(null);
    when(() => mockWs.dispose()).thenReturn(null);
    when(() => mockWs.isConnected).thenReturn(false);
    when(() => mockWs.connectionState).thenReturn(SocketConnectionState.disconnected);

    when(() => mockSettings.getAvailableModels()).thenAnswer((_) async => []);
    when(() => mockSettings.getSettings()).thenAnswer((_) async => throw Exception('test'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameSocketServiceProvider.overrideWithValue(mockWs),
          gameControlApiProvider.overrideWithValue(mockControl),
          settingsApiProvider.overrideWithValue(mockSettings),
        ],
        child: const ChessArenaApp(),
      ),
    );

    expect(find.text('AI Chess Arena'), findsOneWidget);
  });
}
