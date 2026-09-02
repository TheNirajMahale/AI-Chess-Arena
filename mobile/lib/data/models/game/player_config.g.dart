// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerConfigImpl _$$PlayerConfigImplFromJson(Map<String, dynamic> json) =>
    _$PlayerConfigImpl(
      name: json['name'] as String,
      provider: $enumDecode(_$ProviderTypeEnumMap, json['provider']),
      modelId: json['model_id'] as String,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      systemPrompt: json['system_prompt'] as String?,
      thinkingMode: json['thinking_mode'] as String? ?? 'medium',
      isCustom: json['is_custom'] as bool? ?? false,
      color:
          $enumDecodeNullable(_$PlayerColorEnumMap, json['color']) ??
          PlayerColor.white,
    );

Map<String, dynamic> _$$PlayerConfigImplToJson(_$PlayerConfigImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'provider': _$ProviderTypeEnumMap[instance.provider]!,
      'model_id': instance.modelId,
      'temperature': instance.temperature,
      'system_prompt': instance.systemPrompt,
      'thinking_mode': instance.thinkingMode,
      'is_custom': instance.isCustom,
      'color': _$PlayerColorEnumMap[instance.color]!,
    };

const _$ProviderTypeEnumMap = {
  ProviderType.deepseek: 'deepseek',
  ProviderType.openai: 'openai',
  ProviderType.gemini: 'gemini',
  ProviderType.anthropic: 'anthropic',
  ProviderType.groq: 'groq',
  ProviderType.openrouter: 'openrouter',
};

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
