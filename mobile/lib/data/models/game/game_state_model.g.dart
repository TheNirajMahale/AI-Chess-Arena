// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      gameId: json['game_id'] as String,
      status:
          $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.idle,
      fen:
          json['fen'] as String? ??
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      turn:
          $enumDecodeNullable(_$PlayerColorEnumMap, json['turn']) ??
          PlayerColor.white,
      whitePlayer: json['white_player'] == null
          ? null
          : PlayerConfig.fromJson(json['white_player'] as Map<String, dynamic>),
      blackPlayer: json['black_player'] == null
          ? null
          : PlayerConfig.fromJson(json['black_player'] as Map<String, dynamic>),
      moveDelaySeconds: (json['move_delay_seconds'] as num?)?.toInt() ?? 10,
      currentMoveNumber: (json['current_move_number'] as num?)?.toInt() ?? 1,
      moveHistory:
          (json['move_history'] as List<dynamic>?)
              ?.map((e) => MoveData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      result: json['result'] == null
          ? null
          : GameResult.fromJson(json['result'] as Map<String, dynamic>),
      capturedByWhite:
          (json['captured_by_white'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      capturedByBlack:
          (json['captured_by_black'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pgn: json['pgn'] as String? ?? '',
      liveThinking: json['live_thinking'] as String? ?? '',
      isThinking: json['is_thinking'] as bool? ?? false,
      thinkingPlayer: $enumDecodeNullable(
        _$PlayerColorEnumMap,
        json['thinking_player'],
      ),
      countdownSeconds: (json['countdown_seconds'] as num?)?.toDouble(),
      lastMoveUci: json['last_move_uci'] as String?,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'status': _$GameStatusEnumMap[instance.status]!,
      'fen': instance.fen,
      'turn': _$PlayerColorEnumMap[instance.turn]!,
      'white_player': instance.whitePlayer?.toJson(),
      'black_player': instance.blackPlayer?.toJson(),
      'move_delay_seconds': instance.moveDelaySeconds,
      'current_move_number': instance.currentMoveNumber,
      'move_history': instance.moveHistory.map((e) => e.toJson()).toList(),
      'result': instance.result?.toJson(),
      'captured_by_white': instance.capturedByWhite,
      'captured_by_black': instance.capturedByBlack,
      'pgn': instance.pgn,
      'live_thinking': instance.liveThinking,
      'is_thinking': instance.isThinking,
      'thinking_player': _$PlayerColorEnumMap[instance.thinkingPlayer],
      'countdown_seconds': instance.countdownSeconds,
      'last_move_uci': instance.lastMoveUci,
    };

const _$GameStatusEnumMap = {
  GameStatus.idle: 'idle',
  GameStatus.playing: 'playing',
  GameStatus.paused: 'paused',
  GameStatus.finished: 'finished',
};

const _$PlayerColorEnumMap = {
  PlayerColor.white: 'white',
  PlayerColor.black: 'black',
};
