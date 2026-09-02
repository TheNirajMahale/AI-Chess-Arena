import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';
import '../game/game_result.dart';
import '../game/game_state_model.dart';
import '../game/move_data.dart';

part 'ws_event.freezed.dart';

/// Sealed union representing all real-time events streamed from the WebSocket server.
@freezed
class WsEvent with _$WsEvent {
  const factory WsEvent.gameState(GameState state) = _WsEventGameState;

  const factory WsEvent.thinkingChunk({
    required String chunk,
    @JsonKey(name: 'full_text') required String fullText,
    required PlayerColor player,
  }) = _WsEventThinkingChunk;

  const factory WsEvent.moveMade(MoveData move) = _WsEventMoveMade;

  const factory WsEvent.gameOver(GameResult result) = _WsEventGameOver;

  const factory WsEvent.error(String message) = _WsEventError;

  const factory WsEvent.pong() = _WsEventPong;

  const factory WsEvent.unknown(String raw) = _WsEventUnknown;

  factory WsEvent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'game_state':
        return WsEvent.gameState(
          GameState.fromJson(json['state'] as Map<String, dynamic>),
        );
      case 'thinking_chunk':
        return WsEvent.thinkingChunk(
          chunk: json['chunk'] as String? ?? '',
          fullText: json['full_text'] as String? ?? '',
          player: json['player'] == 'white' ? PlayerColor.white : PlayerColor.black,
        );
      case 'move_made':
        return WsEvent.moveMade(
          MoveData.fromJson(json['move'] as Map<String, dynamic>),
        );
      case 'game_over':
        return WsEvent.gameOver(
          GameResult.fromJson(json['result'] as Map<String, dynamic>),
        );
      case 'error':
        return WsEvent.error(json['message'] as String? ?? 'Unknown error');
      case 'pong':
        return const WsEvent.pong();
      default:
        return WsEvent.unknown(json.toString());
    }
  }
}
