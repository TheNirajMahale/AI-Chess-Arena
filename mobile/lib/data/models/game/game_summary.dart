import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_result.dart';

part 'game_summary.freezed.dart';
part 'game_summary.g.dart';

/// Lightweight summary metadata for displaying archived games in history lists.
@freezed
class GameSummary with _$GameSummary {
  const factory GameSummary({
    @JsonKey(name: 'game_id') required String gameId,
    @JsonKey(name: 'white_player') required String whitePlayer,
    @JsonKey(name: 'black_player') required String blackPlayer,
    @JsonKey(name: 'moves_count') @Default(0) int movesCount,
    GameResult? result,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'white_model') String? whiteModel,
    @JsonKey(name: 'black_model') String? blackModel,
  }) = _GameSummary;

  factory GameSummary.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryFromJson(json);
}
