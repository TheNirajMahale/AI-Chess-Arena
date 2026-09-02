// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameSummary _$GameSummaryFromJson(Map<String, dynamic> json) {
  return _GameSummary.fromJson(json);
}

/// @nodoc
mixin _$GameSummary {
  @JsonKey(name: 'game_id')
  String get gameId => throw _privateConstructorUsedError;
  @JsonKey(name: 'white_player')
  String get whitePlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'black_player')
  String get blackPlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'moves_count')
  int get movesCount => throw _privateConstructorUsedError;
  GameResult? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String? get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'white_model')
  String? get whiteModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'black_model')
  String? get blackModel => throw _privateConstructorUsedError;

  /// Serializes this GameSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSummaryCopyWith<GameSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSummaryCopyWith<$Res> {
  factory $GameSummaryCopyWith(
    GameSummary value,
    $Res Function(GameSummary) then,
  ) = _$GameSummaryCopyWithImpl<$Res, GameSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'white_player') String whitePlayer,
    @JsonKey(name: 'black_player') String blackPlayer,
    @JsonKey(name: 'moves_count') int movesCount,
    GameResult? result,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'white_model') String? whiteModel,
    @JsonKey(name: 'black_model') String? blackModel,
  });

  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$GameSummaryCopyWithImpl<$Res, $Val extends GameSummary>
    implements $GameSummaryCopyWith<$Res> {
  _$GameSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? movesCount = null,
    Object? result = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? whiteModel = freezed,
    Object? blackModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            whitePlayer: null == whitePlayer
                ? _value.whitePlayer
                : whitePlayer // ignore: cast_nullable_to_non_nullable
                      as String,
            blackPlayer: null == blackPlayer
                ? _value.blackPlayer
                : blackPlayer // ignore: cast_nullable_to_non_nullable
                      as String,
            movesCount: null == movesCount
                ? _value.movesCount
                : movesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as GameResult?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            whiteModel: freezed == whiteModel
                ? _value.whiteModel
                : whiteModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            blackModel: freezed == blackModel
                ? _value.blackModel
                : blackModel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $GameResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameSummaryImplCopyWith<$Res>
    implements $GameSummaryCopyWith<$Res> {
  factory _$$GameSummaryImplCopyWith(
    _$GameSummaryImpl value,
    $Res Function(_$GameSummaryImpl) then,
  ) = __$$GameSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'game_id') String gameId,
    @JsonKey(name: 'white_player') String whitePlayer,
    @JsonKey(name: 'black_player') String blackPlayer,
    @JsonKey(name: 'moves_count') int movesCount,
    GameResult? result,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'white_model') String? whiteModel,
    @JsonKey(name: 'black_model') String? blackModel,
  });

  @override
  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$GameSummaryImplCopyWithImpl<$Res>
    extends _$GameSummaryCopyWithImpl<$Res, _$GameSummaryImpl>
    implements _$$GameSummaryImplCopyWith<$Res> {
  __$$GameSummaryImplCopyWithImpl(
    _$GameSummaryImpl _value,
    $Res Function(_$GameSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? movesCount = null,
    Object? result = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? whiteModel = freezed,
    Object? blackModel = freezed,
  }) {
    return _then(
      _$GameSummaryImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        whitePlayer: null == whitePlayer
            ? _value.whitePlayer
            : whitePlayer // ignore: cast_nullable_to_non_nullable
                  as String,
        blackPlayer: null == blackPlayer
            ? _value.blackPlayer
            : blackPlayer // ignore: cast_nullable_to_non_nullable
                  as String,
        movesCount: null == movesCount
            ? _value.movesCount
            : movesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        result: freezed == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as GameResult?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        whiteModel: freezed == whiteModel
            ? _value.whiteModel
            : whiteModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        blackModel: freezed == blackModel
            ? _value.blackModel
            : blackModel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSummaryImpl implements _GameSummary {
  const _$GameSummaryImpl({
    @JsonKey(name: 'game_id') required this.gameId,
    @JsonKey(name: 'white_player') required this.whitePlayer,
    @JsonKey(name: 'black_player') required this.blackPlayer,
    @JsonKey(name: 'moves_count') this.movesCount = 0,
    this.result,
    @JsonKey(name: 'start_time') this.startTime,
    @JsonKey(name: 'end_time') this.endTime,
    @JsonKey(name: 'white_model') this.whiteModel,
    @JsonKey(name: 'black_model') this.blackModel,
  });

  factory _$GameSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'game_id')
  final String gameId;
  @override
  @JsonKey(name: 'white_player')
  final String whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  final String blackPlayer;
  @override
  @JsonKey(name: 'moves_count')
  final int movesCount;
  @override
  final GameResult? result;
  @override
  @JsonKey(name: 'start_time')
  final String? startTime;
  @override
  @JsonKey(name: 'end_time')
  final String? endTime;
  @override
  @JsonKey(name: 'white_model')
  final String? whiteModel;
  @override
  @JsonKey(name: 'black_model')
  final String? blackModel;

  @override
  String toString() {
    return 'GameSummary(gameId: $gameId, whitePlayer: $whitePlayer, blackPlayer: $blackPlayer, movesCount: $movesCount, result: $result, startTime: $startTime, endTime: $endTime, whiteModel: $whiteModel, blackModel: $blackModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSummaryImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.whitePlayer, whitePlayer) ||
                other.whitePlayer == whitePlayer) &&
            (identical(other.blackPlayer, blackPlayer) ||
                other.blackPlayer == blackPlayer) &&
            (identical(other.movesCount, movesCount) ||
                other.movesCount == movesCount) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.whiteModel, whiteModel) ||
                other.whiteModel == whiteModel) &&
            (identical(other.blackModel, blackModel) ||
                other.blackModel == blackModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameId,
    whitePlayer,
    blackPlayer,
    movesCount,
    result,
    startTime,
    endTime,
    whiteModel,
    blackModel,
  );

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSummaryImplCopyWith<_$GameSummaryImpl> get copyWith =>
      __$$GameSummaryImplCopyWithImpl<_$GameSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSummaryImplToJson(this);
  }
}

abstract class _GameSummary implements GameSummary {
  const factory _GameSummary({
    @JsonKey(name: 'game_id') required final String gameId,
    @JsonKey(name: 'white_player') required final String whitePlayer,
    @JsonKey(name: 'black_player') required final String blackPlayer,
    @JsonKey(name: 'moves_count') final int movesCount,
    final GameResult? result,
    @JsonKey(name: 'start_time') final String? startTime,
    @JsonKey(name: 'end_time') final String? endTime,
    @JsonKey(name: 'white_model') final String? whiteModel,
    @JsonKey(name: 'black_model') final String? blackModel,
  }) = _$GameSummaryImpl;

  factory _GameSummary.fromJson(Map<String, dynamic> json) =
      _$GameSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'game_id')
  String get gameId;
  @override
  @JsonKey(name: 'white_player')
  String get whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  String get blackPlayer;
  @override
  @JsonKey(name: 'moves_count')
  int get movesCount;
  @override
  GameResult? get result;
  @override
  @JsonKey(name: 'start_time')
  String? get startTime;
  @override
  @JsonKey(name: 'end_time')
  String? get endTime;
  @override
  @JsonKey(name: 'white_model')
  String? get whiteModel;
  @override
  @JsonKey(name: 'black_model')
  String? get blackModel;

  /// Create a copy of GameSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSummaryImplCopyWith<_$GameSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
