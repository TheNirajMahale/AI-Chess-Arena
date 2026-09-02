// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'move_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MoveData _$MoveDataFromJson(Map<String, dynamic> json) {
  return _MoveData.fromJson(json);
}

/// @nodoc
mixin _$MoveData {
  @JsonKey(name: 'move_number')
  int get moveNumber => throw _privateConstructorUsedError;
  PlayerColor get turn => throw _privateConstructorUsedError;
  String get san => throw _privateConstructorUsedError;
  String get uci => throw _privateConstructorUsedError;
  @JsonKey(name: 'fen_before')
  String get fenBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'fen_after')
  String get fenAfter => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_id')
  String get modelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_ms')
  int get durationMs => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_check')
  bool get isCheck => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_checkmate')
  bool get isCheckmate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_capture')
  bool get isCapture => throw _privateConstructorUsedError;
  @JsonKey(name: 'captured_piece')
  String? get capturedPiece => throw _privateConstructorUsedError;

  /// Serializes this MoveData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoveData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoveDataCopyWith<MoveData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoveDataCopyWith<$Res> {
  factory $MoveDataCopyWith(MoveData value, $Res Function(MoveData) then) =
      _$MoveDataCopyWithImpl<$Res, MoveData>;
  @useResult
  $Res call({
    @JsonKey(name: 'move_number') int moveNumber,
    PlayerColor turn,
    String san,
    String uci,
    @JsonKey(name: 'fen_before') String fenBefore,
    @JsonKey(name: 'fen_after') String fenAfter,
    String reasoning,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'model_id') String modelId,
    @JsonKey(name: 'duration_ms') int durationMs,
    String timestamp,
    @JsonKey(name: 'is_check') bool isCheck,
    @JsonKey(name: 'is_checkmate') bool isCheckmate,
    @JsonKey(name: 'is_capture') bool isCapture,
    @JsonKey(name: 'captured_piece') String? capturedPiece,
  });
}

/// @nodoc
class _$MoveDataCopyWithImpl<$Res, $Val extends MoveData>
    implements $MoveDataCopyWith<$Res> {
  _$MoveDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoveData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moveNumber = null,
    Object? turn = null,
    Object? san = null,
    Object? uci = null,
    Object? fenBefore = null,
    Object? fenAfter = null,
    Object? reasoning = null,
    Object? playerName = null,
    Object? modelId = null,
    Object? durationMs = null,
    Object? timestamp = null,
    Object? isCheck = null,
    Object? isCheckmate = null,
    Object? isCapture = null,
    Object? capturedPiece = freezed,
  }) {
    return _then(
      _value.copyWith(
            moveNumber: null == moveNumber
                ? _value.moveNumber
                : moveNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            turn: null == turn
                ? _value.turn
                : turn // ignore: cast_nullable_to_non_nullable
                      as PlayerColor,
            san: null == san
                ? _value.san
                : san // ignore: cast_nullable_to_non_nullable
                      as String,
            uci: null == uci
                ? _value.uci
                : uci // ignore: cast_nullable_to_non_nullable
                      as String,
            fenBefore: null == fenBefore
                ? _value.fenBefore
                : fenBefore // ignore: cast_nullable_to_non_nullable
                      as String,
            fenAfter: null == fenAfter
                ? _value.fenAfter
                : fenAfter // ignore: cast_nullable_to_non_nullable
                      as String,
            reasoning: null == reasoning
                ? _value.reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            modelId: null == modelId
                ? _value.modelId
                : modelId // ignore: cast_nullable_to_non_nullable
                      as String,
            durationMs: null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String,
            isCheck: null == isCheck
                ? _value.isCheck
                : isCheck // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCheckmate: null == isCheckmate
                ? _value.isCheckmate
                : isCheckmate // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCapture: null == isCapture
                ? _value.isCapture
                : isCapture // ignore: cast_nullable_to_non_nullable
                      as bool,
            capturedPiece: freezed == capturedPiece
                ? _value.capturedPiece
                : capturedPiece // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoveDataImplCopyWith<$Res>
    implements $MoveDataCopyWith<$Res> {
  factory _$$MoveDataImplCopyWith(
    _$MoveDataImpl value,
    $Res Function(_$MoveDataImpl) then,
  ) = __$$MoveDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'move_number') int moveNumber,
    PlayerColor turn,
    String san,
    String uci,
    @JsonKey(name: 'fen_before') String fenBefore,
    @JsonKey(name: 'fen_after') String fenAfter,
    String reasoning,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'model_id') String modelId,
    @JsonKey(name: 'duration_ms') int durationMs,
    String timestamp,
    @JsonKey(name: 'is_check') bool isCheck,
    @JsonKey(name: 'is_checkmate') bool isCheckmate,
    @JsonKey(name: 'is_capture') bool isCapture,
    @JsonKey(name: 'captured_piece') String? capturedPiece,
  });
}

