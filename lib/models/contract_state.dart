import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract_state.freezed.dart';
part 'contract_state.g.dart';

enum UserRole { seller, buyer }

enum NegotiationStatus {
  idle,
  awaitingPeerResponse,
  awaitingMyResponse,
  agreed,
  finalized,
}

enum TransactionStep {
  negotiation, // Step 1: Contract negotiation
  escrow, // Step 2: Escrow payment
  delivery, // Step 3: Delivery confirmation
  completed, // Transaction complete
}

@freezed
class ContractDraft with _$ContractDraft {
  const factory ContractDraft({
    required int version,
    required String text,
    required UserRole proposedBy,
    required DateTime timestamp,
    String? aiSuggestion,
  }) = _ContractDraft;

  factory ContractDraft.fromJson(Map<String, dynamic> json) =>
      _$ContractDraftFromJson(json);
}

@freezed
class ContractState with _$ContractState {
  const factory ContractState({
    // User's role in the transaction
    UserRole? myRole,

    // Current draft being negotiated
    ContractDraft? currentDraft,

    // Draft history for tracking changes
    @Default([]) List<ContractDraft> draftHistory,

    // Private input field (not yet submitted)
    @Default('') String myPrivateInput,

    // Whose turn it is to respond
    @Default(NegotiationStatus.idle) NegotiationStatus status,

    // AI suggestions for current negotiation
    String? aiMediation,

    // Final approval state
    @Default(false) bool myApproval,
    @Default(false) bool peerApproval,
    @Default(false) bool isFinalized,
    String? finalHash,

    // Transaction step tracking
    @Default(TransactionStep.negotiation) TransactionStep currentStep,
    @Default(false) bool escrowDeposited,
    @Default(false) bool deliveryConfirmed,
  }) = _ContractState;

  factory ContractState.fromJson(Map<String, dynamic> json) =>
      _$ContractStateFromJson(json);
}

const ContractState initialContractState = ContractState();
