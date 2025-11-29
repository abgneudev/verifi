// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contract_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContractDraft _$ContractDraftFromJson(Map<String, dynamic> json) {
  return _ContractDraft.fromJson(json);
}

/// @nodoc
mixin _$ContractDraft {
  int get version => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  UserRole get proposedBy => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get aiSuggestion => throw _privateConstructorUsedError;

  /// Serializes this ContractDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContractDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContractDraftCopyWith<ContractDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContractDraftCopyWith<$Res> {
  factory $ContractDraftCopyWith(
    ContractDraft value,
    $Res Function(ContractDraft) then,
  ) = _$ContractDraftCopyWithImpl<$Res, ContractDraft>;
  @useResult
  $Res call({
    int version,
    String text,
    UserRole proposedBy,
    DateTime timestamp,
    String? aiSuggestion,
  });
}

/// @nodoc
class _$ContractDraftCopyWithImpl<$Res, $Val extends ContractDraft>
    implements $ContractDraftCopyWith<$Res> {
  _$ContractDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContractDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? text = null,
    Object? proposedBy = null,
    Object? timestamp = null,
    Object? aiSuggestion = freezed,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            proposedBy: null == proposedBy
                ? _value.proposedBy
                : proposedBy // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            aiSuggestion: freezed == aiSuggestion
                ? _value.aiSuggestion
                : aiSuggestion // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContractDraftImplCopyWith<$Res>
    implements $ContractDraftCopyWith<$Res> {
  factory _$$ContractDraftImplCopyWith(
    _$ContractDraftImpl value,
    $Res Function(_$ContractDraftImpl) then,
  ) = __$$ContractDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int version,
    String text,
    UserRole proposedBy,
    DateTime timestamp,
    String? aiSuggestion,
  });
}

/// @nodoc
class __$$ContractDraftImplCopyWithImpl<$Res>
    extends _$ContractDraftCopyWithImpl<$Res, _$ContractDraftImpl>
    implements _$$ContractDraftImplCopyWith<$Res> {
  __$$ContractDraftImplCopyWithImpl(
    _$ContractDraftImpl _value,
    $Res Function(_$ContractDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContractDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? text = null,
    Object? proposedBy = null,
    Object? timestamp = null,
    Object? aiSuggestion = freezed,
  }) {
    return _then(
      _$ContractDraftImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        proposedBy: null == proposedBy
            ? _value.proposedBy
            : proposedBy // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        aiSuggestion: freezed == aiSuggestion
            ? _value.aiSuggestion
            : aiSuggestion // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContractDraftImpl implements _ContractDraft {
  const _$ContractDraftImpl({
    required this.version,
    required this.text,
    required this.proposedBy,
    required this.timestamp,
    this.aiSuggestion,
  });

  factory _$ContractDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContractDraftImplFromJson(json);

  @override
  final int version;
  @override
  final String text;
  @override
  final UserRole proposedBy;
  @override
  final DateTime timestamp;
  @override
  final String? aiSuggestion;

  @override
  String toString() {
    return 'ContractDraft(version: $version, text: $text, proposedBy: $proposedBy, timestamp: $timestamp, aiSuggestion: $aiSuggestion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContractDraftImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.proposedBy, proposedBy) ||
                other.proposedBy == proposedBy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.aiSuggestion, aiSuggestion) ||
                other.aiSuggestion == aiSuggestion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    text,
    proposedBy,
    timestamp,
    aiSuggestion,
  );

  /// Create a copy of ContractDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContractDraftImplCopyWith<_$ContractDraftImpl> get copyWith =>
      __$$ContractDraftImplCopyWithImpl<_$ContractDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContractDraftImplToJson(this);
  }
}

abstract class _ContractDraft implements ContractDraft {
  const factory _ContractDraft({
    required final int version,
    required final String text,
    required final UserRole proposedBy,
    required final DateTime timestamp,
    final String? aiSuggestion,
  }) = _$ContractDraftImpl;

