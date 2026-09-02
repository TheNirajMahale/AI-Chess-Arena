---
name: flutter-riverpod
description: >-
  Expert guide for Flutter state management using Riverpod 2.x, including AsyncNotifier,
  StateNotifier, family/autoDispose providers, selector optimization (select), and WebSocket streaming.
---

# Riverpod 2.x State Management Skill

This skill provides best practices for managing reactive application state in Flutter using Riverpod.

---

## 1. Provider Selection Rules

| Provider Type | Best For | Example Use Case |
|---|---|---|
| `Provider<T>` | Read-only synchronous services and static values | `dioProvider`, `themeConfigProvider` |
| `StateNotifierProvider` / `NotifierProvider` | Synchronous state machines and local UI controls | `boardThemeNotifier`, `boardOrientationNotifier` |
| `AsyncNotifierProvider` / `FutureProvider` | Asynchronous operations and API fetches | `modelsListNotifier`, `pastGamesNotifier` |
| `StreamProvider` | Persistent WebSocket streams and real-time event tickers | `gameStreamProvider`, `countdownStreamProvider` |

---

## 2. Riverpod Architecture Example: Live Game Notifier

```dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/player_config.dart';
import '../../core/network/websocket_client.dart';
import '../repositories/game_repository.dart';

class LiveGameState {
  final GameState? gameState;
  final String liveThinking;
  final double? countdownSeconds;
  final bool isConnected;
  final String? errorMessage;

  const LiveGameState({
    this.gameState,
    this.liveThinking = '',
    this.countdownSeconds,
    this.isConnected = false,
    this.errorMessage,
  });

  LiveGameState copyWith({
    GameState? gameState,
    String? liveThinking,
    double? countdownSeconds,
    bool? isConnected,
    String? errorMessage,
  }) {
    return LiveGameState(
      gameState: gameState ?? this.gameState,
      liveThinking: liveThinking ?? this.liveThinking,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage,
    );
  }
}

class GameNotifier extends StateNotifier<LiveGameState> {
  final GameWebSocketClient _wsClient;
  final GameRepository _repository;
  StreamSubscription? _wsSubscription;

  GameNotifier({
    required GameWebSocketClient wsClient,
    required GameRepository repository,
  })  : _wsClient = wsClient,
        _repository = repository,
        super(const LiveGameState()) {
    _initWebSocket();
  }

  void _initWebSocket() {
    _wsClient.connect();
    _wsSubscription = _wsClient.stream.listen((event) {
      final type = event['type'] as String?;
      if (type == 'game_state') {
        final stateJson = event['state'] as Map<String, dynamic>;
        state = state.copyWith(
          gameState: GameState.fromJson(stateJson),
          liveThinking: (stateJson['live_thinking'] as String?) ?? '',
          isConnected: true,
        );
      } else if (type == 'thinking_chunk') {
        final fullText = event['full_text'] as String?;
        final chunk = event['chunk'] as String? ?? '';
        state = state.copyWith(
          liveThinking: fullText ?? '${state.liveThinking}$chunk',
        );
      } else if (type == 'countdown') {
        state = state.copyWith(
          countdownSeconds: (event['remaining'] as num?)?.toDouble(),
        );
      } else if (type == 'error') {
        state = state.copyWith(errorMessage: event['message'] as String?);
      }
    });
  }

  Future<void> startMatch({
    required PlayerConfig white,
    required PlayerConfig black,
    int delaySeconds = 10,
  }) async {
    try {
      state = state.copyWith(liveThinking: '', errorMessage: null);
      await _repository.controlGame(
        action: 'start',
        whitePlayer: white,
        blackPlayer: black,
        moveDelaySeconds: delaySeconds,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> pauseMatch() async {
    await _repository.controlGame(action: 'pause');
  }

  Future<void> resumeMatch() async {
    await _repository.controlGame(action: 'resume');
  }

  Future<void> stopMatch() async {
    await _repository.controlGame(action: 'stop');
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _wsClient.dispose();
    super.dispose();
  }
}
```

---

## 3. UI Consumption with `.select()` Optimization

Always use `.select()` inside widget `build()` methods to prevent rebuilding widgets when unrelated fields change:

```dart
// Only rebuilds when FEN changes (not when liveThinking or countdown changes)
final fen = ref.watch(gameNotifierProvider.select((s) => s.gameState?.fen));

// Only rebuilds when the thinking string updates
final liveThinking = ref.watch(gameNotifierProvider.select((s) => s.liveThinking));
```
