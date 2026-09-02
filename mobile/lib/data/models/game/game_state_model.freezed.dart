// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  @JsonKey(name: 'game_id')
  String get gameId => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  String get fen => throw _privateConstructorUsedError;
  PlayerColor get turn => throw _privateConstructorUsedError;
  @JsonKey(name: 'white_player')
  PlayerConfig? get whitePlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'black_player')
  PlayerConfig? get blackPlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'move_delay_seconds')
  int get moveDelaySeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_move_number')
  int get currentMoveNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'move_history')
  List<MoveData> get moveHistory => throw _privateConstructorUsedError;
  GameResult? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'captured_by_white')
  List<String> get capturedByWhite => throw _privateConstructorUsedError;
  @JsonKey(name: 'captured_by_black')
  List<String> get capturedByBlack => throw _privateConstructorUsedError;
  String get pgn => throw _privateConstructorUsedError;
  @JsonKey(name: 'live_thinking')
  String get liveThinking => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_thinking')
  bool get isThinking => throw _privateConstructorUsedError;
  @JsonKey(name: 'thinking_player')
  PlayerColor? get thinkingPlayer => throw _privateConstructorUsedError;
  @JsonKey(name: 'countdown_seconds')
  double? get countdownSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_move_uci')
  String? get lastMoveUci => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    @JsonKey(name: 'game_id') String gameId,
    GameStatus status,
    String fen,
    PlayerColor turn,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') int moveDelaySeconds,
    @JsonKey(name: 'current_move_number') int currentMoveNumber,
    @JsonKey(name: 'move_history') List<MoveData> moveHistory,
    GameResult? result,
    @JsonKey(name: 'captured_by_white') List<String> capturedByWhite,
    @JsonKey(name: 'captured_by_black') List<String> capturedByBlack,
    String pgn,
    @JsonKey(name: 'live_thinking') String liveThinking,
    @JsonKey(name: 'is_thinking') bool isThinking,
    @JsonKey(name: 'thinking_player') PlayerColor? thinkingPlayer,
    @JsonKey(name: 'countdown_seconds') double? countdownSeconds,
    @JsonKey(name: 'last_move_uci') String? lastMoveUci,
  });

  $PlayerConfigCopyWith<$Res>? get whitePlayer;
  $PlayerConfigCopyWith<$Res>? get blackPlayer;
  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? status = null,
    Object? fen = null,
    Object? turn = null,
    Object? whitePlayer = freezed,
    Object? blackPlayer = freezed,
    Object? moveDelaySeconds = null,
    Object? currentMoveNumber = null,
    Object? moveHistory = null,
    Object? result = freezed,
    Object? capturedByWhite = null,
    Object? capturedByBlack = null,
    Object? pgn = null,
    Object? liveThinking = null,
    Object? isThinking = null,
    Object? thinkingPlayer = freezed,
    Object? countdownSeconds = freezed,
    Object? lastMoveUci = freezed,
  }) {
    return _then(
      _value.copyWith(
            gameId: null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            fen: null == fen
                ? _value.fen
                : fen // ignore: cast_nullable_to_non_nullable
                      as String,
            turn: null == turn
                ? _value.turn
                : turn // ignore: cast_nullable_to_non_nullable
                      as PlayerColor,
            whitePlayer: freezed == whitePlayer
                ? _value.whitePlayer
                : whitePlayer // ignore: cast_nullable_to_non_nullable
                      as PlayerConfig?,
            blackPlayer: freezed == blackPlayer
                ? _value.blackPlayer
                : blackPlayer // ignore: cast_nullable_to_non_nullable
                      as PlayerConfig?,
            moveDelaySeconds: null == moveDelaySeconds
                ? _value.moveDelaySeconds
                : moveDelaySeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            currentMoveNumber: null == currentMoveNumber
                ? _value.currentMoveNumber
                : currentMoveNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            moveHistory: null == moveHistory
                ? _value.moveHistory
                : moveHistory // ignore: cast_nullable_to_non_nullable
                      as List<MoveData>,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as GameResult?,
            capturedByWhite: null == capturedByWhite
                ? _value.capturedByWhite
                : capturedByWhite // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            capturedByBlack: null == capturedByBlack
                ? _value.capturedByBlack
                : capturedByBlack // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            pgn: null == pgn
                ? _value.pgn
                : pgn // ignore: cast_nullable_to_non_nullable
                      as String,
            liveThinking: null == liveThinking
                ? _value.liveThinking
                : liveThinking // ignore: cast_nullable_to_non_nullable
                      as String,
            isThinking: null == isThinking
                ? _value.isThinking
                : isThinking // ignore: cast_nullable_to_non_nullable
                      as bool,
            thinkingPlayer: freezed == thinkingPlayer
                ? _value.thinkingPlayer
                : thinkingPlayer // ignore: cast_nullable_to_non_nullable
                      as PlayerColor?,
            countdownSeconds: freezed == countdownSeconds
                ? _value.countdownSeconds
                : countdownSeconds // ignore: cast_nullable_to_non_nullable
                      as double?,
            lastMoveUci: freezed == lastMoveUci
                ? _value.lastMoveUci
                : lastMoveUci // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameState
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

  /// Create a copy of GameState
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

  /// Create a copy of GameState
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
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'game_id') String gameId,
    GameStatus status,
    String fen,
    PlayerColor turn,
    @JsonKey(name: 'white_player') PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') int moveDelaySeconds,
    @JsonKey(name: 'current_move_number') int currentMoveNumber,
    @JsonKey(name: 'move_history') List<MoveData> moveHistory,
    GameResult? result,
    @JsonKey(name: 'captured_by_white') List<String> capturedByWhite,
    @JsonKey(name: 'captured_by_black') List<String> capturedByBlack,
    String pgn,
    @JsonKey(name: 'live_thinking') String liveThinking,
    @JsonKey(name: 'is_thinking') bool isThinking,
    @JsonKey(name: 'thinking_player') PlayerColor? thinkingPlayer,
    @JsonKey(name: 'countdown_seconds') double? countdownSeconds,
    @JsonKey(name: 'last_move_uci') String? lastMoveUci,
  });

  @override
  $PlayerConfigCopyWith<$Res>? get whitePlayer;
  @override
  $PlayerConfigCopyWith<$Res>? get blackPlayer;
  @override
  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? status = null,
    Object? fen = null,
    Object? turn = null,
    Object? whitePlayer = freezed,
    Object? blackPlayer = freezed,
    Object? moveDelaySeconds = null,
    Object? currentMoveNumber = null,
    Object? moveHistory = null,
    Object? result = freezed,
    Object? capturedByWhite = null,
    Object? capturedByBlack = null,
    Object? pgn = null,
    Object? liveThinking = null,
    Object? isThinking = null,
    Object? thinkingPlayer = freezed,
    Object? countdownSeconds = freezed,
    Object? lastMoveUci = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        fen: null == fen
            ? _value.fen
            : fen // ignore: cast_nullable_to_non_nullable
                  as String,
        turn: null == turn
            ? _value.turn
            : turn // ignore: cast_nullable_to_non_nullable
                  as PlayerColor,
        whitePlayer: freezed == whitePlayer
            ? _value.whitePlayer
            : whitePlayer // ignore: cast_nullable_to_non_nullable
                  as PlayerConfig?,
        blackPlayer: freezed == blackPlayer
            ? _value.blackPlayer
            : blackPlayer // ignore: cast_nullable_to_non_nullable
                  as PlayerConfig?,
        moveDelaySeconds: null == moveDelaySeconds
            ? _value.moveDelaySeconds
            : moveDelaySeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        currentMoveNumber: null == currentMoveNumber
            ? _value.currentMoveNumber
            : currentMoveNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        moveHistory: null == moveHistory
            ? _value._moveHistory
            : moveHistory // ignore: cast_nullable_to_non_nullable
                  as List<MoveData>,
        result: freezed == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as GameResult?,
        capturedByWhite: null == capturedByWhite
            ? _value._capturedByWhite
            : capturedByWhite // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        capturedByBlack: null == capturedByBlack
            ? _value._capturedByBlack
            : capturedByBlack // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        pgn: null == pgn
            ? _value.pgn
            : pgn // ignore: cast_nullable_to_non_nullable
                  as String,
        liveThinking: null == liveThinking
            ? _value.liveThinking
            : liveThinking // ignore: cast_nullable_to_non_nullable
                  as String,
        isThinking: null == isThinking
            ? _value.isThinking
            : isThinking // ignore: cast_nullable_to_non_nullable
                  as bool,
        thinkingPlayer: freezed == thinkingPlayer
            ? _value.thinkingPlayer
            : thinkingPlayer // ignore: cast_nullable_to_non_nullable
                  as PlayerColor?,
        countdownSeconds: freezed == countdownSeconds
            ? _value.countdownSeconds
            : countdownSeconds // ignore: cast_nullable_to_non_nullable
                  as double?,
        lastMoveUci: freezed == lastMoveUci
            ? _value.lastMoveUci
            : lastMoveUci // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    @JsonKey(name: 'game_id') required this.gameId,
    this.status = GameStatus.idle,
    this.fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    this.turn = PlayerColor.white,
    @JsonKey(name: 'white_player') this.whitePlayer,
    @JsonKey(name: 'black_player') this.blackPlayer,
    @JsonKey(name: 'move_delay_seconds') this.moveDelaySeconds = 10,
    @JsonKey(name: 'current_move_number') this.currentMoveNumber = 1,
    @JsonKey(name: 'move_history') final List<MoveData> moveHistory = const [],
    this.result,
    @JsonKey(name: 'captured_by_white')
    final List<String> capturedByWhite = const [],
    @JsonKey(name: 'captured_by_black')
    final List<String> capturedByBlack = const [],
    this.pgn = '',
    @JsonKey(name: 'live_thinking') this.liveThinking = '',
    @JsonKey(name: 'is_thinking') this.isThinking = false,
    @JsonKey(name: 'thinking_player') this.thinkingPlayer,
    @JsonKey(name: 'countdown_seconds') this.countdownSeconds,
    @JsonKey(name: 'last_move_uci') this.lastMoveUci,
  }) : _moveHistory = moveHistory,
       _capturedByWhite = capturedByWhite,
       _capturedByBlack = capturedByBlack;

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  @override
  @JsonKey(name: 'game_id')
  final String gameId;
  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final String fen;
  @override
  @JsonKey()
  final PlayerColor turn;
  @override
  @JsonKey(name: 'white_player')
  final PlayerConfig? whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  final PlayerConfig? blackPlayer;
  @override
  @JsonKey(name: 'move_delay_seconds')
  final int moveDelaySeconds;
  @override
  @JsonKey(name: 'current_move_number')
  final int currentMoveNumber;
  final List<MoveData> _moveHistory;
  @override
  @JsonKey(name: 'move_history')
  List<MoveData> get moveHistory {
    if (_moveHistory is EqualUnmodifiableListView) return _moveHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moveHistory);
  }

  @override
  final GameResult? result;
  final List<String> _capturedByWhite;
  @override
  @JsonKey(name: 'captured_by_white')
  List<String> get capturedByWhite {
    if (_capturedByWhite is EqualUnmodifiableListView) return _capturedByWhite;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capturedByWhite);
  }

  final List<String> _capturedByBlack;
  @override
  @JsonKey(name: 'captured_by_black')
  List<String> get capturedByBlack {
    if (_capturedByBlack is EqualUnmodifiableListView) return _capturedByBlack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capturedByBlack);
  }

  @override
  @JsonKey()
  final String pgn;
  @override
  @JsonKey(name: 'live_thinking')
  final String liveThinking;
  @override
  @JsonKey(name: 'is_thinking')
  final bool isThinking;
  @override
  @JsonKey(name: 'thinking_player')
  final PlayerColor? thinkingPlayer;
  @override
  @JsonKey(name: 'countdown_seconds')
  final double? countdownSeconds;
  @override
  @JsonKey(name: 'last_move_uci')
  final String? lastMoveUci;

  @override
  String toString() {
    return 'GameState(gameId: $gameId, status: $status, fen: $fen, turn: $turn, whitePlayer: $whitePlayer, blackPlayer: $blackPlayer, moveDelaySeconds: $moveDelaySeconds, currentMoveNumber: $currentMoveNumber, moveHistory: $moveHistory, result: $result, capturedByWhite: $capturedByWhite, capturedByBlack: $capturedByBlack, pgn: $pgn, liveThinking: $liveThinking, isThinking: $isThinking, thinkingPlayer: $thinkingPlayer, countdownSeconds: $countdownSeconds, lastMoveUci: $lastMoveUci)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fen, fen) || other.fen == fen) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.whitePlayer, whitePlayer) ||
                other.whitePlayer == whitePlayer) &&
            (identical(other.blackPlayer, blackPlayer) ||
                other.blackPlayer == blackPlayer) &&
            (identical(other.moveDelaySeconds, moveDelaySeconds) ||
                other.moveDelaySeconds == moveDelaySeconds) &&
            (identical(other.currentMoveNumber, currentMoveNumber) ||
                other.currentMoveNumber == currentMoveNumber) &&
            const DeepCollectionEquality().equals(
              other._moveHistory,
              _moveHistory,
            ) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(
              other._capturedByWhite,
              _capturedByWhite,
            ) &&
            const DeepCollectionEquality().equals(
              other._capturedByBlack,
              _capturedByBlack,
            ) &&
            (identical(other.pgn, pgn) || other.pgn == pgn) &&
            (identical(other.liveThinking, liveThinking) ||
                other.liveThinking == liveThinking) &&
            (identical(other.isThinking, isThinking) ||
                other.isThinking == isThinking) &&
            (identical(other.thinkingPlayer, thinkingPlayer) ||
                other.thinkingPlayer == thinkingPlayer) &&
            (identical(other.countdownSeconds, countdownSeconds) ||
                other.countdownSeconds == countdownSeconds) &&
            (identical(other.lastMoveUci, lastMoveUci) ||
                other.lastMoveUci == lastMoveUci));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameId,
    status,
    fen,
    turn,
    whitePlayer,
    blackPlayer,
    moveDelaySeconds,
    currentMoveNumber,
    const DeepCollectionEquality().hash(_moveHistory),
    result,
    const DeepCollectionEquality().hash(_capturedByWhite),
    const DeepCollectionEquality().hash(_capturedByBlack),
    pgn,
    liveThinking,
    isThinking,
    thinkingPlayer,
    countdownSeconds,
    lastMoveUci,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(this);
  }
}

