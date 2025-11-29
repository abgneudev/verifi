import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cactus/cactus.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

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

  /// Analyze proof image or text against a contract.
  ///
  /// imagePath: local filesystem path if available.
  /// imageBytes: raw bytes of an image (useful when the picker returns a content:// URI or when using XFile.readAsBytes()).
  /// maxDimension: maximum width/height in pixels to resize images to (preserves aspect ratio).
  Future<String> analyzeProof({
    String? imagePath,
    Uint8List? imageBytes,
    String? textProof,
    required String contractText,
    int maxDimension = 1024,
  }) async {
    if (!_isReady || _cactus == null) {
      throw Exception('Cactus AI not ready');
    }

    // If imageBytes provided but imagePath not present, optionally resize/compress and write to temp file
    String? effectiveImagePath = imagePath;
    if (imageBytes != null && (effectiveImagePath == null || effectiveImagePath.isEmpty)) {
      // Resize/compress in background
      final resized = await _resizeAndCompress(imageBytes, maxDimension);
      final tmp = await _writeBytesToTempFile(resized, extension: '.jpg');
      effectiveImagePath = tmp.path;
      // release memory reference to original bytes
      imageBytes = null;
    }

    // If imagePath was provided by the caller, read bytes, resize if necessary, and write temp file to normalize path
    if (effectiveImagePath != null && (imagePath != effectiveImagePath)) {
      // already handled when imageBytes was provided
    } else if (imagePath != null && effectiveImagePath == null) {
      // caller passed a path; ensure file exists and optionally resize/compress
      final originalFile = File(imagePath);
      if (!await originalFile.exists()) {
        throw Exception(
            'Image path does not exist: $imagePath.\nIf you are on Android and have a content:// URI, pass the image bytes (e.g., XFile.readAsBytes()) to analyzeProof using the imageBytes parameter, or copy the file to a local path before calling this method.');
      }
      final bytes = await originalFile.readAsBytes();
      final resized = await _resizeAndCompress(bytes, maxDimension);
      final tmp = await _writeBytesToTempFile(resized, extension: '.jpg');
      effectiveImagePath = tmp.path;
    }

    // If imagePath exists but file missing, try to recover if imageBytes were provided earlier
    if (effectiveImagePath != null) {
      final file = File(effectiveImagePath);
      if (!await file.exists()) {
        // If caller also passed imageBytes, we already handled it above. If not, return helpful error.
        throw Exception(
          'Image path does not exist: $effectiveImagePath.\nIf you are on Android and have a content:// URI or a platform-specific path, pass the image bytes (e.g., XFile.readAsBytes()) to analyzeProof using the imageBytes parameter, or copy the file to a local path before calling this method.');
      }

      // If the file is still larger than the target, attempt a final compression pass
      try {
        final len = await file.length();
        const targetBytes = 5 * 1024 * 1024; // 5 MB target
        if (len > targetBytes) {
          // Read bytes and attempt stronger compression in background
          final bytes = await file.readAsBytes();
          final compressed = await _resizeAndCompress(bytes, maxDimension, targetBytes: targetBytes);
          // overwrite temp file with compressed result
          await file.writeAsBytes(compressed, flush: true);
        }
      } catch (e) {
        // If compression fails, continue — generateCompletion will still run but may fail on very large inputs.
        print('Warning: final compression pass failed: $e');
      }
    }

    // Build the analysis prompt based on what evidence is provided
    String userPrompt;
    List<String>? images;

    // Strong instruction to return a strict, machine-readable JSON
    const jsonInstruction =
        'Respond ONLY with JSON exactly in this shape: {"approved": true|false, "reason": "brief text", "confidence": 0.0-1.0}. Example: {"approved": true, "reason":"Clear photo of a sealed 500ml branded water bottle","confidence":0.95}';

    if (effectiveImagePath != null && textProof != null && textProof.isNotEmpty) {
      // Both image and text provided
      userPrompt =
          "Analyze this image and the following text description to determine if they match the contract requirement: '$contractText'.\n\nText description: '$textProof'\n\n$jsonInstruction";
      images = [effectiveImagePath];
    } else if (effectiveImagePath != null) {
      // Only image provided
      userPrompt =
          "Analyze this image and determine if it matches the contract requirement: '$contractText'.\n\n$jsonInstruction";
      images = [effectiveImagePath];
    } else if (textProof != null && textProof.isNotEmpty) {
      // Only text provided
      userPrompt =
          "Analyze this text description to determine if it matches the contract requirement: '$contractText'.\n\nText description: '$textProof'\n\n$jsonInstruction";
      images = null;
    } else {
      throw Exception('Either image or text proof must be provided');
    }

    final messages = [
      ChatMessage(
        role: "system",
        content:
            "You are a helpful AI assistant that can analyze evidence (images and/or text) to verify contract fulfillment. Be concise and return ONLY the required JSON.",
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

    // Use explicit params for deterministic vision judgement
    final params = CactusCompletionParams(
      model: 'lfm2-vl-450m',
      maxTokens: 300,
      temperature: 0.0,
    );

    CactusCompletionResult response;
    try {
      // Add a timeout to avoid indefinite blocking; catching errors prevents crashes
      response = await _cactus!.generateCompletion(
        messages: messages,
        params: params,
      ).timeout(const Duration(seconds: 60));
    } catch (e, st) {
      // Log error and return structured error JSON so app UI can handle it gracefully
      print('Cactus analyzeProof error: $e\n$st');
      final err = {
        'approved': false,
        'reason': 'AI analysis failed: ${e.toString()}',
        'confidence': 0.0,
      };
      return jsonEncode(err);
    }

    // Log useful debugging info for failures (will appear in device logs)
    try {
      print('Cactus analyzeProof success=${response.success} tokens=${response.totalTokens}');
    } catch (_) {}

    final raw = response.response;

    // Try to extract JSON from the model output and return a normalized JSON string
    final parsed = _tryParseJsonFromString(raw);
    if (parsed != null) {
      return jsonEncode(parsed);
    }

    // If parsing fails, return the raw response so caller can inspect it
    return raw;
  }

  // Helper to write bytes to a temporary file and return the File
  Future<File> _writeBytesToTempFile(Uint8List bytes, {String extension = '.jpg'}) async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/cactus_upload_${DateTime.now().millisecondsSinceEpoch}$extension');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Replace resize/compress helpers with progressive compression implementation
  Future<Uint8List> _resizeAndCompress(Uint8List bytes, int maxDimension, {int? targetBytes}) async {
    final result = await compute(_resizeAndCompressStatic, {
      'bytes': bytes,
      'max': maxDimension,
      'target': targetBytes,
    });
    return result;
  }

  // Top-level handler executed in background isolate — performs resizing and progressive compression until under target size
  Uint8List _resizeAndCompressStatic(Map args) {
    final bytes = args['bytes'] as Uint8List;
    final max = args['max'] as int;
    final target = args['target'] as int?;
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return bytes;
      img.Image image = decoded;

      // Initial resize to maxDimension while preserving aspect ratio
      final width = image.width;
      final height = image.height;
      if (width > max || height > max) {
        final scale = max / (width > height ? width : height);
        final newW = (width * scale).round();
        final newH = (height * scale).round();
        image = img.copyResize(image, width: newW, height: newH, interpolation: img.Interpolation.cubic);
      }

      // Encode with an initial quality
      int quality = 85;
      Uint8List encoded = Uint8List.fromList(img.encodeJpg(image, quality: quality));

      // If no target requested, return the resized jpeg
      if (target == null) return encoded;

      // If already under target, return
      if (encoded.lengthInBytes <= target) return encoded;

      // Try progressively lower qualities
      final qualities = [75, 65, 55, 45, 35, 30];
      for (final q in qualities) {
        encoded = Uint8List.fromList(img.encodeJpg(image, quality: q));
        if (encoded.lengthInBytes <= target) return encoded;
      }

      // If still too large, progressively downscale dimensions and encode at min quality
      int currW = image.width;
      int currH = image.height;
      const minQuality = 30;
      while (encoded.lengthInBytes > target && currW > 200 && currH > 200) {
        currW = (currW * 0.8).round();
        currH = (currH * 0.8).round();
        final smaller = img.copyResize(image, width: currW, height: currH, interpolation: img.Interpolation.cubic);
        encoded = Uint8List.fromList(img.encodeJpg(smaller, quality: minQuality));
        if (encoded.lengthInBytes <= target) return encoded;
        image = smaller; // continue from the smaller image
      }

      // Return best-effort compressed bytes
      return encoded;
    } catch (e) {
      // On error, return original bytes
      return bytes;
    }
  }

  Map<String, dynamic>? _tryParseJsonFromString(String input) {
    try {
      final jsonStart = input.indexOf('{');
      final jsonEnd = input.lastIndexOf('}');
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonStr = input.substring(jsonStart, jsonEnd + 1);
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      // fall through
    }
    return null;
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
