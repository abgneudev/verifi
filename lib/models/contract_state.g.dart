// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NegotiationMessageImpl _$$NegotiationMessageImplFromJson(
  Map<String, dynamic> json,
) => _$NegotiationMessageImpl(
  id: json['id'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  text: json['text'] as String,
  senderRole: $enumDecodeNullable(_$UserRoleEnumMap, json['senderRole']),
  senderName: json['senderName'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  aiAnalysis: json['aiAnalysis'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$NegotiationMessageImplToJson(
  _$NegotiationMessageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'text': instance.text,
  'senderRole': _$UserRoleEnumMap[instance.senderRole],
  'senderName': instance.senderName,
  'attachments': instance.attachments,
  'timestamp': instance.timestamp?.toIso8601String(),
  'aiAnalysis': instance.aiAnalysis,
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.contract: 'contract',
  MessageType.image: 'image',
  MessageType.ai: 'ai',
};

const _$UserRoleEnumMap = {UserRole.seller: 'seller', UserRole.buyer: 'buyer'};

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

_$ContractStateImpl _$$ContractStateImplFromJson(
  Map<String, dynamic> json,
) => _$ContractStateImpl(
  myRole: $enumDecodeNullable(_$UserRoleEnumMap, json['myRole']),
  currentDraft: json['currentDraft'] == null
      ? null
      : ContractDraft.fromJson(json['currentDraft'] as Map<String, dynamic>),
  draftHistory:
      (json['draftHistory'] as List<dynamic>?)
          ?.map((e) => ContractDraft.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => NegotiationMessage.fromJson(e as Map<String, dynamic>))
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
  proofSubmitted: json['proofSubmitted'] as bool? ?? false,
  proofText: json['proofText'] as String?,
  proofImagePath: json['proofImagePath'] as String?,
  aiProofAnalysis: json['aiProofAnalysis'] as String?,
  aiApprovedProof: json['aiApprovedProof'] as bool? ?? false,
  proofSubmittedAt: json['proofSubmittedAt'] == null
      ? null
      : DateTime.parse(json['proofSubmittedAt'] as String),
  buyerApprovedDelivery: json['buyerApprovedDelivery'] as bool? ?? false,
);

Map<String, dynamic> _$$ContractStateImplToJson(_$ContractStateImpl instance) =>
    <String, dynamic>{
      'myRole': _$UserRoleEnumMap[instance.myRole],
      'currentDraft': instance.currentDraft,
      'draftHistory': instance.draftHistory,
      'messages': instance.messages,
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
      'proofSubmitted': instance.proofSubmitted,
      'proofText': instance.proofText,
      'proofImagePath': instance.proofImagePath,
      'aiProofAnalysis': instance.aiProofAnalysis,
      'aiApprovedProof': instance.aiApprovedProof,
      'proofSubmittedAt': instance.proofSubmittedAt?.toIso8601String(),
      'buyerApprovedDelivery': instance.buyerApprovedDelivery,
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
