// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_control_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameControlRequestImpl _$$GameControlRequestImplFromJson(
  Map<String, dynamic> json,
) => _$GameControlRequestImpl(
  action: json['action'] as String,
  whitePlayer: json['white_player'] == null
      ? null
      : PlayerConfig.fromJson(json['white_player'] as Map<String, dynamic>),
  blackPlayer: json['black_player'] == null
      ? null
      : PlayerConfig.fromJson(json['black_player'] as Map<String, dynamic>),
  moveDelaySeconds: (json['move_delay_seconds'] as num?)?.toInt() ?? 10,
  gameId: json['game_id'] as String?,
);

Map<String, dynamic> _$$GameControlRequestImplToJson(
  _$GameControlRequestImpl instance,
) => <String, dynamic>{
  'action': instance.action,
  'white_player': instance.whitePlayer?.toJson(),
  'black_player': instance.blackPlayer?.toJson(),
  'move_delay_seconds': instance.moveDelaySeconds,
  'game_id': instance.gameId,
};

_$TestKeyRequestImpl _$$TestKeyRequestImplFromJson(Map<String, dynamic> json) =>
    _$TestKeyRequestImpl(
      provider: $enumDecode(_$ProviderTypeEnumMap, json['provider']),
      apiKey: json['api_key'] as String,
    );

Map<String, dynamic> _$$TestKeyRequestImplToJson(
  _$TestKeyRequestImpl instance,
) => <String, dynamic>{
  'provider': _$ProviderTypeEnumMap[instance.provider]!,
  'api_key': instance.apiKey,
};

const _$ProviderTypeEnumMap = {
  ProviderType.deepseek: 'deepseek',
  ProviderType.openai: 'openai',
  ProviderType.gemini: 'gemini',
  ProviderType.anthropic: 'anthropic',
  ProviderType.groq: 'groq',
  ProviderType.openrouter: 'openrouter',
};
