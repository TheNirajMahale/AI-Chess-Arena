// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiKeysConfig _$ApiKeysConfigFromJson(Map<String, dynamic> json) {
  return _ApiKeysConfig.fromJson(json);
}

/// @nodoc
mixin _$ApiKeysConfig {
  @JsonKey(name: 'deepseek_key')
  String get deepseekKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'openai_key')
  String get openaiKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'gemini_key')
  String get geminiKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'anthropic_key')
  String get anthropicKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'groq_key')
  String get groqKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'openrouter_key')
  String get openrouterKey => throw _privateConstructorUsedError;

  /// Serializes this ApiKeysConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiKeysConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiKeysConfigCopyWith<ApiKeysConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiKeysConfigCopyWith<$Res> {
  factory $ApiKeysConfigCopyWith(
    ApiKeysConfig value,
    $Res Function(ApiKeysConfig) then,
  ) = _$ApiKeysConfigCopyWithImpl<$Res, ApiKeysConfig>;
  @useResult
  $Res call({
    @JsonKey(name: 'deepseek_key') String deepseekKey,
    @JsonKey(name: 'openai_key') String openaiKey,
    @JsonKey(name: 'gemini_key') String geminiKey,
    @JsonKey(name: 'anthropic_key') String anthropicKey,
    @JsonKey(name: 'groq_key') String groqKey,
    @JsonKey(name: 'openrouter_key') String openrouterKey,
  });
}

/// @nodoc
class _$ApiKeysConfigCopyWithImpl<$Res, $Val extends ApiKeysConfig>
    implements $ApiKeysConfigCopyWith<$Res> {
  _$ApiKeysConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiKeysConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deepseekKey = null,
    Object? openaiKey = null,
    Object? geminiKey = null,
    Object? anthropicKey = null,
    Object? groqKey = null,
    Object? openrouterKey = null,
  }) {
    return _then(
      _value.copyWith(
            deepseekKey: null == deepseekKey
                ? _value.deepseekKey
                : deepseekKey // ignore: cast_nullable_to_non_nullable
                      as String,
            openaiKey: null == openaiKey
                ? _value.openaiKey
                : openaiKey // ignore: cast_nullable_to_non_nullable
                      as String,
            geminiKey: null == geminiKey
                ? _value.geminiKey
                : geminiKey // ignore: cast_nullable_to_non_nullable
                      as String,
            anthropicKey: null == anthropicKey
                ? _value.anthropicKey
                : anthropicKey // ignore: cast_nullable_to_non_nullable
                      as String,
            groqKey: null == groqKey
                ? _value.groqKey
                : groqKey // ignore: cast_nullable_to_non_nullable
                      as String,
            openrouterKey: null == openrouterKey
                ? _value.openrouterKey
                : openrouterKey // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiKeysConfigImplCopyWith<$Res>
    implements $ApiKeysConfigCopyWith<$Res> {
  factory _$$ApiKeysConfigImplCopyWith(
    _$ApiKeysConfigImpl value,
    $Res Function(_$ApiKeysConfigImpl) then,
  ) = __$$ApiKeysConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'deepseek_key') String deepseekKey,
    @JsonKey(name: 'openai_key') String openaiKey,
    @JsonKey(name: 'gemini_key') String geminiKey,
    @JsonKey(name: 'anthropic_key') String anthropicKey,
    @JsonKey(name: 'groq_key') String groqKey,
    @JsonKey(name: 'openrouter_key') String openrouterKey,
  });
}