abstract class _GameState implements GameState {
  const factory _GameState({
    @JsonKey(name: 'game_id') required final String gameId,
    final GameStatus status,
    final String fen,
    final PlayerColor turn,
    @JsonKey(name: 'white_player') final PlayerConfig? whitePlayer,
    @JsonKey(name: 'black_player') final PlayerConfig? blackPlayer,
    @JsonKey(name: 'move_delay_seconds') final int moveDelaySeconds,
    @JsonKey(name: 'current_move_number') final int currentMoveNumber,
    @JsonKey(name: 'move_history') final List<MoveData> moveHistory,
    final GameResult? result,
    @JsonKey(name: 'captured_by_white') final List<String> capturedByWhite,
    @JsonKey(name: 'captured_by_black') final List<String> capturedByBlack,
    final String pgn,
    @JsonKey(name: 'live_thinking') final String liveThinking,
    @JsonKey(name: 'is_thinking') final bool isThinking,
    @JsonKey(name: 'thinking_player') final PlayerColor? thinkingPlayer,
    @JsonKey(name: 'countdown_seconds') final double? countdownSeconds,
    @JsonKey(name: 'last_move_uci') final String? lastMoveUci,
  }) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  @JsonKey(name: 'game_id')
  String get gameId;
  @override
  GameStatus get status;
  @override
  String get fen;
  @override
  PlayerColor get turn;
  @override
  @JsonKey(name: 'white_player')
  PlayerConfig? get whitePlayer;
  @override
  @JsonKey(name: 'black_player')
  PlayerConfig? get blackPlayer;
  @override
  @JsonKey(name: 'move_delay_seconds')
  int get moveDelaySeconds;
  @override
  @JsonKey(name: 'current_move_number')
  int get currentMoveNumber;
  @override
  @JsonKey(name: 'move_history')
  List<MoveData> get moveHistory;
  @override
  GameResult? get result;
  @override
  @JsonKey(name: 'captured_by_white')
  List<String> get capturedByWhite;
  @override
  @JsonKey(name: 'captured_by_black')
  List<String> get capturedByBlack;
  @override
  String get pgn;
  @override
  @JsonKey(name: 'live_thinking')
  String get liveThinking;
  @override
  @JsonKey(name: 'is_thinking')
  bool get isThinking;
  @override
  @JsonKey(name: 'thinking_player')
  PlayerColor? get thinkingPlayer;
  @override
  @JsonKey(name: 'countdown_seconds')
  double? get countdownSeconds;
  @override
  @JsonKey(name: 'last_move_uci')
  String? get lastMoveUci;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
