// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoveDataImpl _$$MoveDataImplFromJson(Map<String, dynamic> json) =>
    _$MoveDataImpl(
      moveNumber: (json['move_number'] as num).toInt(),
      turn: $enumDecode(_$PlayerColorEnumMap, json['turn']),
      san: json['san'] as String,
      uci: json['uci'] as String,
      fenBefore: json['fen_before'] as String,
      fenAfter: json['fen_after'] as String,
      reasoning: json['reasoning'] as String? ?? '',
      playerName: json['player_name'] as String,
      modelId: json['model_id'] as String,
      durationMs: (json['duration_ms'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] as String,
      isCheck: json['is_check'] as bool? ?? false,
      isCheckmate: json['is_checkmate'] as bool? ?? false,
      isCapture: json['is_capture'] as bool? ?? false,
      capturedPiece: json['captured_piece'] as String?,
    );

Map<String, dynamic> _$$MoveDataImplToJson(_$MoveDataImpl instance) =>
    <String, dynamic>{
      'move_number': instance.moveNumber,
      'turn': _$PlayerColorEnumMap[instance.turn]!,
      'san': instance.san,
      'uci': instance.uci,
      'fen_before': instance.fenBefore,
      'fen_after': instance.fenAfter,
      'reasoning': instance.reasoning,
      'player_name': instance.playerName,
      'model_id': instance.modelId,
      'duration_ms': instance.durationMs,
      'timestamp': instance.timestamp,
      'is_check': instance.isCheck,
      'is_checkmate': instance.isCheckmate,
      'is_capture': instance.isCapture,
      'captured_piece': instance.capturedPiece,
    };

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
