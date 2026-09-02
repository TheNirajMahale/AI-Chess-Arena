import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';

part 'game_result.freezed.dart';
part 'game_result.g.dart';

/// The final outcome of a concluded chess game.
@freezed
class GameResult with _$GameResult {
  const factory GameResult({
    PlayerColor? winner,
    required String reason,
    String? description,
  }) = _GameResult;

  factory GameResult.fromJson(Map<String, dynamic> json) =>
      _$GameResultFromJson(json);
}
