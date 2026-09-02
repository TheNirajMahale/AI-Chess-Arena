import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';

enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// Robust WebSocket client for real-time match streaming with heartbeat and exponential backoff.
class GameSocketService {
  String _wsUrl;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  final StreamController<WsEvent> _eventController =
      StreamController<WsEvent>.broadcast();
  final StreamController<SocketConnectionState> _stateController =
      StreamController<SocketConnectionState>.broadcast();

  SocketConnectionState _connectionState = SocketConnectionState.disconnected;
  Timer? _heartbeatTimer;
  Timer? _pongWatchdogTimer;
  Timer? _reconnectTimer;

  int _reconnectAttempts = 0;
  bool _isDisposed = false;
  bool _awaitingPong = false;

  GameSocketService({String? wsUrl})
      : _wsUrl = wsUrl ?? ApiEndpoints.defaultWsUrl;

  Stream<WsEvent> get eventStream => _eventController.stream;
  Stream<SocketConnectionState> get stateStream => _stateController.stream;
  SocketConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == SocketConnectionState.connected;

  void updateWsUrl(String newWsUrl) {
    if (_wsUrl != newWsUrl) {
      _wsUrl = newWsUrl;
      if (isConnected || _connectionState == SocketConnectionState.connecting) {
        reconnect(resetBackoff: true);
      }
    }
  }

  void _updateState(SocketConnectionState state) {
    _connectionState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  /// Establishes WebSocket connection with server.
  void connect() {
    if (_isDisposed) return;
    if (_connectionState == SocketConnectionState.connected ||
        _connectionState == SocketConnectionState.connecting) {
      return;
    }

    _updateState(_reconnectAttempts > 0
        ? SocketConnectionState.reconnecting
        : SocketConnectionState.connecting);

    try {
      final uri = Uri.parse(_wsUrl);
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        (data) {
          _onMessageReceived(data);
        },
        onDone: () {
          debugPrint('[WebSocket] Connection closed by server.');
          _handleDisconnect();
        },
        onError: (error) {
          debugPrint('[WebSocket] Stream error: $error');
          _handleDisconnect();
        },
      );
    } catch (e) {
      debugPrint('[WebSocket] Connection failed: $e');
      _handleDisconnect();
    }
  }

  void _onMessageReceived(dynamic rawData) {
    try {
      if (_connectionState != SocketConnectionState.connected) {
        _updateState(SocketConnectionState.connected);
        _reconnectAttempts = 0;
        _startHeartbeat();
      }

      final Map<String, dynamic> json;
      if (rawData is String) {
        json = jsonDecode(rawData) as Map<String, dynamic>;
      } else if (rawData is Map<String, dynamic>) {
        json = rawData;
      } else {
        return;
      }

      final event = WsEvent.fromJson(json);

      // Handle heartbeat pong
      if (event == const WsEvent.pong() || json['type'] == 'pong') {
        _awaitingPong = false;
        _pongWatchdogTimer?.cancel();
        return;
      }

      if (!_eventController.isClosed) {
        _eventController.add(event);
      }
    } catch (e) {
      debugPrint('[WebSocket] Error parsing event frame: $e');
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _pongWatchdogTimer?.cancel();

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (isConnected) {
        send({'action': 'ping'});
        _awaitingPong = true;

        // If pong not received within 10s, consider socket dead and reconnect
        _pongWatchdogTimer?.cancel();
        _pongWatchdogTimer = Timer(const Duration(seconds: 10), () {
          if (_awaitingPong && isConnected) {
            debugPrint('[WebSocket] Missed pong watchdog timeout. Reconnecting...');
            _handleDisconnect();
          }
        });
      }
    });
  }

  void _handleDisconnect() {
    _cleanUpCurrentSocket();
    _updateState(SocketConnectionState.disconnected);

    if (_isDisposed) return;

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();

    // Exponential backoff: 1s -> 2s -> 4s -> 8s -> 15s cap
    final delaySeconds = (_reconnectAttempts == 0)
        ? 1
        : (1 << _reconnectAttempts).clamp(1, 15);

    _reconnectAttempts++;
    debugPrint('[WebSocket] Reconnecting in ${delaySeconds}s (attempt $_reconnectAttempts)...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!_isDisposed) {
        connect();
      }
    });
  }

  /// Sends a JSON payload frame across the WebSocket sink.
  void send(Map<String, dynamic> message) {
    try {
      if (_channel != null && isConnected) {
        _channel!.sink.add(jsonEncode(message));
      }
    } catch (e) {
      debugPrint('[WebSocket] Error sending message: $e');
    }
  }

  void reconnect({bool resetBackoff = false}) {
    if (resetBackoff) {
      _reconnectAttempts = 0;
    }
    _handleDisconnect();
  }

  void _cleanUpCurrentSocket() {
    _heartbeatTimer?.cancel();
    _pongWatchdogTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    _awaitingPong = false;
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _cleanUpCurrentSocket();
    _eventController.close();
    _stateController.close();
  }
}