  factory _ContractDraft.fromJson(Map<String, dynamic> json) =
      _$ContractDraftImpl.fromJson;

  @override
  int get version;
  @override
  String get text;
  @override
  UserRole get proposedBy;
  @override
  DateTime get timestamp;
  @override
  String? get aiSuggestion;

  /// Create a copy of ContractDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContractDraftImplCopyWith<_$ContractDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContractState _$ContractStateFromJson(Map<String, dynamic> json) {
  return _ContractState.fromJson(json);
}

/// @nodoc
mixin _$ContractState {
  // User's role in the transaction
  UserRole? get myRole =>
      throw _privateConstructorUsedError; // Current draft being negotiated
  ContractDraft? get currentDraft =>
      throw _privateConstructorUsedError; // Draft history for tracking changes
  List<ContractDraft> get draftHistory =>
      throw _privateConstructorUsedError; // Private input field (not yet submitted)
  String get myPrivateInput =>
      throw _privateConstructorUsedError; // Whose turn it is to respond
  NegotiationStatus get status =>
      throw _privateConstructorUsedError; // AI suggestions for current negotiation
  String? get aiMediation =>
      throw _privateConstructorUsedError; // Final approval state
  bool get myApproval => throw _privateConstructorUsedError;
  bool get peerApproval => throw _privateConstructorUsedError;
  bool get isFinalized => throw _privateConstructorUsedError;
  String? get finalHash =>
      throw _privateConstructorUsedError; // Transaction step tracking
  TransactionStep get currentStep => throw _privateConstructorUsedError;
  bool get escrowDeposited => throw _privateConstructorUsedError;
  bool get deliveryConfirmed =>
      throw _privateConstructorUsedError; // Proof of work submission
  bool get proofSubmitted => throw _privateConstructorUsedError;
  String? get proofText => throw _privateConstructorUsedError;
  String? get proofImagePath => throw _privateConstructorUsedError;
  String? get aiProofAnalysis => throw _privateConstructorUsedError;
  bool get aiApprovedProof => throw _privateConstructorUsedError;
  DateTime? get proofSubmittedAt => throw _privateConstructorUsedError;
  bool get buyerApprovedDelivery => throw _privateConstructorUsedError;

  /// Serializes this ContractState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContractStateCopyWith<ContractState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContractStateCopyWith<$Res> {
  factory $ContractStateCopyWith(
    ContractState value,
    $Res Function(ContractState) then,
  ) = _$ContractStateCopyWithImpl<$Res, ContractState>;
  @useResult
  $Res call({
    UserRole? myRole,
    ContractDraft? currentDraft,
    List<ContractDraft> draftHistory,
    String myPrivateInput,
    NegotiationStatus status,
    String? aiMediation,
    bool myApproval,
    bool peerApproval,
    bool isFinalized,
    String? finalHash,
    TransactionStep currentStep,
    bool escrowDeposited,
    bool deliveryConfirmed,
    bool proofSubmitted,
    String? proofText,
    String? proofImagePath,
    String? aiProofAnalysis,
    bool aiApprovedProof,
    DateTime? proofSubmittedAt,
    bool buyerApprovedDelivery,
  });

  $ContractDraftCopyWith<$Res>? get currentDraft;
}

