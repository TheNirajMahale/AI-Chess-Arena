// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameResultImpl _$$GameResultImplFromJson(Map<String, dynamic> json) =>
    _$GameResultImpl(
      winner: $enumDecodeNullable(_$PlayerColorEnumMap, json['winner']),
      reason: json['reason'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$GameResultImplToJson(_$GameResultImpl instance) =>
    <String, dynamic>{
      'winner': _$PlayerColorEnumMap[instance.winner],
      'reason': instance.reason,
      'description': instance.description,
    };

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