/// @nodoc
class __$$MoveDataImplCopyWithImpl<$Res>
    extends _$MoveDataCopyWithImpl<$Res, _$MoveDataImpl>
    implements _$$MoveDataImplCopyWith<$Res> {
  __$$MoveDataImplCopyWithImpl(
    _$MoveDataImpl _value,
    $Res Function(_$MoveDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoveData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moveNumber = null,
    Object? turn = null,
    Object? san = null,
    Object? uci = null,
    Object? fenBefore = null,
    Object? fenAfter = null,
    Object? reasoning = null,
    Object? playerName = null,
    Object? modelId = null,
    Object? durationMs = null,
    Object? timestamp = null,
    Object? isCheck = null,
    Object? isCheckmate = null,
    Object? isCapture = null,
    Object? capturedPiece = freezed,
  }) {
    return _then(
      _$MoveDataImpl(
        moveNumber: null == moveNumber
            ? _value.moveNumber
            : moveNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        turn: null == turn
            ? _value.turn
            : turn // ignore: cast_nullable_to_non_nullable
                  as PlayerColor,
        san: null == san
            ? _value.san
            : san // ignore: cast_nullable_to_non_nullable
                  as String,
        uci: null == uci
            ? _value.uci
            : uci // ignore: cast_nullable_to_non_nullable
                  as String,
        fenBefore: null == fenBefore
            ? _value.fenBefore
            : fenBefore // ignore: cast_nullable_to_non_nullable
                  as String,
        fenAfter: null == fenAfter
            ? _value.fenAfter
            : fenAfter // ignore: cast_nullable_to_non_nullable
                  as String,
        reasoning: null == reasoning
            ? _value.reasoning
            : reasoning // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        modelId: null == modelId
            ? _value.modelId
            : modelId // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMs: null == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
        isCheck: null == isCheck
            ? _value.isCheck
            : isCheck // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCheckmate: null == isCheckmate
            ? _value.isCheckmate
            : isCheckmate // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCapture: null == isCapture
            ? _value.isCapture
            : isCapture // ignore: cast_nullable_to_non_nullable
                  as bool,
        capturedPiece: freezed == capturedPiece
            ? _value.capturedPiece
            : capturedPiece // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoveDataImpl implements _MoveData {
  const _$MoveDataImpl({
    @JsonKey(name: 'move_number') required this.moveNumber,
    required this.turn,
    required this.san,
    required this.uci,
    @JsonKey(name: 'fen_before') required this.fenBefore,
    @JsonKey(name: 'fen_after') required this.fenAfter,
    this.reasoning = '',
    @JsonKey(name: 'player_name') required this.playerName,
    @JsonKey(name: 'model_id') required this.modelId,
    @JsonKey(name: 'duration_ms') this.durationMs = 0,
    required this.timestamp,
    @JsonKey(name: 'is_check') this.isCheck = false,
    @JsonKey(name: 'is_checkmate') this.isCheckmate = false,
    @JsonKey(name: 'is_capture') this.isCapture = false,
    @JsonKey(name: 'captured_piece') this.capturedPiece,
  });

  factory _$MoveDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoveDataImplFromJson(json);

  @override
  @JsonKey(name: 'move_number')
  final int moveNumber;
  @override
  final PlayerColor turn;
  @override
  final String san;
  @override
  final String uci;
  @override
  @JsonKey(name: 'fen_before')
  final String fenBefore;
  @override
  @JsonKey(name: 'fen_after')
  final String fenAfter;
  @override
  @JsonKey()
  final String reasoning;
  @override
  @JsonKey(name: 'player_name')
  final String playerName;
  @override
  @JsonKey(name: 'model_id')
  final String modelId;
  @override
  @JsonKey(name: 'duration_ms')
  final int durationMs;
  @override
  final String timestamp;
  @override
  @JsonKey(name: 'is_check')
  final bool isCheck;
  @override
  @JsonKey(name: 'is_checkmate')
  final bool isCheckmate;
  @override
  @JsonKey(name: 'is_capture')
  final bool isCapture;
  @override
  @JsonKey(name: 'captured_piece')
  final String? capturedPiece;

  @override
  String toString() {
    return 'MoveData(moveNumber: $moveNumber, turn: $turn, san: $san, uci: $uci, fenBefore: $fenBefore, fenAfter: $fenAfter, reasoning: $reasoning, playerName: $playerName, modelId: $modelId, durationMs: $durationMs, timestamp: $timestamp, isCheck: $isCheck, isCheckmate: $isCheckmate, isCapture: $isCapture, capturedPiece: $capturedPiece)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoveDataImpl &&
            (identical(other.moveNumber, moveNumber) ||
                other.moveNumber == moveNumber) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.san, san) || other.san == san) &&
            (identical(other.uci, uci) || other.uci == uci) &&
            (identical(other.fenBefore, fenBefore) ||
                other.fenBefore == fenBefore) &&
            (identical(other.fenAfter, fenAfter) ||
                other.fenAfter == fenAfter) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isCheck, isCheck) || other.isCheck == isCheck) &&
            (identical(other.isCheckmate, isCheckmate) ||
                other.isCheckmate == isCheckmate) &&
            (identical(other.isCapture, isCapture) ||
                other.isCapture == isCapture) &&
            (identical(other.capturedPiece, capturedPiece) ||
                other.capturedPiece == capturedPiece));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    moveNumber,
    turn,
    san,
    uci,
    fenBefore,
    fenAfter,
    reasoning,
    playerName,
    modelId,
    durationMs,
    timestamp,
    isCheck,
    isCheckmate,
    isCapture,
    capturedPiece,
  );

  /// Create a copy of MoveData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoveDataImplCopyWith<_$MoveDataImpl> get copyWith =>
      __$$MoveDataImplCopyWithImpl<_$MoveDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoveDataImplToJson(this);
  }
}

