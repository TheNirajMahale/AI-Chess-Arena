import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';

part 'player_config.freezed.dart';
part 'player_config.g.dart';

/// Configuration specification for an AI player in a match.
@freezed
class PlayerConfig with _$PlayerConfig {
  const factory PlayerConfig({
    required String name,
    required ProviderType provider,
    @JsonKey(name: 'model_id') required String modelId,
    @Default(0.7) double temperature,
    @JsonKey(name: 'system_prompt') String? systemPrompt,
    @JsonKey(name: 'thinking_mode') @Default('medium') String thinkingMode,
    @JsonKey(name: 'is_custom') @Default(false) bool isCustom,
    @Default(PlayerColor.white) PlayerColor color,
  }) = _PlayerConfig;

  factory PlayerConfig.fromJson(Map<String, dynamic> json) =>
      _$PlayerConfigFromJson(json);
}
