// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerConfig _$PlayerConfigFromJson(Map<String, dynamic> json) {
  return _PlayerConfig.fromJson(json);
}

/// @nodoc
mixin _$PlayerConfig {
  String get name => throw _privateConstructorUsedError;
  ProviderType get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_id')
  String get modelId => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_prompt')
  String? get systemPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'thinking_mode')
  String get thinkingMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_custom')
  bool get isCustom => throw _privateConstructorUsedError;
  PlayerColor get color => throw _privateConstructorUsedError;

  /// Serializes this PlayerConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerConfigCopyWith<PlayerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerConfigCopyWith<$Res> {
  factory $PlayerConfigCopyWith(
    PlayerConfig value,
    $Res Function(PlayerConfig) then,
  ) = _$PlayerConfigCopyWithImpl<$Res, PlayerConfig>;
  @useResult
  $Res call({
    String name,
    ProviderType provider,
    @JsonKey(name: 'model_id') String modelId,
    double temperature,
    @JsonKey(name: 'system_prompt') String? systemPrompt,
    @JsonKey(name: 'thinking_mode') String thinkingMode,
    @JsonKey(name: 'is_custom') bool isCustom,
    PlayerColor color,
  });
}

/// @nodoc
class _$PlayerConfigCopyWithImpl<$Res, $Val extends PlayerConfig>
    implements $PlayerConfigCopyWith<$Res> {
  _$PlayerConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? provider = null,
    Object? modelId = null,
    Object? temperature = null,
    Object? systemPrompt = freezed,
    Object? thinkingMode = null,
    Object? isCustom = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as ProviderType,
            modelId: null == modelId
                ? _value.modelId
                : modelId // ignore: cast_nullable_to_non_nullable
                      as String,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            systemPrompt: freezed == systemPrompt
                ? _value.systemPrompt
                : systemPrompt // ignore: cast_nullable_to_non_nullable
                      as String?,
            thinkingMode: null == thinkingMode
                ? _value.thinkingMode
                : thinkingMode // ignore: cast_nullable_to_non_nullable
                      as String,
            isCustom: null == isCustom
                ? _value.isCustom
                : isCustom // ignore: cast_nullable_to_non_nullable
                      as bool,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as PlayerColor,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerConfigImplCopyWith<$Res>
    implements $PlayerConfigCopyWith<$Res> {
  factory _$$PlayerConfigImplCopyWith(
    _$PlayerConfigImpl value,
    $Res Function(_$PlayerConfigImpl) then,
  ) = __$$PlayerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    ProviderType provider,
    @JsonKey(name: 'model_id') String modelId,
    double temperature,
    @JsonKey(name: 'system_prompt') String? systemPrompt,
    @JsonKey(name: 'thinking_mode') String thinkingMode,
    @JsonKey(name: 'is_custom') bool isCustom,
    PlayerColor color,
  });
}

/// @nodoc
class __$$PlayerConfigImplCopyWithImpl<$Res>
    extends _$PlayerConfigCopyWithImpl<$Res, _$PlayerConfigImpl>
    implements _$$PlayerConfigImplCopyWith<$Res> {
  __$$PlayerConfigImplCopyWithImpl(
    _$PlayerConfigImpl _value,
    $Res Function(_$PlayerConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? provider = null,
    Object? modelId = null,
    Object? temperature = null,
    Object? systemPrompt = freezed,
    Object? thinkingMode = null,
    Object? isCustom = null,
    Object? color = null,
  }) {
    return _then(
      _$PlayerConfigImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as ProviderType,
        modelId: null == modelId
            ? _value.modelId
            : modelId // ignore: cast_nullable_to_non_nullable
                  as String,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        systemPrompt: freezed == systemPrompt
            ? _value.systemPrompt
            : systemPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        thinkingMode: null == thinkingMode
            ? _value.thinkingMode
            : thinkingMode // ignore: cast_nullable_to_non_nullable
                  as String,
        isCustom: null == isCustom
            ? _value.isCustom
            : isCustom // ignore: cast_nullable_to_non_nullable
                  as bool,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as PlayerColor,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerConfigImpl implements _PlayerConfig {
  const _$PlayerConfigImpl({
    required this.name,
    required this.provider,
    @JsonKey(name: 'model_id') required this.modelId,
    this.temperature = 0.7,
    @JsonKey(name: 'system_prompt') this.systemPrompt,
    @JsonKey(name: 'thinking_mode') this.thinkingMode = 'medium',
    @JsonKey(name: 'is_custom') this.isCustom = false,
    this.color = PlayerColor.white,
  });

  factory _$PlayerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerConfigImplFromJson(json);

  @override
  final String name;
  @override
  final ProviderType provider;
  @override
  @JsonKey(name: 'model_id')
  final String modelId;
  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey(name: 'system_prompt')
  final String? systemPrompt;
  @override
  @JsonKey(name: 'thinking_mode')
  final String thinkingMode;
  @override
  @JsonKey(name: 'is_custom')
  final bool isCustom;
  @override
  @JsonKey()
  final PlayerColor color;

  @override
  String toString() {
    return 'PlayerConfig(name: $name, provider: $provider, modelId: $modelId, temperature: $temperature, systemPrompt: $systemPrompt, thinkingMode: $thinkingMode, isCustom: $isCustom, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerConfigImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.thinkingMode, thinkingMode) ||
                other.thinkingMode == thinkingMode) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    provider,
    modelId,
    temperature,
    systemPrompt,
    thinkingMode,
    isCustom,
    color,
  );

  /// Create a copy of PlayerConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerConfigImplCopyWith<_$PlayerConfigImpl> get copyWith =>
      __$$PlayerConfigImplCopyWithImpl<_$PlayerConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerConfigImplToJson(this);
  }
}

abstract class _PlayerConfig implements PlayerConfig {
  const factory _PlayerConfig({
    required final String name,
    required final ProviderType provider,
    @JsonKey(name: 'model_id') required final String modelId,
    final double temperature,
    @JsonKey(name: 'system_prompt') final String? systemPrompt,
    @JsonKey(name: 'thinking_mode') final String thinkingMode,
    @JsonKey(name: 'is_custom') final bool isCustom,
    final PlayerColor color,
  }) = _$PlayerConfigImpl;

  factory _PlayerConfig.fromJson(Map<String, dynamic> json) =
      _$PlayerConfigImpl.fromJson;

  @override
  String get name;
  @override
  ProviderType get provider;
  @override
  @JsonKey(name: 'model_id')
  String get modelId;
  @override
  double get temperature;
  @override
  @JsonKey(name: 'system_prompt')
  String? get systemPrompt;
  @override
  @JsonKey(name: 'thinking_mode')
  String get thinkingMode;
  @override
  @JsonKey(name: 'is_custom')
  bool get isCustom;
  @override
  PlayerColor get color;

  /// Create a copy of PlayerConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerConfigImplCopyWith<_$PlayerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
