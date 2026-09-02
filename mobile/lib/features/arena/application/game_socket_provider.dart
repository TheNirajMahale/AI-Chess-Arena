import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../data/models/models.dart';
import '../../../data/ws/game_socket_service.dart';

/// Singleton WebSocket service provider kept alive across screen navigation.
final gameSocketServiceProvider = Provider<GameSocketService>((ref) {
  final wsUrl = ref.watch(appSettingsProvider.select((s) => s.wsUrl));
  final service = GameSocketService(wsUrl: wsUrl);
  service.connect();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Stream of WebSocket connection lifecycle states (connected, disconnected, reconnecting).
final socketConnectionStateProvider = StreamProvider<SocketConnectionState>((ref) {
  final service = ref.watch(gameSocketServiceProvider);
  return service.stateStream;
});

/// Direct stream provider of parsed WsEvent sealed classes.
final wsEventStreamProvider = StreamProvider<WsEvent>((ref) {
  final service = ref.watch(gameSocketServiceProvider);
  return service.eventStream;
});