abstract class _MoveData implements MoveData {
  const factory _MoveData({
    @JsonKey(name: 'move_number') required final int moveNumber,
    required final PlayerColor turn,
    required final String san,
    required final String uci,
    @JsonKey(name: 'fen_before') required final String fenBefore,
    @JsonKey(name: 'fen_after') required final String fenAfter,
    final String reasoning,
    @JsonKey(name: 'player_name') required final String playerName,
    @JsonKey(name: 'model_id') required final String modelId,
    @JsonKey(name: 'duration_ms') final int durationMs,
    required final String timestamp,
    @JsonKey(name: 'is_check') final bool isCheck,
    @JsonKey(name: 'is_checkmate') final bool isCheckmate,
    @JsonKey(name: 'is_capture') final bool isCapture,
    @JsonKey(name: 'captured_piece') final String? capturedPiece,
  }) = _$MoveDataImpl;

  factory _MoveData.fromJson(Map<String, dynamic> json) =
      _$MoveDataImpl.fromJson;

  @override
  @JsonKey(name: 'move_number')
  int get moveNumber;
  @override
  PlayerColor get turn;
  @override
  String get san;
  @override
  String get uci;
  @override
  @JsonKey(name: 'fen_before')
  String get fenBefore;
  @override
  @JsonKey(name: 'fen_after')
  String get fenAfter;
  @override
  String get reasoning;
  @override
  @JsonKey(name: 'player_name')
  String get playerName;
  @override
  @JsonKey(name: 'model_id')
  String get modelId;
  @override
  @JsonKey(name: 'duration_ms')
  int get durationMs;
  @override
  String get timestamp;
  @override
  @JsonKey(name: 'is_check')
  bool get isCheck;
  @override
  @JsonKey(name: 'is_checkmate')
  bool get isCheckmate;
  @override
  @JsonKey(name: 'is_capture')
  bool get isCapture;
  @override
  @JsonKey(name: 'captured_piece')
  String? get capturedPiece;

  /// Create a copy of MoveData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoveDataImplCopyWith<_$MoveDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
