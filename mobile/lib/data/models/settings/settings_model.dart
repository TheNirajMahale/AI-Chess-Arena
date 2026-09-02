import 'package:freezed_annotation/freezed_annotation.dart';
import '../common/enums.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

/// Stored API keys for AI provider access.
@freezed
class ApiKeysConfig with _$ApiKeysConfig {
  const factory ApiKeysConfig({
    @JsonKey(name: 'deepseek_key') @Default('') String deepseekKey,
    @JsonKey(name: 'openai_key') @Default('') String openaiKey,
    @JsonKey(name: 'gemini_key') @Default('') String geminiKey,
    @JsonKey(name: 'anthropic_key') @Default('') String anthropicKey,
    @JsonKey(name: 'groq_key') @Default('') String groqKey,
    @JsonKey(name: 'openrouter_key') @Default('') String openrouterKey,
  }) = _ApiKeysConfig;

  factory ApiKeysConfig.fromJson(Map<String, dynamic> json) =>
      _$ApiKeysConfigFromJson(json);
}

/// Metadata describing an available AI model for the match roster.
@freezed
class ModelOption with _$ModelOption {
  const factory ModelOption({
    required String id,
    required String name,
    required ProviderType provider,
    @JsonKey(name: 'supports_thinking') @Default(false) bool supportsThinking,
    @Default('') String description,
    @JsonKey(name: 'is_configured') @Default(false) bool isConfigured,
  }) = _ModelOption;

  factory ModelOption.fromJson(Map<String, dynamic> json) =>
      _$ModelOptionFromJson(json);
}

/// Full application settings payload containing credentials, dynamic models, and token optimizations.
@freezed
class SettingsPayload with _$SettingsPayload {
  @JsonSerializable(explicitToJson: true)
  const factory SettingsPayload({
    @Default(ApiKeysConfig()) ApiKeysConfig keys,
    @JsonKey(name: 'default_delay') @Default(10) int defaultDelay,
    @JsonKey(name: 'custom_models') @Default([]) List<ModelOption> models,
    @JsonKey(name: 'include_ascii_board') @Default(true) bool includeAsciiBoard,
    @JsonKey(name: 'history_context_limit') @Default(0) int historyContextLimit,
    @JsonKey(name: 'max_output_tokens') @Default(500) int maxOutputTokens,
  }) = _SettingsPayload;

  factory SettingsPayload.fromJson(Map<String, dynamic> json) =>
      _$SettingsPayloadFromJson(json);
}