/// @nodoc
class __$$ApiKeysConfigImplCopyWithImpl<$Res>
    extends _$ApiKeysConfigCopyWithImpl<$Res, _$ApiKeysConfigImpl>
    implements _$$ApiKeysConfigImplCopyWith<$Res> {
  __$$ApiKeysConfigImplCopyWithImpl(
    _$ApiKeysConfigImpl _value,
    $Res Function(_$ApiKeysConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiKeysConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deepseekKey = null,
    Object? openaiKey = null,
    Object? geminiKey = null,
    Object? anthropicKey = null,
    Object? groqKey = null,
    Object? openrouterKey = null,
  }) {
    return _then(
      _$ApiKeysConfigImpl(
        deepseekKey: null == deepseekKey
            ? _value.deepseekKey
            : deepseekKey // ignore: cast_nullable_to_non_nullable
                  as String,
        openaiKey: null == openaiKey
            ? _value.openaiKey
            : openaiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        geminiKey: null == geminiKey
            ? _value.geminiKey
            : geminiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        anthropicKey: null == anthropicKey
            ? _value.anthropicKey
            : anthropicKey // ignore: cast_nullable_to_non_nullable
                  as String,
        groqKey: null == groqKey
            ? _value.groqKey
            : groqKey // ignore: cast_nullable_to_non_nullable
                  as String,
        openrouterKey: null == openrouterKey
            ? _value.openrouterKey
            : openrouterKey // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiKeysConfigImpl implements _ApiKeysConfig {
  const _$ApiKeysConfigImpl({
    @JsonKey(name: 'deepseek_key') this.deepseekKey = '',
    @JsonKey(name: 'openai_key') this.openaiKey = '',
    @JsonKey(name: 'gemini_key') this.geminiKey = '',
    @JsonKey(name: 'anthropic_key') this.anthropicKey = '',
    @JsonKey(name: 'groq_key') this.groqKey = '',
    @JsonKey(name: 'openrouter_key') this.openrouterKey = '',
  });

  factory _$ApiKeysConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiKeysConfigImplFromJson(json);

  @override
  @JsonKey(name: 'deepseek_key')
  final String deepseekKey;
  @override
  @JsonKey(name: 'openai_key')
  final String openaiKey;
  @override
  @JsonKey(name: 'gemini_key')
  final String geminiKey;
  @override
  @JsonKey(name: 'anthropic_key')
  final String anthropicKey;
  @override
  @JsonKey(name: 'groq_key')
  final String groqKey;
  @override
  @JsonKey(name: 'openrouter_key')
  final String openrouterKey;

  @override
  String toString() {
    return 'ApiKeysConfig(deepseekKey: $deepseekKey, openaiKey: $openaiKey, geminiKey: $geminiKey, anthropicKey: $anthropicKey, groqKey: $groqKey, openrouterKey: $openrouterKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiKeysConfigImpl &&
            (identical(other.deepseekKey, deepseekKey) ||
                other.deepseekKey == deepseekKey) &&
            (identical(other.openaiKey, openaiKey) ||
                other.openaiKey == openaiKey) &&
            (identical(other.geminiKey, geminiKey) ||
                other.geminiKey == geminiKey) &&
            (identical(other.anthropicKey, anthropicKey) ||
                other.anthropicKey == anthropicKey) &&
            (identical(other.groqKey, groqKey) || other.groqKey == groqKey) &&
            (identical(other.openrouterKey, openrouterKey) ||
                other.openrouterKey == openrouterKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deepseekKey,
    openaiKey,
    geminiKey,
    anthropicKey,
    groqKey,
    openrouterKey,
  );

  /// Create a copy of ApiKeysConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiKeysConfigImplCopyWith<_$ApiKeysConfigImpl> get copyWith =>
      __$$ApiKeysConfigImplCopyWithImpl<_$ApiKeysConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiKeysConfigImplToJson(this);
  }
}

abstract class _ApiKeysConfig implements ApiKeysConfig {
  const factory _ApiKeysConfig({
    @JsonKey(name: 'deepseek_key') final String deepseekKey,
    @JsonKey(name: 'openai_key') final String openaiKey,
    @JsonKey(name: 'gemini_key') final String geminiKey,
    @JsonKey(name: 'anthropic_key') final String anthropicKey,
    @JsonKey(name: 'groq_key') final String groqKey,
    @JsonKey(name: 'openrouter_key') final String openrouterKey,
  }) = _$ApiKeysConfigImpl;

  factory _ApiKeysConfig.fromJson(Map<String, dynamic> json) =
      _$ApiKeysConfigImpl.fromJson;

  @override
  @JsonKey(name: 'deepseek_key')
  String get deepseekKey;
  @override
  @JsonKey(name: 'openai_key')
  String get openaiKey;
  @override
  @JsonKey(name: 'gemini_key')
  String get geminiKey;
  @override
  @JsonKey(name: 'anthropic_key')
  String get anthropicKey;
  @override
  @JsonKey(name: 'groq_key')
  String get groqKey;
  @override
  @JsonKey(name: 'openrouter_key')
  String get openrouterKey;

  /// Create a copy of ApiKeysConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiKeysConfigImplCopyWith<_$ApiKeysConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModelOption _$ModelOptionFromJson(Map<String, dynamic> json) {
  return _ModelOption.fromJson(json);
}

/// @nodoc
mixin _$ModelOption {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ProviderType get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'supports_thinking')
  bool get supportsThinking => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_configured')
  bool get isConfigured => throw _privateConstructorUsedError;

  /// Serializes this ModelOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelOptionCopyWith<ModelOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelOptionCopyWith<$Res> {
  factory $ModelOptionCopyWith(
    ModelOption value,
    $Res Function(ModelOption) then,
  ) = _$ModelOptionCopyWithImpl<$Res, ModelOption>;
  @useResult
  $Res call({
    String id,
    String name,
    ProviderType provider,
    @JsonKey(name: 'supports_thinking') bool supportsThinking,
    String description,
    @JsonKey(name: 'is_configured') bool isConfigured,
  });
}

/// @nodoc
class _$ModelOptionCopyWithImpl<$Res, $Val extends ModelOption>
    implements $ModelOptionCopyWith<$Res> {
  _$ModelOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? supportsThinking = null,
    Object? description = null,
    Object? isConfigured = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as ProviderType,
            supportsThinking: null == supportsThinking
                ? _value.supportsThinking
                : supportsThinking // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            isConfigured: null == isConfigured
                ? _value.isConfigured
                : isConfigured // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelOptionImplCopyWith<$Res>
    implements $ModelOptionCopyWith<$Res> {
  factory _$$ModelOptionImplCopyWith(
    _$ModelOptionImpl value,
    $Res Function(_$ModelOptionImpl) then,
  ) = __$$ModelOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    ProviderType provider,
    @JsonKey(name: 'supports_thinking') bool supportsThinking,
    String description,
    @JsonKey(name: 'is_configured') bool isConfigured,
  });
}

/// @nodoc
class __$$ModelOptionImplCopyWithImpl<$Res>
    extends _$ModelOptionCopyWithImpl<$Res, _$ModelOptionImpl>
    implements _$$ModelOptionImplCopyWith<$Res> {
  __$$ModelOptionImplCopyWithImpl(
    _$ModelOptionImpl _value,
    $Res Function(_$ModelOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? supportsThinking = null,
    Object? description = null,
    Object? isConfigured = null,
  }) {
    return _then(
      _$ModelOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as ProviderType,
        supportsThinking: null == supportsThinking
            ? _value.supportsThinking
            : supportsThinking // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        isConfigured: null == isConfigured
            ? _value.isConfigured
            : isConfigured // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelOptionImpl implements _ModelOption {
  const _$ModelOptionImpl({
    required this.id,
    required this.name,
    required this.provider,
    @JsonKey(name: 'supports_thinking') this.supportsThinking = false,
    this.description = '',
    @JsonKey(name: 'is_configured') this.isConfigured = false,
  });

  factory _$ModelOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final ProviderType provider;
  @override
  @JsonKey(name: 'supports_thinking')
  final bool supportsThinking;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'is_configured')
  final bool isConfigured;

  @override
  String toString() {
    return 'ModelOption(id: $id, name: $name, provider: $provider, supportsThinking: $supportsThinking, description: $description, isConfigured: $isConfigured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.supportsThinking, supportsThinking) ||
                other.supportsThinking == supportsThinking) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isConfigured, isConfigured) ||
                other.isConfigured == isConfigured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    provider,
    supportsThinking,
    description,
    isConfigured,
  );

  /// Create a copy of ModelOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelOptionImplCopyWith<_$ModelOptionImpl> get copyWith =>
      __$$ModelOptionImplCopyWithImpl<_$ModelOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelOptionImplToJson(this);
  }
}

