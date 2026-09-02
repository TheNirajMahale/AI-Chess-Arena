// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameSummaryImpl _$$GameSummaryImplFromJson(Map<String, dynamic> json) =>
    _$GameSummaryImpl(
      gameId: json['game_id'] as String,
      whitePlayer: json['white_player'] as String,
      blackPlayer: json['black_player'] as String,
      movesCount: (json['moves_count'] as num?)?.toInt() ?? 0,
      result: json['result'] == null
          ? null
          : GameResult.fromJson(json['result'] as Map<String, dynamic>),
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      whiteModel: json['white_model'] as String?,
      blackModel: json['black_model'] as String?,
    );

Map<String, dynamic> _$$GameSummaryImplToJson(_$GameSummaryImpl instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'white_player': instance.whitePlayer,
      'black_player': instance.blackPlayer,
      'moves_count': instance.movesCount,
      'result': instance.result,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'white_model': instance.whiteModel,
      'black_model': instance.blackModel,
    };
