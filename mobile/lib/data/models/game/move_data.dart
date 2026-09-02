import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';

part 'move_data.freezed.dart';
part 'move_data.g.dart';

/// Detailed information regarding an individual move made in the match.
@freezed
class MoveData with _$MoveData {
  const factory MoveData({
    @JsonKey(name: 'move_number') required int moveNumber,
    required PlayerColor turn,
    required String san,
    required String uci,
    @JsonKey(name: 'fen_before') required String fenBefore,
    @JsonKey(name: 'fen_after') required String fenAfter,
    @Default('') String reasoning,
    @JsonKey(name: 'player_name') required String playerName,
    @JsonKey(name: 'model_id') required String modelId,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    required String timestamp,
    @JsonKey(name: 'is_check') @Default(false) bool isCheck,
    @JsonKey(name: 'is_checkmate') @Default(false) bool isCheckmate,
    @JsonKey(name: 'is_capture') @Default(false) bool isCapture,
    @JsonKey(name: 'captured_piece') String? capturedPiece,
  }) = _MoveData;

  factory MoveData.fromJson(Map<String, dynamic> json) =>
      _$MoveDataFromJson(json);
}
