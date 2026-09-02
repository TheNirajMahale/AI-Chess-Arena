---
name: flutter-development
description: >-
  Comprehensive guide for Flutter application development, including Clean Architecture,
  responsive layouts, Dio HTTP & WebSocketChannel integration, Chess rendering,
  theme management, and Dart 3+ best practices. Use when building or refactoring Flutter apps.
---

# Flutter Application Development Skill

This skill provides reference patterns and best practices for building modular, high-performance Flutter applications with Clean Architecture, robust networking, and reactive state management.

---

## 1. Clean Architecture Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   └── app_assets.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── websocket_client.dart
│   │   └── api_result.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   └── utils/
│       ├── formatters.dart
│       └── responsive_layout.dart
├── data/
│   ├── datasources/
│   │   ├── game_remote_datasource.dart
│   │   └── settings_remote_datasource.dart
│   ├── models/
│   │   ├── game_state_dto.dart
│   │   ├── move_data_dto.dart
│   │   └── player_config_dto.dart
│   └── repositories/
│       ├── game_repository_impl.dart
│       └── settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── game_state.dart
│   │   ├── move_data.dart
│   │   └── player_config.dart
│   └── repositories/
│       ├── i_game_repository.dart
│       └── i_settings_repository.dart
└── presentation/
    ├── notifiers/
    │   ├── game_notifier.dart
    │   ├── replay_notifier.dart
    │   └── settings_notifier.dart
    ├── screens/
    │   ├── arena_screen.dart
    │   └── replay_screen.dart
    ├── widgets/
    │   ├── chessboard/
    │   ├── controls/
    │   ├── reasoning/
    │   └── history/
    └── dialogs/
        ├── settings_dialog.dart
        └── past_games_dialog.dart
```

---

## 2. Networking Patterns

### A. Dio REST Client with Interceptors
```dart
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({String baseUrl = 'http://localhost:8000/api'})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
}
```

### B. WebSocket Client with Auto-Reconnect & Keepalive Ping
```dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameWebSocketClient {
  final Uri uri;
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _isDisposed = false;

  GameWebSocketClient({required this.uri});

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void connect() {
    if (_isDisposed) return;
    try {
      _channel = WebSocketChannel.connect(uri);
      _channel?.stream.listen(
        (data) {
          final decoded = jsonDecode(data as String) as Map<String, dynamic>;
          _streamController.add(decoded);
        },
        onDone: _handleDisconnect,
        onError: (err) => _handleDisconnect(),
      );
      _startHeartbeat();
    } catch (_) {
      _handleDisconnect();
    }
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      send({'action': 'ping'});
    });
  }

  void send(Map<String, dynamic> message) {
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (_) {}
  }

  void _handleDisconnect() {
    _pingTimer?.cancel();
    if (_isDisposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), connect);
  }

  void dispose() {
    _isDisposed = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _streamController.close();
  }
}
```

---

## 3. Responsive Layout Patterns

Use `LayoutBuilder` with adaptive breakpoints to provide optimal layouts on mobile, tablet, and desktop:

```dart
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return desktop;
        }
        if (constraints.maxWidth >= 768) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
```

---

## 4. UI Performance Guidelines
1. **Always use `const` widgets** to bypass unnecessary reconciliation.
2. **Break down complex widgets** into focused sub-widgets so that rebuilds only affect the exact visual element changing.
3. **Use `RepaintBoundary`** around custom-painted or frequently updating widgets (e.g. animated evaluation bars, live streaming token cursors).
4. **Prefer `ListView.builder`** over `SingleChildScrollView + Column` when displaying arbitrary length lists (like move history).
