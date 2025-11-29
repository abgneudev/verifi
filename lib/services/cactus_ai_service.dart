import 'dart:convert';
import 'package:cactus/cactus.dart';

class CactusAIService {
  CactusLM? _cactus;
  bool _isReady = false;

  bool get isReady => _isReady;
  CactusLM? get cactus => _cactus;

  Future<void> initialize() async {
    _cactus = CactusLM();
    // Use a vision-capable model for image analysis
    await _cactus!.downloadModel(model: "lfm2-vl-450m");
    await _cactus!.initializeModel(
      params: CactusInitParams(model: 'lfm2-vl-450m'),
    );
    _isReady = true;
  }

  /// AI-mediated contract negotiation with strong mediation logic
  Future<String> mediateContractNegotiation({
    required String currentDraft,
    required String userResponse,
    required String respondingRole, // 'seller' or 'buyer'
    required int draftVersion,
    required List<String> previousVersions,
  }) async {
    if (!_isReady || _cactus == null) {
      throw Exception('Cactus AI not ready');
    }

    final systemPrompt = _buildNegotiationSystemPrompt();
    final userPrompt = _buildNegotiationUserPrompt(
      currentDraft: currentDraft,
      userResponse: userResponse,
      respondingRole: respondingRole,
      draftVersion: draftVersion,
      previousVersions: previousVersions,
    );

    final response = await _cactus!.generateCompletion(
      messages: [
        ChatMessage(role: "system", content: systemPrompt),
        ChatMessage(role: "user", content: userPrompt),
      ],
    );

    return response.toString();
  }

  /// Strong system prompt for AI negotiation mediator
  String _buildNegotiationSystemPrompt() {
    return '''You are an expert contract negotiation mediator AI. Your role is to facilitate fair, efficient contract agreements between a SELLER and a BUYER.

CORE PRINCIPLES:
1. FAIRNESS: Find middle ground that protects both parties equally
2. EFFICIENCY: Minimize negotiation rounds while maintaining quality
3. CLARITY: Ensure terms are specific, measurable, and unambiguous
4. BALANCE: Neither party should have unfair advantage
5. PRACTICALITY: Terms must be realistic and enforceable

YOUR TASK:
- Analyze the current contract draft and the responding party's concerns/edits
- Identify points of agreement and contention
- Synthesize a new draft that incorporates valid concerns from BOTH parties
- Add protective clauses that benefit both sides
- Suggest compromises when positions conflict

NEGOTIATION STRATEGY:
- If buyer wants lower price and seller wants higher: suggest middle price with performance incentives
- If delivery timeline conflicts: propose milestone-based delivery with partial payments
- If quality concerns exist: add specific quality metrics and inspection rights
- If payment security is concern: structure payment in stages tied to milestones
- Always add mutual protection clauses (e.g., cancellation policies, dispute resolution)

OUTPUT FORMAT:
Respond with ONLY a JSON object:
{
  "analysis": "Brief analysis of the negotiation state (2-3 sentences)",
  "revisedContract": "The complete revised contract text incorporating both parties' interests",
  "reasoning": "Explanation of key changes and compromises made",
  "convergenceEstimate": "Number (1-5) indicating how close parties are to agreement"
}

QUALITY CRITERIA FOR REVISED CONTRACT:
- Include ALL essential terms: what, quantity, quality standards, price, delivery timeline, payment terms
- Add protection for both parties
- Use specific, measurable language
- Remove ambiguous or vague terms
- Include conditions for completion and acceptance criteria
- Add what happens if terms aren't met

Remember: Your goal is RAPID CONVERGENCE to a fair agreement, not perfect representation of one party's position.''';
  }

