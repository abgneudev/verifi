import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_consensus_state.freezed.dart';
part 'ai_consensus_state.g.dart';

@freezed
class AIConsensusState with _$AIConsensusState {
  const factory AIConsensusState({
    @Default(false) bool myAIApproved,
    @Default(false) bool peerAIApproved,
    String? myProofImagePath,
    String? peerProofImagePath,
    @Default('') String myProofText, // Text-based proof description
  }) = _AIConsensusState;

  factory AIConsensusState.fromJson(Map<String, dynamic> json) =>
      _$AIConsensusStateFromJson(json);
}

const AIConsensusState initialAIConsensusState = AIConsensusState();
