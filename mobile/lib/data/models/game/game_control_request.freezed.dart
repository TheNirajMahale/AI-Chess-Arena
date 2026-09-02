// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_control_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameControlRequest _$GameControlRequestFromJson(Map<String, dynamic> json) {
  return _GameControlRequest.fromJson(json);
}

/// @nodoc
mixin _$GameControlRequest {
  String get action => throw _privateConstructorUsedError;
  @JsonKey(name: 'white_player')
  PlayerConfig? get whitePlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'black_player')
  PlayerConfig? get blackPlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'move_delay_seconds')
  int? get moveDelaySeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_id')
  String? get gameId => throw _privateConstructorUsedError;

  /// Serializes this GameControlRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameControlRequestCopyWith<GameControlRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameControlRequestCopyWith<$Res> {
  factory $GameControlRequestCopyWith(
    GameControlRequest value,
    $Res Function(GameControlRequest) then,
  ) = _$GameControlRequestCopyWithImpl<$Res, GameControlRequest>;
  @useResult
  $Res call({
    String action,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') int? moveDelaySeconds,
    @JsonKey(name: 'game_id') String? gameId,
  });

  $PlayerConfigCopyWith<$Res>? get whitePlayer;
  $PlayerConfigCopyWith<$Res>? get blackPlayer;
}

