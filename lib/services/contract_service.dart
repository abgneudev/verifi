import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/contract_state.dart';

class ContractService {
  String? _currentHash;

  String? get currentHash => _currentHash;

  String generateHash(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    _currentHash = digest.toString();
    return _currentHash!;
  }

  bool verifyHash(String text, String hash) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return digest.toString() == hash;
  }

  /// Create initial draft from seller
  ContractDraft createInitialDraft(String text) {
    return ContractDraft(
      version: 1,
      text: text,
      proposedBy: UserRole.seller,
      timestamp: DateTime.now(),
    );
  }

  /// Create counter-proposal from current draft
  ContractDraft createCounterProposal({
    required ContractDraft currentDraft,
    required String newText,
    required UserRole proposedBy,
    String? aiSuggestion,
  }) {
    return ContractDraft(
      version: currentDraft.version + 1,
      text: newText,
      proposedBy: proposedBy,
      timestamp: DateTime.now(),
      aiSuggestion: aiSuggestion,
    );
  }

  /// Check if two parties should move to approval phase
  /// This happens when the latest draft is accepted without changes
  bool shouldMoveToApproval({
    required String userInput,
    required String currentDraftText,
  }) {
    // User accepts if input is empty, "agree", "accept", or matches current draft
    final normalizedInput = userInput.trim().toLowerCase();
    return normalizedInput.isEmpty ||
        normalizedInput == 'agree' ||
        normalizedInput == 'agreed' ||
        normalizedInput == 'accept' ||
        normalizedInput == 'accepted' ||
        normalizedInput == 'yes' ||
        normalizedInput == currentDraftText.trim().toLowerCase();
  }

  /// Prepare draft for AI mediation
  Map<String, dynamic> prepareDraftForAI({
    required ContractDraft currentDraft,
    required String userResponse,
    required UserRole respondingUser,
    required List<ContractDraft> history,
  }) {
    return {
      'currentDraft': currentDraft.toJson(),
      'userResponse': userResponse,
      'respondingUser': respondingUser == UserRole.seller ? 'seller' : 'buyer',
      'history': history.map((d) => d.toJson()).toList(),
    };
  }

  void reset() {
    _currentHash = null;
  }
}
