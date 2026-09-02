import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';
import 'player_config.dart';
import 'move_data.dart';
import 'game_result.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

/// Complete snapshot of the active match broadcasted in real-time over WebSockets.
@freezed
class GameState with _$GameState {
  @JsonSerializable(explicitToJson: true)
  const factory GameState({
    @JsonKey(name: 'game_id') required String gameId,
    @Default(GameStatus.idle) GameStatus status,
    @Default('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    String fen,
    @Default(PlayerColor.white) PlayerColor turn,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') @Default(10) int moveDelaySeconds,
    @JsonKey(name: 'current_move_number') @Default(1) int currentMoveNumber,
    @JsonKey(name: 'move_history') @Default([]) List<MoveData> moveHistory,
    GameResult? result,
    @JsonKey(name: 'captured_by_white') @Default([]) List<String> capturedByWhite,
    @JsonKey(name: 'captured_by_black') @Default([]) List<String> capturedByBlack,
    @Default('') String pgn,
    @JsonKey(name: 'live_thinking') @Default('') String liveThinking,
    @JsonKey(name: 'is_thinking') @Default(false) bool isThinking,
    @JsonKey(name: 'thinking_player') PlayerColor? thinkingPlayer,
    @JsonKey(name: 'countdown_seconds') double? countdownSeconds,
    @JsonKey(name: 'last_move_uci') String? lastMoveUci,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