/// @nodoc
class _$ContractStateCopyWithImpl<$Res, $Val extends ContractState>
    implements $ContractStateCopyWith<$Res> {
  _$ContractStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myRole = freezed,
    Object? currentDraft = freezed,
    Object? draftHistory = null,
    Object? myPrivateInput = null,
    Object? status = null,
    Object? aiMediation = freezed,
    Object? myApproval = null,
    Object? peerApproval = null,
    Object? isFinalized = null,
    Object? finalHash = freezed,
    Object? currentStep = null,
    Object? escrowDeposited = null,
    Object? deliveryConfirmed = null,
    Object? proofSubmitted = null,
    Object? proofText = freezed,
    Object? proofImagePath = freezed,
    Object? aiProofAnalysis = freezed,
    Object? aiApprovedProof = null,
    Object? proofSubmittedAt = freezed,
    Object? buyerApprovedDelivery = null,
  }) {
    return _then(
      _value.copyWith(
            myRole: freezed == myRole
                ? _value.myRole
                : myRole // ignore: cast_nullable_to_non_nullable
                      as UserRole?,
            currentDraft: freezed == currentDraft
                ? _value.currentDraft
                : currentDraft // ignore: cast_nullable_to_non_nullable
                      as ContractDraft?,
            draftHistory: null == draftHistory
                ? _value.draftHistory
                : draftHistory // ignore: cast_nullable_to_non_nullable
                      as List<ContractDraft>,
            myPrivateInput: null == myPrivateInput
                ? _value.myPrivateInput
                : myPrivateInput // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as NegotiationStatus,
            aiMediation: freezed == aiMediation
                ? _value.aiMediation
                : aiMediation // ignore: cast_nullable_to_non_nullable
                      as String?,
            myApproval: null == myApproval
                ? _value.myApproval
                : myApproval // ignore: cast_nullable_to_non_nullable
                      as bool,
            peerApproval: null == peerApproval
                ? _value.peerApproval
                : peerApproval // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFinalized: null == isFinalized
                ? _value.isFinalized
                : isFinalized // ignore: cast_nullable_to_non_nullable
                      as bool,
            finalHash: freezed == finalHash
                ? _value.finalHash
                : finalHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as TransactionStep,
            escrowDeposited: null == escrowDeposited
                ? _value.escrowDeposited
                : escrowDeposited // ignore: cast_nullable_to_non_nullable
                      as bool,
            deliveryConfirmed: null == deliveryConfirmed
                ? _value.deliveryConfirmed
                : deliveryConfirmed // ignore: cast_nullable_to_non_nullable
                      as bool,
            proofSubmitted: null == proofSubmitted
                ? _value.proofSubmitted
                : proofSubmitted // ignore: cast_nullable_to_non_nullable
                      as bool,
            proofText: freezed == proofText
                ? _value.proofText
                : proofText // ignore: cast_nullable_to_non_nullable
                      as String?,
            proofImagePath: freezed == proofImagePath
                ? _value.proofImagePath
                : proofImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            aiProofAnalysis: freezed == aiProofAnalysis
                ? _value.aiProofAnalysis
                : aiProofAnalysis // ignore: cast_nullable_to_non_nullable
                      as String?,
            aiApprovedProof: null == aiApprovedProof
                ? _value.aiApprovedProof
                : aiApprovedProof // ignore: cast_nullable_to_non_nullable
                      as bool,
            proofSubmittedAt: freezed == proofSubmittedAt
                ? _value.proofSubmittedAt
                : proofSubmittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            buyerApprovedDelivery: null == buyerApprovedDelivery
                ? _value.buyerApprovedDelivery
                : buyerApprovedDelivery // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContractDraftCopyWith<$Res>? get currentDraft {
    if (_value.currentDraft == null) {
      return null;
    }

    return $ContractDraftCopyWith<$Res>(_value.currentDraft!, (value) {
      return _then(_value.copyWith(currentDraft: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContractStateImplCopyWith<$Res>
    implements $ContractStateCopyWith<$Res> {
  factory _$$ContractStateImplCopyWith(
    _$ContractStateImpl value,
    $Res Function(_$ContractStateImpl) then,
  ) = __$$ContractStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UserRole? myRole,
    ContractDraft? currentDraft,
    List<ContractDraft> draftHistory,
    String myPrivateInput,
    NegotiationStatus status,
    String? aiMediation,
    bool myApproval,
    bool peerApproval,
    bool isFinalized,
    String? finalHash,
    TransactionStep currentStep,
    bool escrowDeposited,
    bool deliveryConfirmed,
    bool proofSubmitted,
    String? proofText,
    String? proofImagePath,
    String? aiProofAnalysis,
    bool aiApprovedProof,
    DateTime? proofSubmittedAt,
    bool buyerApprovedDelivery,
  });

  @override
  $ContractDraftCopyWith<$Res>? get currentDraft;
}

/// @nodoc
class __$$ContractStateImplCopyWithImpl<$Res>
    extends _$ContractStateCopyWithImpl<$Res, _$ContractStateImpl>
    implements _$$ContractStateImplCopyWith<$Res> {
  __$$ContractStateImplCopyWithImpl(
    _$ContractStateImpl _value,
    $Res Function(_$ContractStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myRole = freezed,
    Object? currentDraft = freezed,
    Object? draftHistory = null,
    Object? myPrivateInput = null,
    Object? status = null,
    Object? aiMediation = freezed,
    Object? myApproval = null,
    Object? peerApproval = null,
    Object? isFinalized = null,
    Object? finalHash = freezed,
    Object? currentStep = null,
    Object? escrowDeposited = null,
    Object? deliveryConfirmed = null,
    Object? proofSubmitted = null,
    Object? proofText = freezed,
    Object? proofImagePath = freezed,
    Object? aiProofAnalysis = freezed,
    Object? aiApprovedProof = null,
    Object? proofSubmittedAt = freezed,
    Object? buyerApprovedDelivery = null,
  }) {
    return _then(
      _$ContractStateImpl(
        myRole: freezed == myRole
            ? _value.myRole
            : myRole // ignore: cast_nullable_to_non_nullable
                  as UserRole?,
        currentDraft: freezed == currentDraft
            ? _value.currentDraft
            : currentDraft // ignore: cast_nullable_to_non_nullable
                  as ContractDraft?,
        draftHistory: null == draftHistory
            ? _value._draftHistory
            : draftHistory // ignore: cast_nullable_to_non_nullable
                  as List<ContractDraft>,
        myPrivateInput: null == myPrivateInput
            ? _value.myPrivateInput
            : myPrivateInput // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as NegotiationStatus,
        aiMediation: freezed == aiMediation
            ? _value.aiMediation
            : aiMediation // ignore: cast_nullable_to_non_nullable
                  as String?,
        myApproval: null == myApproval
            ? _value.myApproval
            : myApproval // ignore: cast_nullable_to_non_nullable
                  as bool,
        peerApproval: null == peerApproval
            ? _value.peerApproval
            : peerApproval // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFinalized: null == isFinalized
            ? _value.isFinalized
            : isFinalized // ignore: cast_nullable_to_non_nullable
                  as bool,
        finalHash: freezed == finalHash
            ? _value.finalHash
            : finalHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as TransactionStep,
        escrowDeposited: null == escrowDeposited
            ? _value.escrowDeposited
            : escrowDeposited // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryConfirmed: null == deliveryConfirmed
            ? _value.deliveryConfirmed
            : deliveryConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        proofSubmitted: null == proofSubmitted
            ? _value.proofSubmitted
            : proofSubmitted // ignore: cast_nullable_to_non_nullable
                  as bool,
        proofText: freezed == proofText
            ? _value.proofText
            : proofText // ignore: cast_nullable_to_non_nullable
                  as String?,
        proofImagePath: freezed == proofImagePath
            ? _value.proofImagePath
            : proofImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiProofAnalysis: freezed == aiProofAnalysis
            ? _value.aiProofAnalysis
            : aiProofAnalysis // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiApprovedProof: null == aiApprovedProof
            ? _value.aiApprovedProof
            : aiApprovedProof // ignore: cast_nullable_to_non_nullable
                  as bool,
        proofSubmittedAt: freezed == proofSubmittedAt
            ? _value.proofSubmittedAt
            : proofSubmittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        buyerApprovedDelivery: null == buyerApprovedDelivery
            ? _value.buyerApprovedDelivery
            : buyerApprovedDelivery // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContractStateImpl implements _ContractState {
  const _$ContractStateImpl({
    this.myRole,
    this.currentDraft,
    final List<ContractDraft> draftHistory = const [],
    this.myPrivateInput = '',
    this.status = NegotiationStatus.idle,
    this.aiMediation,
    this.myApproval = false,
    this.peerApproval = false,
    this.isFinalized = false,
    this.finalHash,
    this.currentStep = TransactionStep.negotiation,
    this.escrowDeposited = false,
    this.deliveryConfirmed = false,
    this.proofSubmitted = false,
    this.proofText,
    this.proofImagePath,
    this.aiProofAnalysis,
    this.aiApprovedProof = false,
    this.proofSubmittedAt,
    this.buyerApprovedDelivery = false,
  }) : _draftHistory = draftHistory;

  factory _$ContractStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContractStateImplFromJson(json);

  // User's role in the transaction
  @override
  final UserRole? myRole;
  // Current draft being negotiated
  @override
  final ContractDraft? currentDraft;
  // Draft history for tracking changes
  final List<ContractDraft> _draftHistory;
  // Draft history for tracking changes
  @override
  @JsonKey()
  List<ContractDraft> get draftHistory {
    if (_draftHistory is EqualUnmodifiableListView) return _draftHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_draftHistory);
  }

  // Private input field (not yet submitted)
  @override
  @JsonKey()
  final String myPrivateInput;
  // Whose turn it is to respond
  @override
  @JsonKey()
  final NegotiationStatus status;
  // AI suggestions for current negotiation
  @override
  final String? aiMediation;
  // Final approval state
  @override
  @JsonKey()
  final bool myApproval;
  @override
  @JsonKey()
  final bool peerApproval;
  @override
  @JsonKey()
  final bool isFinalized;
  @override
  final String? finalHash;
  // Transaction step tracking
  @override
  @JsonKey()
  final TransactionStep currentStep;
  @override
  @JsonKey()
  final bool escrowDeposited;
  @override
  @JsonKey()
  final bool deliveryConfirmed;
  // Proof of work submission
  @override
  @JsonKey()
  final bool proofSubmitted;
  @override
  final String? proofText;
  @override
  final String? proofImagePath;
  @override
  final String? aiProofAnalysis;
  @override
  @JsonKey()
  final bool aiApprovedProof;
  @override
  final DateTime? proofSubmittedAt;
  @override
  @JsonKey()
  final bool buyerApprovedDelivery;

  @override
  String toString() {
    return 'ContractState(myRole: $myRole, currentDraft: $currentDraft, draftHistory: $draftHistory, myPrivateInput: $myPrivateInput, status: $status, aiMediation: $aiMediation, myApproval: $myApproval, peerApproval: $peerApproval, isFinalized: $isFinalized, finalHash: $finalHash, currentStep: $currentStep, escrowDeposited: $escrowDeposited, deliveryConfirmed: $deliveryConfirmed, proofSubmitted: $proofSubmitted, proofText: $proofText, proofImagePath: $proofImagePath, aiProofAnalysis: $aiProofAnalysis, aiApprovedProof: $aiApprovedProof, proofSubmittedAt: $proofSubmittedAt, buyerApprovedDelivery: $buyerApprovedDelivery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContractStateImpl &&
            (identical(other.myRole, myRole) || other.myRole == myRole) &&
            (identical(other.currentDraft, currentDraft) ||
                other.currentDraft == currentDraft) &&
            const DeepCollectionEquality().equals(
              other._draftHistory,
              _draftHistory,
            ) &&
            (identical(other.myPrivateInput, myPrivateInput) ||
                other.myPrivateInput == myPrivateInput) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.aiMediation, aiMediation) ||
                other.aiMediation == aiMediation) &&
            (identical(other.myApproval, myApproval) ||
                other.myApproval == myApproval) &&
            (identical(other.peerApproval, peerApproval) ||
                other.peerApproval == peerApproval) &&
            (identical(other.isFinalized, isFinalized) ||
                other.isFinalized == isFinalized) &&
            (identical(other.finalHash, finalHash) ||
                other.finalHash == finalHash) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.escrowDeposited, escrowDeposited) ||
                other.escrowDeposited == escrowDeposited) &&
            (identical(other.deliveryConfirmed, deliveryConfirmed) ||
                other.deliveryConfirmed == deliveryConfirmed) &&
            (identical(other.proofSubmitted, proofSubmitted) ||
                other.proofSubmitted == proofSubmitted) &&
            (identical(other.proofText, proofText) ||
                other.proofText == proofText) &&
            (identical(other.proofImagePath, proofImagePath) ||
                other.proofImagePath == proofImagePath) &&
            (identical(other.aiProofAnalysis, aiProofAnalysis) ||
                other.aiProofAnalysis == aiProofAnalysis) &&
            (identical(other.aiApprovedProof, aiApprovedProof) ||
                other.aiApprovedProof == aiApprovedProof) &&
            (identical(other.proofSubmittedAt, proofSubmittedAt) ||
                other.proofSubmittedAt == proofSubmittedAt) &&
            (identical(other.buyerApprovedDelivery, buyerApprovedDelivery) ||
                other.buyerApprovedDelivery == buyerApprovedDelivery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    myRole,
    currentDraft,
    const DeepCollectionEquality().hash(_draftHistory),
    myPrivateInput,
    status,
    aiMediation,
    myApproval,
    peerApproval,
    isFinalized,
    finalHash,
    currentStep,
    escrowDeposited,
    deliveryConfirmed,
    proofSubmitted,
    proofText,
    proofImagePath,
    aiProofAnalysis,
    aiApprovedProof,
    proofSubmittedAt,
    buyerApprovedDelivery,
  ]);

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContractStateImplCopyWith<_$ContractStateImpl> get copyWith =>
      __$$ContractStateImplCopyWithImpl<_$ContractStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContractStateImplToJson(this);
  }
}

abstract class _ContractState implements ContractState {
  const factory _ContractState({
    final UserRole? myRole,
    final ContractDraft? currentDraft,
    final List<ContractDraft> draftHistory,
    final String myPrivateInput,
    final NegotiationStatus status,
    final String? aiMediation,
    final bool myApproval,
    final bool peerApproval,
    final bool isFinalized,
    final String? finalHash,
    final TransactionStep currentStep,
    final bool escrowDeposited,
    final bool deliveryConfirmed,
    final bool proofSubmitted,
    final String? proofText,
    final String? proofImagePath,
    final String? aiProofAnalysis,
    final bool aiApprovedProof,
    final DateTime? proofSubmittedAt,
    final bool buyerApprovedDelivery,
  }) = _$ContractStateImpl;

  factory _ContractState.fromJson(Map<String, dynamic> json) =
      _$ContractStateImpl.fromJson;

  // User's role in the transaction
  @override
  UserRole? get myRole; // Current draft being negotiated
  @override
  ContractDraft? get currentDraft; // Draft history for tracking changes
  @override
  List<ContractDraft> get draftHistory; // Private input field (not yet submitted)
  @override
  String get myPrivateInput; // Whose turn it is to respond
  @override
  NegotiationStatus get status; // AI suggestions for current negotiation
  @override
  String? get aiMediation; // Final approval state
  @override
  bool get myApproval;
  @override
  bool get peerApproval;
  @override
  bool get isFinalized;
  @override
  String? get finalHash; // Transaction step tracking
  @override
  TransactionStep get currentStep;
  @override
  bool get escrowDeposited;
  @override
  bool get deliveryConfirmed; // Proof of work submission
  @override
  bool get proofSubmitted;
  @override
  String? get proofText;
  @override
  String? get proofImagePath;
  @override
  String? get aiProofAnalysis;
  @override
  bool get aiApprovedProof;
  @override
  DateTime? get proofSubmittedAt;
  @override
  bool get buyerApprovedDelivery;

  /// Create a copy of ContractState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContractStateImplCopyWith<_$ContractStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