abstract class _ModelOption implements ModelOption {
  const factory _ModelOption({
    required final String id,
    required final String name,
    required final ProviderType provider,
    @JsonKey(name: 'supports_thinking') final bool supportsThinking,
    final String description,
    @JsonKey(name: 'is_configured') final bool isConfigured,
  }) = _$ModelOptionImpl;

  factory _ModelOption.fromJson(Map<String, dynamic> json) =
      _$ModelOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  ProviderType get provider;
  @override
  @JsonKey(name: 'supports_thinking')
  bool get supportsThinking;
  @override
  String get description;
  @override
  @JsonKey(name: 'is_configured')
  bool get isConfigured;

  /// Create a copy of ModelOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelOptionImplCopyWith<_$ModelOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SettingsPayload _$SettingsPayloadFromJson(Map<String, dynamic> json) {
  return _SettingsPayload.fromJson(json);
}

/// @nodoc
mixin _$SettingsPayload {
  ApiKeysConfig get keys => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_delay')
  int get defaultDelay => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_models')
  List<ModelOption> get models => throw _privateConstructorUsedError;
  @JsonKey(name: 'include_ascii_board')
  bool get includeAsciiBoard => throw _privateConstructorUsedError;
  @JsonKey(name: 'history_context_limit')
  int get historyContextLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_output_tokens')
  int get maxOutputTokens => throw _privateConstructorUsedError;

  /// Serializes this SettingsPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsPayloadCopyWith<SettingsPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsPayloadCopyWith<$Res> {
  factory $SettingsPayloadCopyWith(
    SettingsPayload value,
    $Res Function(SettingsPayload) then,
  ) = _$SettingsPayloadCopyWithImpl<$Res, SettingsPayload>;
  @useResult
  $Res call({
    ApiKeysConfig keys,
    @JsonKey(name: 'default_delay') int defaultDelay,
    @JsonKey(name: 'custom_models') List<ModelOption> models,
    @JsonKey(name: 'include_ascii_board') bool includeAsciiBoard,
    @JsonKey(name: 'history_context_limit') int historyContextLimit,
    @JsonKey(name: 'max_output_tokens') int maxOutputTokens,
  });

  $ApiKeysConfigCopyWith<$Res> get keys;
}

