// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiKeysConfigImpl _$$ApiKeysConfigImplFromJson(Map<String, dynamic> json) =>
    _$ApiKeysConfigImpl(
      deepseekKey: json['deepseek_key'] as String? ?? '',
      openaiKey: json['openai_key'] as String? ?? '',
      geminiKey: json['gemini_key'] as String? ?? '',
      anthropicKey: json['anthropic_key'] as String? ?? '',
      groqKey: json['groq_key'] as String? ?? '',
      openrouterKey: json['openrouter_key'] as String? ?? '',
    );

Map<String, dynamic> _$$ApiKeysConfigImplToJson(_$ApiKeysConfigImpl instance) =>
    <String, dynamic>{
      'deepseek_key': instance.deepseekKey,
      'openai_key': instance.openaiKey,
      'gemini_key': instance.geminiKey,
      'anthropic_key': instance.anthropicKey,
      'groq_key': instance.groqKey,
      'openrouter_key': instance.openrouterKey,
    };

_$ModelOptionImpl _$$ModelOptionImplFromJson(Map<String, dynamic> json) =>
    _$ModelOptionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: $enumDecode(_$ProviderTypeEnumMap, json['provider']),
      supportsThinking: json['supports_thinking'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      isConfigured: json['is_configured'] as bool? ?? false,
    );

Map<String, dynamic> _$$ModelOptionImplToJson(_$ModelOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': _$ProviderTypeEnumMap[instance.provider]!,
      'supports_thinking': instance.supportsThinking,
      'description': instance.description,
      'is_configured': instance.isConfigured,
    };

const _$ProviderTypeEnumMap = {
  ProviderType.deepseek: 'deepseek',
  ProviderType.openai: 'openai',
  ProviderType.gemini: 'gemini',
  ProviderType.anthropic: 'anthropic',
  ProviderType.groq: 'groq',
  ProviderType.openrouter: 'openrouter',
};

_$SettingsPayloadImpl _$$SettingsPayloadImplFromJson(
  Map<String, dynamic> json,
) => _$SettingsPayloadImpl(
  keys: json['keys'] == null
      ? const ApiKeysConfig()
      : ApiKeysConfig.fromJson(json['keys'] as Map<String, dynamic>),
  defaultDelay: (json['default_delay'] as num?)?.toInt() ?? 10,
  models:
      (json['custom_models'] as List<dynamic>?)
          ?.map((e) => ModelOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  includeAsciiBoard: json['include_ascii_board'] as bool? ?? true,
  historyContextLimit: (json['history_context_limit'] as num?)?.toInt() ?? 0,
  maxOutputTokens: (json['max_output_tokens'] as num?)?.toInt() ?? 500,
);

Map<String, dynamic> _$$SettingsPayloadImplToJson(
  _$SettingsPayloadImpl instance,
) => <String, dynamic>{
  'keys': instance.keys.toJson(),
  'default_delay': instance.defaultDelay,
  'custom_models': instance.models.map((e) => e.toJson()).toList(),
  'include_ascii_board': instance.includeAsciiBoard,
  'history_context_limit': instance.historyContextLimit,
  'max_output_tokens': instance.maxOutputTokens,
};
