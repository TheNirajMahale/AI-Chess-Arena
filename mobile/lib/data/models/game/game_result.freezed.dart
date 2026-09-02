// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameResult _$GameResultFromJson(Map<String, dynamic> json) {
  return _GameResult.fromJson(json);
}

/// @nodoc
mixin _$GameResult {
  PlayerColor? get winner => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this GameResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultCopyWith<GameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultCopyWith<$Res> {
  factory $GameResultCopyWith(
    GameResult value,
    $Res Function(GameResult) then,
  ) = _$GameResultCopyWithImpl<$Res, GameResult>;
  @useResult
  $Res call({PlayerColor? winner, String reason, String? description});
}

/// @nodoc
class _$GameResultCopyWithImpl<$Res, $Val extends GameResult>
    implements $GameResultCopyWith<$Res> {
  _$GameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = freezed,
    Object? reason = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            winner: freezed == winner
                ? _value.winner
                : winner // ignore: cast_nullable_to_non_nullable
                      as PlayerColor?,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameResultImplCopyWith<$Res>
    implements $GameResultCopyWith<$Res> {
  factory _$$GameResultImplCopyWith(
    _$GameResultImpl value,
    $Res Function(_$GameResultImpl) then,
  ) = __$$GameResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PlayerColor? winner, String reason, String? description});
}

/// @nodoc
class __$$GameResultImplCopyWithImpl<$Res>
    extends _$GameResultCopyWithImpl<$Res, _$GameResultImpl>
    implements _$$GameResultImplCopyWith<$Res> {
  __$$GameResultImplCopyWithImpl(
    _$GameResultImpl _value,
    $Res Function(_$GameResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = freezed,
    Object? reason = null,
    Object? description = freezed,
  }) {
    return _then(
      _$GameResultImpl(
        winner: freezed == winner
            ? _value.winner
            : winner // ignore: cast_nullable_to_non_nullable
                  as PlayerColor?,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameResultImpl implements _GameResult {
  const _$GameResultImpl({this.winner, required this.reason, this.description});

  factory _$GameResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameResultImplFromJson(json);

  @override
  final PlayerColor? winner;
  @override
  final String reason;
  @override
  final String? description;

  @override
  String toString() {
    return 'GameResult(winner: $winner, reason: $reason, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultImpl &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, winner, reason, description);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      __$$GameResultImplCopyWithImpl<_$GameResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameResultImplToJson(this);
  }
}

abstract class _GameResult implements GameResult {
  const factory _GameResult({
    final PlayerColor? winner,
    required final String reason,
    final String? description,
  }) = _$GameResultImpl;

  factory _GameResult.fromJson(Map<String, dynamic> json) =
      _$GameResultImpl.fromJson;

  @override
  PlayerColor? get winner;
  @override
  String get reason;
  @override
  String? get description;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
