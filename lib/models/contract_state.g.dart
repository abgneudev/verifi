// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContractDraftImpl _$$ContractDraftImplFromJson(Map<String, dynamic> json) =>
    _$ContractDraftImpl(
      version: (json['version'] as num).toInt(),
      text: json['text'] as String,
      proposedBy: $enumDecode(_$UserRoleEnumMap, json['proposedBy']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      aiSuggestion: json['aiSuggestion'] as String?,
    );

Map<String, dynamic> _$$ContractDraftImplToJson(_$ContractDraftImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'text': instance.text,
      'proposedBy': _$UserRoleEnumMap[instance.proposedBy]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'aiSuggestion': instance.aiSuggestion,
    };

const _$UserRoleEnumMap = {UserRole.seller: 'seller', UserRole.buyer: 'buyer'};

_$ContractStateImpl _$$ContractStateImplFromJson(Map<String, dynamic> json) =>
    _$ContractStateImpl(
      myRole: $enumDecodeNullable(_$UserRoleEnumMap, json['myRole']),
      currentDraft: json['currentDraft'] == null
          ? null
          : ContractDraft.fromJson(
              json['currentDraft'] as Map<String, dynamic>,
            ),
      draftHistory:
          (json['draftHistory'] as List<dynamic>?)
              ?.map((e) => ContractDraft.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      myPrivateInput: json['myPrivateInput'] as String? ?? '',
      status:
          $enumDecodeNullable(_$NegotiationStatusEnumMap, json['status']) ??
          NegotiationStatus.idle,
      aiMediation: json['aiMediation'] as String?,
      myApproval: json['myApproval'] as bool? ?? false,
      peerApproval: json['peerApproval'] as bool? ?? false,
      isFinalized: json['isFinalized'] as bool? ?? false,
      finalHash: json['finalHash'] as String?,
      currentStep:
          $enumDecodeNullable(_$TransactionStepEnumMap, json['currentStep']) ??
          TransactionStep.negotiation,
      escrowDeposited: json['escrowDeposited'] as bool? ?? false,
      deliveryConfirmed: json['deliveryConfirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ContractStateImplToJson(_$ContractStateImpl instance) =>
    <String, dynamic>{
      'myRole': _$UserRoleEnumMap[instance.myRole],
      'currentDraft': instance.currentDraft,
      'draftHistory': instance.draftHistory,
      'myPrivateInput': instance.myPrivateInput,
      'status': _$NegotiationStatusEnumMap[instance.status]!,
      'aiMediation': instance.aiMediation,
      'myApproval': instance.myApproval,
      'peerApproval': instance.peerApproval,
      'isFinalized': instance.isFinalized,
      'finalHash': instance.finalHash,
      'currentStep': _$TransactionStepEnumMap[instance.currentStep]!,
      'escrowDeposited': instance.escrowDeposited,
      'deliveryConfirmed': instance.deliveryConfirmed,
    };

const _$NegotiationStatusEnumMap = {
  NegotiationStatus.idle: 'idle',
  NegotiationStatus.awaitingPeerResponse: 'awaitingPeerResponse',
  NegotiationStatus.awaitingMyResponse: 'awaitingMyResponse',
  NegotiationStatus.agreed: 'agreed',
  NegotiationStatus.finalized: 'finalized',
};

const _$TransactionStepEnumMap = {
  TransactionStep.negotiation: 'negotiation',
  TransactionStep.escrow: 'escrow',
  TransactionStep.delivery: 'delivery',
  TransactionStep.completed: 'completed',
};