/// @nodoc
class _$GameControlRequestCopyWithImpl<$Res, $Val extends GameControlRequest>
    implements $GameControlRequestCopyWith<$Res> {
  _$GameControlRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? whitePlayer = freezed,
    Object? blackPlayer = freezed,
    Object? moveDelaySeconds = freezed,
    Object? gameId = freezed,
  }) {
    return _then(
      _value.copyWith(
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            whitePlayer: freezed == whitePlayer
                ? _value.whitePlayer
                : whitePlayer // ignore: cast_nullable_to_non_nullable
                      as PlayerConfig?,
            blackPlayer: freezed == blackPlayer
                ? _value.blackPlayer
                : blackPlayer // ignore: cast_nullable_to_non_nullable
                      as PlayerConfig?,
            moveDelaySeconds: freezed == moveDelaySeconds
                ? _value.moveDelaySeconds
                : moveDelaySeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            gameId: freezed == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerConfigCopyWith<$Res>? get whitePlayer {
    if (_value.whitePlayer == null) {
      return null;
    }

    return $PlayerConfigCopyWith<$Res>(_value.whitePlayer!, (value) {
      return _then(_value.copyWith(whitePlayer: value) as $Val);
    });
  }

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerConfigCopyWith<$Res>? get blackPlayer {
    if (_value.blackPlayer == null) {
      return null;
    }

    return $PlayerConfigCopyWith<$Res>(_value.blackPlayer!, (value) {
      return _then(_value.copyWith(blackPlayer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameControlRequestImplCopyWith<$Res>
    implements $GameControlRequestCopyWith<$Res> {
  factory _$$GameControlRequestImplCopyWith(
    _$GameControlRequestImpl value,
    $Res Function(_$GameControlRequestImpl) then,
  ) = __$$GameControlRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String action,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') int? moveDelaySeconds,
    @JsonKey(name: 'game_id') String? gameId,
  });

  @override
  $PlayerConfigCopyWith<$Res>? get whitePlayer;
  @override
  $PlayerConfigCopyWith<$Res>? get blackPlayer;
}

/// @nodoc
class __$$GameControlRequestImplCopyWithImpl<$Res>
    extends _$GameControlRequestCopyWithImpl<$Res, _$GameControlRequestImpl>
    implements _$$GameControlRequestImplCopyWith<$Res> {
  __$$GameControlRequestImplCopyWithImpl(
    _$GameControlRequestImpl _value,
    $Res Function(_$GameControlRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? whitePlayer = freezed,
    Object? blackPlayer = freezed,
    Object? moveDelaySeconds = freezed,
    Object? gameId = freezed,
  }) {
    return _then(
      _$GameControlRequestImpl(
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        whitePlayer: freezed == whitePlayer
            ? _value.whitePlayer
            : whitePlayer // ignore: cast_nullable_to_non_nullable
                  as PlayerConfig?,
        blackPlayer: freezed == blackPlayer
            ? _value.blackPlayer
            : blackPlayer // ignore: cast_nullable_to_non_nullable
                  as PlayerConfig?,
        moveDelaySeconds: freezed == moveDelaySeconds
            ? _value.moveDelaySeconds
            : moveDelaySeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        gameId: freezed == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GameControlRequestImpl implements _GameControlRequest {
  const _$GameControlRequestImpl({
    required this.action,
    @JsonKey(name: 'white_player') this.whitePlayer,
    @JsonKey(name: 'black_player') this.blackPlayer,
    @JsonKey(name: 'move_delay_seconds') this.moveDelaySeconds = 10,
    @JsonKey(name: 'game_id') this.gameId,
  });

  factory _$GameControlRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameControlRequestImplFromJson(json);

  @override
  final String action;
  @override
  @JsonKey(name: 'white_player')
  final PlayerConfig? whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  final PlayerConfig? blackPlayer;
  @override
  @JsonKey(name: 'move_delay_seconds')
  final int? moveDelaySeconds;
  @override
  @JsonKey(name: 'game_id')
  final String? gameId;

  @override
  String toString() {
    return 'GameControlRequest(action: $action, whitePlayer: $whitePlayer, blackPlayer: $blackPlayer, moveDelaySeconds: $moveDelaySeconds, gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameControlRequestImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.whitePlayer, whitePlayer) ||
                other.whitePlayer == whitePlayer) &&
            (identical(other.blackPlayer, blackPlayer) ||
                other.blackPlayer == blackPlayer) &&
            (identical(other.moveDelaySeconds, moveDelaySeconds) ||
                other.moveDelaySeconds == moveDelaySeconds) &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    whitePlayer,
    blackPlayer,
    moveDelaySeconds,
    gameId,
  );

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameControlRequestImplCopyWith<_$GameControlRequestImpl> get copyWith =>
      __$$GameControlRequestImplCopyWithImpl<_$GameControlRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameControlRequestImplToJson(this);
  }
}

abstract class _GameControlRequest implements GameControlRequest {
  const factory _GameControlRequest({
    required final String action,
    @JsonKey(name: 'white_player') final PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') final PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') final int? moveDelaySeconds,
    @JsonKey(name: 'game_id') final String? gameId,
  }) = _$GameControlRequestImpl;

  factory _GameControlRequest.fromJson(Map<String, dynamic> json) =
      _$GameControlRequestImpl.fromJson;

  @override
  String get action;
  @override
  @JsonKey(name: 'white_player')
  PlayerConfig? get whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  PlayerConfig? get blackPlayer;
  @override
  @JsonKey(name: 'move_delay_seconds')
  int? get moveDelaySeconds;
  @override
  @JsonKey(name: 'game_id')
  String? get gameId;

  /// Create a copy of GameControlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameControlRequestImplCopyWith<_$GameControlRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TestKeyRequest _$TestKeyRequestFromJson(Map<String, dynamic> json) {
  return _TestKeyRequest.fromJson(json);
}

/// @nodoc
mixin _$TestKeyRequest {
  ProviderType get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_key')
  String get apiKey => throw _privateConstructorUsedError;

  /// Serializes this TestKeyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestKeyRequestCopyWith<TestKeyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestKeyRequestCopyWith<$Res> {
  factory $TestKeyRequestCopyWith(
    TestKeyRequest value,
    $Res Function(TestKeyRequest) then,
  ) = _$TestKeyRequestCopyWithImpl<$Res, TestKeyRequest>;
  @useResult
  $Res call({ProviderType provider, @JsonKey(name: 'api_key') String apiKey});
}

/// @nodoc
class _$TestKeyRequestCopyWithImpl<$Res, $Val extends TestKeyRequest>
    implements $TestKeyRequestCopyWith<$Res> {
  _$TestKeyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? provider = null, Object? apiKey = null}) {
    return _then(
      _value.copyWith(
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as ProviderType,
            apiKey: null == apiKey
                ? _value.apiKey
                : apiKey // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TestKeyRequestImplCopyWith<$Res>
    implements $TestKeyRequestCopyWith<$Res> {
  factory _$$TestKeyRequestImplCopyWith(
    _$TestKeyRequestImpl value,
    $Res Function(_$TestKeyRequestImpl) then,
  ) = __$$TestKeyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProviderType provider, @JsonKey(name: 'api_key') String apiKey});
}

/// @nodoc
class __$$TestKeyRequestImplCopyWithImpl<$Res>
    extends _$TestKeyRequestCopyWithImpl<$Res, _$TestKeyRequestImpl>
    implements _$$TestKeyRequestImplCopyWith<$Res> {
  __$$TestKeyRequestImplCopyWithImpl(
    _$TestKeyRequestImpl _value,
    $Res Function(_$TestKeyRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TestKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? provider = null, Object? apiKey = null}) {
    return _then(
      _$TestKeyRequestImpl(
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as ProviderType,
        apiKey: null == apiKey
            ? _value.apiKey
            : apiKey // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TestKeyRequestImpl implements _TestKeyRequest {
  const _$TestKeyRequestImpl({
    required this.provider,
    @JsonKey(name: 'api_key') required this.apiKey,
  });

  factory _$TestKeyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestKeyRequestImplFromJson(json);

  @override
  final ProviderType provider;
  @override
  @JsonKey(name: 'api_key')
  final String apiKey;

  @override
  String toString() {
    return 'TestKeyRequest(provider: $provider, apiKey: $apiKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestKeyRequestImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, provider, apiKey);

  /// Create a copy of TestKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestKeyRequestImplCopyWith<_$TestKeyRequestImpl> get copyWith =>
      __$$TestKeyRequestImplCopyWithImpl<_$TestKeyRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TestKeyRequestImplToJson(this);
  }
}

abstract class _TestKeyRequest implements TestKeyRequest {
  const factory _TestKeyRequest({
    required final ProviderType provider,
    @JsonKey(name: 'api_key') required final String apiKey,
  }) = _$TestKeyRequestImpl;

  factory _TestKeyRequest.fromJson(Map<String, dynamic> json) =
      _$TestKeyRequestImpl.fromJson;

  @override
  ProviderType get provider;
  @override
  @JsonKey(name: 'api_key')
  String get apiKey;

  /// Create a copy of TestKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestKeyRequestImplCopyWith<_$TestKeyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
