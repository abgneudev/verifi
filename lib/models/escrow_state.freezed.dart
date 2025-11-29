// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escrow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EscrowState _$EscrowStateFromJson(Map<String, dynamic> json) {
  return _EscrowState.fromJson(json);
}

/// @nodoc
mixin _$EscrowState {
  double get amount => throw _privateConstructorUsedError;
  EscrowStatus get status => throw _privateConstructorUsedError;

  /// Serializes this EscrowState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EscrowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EscrowStateCopyWith<EscrowState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscrowStateCopyWith<$Res> {
  factory $EscrowStateCopyWith(
    EscrowState value,
    $Res Function(EscrowState) then,
  ) = _$EscrowStateCopyWithImpl<$Res, EscrowState>;
  @useResult
  $Res call({double amount, EscrowStatus status});
}

/// @nodoc
class _$EscrowStateCopyWithImpl<$Res, $Val extends EscrowState>
    implements $EscrowStateCopyWith<$Res> {
  _$EscrowStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EscrowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? status = null}) {
    return _then(
      _value.copyWith(
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EscrowStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EscrowStateImplCopyWith<$Res>
    implements $EscrowStateCopyWith<$Res> {
  factory _$$EscrowStateImplCopyWith(
    _$EscrowStateImpl value,
    $Res Function(_$EscrowStateImpl) then,
  ) = __$$EscrowStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double amount, EscrowStatus status});
}

/// @nodoc
class __$$EscrowStateImplCopyWithImpl<$Res>
    extends _$EscrowStateCopyWithImpl<$Res, _$EscrowStateImpl>
    implements _$$EscrowStateImplCopyWith<$Res> {
  __$$EscrowStateImplCopyWithImpl(
    _$EscrowStateImpl _value,
    $Res Function(_$EscrowStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EscrowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? status = null}) {
    return _then(
      _$EscrowStateImpl(
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EscrowStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EscrowStateImpl implements _EscrowState {
  const _$EscrowStateImpl({this.amount = 0.0, this.status = EscrowStatus.idle});

  factory _$EscrowStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EscrowStateImplFromJson(json);

  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final EscrowStatus status;

  @override
  String toString() {
    return 'EscrowState(amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscrowStateImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, status);

  /// Create a copy of EscrowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EscrowStateImplCopyWith<_$EscrowStateImpl> get copyWith =>
      __$$EscrowStateImplCopyWithImpl<_$EscrowStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EscrowStateImplToJson(this);
  }
}

abstract class _EscrowState implements EscrowState {
  const factory _EscrowState({final double amount, final EscrowStatus status}) =
      _$EscrowStateImpl;

  factory _EscrowState.fromJson(Map<String, dynamic> json) =
      _$EscrowStateImpl.fromJson;

  @override
  double get amount;
  @override
  EscrowStatus get status;

  /// Create a copy of EscrowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EscrowStateImplCopyWith<_$EscrowStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
