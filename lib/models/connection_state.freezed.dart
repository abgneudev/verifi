// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppConnectionState _$AppConnectionStateFromJson(Map<String, dynamic> json) {
  return _AppConnectionState.fromJson(json);
}

/// @nodoc
mixin _$AppConnectionState {
  ConnectionStatus get status => throw _privateConstructorUsedError;
  String? get connectedEndpointId => throw _privateConstructorUsedError;
  String get logText => throw _privateConstructorUsedError;
  bool get isAdvertiser => throw _privateConstructorUsedError;

  /// Serializes this AppConnectionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConnectionStateCopyWith<AppConnectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConnectionStateCopyWith<$Res> {
  factory $AppConnectionStateCopyWith(
    AppConnectionState value,
    $Res Function(AppConnectionState) then,
  ) = _$AppConnectionStateCopyWithImpl<$Res, AppConnectionState>;
  @useResult
  $Res call({
    ConnectionStatus status,
    String? connectedEndpointId,
    String logText,
    bool isAdvertiser,
  });
}

/// @nodoc
class _$AppConnectionStateCopyWithImpl<$Res, $Val extends AppConnectionState>
    implements $AppConnectionStateCopyWith<$Res> {
  _$AppConnectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? connectedEndpointId = freezed,
    Object? logText = null,
    Object? isAdvertiser = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            connectedEndpointId: freezed == connectedEndpointId
                ? _value.connectedEndpointId
                : connectedEndpointId // ignore: cast_nullable_to_non_nullable
                      as String?,
            logText: null == logText
                ? _value.logText
                : logText // ignore: cast_nullable_to_non_nullable
                      as String,
            isAdvertiser: null == isAdvertiser
                ? _value.isAdvertiser
                : isAdvertiser // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppConnectionStateImplCopyWith<$Res>
    implements $AppConnectionStateCopyWith<$Res> {
  factory _$$AppConnectionStateImplCopyWith(
    _$AppConnectionStateImpl value,
    $Res Function(_$AppConnectionStateImpl) then,
  ) = __$$AppConnectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ConnectionStatus status,
    String? connectedEndpointId,
    String logText,
    bool isAdvertiser,
  });
}

/// @nodoc
class __$$AppConnectionStateImplCopyWithImpl<$Res>
    extends _$AppConnectionStateCopyWithImpl<$Res, _$AppConnectionStateImpl>
    implements _$$AppConnectionStateImplCopyWith<$Res> {
  __$$AppConnectionStateImplCopyWithImpl(
    _$AppConnectionStateImpl _value,
    $Res Function(_$AppConnectionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? connectedEndpointId = freezed,
    Object? logText = null,
    Object? isAdvertiser = null,
  }) {
    return _then(
      _$AppConnectionStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        connectedEndpointId: freezed == connectedEndpointId
            ? _value.connectedEndpointId
            : connectedEndpointId // ignore: cast_nullable_to_non_nullable
                  as String?,
        logText: null == logText
            ? _value.logText
            : logText // ignore: cast_nullable_to_non_nullable
                  as String,
        isAdvertiser: null == isAdvertiser
            ? _value.isAdvertiser
            : isAdvertiser // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConnectionStateImpl implements _AppConnectionState {
  const _$AppConnectionStateImpl({
    this.status = ConnectionStatus.disconnected,
    this.connectedEndpointId,
    this.logText = 'Initializing...',
    this.isAdvertiser = false,
  });

  factory _$AppConnectionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConnectionStateImplFromJson(json);

  @override
  @JsonKey()
  final ConnectionStatus status;
  @override
  final String? connectedEndpointId;
  @override
  @JsonKey()
  final String logText;
  @override
  @JsonKey()
  final bool isAdvertiser;

  @override
  String toString() {
    return 'AppConnectionState(status: $status, connectedEndpointId: $connectedEndpointId, logText: $logText, isAdvertiser: $isAdvertiser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConnectionStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.connectedEndpointId, connectedEndpointId) ||
                other.connectedEndpointId == connectedEndpointId) &&
            (identical(other.logText, logText) || other.logText == logText) &&
            (identical(other.isAdvertiser, isAdvertiser) ||
                other.isAdvertiser == isAdvertiser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    connectedEndpointId,
    logText,
    isAdvertiser,
  );

  /// Create a copy of AppConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConnectionStateImplCopyWith<_$AppConnectionStateImpl> get copyWith =>
      __$$AppConnectionStateImplCopyWithImpl<_$AppConnectionStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConnectionStateImplToJson(this);
  }
}

abstract class _AppConnectionState implements AppConnectionState {
  const factory _AppConnectionState({
    final ConnectionStatus status,
    final String? connectedEndpointId,
    final String logText,
    final bool isAdvertiser,
  }) = _$AppConnectionStateImpl;

  factory _AppConnectionState.fromJson(Map<String, dynamic> json) =
      _$AppConnectionStateImpl.fromJson;

  @override
  ConnectionStatus get status;
  @override
  String? get connectedEndpointId;
  @override
  String get logText;
  @override
  bool get isAdvertiser;

  /// Create a copy of AppConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConnectionStateImplCopyWith<_$AppConnectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
