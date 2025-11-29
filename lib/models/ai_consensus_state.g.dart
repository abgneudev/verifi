// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_consensus_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIConsensusStateImpl _$$AIConsensusStateImplFromJson(
  Map<String, dynamic> json,
) => _$AIConsensusStateImpl(
  myAIApproved: json['myAIApproved'] as bool? ?? false,
  peerAIApproved: json['peerAIApproved'] as bool? ?? false,
  myProofImagePath: json['myProofImagePath'] as String?,
  peerProofImagePath: json['peerProofImagePath'] as String?,
  myProofText: json['myProofText'] as String? ?? '',
);

Map<String, dynamic> _$$AIConsensusStateImplToJson(
  _$AIConsensusStateImpl instance,
) => <String, dynamic>{
  'myAIApproved': instance.myAIApproved,
  'peerAIApproved': instance.peerAIApproved,
  'myProofImagePath': instance.myProofImagePath,
  'peerProofImagePath': instance.peerProofImagePath,
  'myProofText': instance.myProofText,
};
