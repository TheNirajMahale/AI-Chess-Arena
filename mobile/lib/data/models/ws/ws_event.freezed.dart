// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WsEventCopyWith<$Res> {
  factory $WsEventCopyWith(WsEvent value, $Res Function(WsEvent) then) =
      _$WsEventCopyWithImpl<$Res, WsEvent>;
}

/// @nodoc
class _$WsEventCopyWithImpl<$Res, $Val extends WsEvent>
    implements $WsEventCopyWith<$Res> {
  _$WsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$WsEventGameStateImplCopyWith<$Res> {
  factory _$$WsEventGameStateImplCopyWith(
    _$WsEventGameStateImpl value,
    $Res Function(_$WsEventGameStateImpl) then,
  ) = __$$WsEventGameStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GameState state});

  $GameStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$WsEventGameStateImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventGameStateImpl>
    implements _$$WsEventGameStateImplCopyWith<$Res> {
  __$$WsEventGameStateImplCopyWithImpl(
    _$WsEventGameStateImpl _value,
    $Res Function(_$WsEventGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? state = null}) {
    return _then(
      _$WsEventGameStateImpl(
        null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as GameState,
      ),
    );
  }

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res> get state {
    return $GameStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc

class _$WsEventGameStateImpl implements _WsEventGameState {
  const _$WsEventGameStateImpl(this.state);

  @override
  final GameState state;

  @override
  String toString() {
    return 'WsEvent.gameState(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventGameStateImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventGameStateImplCopyWith<_$WsEventGameStateImpl> get copyWith =>
      __$$WsEventGameStateImplCopyWithImpl<_$WsEventGameStateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return gameState(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return gameState?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (gameState != null) {
      return gameState(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return gameState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return gameState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (gameState != null) {
      return gameState(this);
    }
    return orElse();
  }
}

abstract class _WsEventGameState implements WsEvent {
  const factory _WsEventGameState(final GameState state) =
      _$WsEventGameStateImpl;

  GameState get state;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventGameStateImplCopyWith<_$WsEventGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WsEventThinkingChunkImplCopyWith<$Res> {
  factory _$$WsEventThinkingChunkImplCopyWith(
    _$WsEventThinkingChunkImpl value,
    $Res Function(_$WsEventThinkingChunkImpl) then,
  ) = __$$WsEventThinkingChunkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String chunk,
    @JsonKey(name: 'full_text') String fullText,
    PlayerColor player,
  });
}

/// @nodoc
class __$$WsEventThinkingChunkImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventThinkingChunkImpl>
    implements _$$WsEventThinkingChunkImplCopyWith<$Res> {
  __$$WsEventThinkingChunkImplCopyWithImpl(
    _$WsEventThinkingChunkImpl _value,
    $Res Function(_$WsEventThinkingChunkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chunk = null,
    Object? fullText = null,
    Object? player = null,
  }) {
    return _then(
      _$WsEventThinkingChunkImpl(
        chunk: null == chunk
            ? _value.chunk
            : chunk // ignore: cast_nullable_to_non_nullable
                  as String,
        fullText: null == fullText
            ? _value.fullText
            : fullText // ignore: cast_nullable_to_non_nullable
                  as String,
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as PlayerColor,
      ),
    );
  }
}

/// @nodoc

class _$WsEventThinkingChunkImpl implements _WsEventThinkingChunk {
  const _$WsEventThinkingChunkImpl({
    required this.chunk,
    @JsonKey(name: 'full_text') required this.fullText,
    required this.player,
  });

  @override
  final String chunk;
  @override
  @JsonKey(name: 'full_text')
  final String fullText;
  @override
  final PlayerColor player;

  @override
  String toString() {
    return 'WsEvent.thinkingChunk(chunk: $chunk, fullText: $fullText, player: $player)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventThinkingChunkImpl &&
            (identical(other.chunk, chunk) || other.chunk == chunk) &&
            (identical(other.fullText, fullText) ||
                other.fullText == fullText) &&
            (identical(other.player, player) || other.player == player));
  }

  @override
  int get hashCode => Object.hash(runtimeType, chunk, fullText, player);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventThinkingChunkImplCopyWith<_$WsEventThinkingChunkImpl>
  get copyWith =>
      __$$WsEventThinkingChunkImplCopyWithImpl<_$WsEventThinkingChunkImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return thinkingChunk(chunk, fullText, player);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return thinkingChunk?.call(chunk, fullText, player);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (thinkingChunk != null) {
      return thinkingChunk(chunk, fullText, player);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return thinkingChunk(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return thinkingChunk?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (thinkingChunk != null) {
      return thinkingChunk(this);
    }
    return orElse();
  }
}

abstract class _WsEventThinkingChunk implements WsEvent {
  const factory _WsEventThinkingChunk({
    required final String chunk,
    @JsonKey(name: 'full_text') required final String fullText,
    required final PlayerColor player,
  }) = _$WsEventThinkingChunkImpl;

  String get chunk;
  @JsonKey(name: 'full_text')
  String get fullText;
  PlayerColor get player;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventThinkingChunkImplCopyWith<_$WsEventThinkingChunkImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WsEventMoveMadeImplCopyWith<$Res> {
  factory _$$WsEventMoveMadeImplCopyWith(
    _$WsEventMoveMadeImpl value,
    $Res Function(_$WsEventMoveMadeImpl) then,
  ) = __$$WsEventMoveMadeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MoveData move});

  $MoveDataCopyWith<$Res> get move;
}

/// @nodoc
class __$$WsEventMoveMadeImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventMoveMadeImpl>
    implements _$$WsEventMoveMadeImplCopyWith<$Res> {
  __$$WsEventMoveMadeImplCopyWithImpl(
    _$WsEventMoveMadeImpl _value,
    $Res Function(_$WsEventMoveMadeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? move = null}) {
    return _then(
      _$WsEventMoveMadeImpl(
        null == move
            ? _value.move
            : move // ignore: cast_nullable_to_non_nullable
                  as MoveData,
      ),
    );
  }

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoveDataCopyWith<$Res> get move {
    return $MoveDataCopyWith<$Res>(_value.move, (value) {
      return _then(_value.copyWith(move: value));
    });
  }
}

/// @nodoc

class _$WsEventMoveMadeImpl implements _WsEventMoveMade {
  const _$WsEventMoveMadeImpl(this.move);

  @override
  final MoveData move;

  @override
  String toString() {
    return 'WsEvent.moveMade(move: $move)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventMoveMadeImpl &&
            (identical(other.move, move) || other.move == move));
  }

  @override
  int get hashCode => Object.hash(runtimeType, move);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventMoveMadeImplCopyWith<_$WsEventMoveMadeImpl> get copyWith =>
      __$$WsEventMoveMadeImplCopyWithImpl<_$WsEventMoveMadeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return moveMade(move);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return moveMade?.call(move);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (moveMade != null) {
      return moveMade(move);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return moveMade(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return moveMade?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (moveMade != null) {
      return moveMade(this);
    }
    return orElse();
  }
}

abstract class _WsEventMoveMade implements WsEvent {
  const factory _WsEventMoveMade(final MoveData move) = _$WsEventMoveMadeImpl;

  MoveData get move;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventMoveMadeImplCopyWith<_$WsEventMoveMadeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WsEventGameOverImplCopyWith<$Res> {
  factory _$$WsEventGameOverImplCopyWith(
    _$WsEventGameOverImpl value,
    $Res Function(_$WsEventGameOverImpl) then,
  ) = __$$WsEventGameOverImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GameResult result});

  $GameResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$WsEventGameOverImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventGameOverImpl>
    implements _$$WsEventGameOverImplCopyWith<$Res> {
  __$$WsEventGameOverImplCopyWithImpl(
    _$WsEventGameOverImpl _value,
    $Res Function(_$WsEventGameOverImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null}) {
    return _then(
      _$WsEventGameOverImpl(
        null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as GameResult,
      ),
    );
  }

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameResultCopyWith<$Res> get result {
    return $GameResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }
}

/// @nodoc

class _$WsEventGameOverImpl implements _WsEventGameOver {
  const _$WsEventGameOverImpl(this.result);

  @override
  final GameResult result;

  @override
  String toString() {
    return 'WsEvent.gameOver(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventGameOverImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventGameOverImplCopyWith<_$WsEventGameOverImpl> get copyWith =>
      __$$WsEventGameOverImplCopyWithImpl<_$WsEventGameOverImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return gameOver(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return gameOver?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return gameOver(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return gameOver?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(this);
    }
    return orElse();
  }
}

abstract class _WsEventGameOver implements WsEvent {
  const factory _WsEventGameOver(final GameResult result) =
      _$WsEventGameOverImpl;

  GameResult get result;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventGameOverImplCopyWith<_$WsEventGameOverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WsEventErrorImplCopyWith<$Res> {
  factory _$$WsEventErrorImplCopyWith(
    _$WsEventErrorImpl value,
    $Res Function(_$WsEventErrorImpl) then,
  ) = __$$WsEventErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$WsEventErrorImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventErrorImpl>
    implements _$$WsEventErrorImplCopyWith<$Res> {
  __$$WsEventErrorImplCopyWithImpl(
    _$WsEventErrorImpl _value,
    $Res Function(_$WsEventErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$WsEventErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WsEventErrorImpl implements _WsEventError {
  const _$WsEventErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'WsEvent.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventErrorImplCopyWith<_$WsEventErrorImpl> get copyWith =>
      __$$WsEventErrorImplCopyWithImpl<_$WsEventErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _WsEventError implements WsEvent {
  const factory _WsEventError(final String message) = _$WsEventErrorImpl;

  String get message;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventErrorImplCopyWith<_$WsEventErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WsEventPongImplCopyWith<$Res> {
  factory _$$WsEventPongImplCopyWith(
    _$WsEventPongImpl value,
    $Res Function(_$WsEventPongImpl) then,
  ) = __$$WsEventPongImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WsEventPongImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventPongImpl>
    implements _$$WsEventPongImplCopyWith<$Res> {
  __$$WsEventPongImplCopyWithImpl(
    _$WsEventPongImpl _value,
    $Res Function(_$WsEventPongImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WsEventPongImpl implements _WsEventPong {
  const _$WsEventPongImpl();

  @override
  String toString() {
    return 'WsEvent.pong()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WsEventPongImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return pong();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return pong?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (pong != null) {
      return pong();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return pong(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return pong?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (pong != null) {
      return pong(this);
    }
    return orElse();
  }
}

abstract class _WsEventPong implements WsEvent {
  const factory _WsEventPong() = _$WsEventPongImpl;
}

/// @nodoc
abstract class _$$WsEventUnknownImplCopyWith<$Res> {
  factory _$$WsEventUnknownImplCopyWith(
    _$WsEventUnknownImpl value,
    $Res Function(_$WsEventUnknownImpl) then,
  ) = __$$WsEventUnknownImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String raw});
}

/// @nodoc
class __$$WsEventUnknownImplCopyWithImpl<$Res>
    extends _$WsEventCopyWithImpl<$Res, _$WsEventUnknownImpl>
    implements _$$WsEventUnknownImplCopyWith<$Res> {
  __$$WsEventUnknownImplCopyWithImpl(
    _$WsEventUnknownImpl _value,
    $Res Function(_$WsEventUnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? raw = null}) {
    return _then(
      _$WsEventUnknownImpl(
        null == raw
            ? _value.raw
            : raw // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WsEventUnknownImpl implements _WsEventUnknown {
  const _$WsEventUnknownImpl(this.raw);

  @override
  final String raw;

  @override
  String toString() {
    return 'WsEvent.unknown(raw: $raw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsEventUnknownImpl &&
            (identical(other.raw, raw) || other.raw == raw));
  }

  @override
  int get hashCode => Object.hash(runtimeType, raw);

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsEventUnknownImplCopyWith<_$WsEventUnknownImpl> get copyWith =>
      __$$WsEventUnknownImplCopyWithImpl<_$WsEventUnknownImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GameState state) gameState,
    required TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )
    thinkingChunk,
    required TResult Function(MoveData move) moveMade,
    required TResult Function(GameResult result) gameOver,
    required TResult Function(String message) error,
    required TResult Function() pong,
    required TResult Function(String raw) unknown,
  }) {
    return unknown(raw);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GameState state)? gameState,
    TResult? Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult? Function(MoveData move)? moveMade,
    TResult? Function(GameResult result)? gameOver,
    TResult? Function(String message)? error,
    TResult? Function()? pong,
    TResult? Function(String raw)? unknown,
  }) {
    return unknown?.call(raw);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GameState state)? gameState,
    TResult Function(
      String chunk,
      @JsonKey(name: 'full_text') String fullText,
      PlayerColor player,
    )?
    thinkingChunk,
    TResult Function(MoveData move)? moveMade,
    TResult Function(GameResult result)? gameOver,
    TResult Function(String message)? error,
    TResult Function()? pong,
    TResult Function(String raw)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(raw);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WsEventGameState value) gameState,
    required TResult Function(_WsEventThinkingChunk value) thinkingChunk,
    required TResult Function(_WsEventMoveMade value) moveMade,
    required TResult Function(_WsEventGameOver value) gameOver,
    required TResult Function(_WsEventError value) error,
    required TResult Function(_WsEventPong value) pong,
    required TResult Function(_WsEventUnknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WsEventGameState value)? gameState,
    TResult? Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult? Function(_WsEventMoveMade value)? moveMade,
    TResult? Function(_WsEventGameOver value)? gameOver,
    TResult? Function(_WsEventError value)? error,
    TResult? Function(_WsEventPong value)? pong,
    TResult? Function(_WsEventUnknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WsEventGameState value)? gameState,
    TResult Function(_WsEventThinkingChunk value)? thinkingChunk,
    TResult Function(_WsEventMoveMade value)? moveMade,
    TResult Function(_WsEventGameOver value)? gameOver,
    TResult Function(_WsEventError value)? error,
    TResult Function(_WsEventPong value)? pong,
    TResult Function(_WsEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _WsEventUnknown implements WsEvent {
  const factory _WsEventUnknown(final String raw) = _$WsEventUnknownImpl;

  String get raw;

  /// Create a copy of WsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsEventUnknownImplCopyWith<_$WsEventUnknownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
