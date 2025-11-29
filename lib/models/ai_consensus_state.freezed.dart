// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_consensus_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIConsensusState _$AIConsensusStateFromJson(Map<String, dynamic> json) {
  return _AIConsensusState.fromJson(json);
}

/// @nodoc
mixin _$AIConsensusState {
  bool get myAIApproved => throw _privateConstructorUsedError;
  bool get peerAIApproved => throw _privateConstructorUsedError;
  String? get myProofImagePath => throw _privateConstructorUsedError;
  String? get peerProofImagePath => throw _privateConstructorUsedError;
  String get myProofText => throw _privateConstructorUsedError;

  /// Serializes this AIConsensusState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIConsensusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIConsensusStateCopyWith<AIConsensusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIConsensusStateCopyWith<$Res> {
  factory $AIConsensusStateCopyWith(
    AIConsensusState value,
    $Res Function(AIConsensusState) then,
  ) = _$AIConsensusStateCopyWithImpl<$Res, AIConsensusState>;
  @useResult
  $Res call({
    bool myAIApproved,
    bool peerAIApproved,
    String? myProofImagePath,
    String? peerProofImagePath,
    String myProofText,
  });
}

/// @nodoc
class _$AIConsensusStateCopyWithImpl<$Res, $Val extends AIConsensusState>
    implements $AIConsensusStateCopyWith<$Res> {
  _$AIConsensusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIConsensusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAIApproved = null,
    Object? peerAIApproved = null,
    Object? myProofImagePath = freezed,
    Object? peerProofImagePath = freezed,
    Object? myProofText = null,
  }) {
    return _then(
      _value.copyWith(
            myAIApproved: null == myAIApproved
                ? _value.myAIApproved
                : myAIApproved // ignore: cast_nullable_to_non_nullable
                      as bool,
            peerAIApproved: null == peerAIApproved
                ? _value.peerAIApproved
                : peerAIApproved // ignore: cast_nullable_to_non_nullable
                      as bool,
            myProofImagePath: freezed == myProofImagePath
                ? _value.myProofImagePath
                : myProofImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            peerProofImagePath: freezed == peerProofImagePath
                ? _value.peerProofImagePath
                : peerProofImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            myProofText: null == myProofText
                ? _value.myProofText
                : myProofText // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIConsensusStateImplCopyWith<$Res>
    implements $AIConsensusStateCopyWith<$Res> {
  factory _$$AIConsensusStateImplCopyWith(
    _$AIConsensusStateImpl value,
    $Res Function(_$AIConsensusStateImpl) then,
  ) = __$$AIConsensusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool myAIApproved,
    bool peerAIApproved,
    String? myProofImagePath,
    String? peerProofImagePath,
    String myProofText,
  });
}

/// @nodoc
class __$$AIConsensusStateImplCopyWithImpl<$Res>
    extends _$AIConsensusStateCopyWithImpl<$Res, _$AIConsensusStateImpl>
    implements _$$AIConsensusStateImplCopyWith<$Res> {
  __$$AIConsensusStateImplCopyWithImpl(
    _$AIConsensusStateImpl _value,
    $Res Function(_$AIConsensusStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIConsensusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAIApproved = null,
    Object? peerAIApproved = null,
    Object? myProofImagePath = freezed,
    Object? peerProofImagePath = freezed,
    Object? myProofText = null,
  }) {
    return _then(
      _$AIConsensusStateImpl(
        myAIApproved: null == myAIApproved
            ? _value.myAIApproved
            : myAIApproved // ignore: cast_nullable_to_non_nullable
                  as bool,
        peerAIApproved: null == peerAIApproved
            ? _value.peerAIApproved
            : peerAIApproved // ignore: cast_nullable_to_non_nullable
                  as bool,
        myProofImagePath: freezed == myProofImagePath
            ? _value.myProofImagePath
            : myProofImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        peerProofImagePath: freezed == peerProofImagePath
            ? _value.peerProofImagePath
            : peerProofImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        myProofText: null == myProofText
            ? _value.myProofText
            : myProofText // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIConsensusStateImpl implements _AIConsensusState {
  const _$AIConsensusStateImpl({
    this.myAIApproved = false,
    this.peerAIApproved = false,
    this.myProofImagePath,
    this.peerProofImagePath,
    this.myProofText = '',
  });

  factory _$AIConsensusStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIConsensusStateImplFromJson(json);

  @override
  @JsonKey()
  final bool myAIApproved;
  @override
  @JsonKey()
  final bool peerAIApproved;
  @override
  final String? myProofImagePath;
  @override
  final String? peerProofImagePath;
  @override
  @JsonKey()
  final String myProofText;

  @override
  String toString() {
    return 'AIConsensusState(myAIApproved: $myAIApproved, peerAIApproved: $peerAIApproved, myProofImagePath: $myProofImagePath, peerProofImagePath: $peerProofImagePath, myProofText: $myProofText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIConsensusStateImpl &&
            (identical(other.myAIApproved, myAIApproved) ||
                other.myAIApproved == myAIApproved) &&
            (identical(other.peerAIApproved, peerAIApproved) ||
                other.peerAIApproved == peerAIApproved) &&
            (identical(other.myProofImagePath, myProofImagePath) ||
                other.myProofImagePath == myProofImagePath) &&
            (identical(other.peerProofImagePath, peerProofImagePath) ||
                other.peerProofImagePath == peerProofImagePath) &&
            (identical(other.myProofText, myProofText) ||
                other.myProofText == myProofText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    myAIApproved,
    peerAIApproved,
    myProofImagePath,
    peerProofImagePath,
    myProofText,
  );

  /// Create a copy of AIConsensusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIConsensusStateImplCopyWith<_$AIConsensusStateImpl> get copyWith =>
      __$$AIConsensusStateImplCopyWithImpl<_$AIConsensusStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIConsensusStateImplToJson(this);
  }
}

abstract class _AIConsensusState implements AIConsensusState {
  const factory _AIConsensusState({
    final bool myAIApproved,
    final bool peerAIApproved,
    final String? myProofImagePath,
    final String? peerProofImagePath,
    final String myProofText,
  }) = _$AIConsensusStateImpl;

  factory _AIConsensusState.fromJson(Map<String, dynamic> json) =
      _$AIConsensusStateImpl.fromJson;

  @override
  bool get myAIApproved;
  @override
  bool get peerAIApproved;
  @override
  String? get myProofImagePath;
  @override
  String? get peerProofImagePath;
  @override
  String get myProofText;

  /// Create a copy of AIConsensusState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIConsensusStateImplCopyWith<_$AIConsensusStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