  String _buildNegotiationUserPrompt({
    required String currentDraft,
    required String userResponse,
    required String respondingRole,
    required int draftVersion,
    required List<String> previousVersions,
  }) {
    final historyContext = previousVersions.isEmpty
        ? 'This is the initial draft.'
        : 'Previous versions:\n${previousVersions.asMap().entries.map((e) => 'V${e.key + 1}: ${e.value}').join('\n')}';

    return '''NEGOTIATION ROUND ${draftVersion}

CURRENT CONTRACT DRAFT (Version $draftVersion):
"""
$currentDraft
"""

${respondingRole.toUpperCase()}'S RESPONSE:
"""
$userResponse
"""

CONTEXT:
$historyContext

TASK: Analyze the ${respondingRole}'s response and create a revised contract that:
1. Incorporates their valid concerns
2. Preserves the other party's key interests
3. Adds protective clauses for both sides
4. Moves toward rapid agreement

If the response indicates agreement (e.g., "agree", "accept", empty, or no changes), set convergenceEstimate to 5.
If significant conflicts remain, provide a strong mediating revision that finds middle ground.

Respond ONLY with the JSON format specified in your system prompt.''';
  }

  Future<String> analyzeProof({
    String? imagePath,
    String? textProof,
    required String contractText,
  }) async {
    if (!_isReady || _cactus == null) {
      throw Exception('Cactus AI not ready');
    }

    // Build the analysis prompt based on what evidence is provided
    String userPrompt;
    List<String>? images;

    if (imagePath != null && textProof != null && textProof.isNotEmpty) {
      // Both image and text provided
      userPrompt =
          "Analyze this image and the following text description to determine if they match the contract requirement: '$contractText'.\n\nText description: '$textProof'\n\nIMPORTANT: Start your response with ONLY 'YES' or 'NO', then provide a brief reason.\n\nYES if the evidence clearly shows contract fulfillment.\nNO if it doesn't match or is unclear.";
      images = [imagePath];
    } else if (imagePath != null) {
      // Only image provided
      userPrompt =
          "Analyze this image and determine if it matches the contract requirement: '$contractText'.\n\nIMPORTANT: Start your response with ONLY 'YES' or 'NO', then provide a brief reason.\n\nYES if the image clearly shows evidence of contract fulfillment.\nNO if it doesn't match or is unclear.";
      images = [imagePath];
    } else if (textProof != null && textProof.isNotEmpty) {
      // Only text provided
      userPrompt =
          "Analyze this text description to determine if it matches the contract requirement: '$contractText'.\n\nText description: '$textProof'\n\nIMPORTANT: Start your response with ONLY 'YES' or 'NO', then provide a brief reason.\n\nYES if the description clearly indicates contract fulfillment.\nNO if it doesn't match or is unclear.";
      images = null;
    } else {
      throw Exception('Either image or text proof must be provided');
    }

    final messages = [
      ChatMessage(
        role: "system",
        content:
            "You are a helpful AI assistant that can analyze evidence (images and/or text) to verify contract fulfillment.",
      ),
    ];

    // Add user message with or without images based on what's available
    if (images != null) {
      messages.add(
        ChatMessage(role: "user", content: userPrompt, images: images),
      );
    } else {
      messages.add(ChatMessage(role: "user", content: userPrompt));
    }

    final response = await _cactus!.generateCompletion(
      messages: messages,
      params: CactusCompletionParams(maxTokens: 300),
    );

    return response.response;
  }

  bool isApproved(String response) {
    final upperResponse = response.toUpperCase();

    // Check for explicit YES
    if (upperResponse.contains("YES")) {
      return true;
    }

    // Check for positive approval keywords
    final approvalKeywords = [
      "MATCHES",
      "MATCH",
      "FULFILLS",
      "FULFILLED",
      "APPROVED",
      "SATISFIES",
      "SATISFIED",
      "COMPLIES",
      "MEETS THE REQUIREMENT",
      "MEETS REQUIREMENT",
    ];

    for (final keyword in approvalKeywords) {
      if (upperResponse.contains(keyword)) {
        // Make sure it's not a negative context
        if (!upperResponse.contains("NOT $keyword") &&
            !upperResponse.contains("DOESN'T $keyword") &&
            !upperResponse.contains("DOES NOT $keyword")) {
          return true;
        }
      }
    }

    // Explicit NO means rejection
    if (upperResponse.startsWith("NO")) {
      return false;
    }

    return false;
  }

  /// Parse AI mediation response
  Map<String, dynamic>? parseMediationResponse(String response) {
    try {
      // Try to extract JSON from response (LLM might add extra text)
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonStr = response.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