/// @nodoc
class _$SettingsPayloadCopyWithImpl<$Res, $Val extends SettingsPayload>
    implements $SettingsPayloadCopyWith<$Res> {
  _$SettingsPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keys = null,
    Object? defaultDelay = null,
    Object? models = null,
    Object? includeAsciiBoard = null,
    Object? historyContextLimit = null,
    Object? maxOutputTokens = null,
  }) {
    return _then(
      _value.copyWith(
            keys: null == keys
                ? _value.keys
                : keys // ignore: cast_nullable_to_non_nullable
                      as ApiKeysConfig,
            defaultDelay: null == defaultDelay
                ? _value.defaultDelay
                : defaultDelay // ignore: cast_nullable_to_non_nullable
                      as int,
            models: null == models
                ? _value.models
                : models // ignore: cast_nullable_to_non_nullable
                      as List<ModelOption>,
            includeAsciiBoard: null == includeAsciiBoard
                ? _value.includeAsciiBoard
                : includeAsciiBoard // ignore: cast_nullable_to_non_nullable
                      as bool,
            historyContextLimit: null == historyContextLimit
                ? _value.historyContextLimit
                : historyContextLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            maxOutputTokens: null == maxOutputTokens
                ? _value.maxOutputTokens
                : maxOutputTokens // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiKeysConfigCopyWith<$Res> get keys {
    return $ApiKeysConfigCopyWith<$Res>(_value.keys, (value) {
      return _then(_value.copyWith(keys: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsPayloadImplCopyWith<$Res>
    implements $SettingsPayloadCopyWith<$Res> {
  factory _$$SettingsPayloadImplCopyWith(
    _$SettingsPayloadImpl value,
    $Res Function(_$SettingsPayloadImpl) then,
  ) = __$$SettingsPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ApiKeysConfig keys,
    @JsonKey(name: 'default_delay') int defaultDelay,
    @JsonKey(name: 'custom_models') List<ModelOption> models,
    @JsonKey(name: 'include_ascii_board') bool includeAsciiBoard,
    @JsonKey(name: 'history_context_limit') int historyContextLimit,
    @JsonKey(name: 'max_output_tokens') int maxOutputTokens,
  });

  @override
  $ApiKeysConfigCopyWith<$Res> get keys;
}

/// @nodoc
class __$$SettingsPayloadImplCopyWithImpl<$Res>
    extends _$SettingsPayloadCopyWithImpl<$Res, _$SettingsPayloadImpl>
    implements _$$SettingsPayloadImplCopyWith<$Res> {
  __$$SettingsPayloadImplCopyWithImpl(
    _$SettingsPayloadImpl _value,
    $Res Function(_$SettingsPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keys = null,
    Object? defaultDelay = null,
    Object? models = null,
    Object? includeAsciiBoard = null,
    Object? historyContextLimit = null,
    Object? maxOutputTokens = null,
  }) {
    return _then(
      _$SettingsPayloadImpl(
        keys: null == keys
            ? _value.keys
            : keys // ignore: cast_nullable_to_non_nullable
                  as ApiKeysConfig,
        defaultDelay: null == defaultDelay
            ? _value.defaultDelay
            : defaultDelay // ignore: cast_nullable_to_non_nullable
                  as int,
        models: null == models
            ? _value._models
            : models // ignore: cast_nullable_to_non_nullable
                  as List<ModelOption>,
        includeAsciiBoard: null == includeAsciiBoard
            ? _value.includeAsciiBoard
            : includeAsciiBoard // ignore: cast_nullable_to_non_nullable
                  as bool,
        historyContextLimit: null == historyContextLimit
            ? _value.historyContextLimit
            : historyContextLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        maxOutputTokens: null == maxOutputTokens
            ? _value.maxOutputTokens
            : maxOutputTokens // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SettingsPayloadImpl implements _SettingsPayload {
  const _$SettingsPayloadImpl({
    this.keys = const ApiKeysConfig(),
    @JsonKey(name: 'default_delay') this.defaultDelay = 10,
    @JsonKey(name: 'custom_models') final List<ModelOption> models = const [],
    @JsonKey(name: 'include_ascii_board') this.includeAsciiBoard = true,
    @JsonKey(name: 'history_context_limit') this.historyContextLimit = 0,
    @JsonKey(name: 'max_output_tokens') this.maxOutputTokens = 500,
  }) : _models = models;

  factory _$SettingsPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsPayloadImplFromJson(json);

  @override
  @JsonKey()
  final ApiKeysConfig keys;
  @override
  @JsonKey(name: 'default_delay')
  final int defaultDelay;
  final List<ModelOption> _models;
  @override
  @JsonKey(name: 'custom_models')
  List<ModelOption> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  @JsonKey(name: 'include_ascii_board')
  final bool includeAsciiBoard;
  @override
  @JsonKey(name: 'history_context_limit')
  final int historyContextLimit;
  @override
  @JsonKey(name: 'max_output_tokens')
  final int maxOutputTokens;

  @override
  String toString() {
    return 'SettingsPayload(keys: $keys, defaultDelay: $defaultDelay, models: $models, includeAsciiBoard: $includeAsciiBoard, historyContextLimit: $historyContextLimit, maxOutputTokens: $maxOutputTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsPayloadImpl &&
            (identical(other.keys, keys) || other.keys == keys) &&
            (identical(other.defaultDelay, defaultDelay) ||
                other.defaultDelay == defaultDelay) &&
            const DeepCollectionEquality().equals(other._models, _models) &&
            (identical(other.includeAsciiBoard, includeAsciiBoard) ||
                other.includeAsciiBoard == includeAsciiBoard) &&
            (identical(other.historyContextLimit, historyContextLimit) ||
                other.historyContextLimit == historyContextLimit) &&
            (identical(other.maxOutputTokens, maxOutputTokens) ||
                other.maxOutputTokens == maxOutputTokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    keys,
    defaultDelay,
    const DeepCollectionEquality().hash(_models),
    includeAsciiBoard,
    historyContextLimit,
    maxOutputTokens,
  );

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsPayloadImplCopyWith<_$SettingsPayloadImpl> get copyWith =>
      __$$SettingsPayloadImplCopyWithImpl<_$SettingsPayloadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsPayloadImplToJson(this);
  }
}

abstract class _SettingsPayload implements SettingsPayload {
  const factory _SettingsPayload({
    final ApiKeysConfig keys,
    @JsonKey(name: 'default_delay') final int defaultDelay,
    @JsonKey(name: 'custom_models') final List<ModelOption> models,
    @JsonKey(name: 'include_ascii_board') final bool includeAsciiBoard,
    @JsonKey(name: 'history_context_limit') final int historyContextLimit,
    @JsonKey(name: 'max_output_tokens') final int maxOutputTokens,
  }) = _$SettingsPayloadImpl;

  factory _SettingsPayload.fromJson(Map<String, dynamic> json) =
      _$SettingsPayloadImpl.fromJson;

  @override
  ApiKeysConfig get keys;
  @override
  @JsonKey(name: 'default_delay')
  int get defaultDelay;
  @override
  @JsonKey(name: 'custom_models')
  List<ModelOption> get models;
  @override
  @JsonKey(name: 'include_ascii_board')
  bool get includeAsciiBoard;
  @override
  @JsonKey(name: 'history_context_limit')
  int get historyContextLimit;
  @override
  @JsonKey(name: 'max_output_tokens')
  int get maxOutputTokens;

  /// Create a copy of SettingsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsPayloadImplCopyWith<_$SettingsPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
