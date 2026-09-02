import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';
import 'player_config.dart';

part 'game_control_request.freezed.dart';
part 'game_control_request.g.dart';

/// Payload for match lifecycle actions (start, pause, resume, step, stop, reset, load).
@freezed
class GameControlRequest with _$GameControlRequest {
  @JsonSerializable(explicitToJson: true)
  const factory GameControlRequest({
    required String action,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') @Default(10) int? moveDelaySeconds,
    @JsonKey(name: 'game_id') String? gameId,
  }) = _GameControlRequest;

  factory GameControlRequest.fromJson(Map<String, dynamic> json) =>
      _$GameControlRequestFromJson(json);
}

/// Payload for validating API key connectivity against a provider.
@freezed
class TestKeyRequest with _$TestKeyRequest {
  const factory TestKeyRequest({
    required ProviderType provider,
    @JsonKey(name: 'api_key') required String apiKey,
  }) = _TestKeyRequest;

  factory TestKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$TestKeyRequestFromJson(json);
}
