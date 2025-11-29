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

    return '''NEGOTIATION ROUND $draftVersion

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

TASK: Analyze the $respondingRole's response and create a revised contract that:
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

    // Base system message used for text-only requests
    final baseSystemMessages = [
      ChatMessage(
        role: "system",
        content:
            "You are a helpful AI assistant that can analyze evidence (images and/or text) to verify contract fulfillment. Be concise and return ONLY the required JSON.",
      ),
    ];

    // Read bytes of effective image for cropping/ocr
    Uint8List? originalBytes;
    if (effectiveImagePath != null) {
      originalBytes = await File(effectiveImagePath).readAsBytes();
    }

    // Optional OCR-like text extraction using the vision model (avoid adding new native OCR deps)
    String? extractedText;
    if (originalBytes != null) {
      try {
        final ocrMessages = [
          ChatMessage(role: 'system', content: 'You are an image OCR assistant. Extract any readable text from the provided image and return ONLY the JSON {"text": "..."}.'),
          ChatMessage(role: 'user', content: 'Extract visible text from the image and respond with JSON. Do not add any commentary.'),
        ];
        final ocrResp = await _cactus!.generateCompletion(messages: ocrMessages, params: CactusCompletionParams(model: 'lfm2-vl-450m', maxTokens: 200, temperature: 0.0));
        final ocrParsed = _tryParseJsonFromString(ocrResp.response);
        if (ocrParsed != null && ocrParsed['text'] is String) {
          extractedText = ocrParsed['text'] as String;
        } else {
          // fallback: use raw response as text
          extractedText = ocrResp.response;
        }
      } catch (e) {
        print('OCR extraction failed: $e');
      }
    }

    // Generate crops (full + center + small center + top + bottom) to form an ensemble
    List<Uint8List> crops = [];
    if (originalBytes != null) {
      try {
        final cropList = await compute(_generateCropsStatic, {'bytes': originalBytes, 'max': maxDimension});
        crops = List<Uint8List>.from(cropList);
      } catch (e) {
        print('Crop generation failed: $e');
        crops = [originalBytes];
      }
    }

    // Pre-check: run an object-detection style prompt on crops to ensure expected object (e.g., "bottle") is present.
    if (crops.isNotEmpty) {
      bool foundExpected = false;
      for (final cropBytes in crops) {
        try {
          final tmp = await _writeBytesToTempFile(cropBytes, extension: '.jpg');
          final detectMessages = [
            ChatMessage(
              role: 'system',
              content:
                  'You are a strict image object detector. Given an image, return ONLY JSON in the form {"objects": [{"name":"...","confidence":0.0}]}. Do not add commentary.',
            ),
            ChatMessage(
              role: 'user',
              content: 'List all visible objects in the image and their confidence (0-1) as JSON.',
              images: [tmp.path],
            ),
          ];

          final detectParams = CactusCompletionParams(model: 'lfm2-vl-450m', maxTokens: 150, temperature: 0.0, topP: 0.0);
          final detectResp = await _cactus!.generateCompletion(messages: detectMessages, params: detectParams).timeout(const Duration(seconds: 30));
          final detParsed = _tryParseJsonFromString(detectResp.response);
          if (detParsed != null && detParsed['objects'] is List) {
            for (final o in detParsed['objects']) {
              try {
                final name = (o['name'] ?? '').toString().toLowerCase();
                final conf = (o['confidence'] is num) ? (o['confidence'] as num).toDouble() : 0.0;
                if (name.contains('bottle') && conf >= 0.5) {
                  foundExpected = true;
                  break;
                }
              } catch (_) {}
            }
          }
        } catch (e) {
          // ignore and continue with other crops
          print('Object detection failed on crop: $e');
        }
        if (foundExpected) break;
      }

      if (!foundExpected) {
        // No bottle detected in any crop — return a clear rejection so UI can surface it immediately
        final fallback = {
          'approved': false,
          'reason': 'No water bottle detected in provided image evidence. Please upload a clear photo of the product (water bottle).',
          'confidence': 0.0,
        };
        return jsonEncode(fallback);
      }
    }

    // If no crops available and there is textProof, proceed with text-only path
    if (crops.isEmpty && (textProof != null && textProof.isNotEmpty)) {
      userPrompt = "Analyze this text description to determine if it matches the contract requirement: '$contractText'.\n\nText description: '$textProof'\n\n$jsonInstruction";
      images = null;
      final messagesSingle = List<ChatMessage>.from(baseSystemMessages)
        ..add(ChatMessage(role: 'user', content: userPrompt));
      final paramsSingle = CactusCompletionParams(model: 'lfm2-vl-450m', maxTokens: 300, temperature: 0.0, topP: 0.0);
      CactusCompletionResult responseSingle;
      try {
        responseSingle = await _cactus!.generateCompletion(messages: messagesSingle, params: paramsSingle).timeout(const Duration(seconds: 60));
      } catch (e) {
        print('Text-only analysis failed: $e');
        final err = {'approved': false, 'reason': 'AI analysis failed: ${e.toString()}', 'confidence': 0.0};
        return jsonEncode(err);
      }
      final rawSingle = responseSingle.response;
      final parsedSingle = _tryParseJsonFromString(rawSingle);
      if (parsedSingle != null) return jsonEncode(parsedSingle);
      return rawSingle;
    }

    // For image-based ensemble, run analysis on each crop and aggregate
    final results = <Map<String, dynamic>>[];
    final debugRaw = <String>[];
    var idx = 0;
    for (final cropBytes in crops) {
      idx++;
      // write crop to temp file
      final tmpFile = await _writeBytesToTempFile(cropBytes, extension: '.jpg');
      final cropPath = tmpFile.path;

      // Build prompt for this crop, include OCR text if available and textProof
      final sb = StringBuffer();
      sb.writeln("Analyze this image crop (index $idx) and determine if it matches the contract requirement: '$contractText'.");
      if (extractedText != null && extractedText.trim().isNotEmpty) {
        sb.writeln('\nDetected text from image (OCR):');
        sb.writeln('"""');
        sb.writeln(extractedText);
        sb.writeln('"""');
      }
      if (textProof != null && textProof.isNotEmpty) {
        sb.writeln('\nText proof provided:');
        sb.writeln('"""');
        sb.writeln(textProof);
        sb.writeln('"""');
      }
      sb.writeln('\n$jsonInstruction');

      final cropMessages = [
        ChatMessage(role: 'system', content: 'You are an expert visual contract verifier. Answer only with the specified JSON.'),
        ChatMessage(role: 'user', content: sb.toString(), images: [cropPath]),
      ];

      final paramsCrop = CactusCompletionParams(model: 'lfm2-vl-450m', maxTokens: 300, temperature: 0.0, topP: 0.0);
      CactusCompletionResult cropResp;
      try {
        cropResp = await _cactus!.generateCompletion(messages: cropMessages, params: paramsCrop).timeout(const Duration(seconds: 60));
      } catch (e) {
        print('Crop analysis failed for idx $idx: $e');
        debugRaw.add('ERROR: $e');
        results.add({'approved': false, 'confidence': 0.0, 'reason': 'analysis error'});
        continue;
      }

      final cropRaw = cropResp.response;
      debugRaw.add(cropRaw);
      final parsed = _tryParseJsonFromString(cropRaw);
      if (parsed != null) {
        final approved = parsed['approved'] == true;
        final confidence = (parsed['confidence'] is num) ? (parsed['confidence'] as num).toDouble() : (approved ? 0.75 : 0.25);
        final reason = parsed['reason']?.toString() ?? '';
        results.add({'approved': approved, 'confidence': confidence, 'reason': reason});
      } else {
        // Fallback to keyword heuristics
        final approved = isApproved(cropRaw);
        results.add({'approved': approved, 'confidence': approved ? 0.6 : 0.2, 'reason': cropRaw});
      }
    }

    // Aggregate results
    final voteCount = results.length;
    final votesFor = results.where((r) => r['approved'] == true).length;
    final avgConfidence = results.map((r) => r['confidence'] as double).fold(0.0, (a, b) => a + b) / (voteCount == 0 ? 1 : voteCount);
    final approvedFinal = votesFor > (voteCount / 2);
    final reasons = results.map((r) => r['reason']?.toString() ?? '').where((s) => s.isNotEmpty).toList();

    final aggregated = {
      'approved': approvedFinal,
      'confidence': double.parse(avgConfidence.toStringAsFixed(2)),
      'votes': results,
      'votesFor': votesFor,
      'voteCount': voteCount,
      'reasons': reasons,
      'ocrText': extractedText ?? '',
      'debug': debugRaw,
    };

    return jsonEncode(aggregated);
  }

  /// Assess pricing and return structured JSON with fields:
  /// { isAnomalous: bool, marketPrice: number|null, proposedPrice: number, marginPercent: number, suggestedPrice: number|null, confidence: 0-1, reasons: [string] }
  Future<Map<String, dynamic>?> assessPricing({required String contractText}) async {
    if (!_isReady || _cactus == null) {
      print('Pricing assessment requested but Cactus AI not ready: isReady=$_isReady');
      return null;
    }

    // Short system prompt and clear JSON schema
    final system = ChatMessage(
      role: 'system',
      content:
          'You are a pricing analysis assistant. Given a contract text describing an item and price, determine if the proposed price is anomalous compared to typical market value. Return ONLY a JSON object matching the schema: {"type":"pricing_assessment","isAnomalous":true|false,"marketPrice":number|null,"proposedPrice":number,"marginPercent":number,"suggestedPrice":number|null,"confidence":0.0-1.0,"reasons":["..."]}.' ,
    );

    final user = ChatMessage(
      role: 'user',
      content:
          'Analyze this contract text and respond with the JSON schema exactly. Contract:\n"""\n$contractText\n"""',
    );

    final params = CactusCompletionParams(
      model: 'lfm2-vl-450m',
      maxTokens: 300,
      temperature: 0.0,
      topP: 0.0,
    );

    try {
      print('Pricing assessment: sending request to model...');
      final res = await _cactus!
          .generateCompletion(messages: [system, user], params: params)
          .timeout(const Duration(seconds: 60));

      print('Pricing assessment raw response: ${res.response}');

      final parsed = _tryParseJsonFromString(res.response);
      if (parsed != null && parsed['type'] == 'pricing_assessment') {
        print('Pricing assessment parsed JSON OK: $parsed');
        return Map<String, dynamic>.from(parsed);
      }

      // If model didn't return valid JSON, log and fall back to heuristic
      print('Pricing assessment: model returned unparsable output, falling back to heuristic');
    } catch (e, st) {
      print('Pricing assessment failed: $e\n$st');
    }

    // Fallback heuristic: extract numeric price and create a conservative assessment
    try {
      final priceRegexes = [
        RegExp(r"USD\s*([0-9]{1,7}(?:\.[0-9]{1,2})?)", caseSensitive: false),
        RegExp(r"\$([0-9]{1,7}(?:\.[0-9]{1,2})?)"),
        RegExp(r"([0-9]{1,7}(?:\.[0-9]{1,2})?)\s*USD", caseSensitive: false),
        RegExp(r"([0-9]{1,7}(?:\.[0-9]{1,2})?)\s*(?:dollars|usd|us\$)", caseSensitive: false),
        RegExp(r"\b([0-9]{1,7}(?:\.[0-9]{1,2})?)\b"),
      ];
      double? proposed;
      for (final r in priceRegexes) {
        final m = r.firstMatch(contractText);
        if (m != null) {
          final group = m.group(1) ?? m.group(0);
          if (group != null) {
            final cleaned = group.replaceAll(RegExp(r'[^0-9.]'), '');
            proposed = double.tryParse(cleaned);
            if (proposed != null) break;
          }
        }
      }

      if (proposed == null) {
        print('Pricing heuristic: no numeric price found in text');
        return null;
      }

      // Simple market estimate: assume marketPrice ~= proposed * 0.9 (conservative)
      final marketEstimate = (proposed * 0.9);
      final marginPercent = ((proposed - marketEstimate) / (marketEstimate == 0 ? 1 : marketEstimate)) * 100;
      final suggestedPrice = double.parse((marketEstimate).toStringAsFixed(2));
      final isAnomalous = marginPercent.abs() >= 20.0; // flag if >20% deviation

      final fallback = {
        'type': 'pricing_assessment',
        'isAnomalous': isAnomalous,
        'marketPrice': double.parse(marketEstimate.toStringAsFixed(2)),
        'proposedPrice': double.parse(proposed.toStringAsFixed(2)),
        'marginPercent': double.parse(marginPercent.toStringAsFixed(1)),
        'suggestedPrice': suggestedPrice,
        'confidence': 0.45, // conservative confidence for heuristic
        'reasons': [
          'Fallback heuristic: extracted numeric price from text',
          'Conservative market estimate = 90% of proposed price',
        ],
      };

      print('Pricing heuristic result: $fallback');
      return fallback;
    } catch (e, st) {
      print('Pricing heuristic failed: $e\n$st');
      return null;
    }
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

// Top-level helper to generate multiple crops in background
List<Uint8List> _generateCropsStatic(Map args) {
  final bytes = args['bytes'] as Uint8List;
  final max = args['max'] as int;
  try {
    final image = img.decodeImage(bytes);
    if (image == null) return [bytes];

    // Resize large image to max dimension first while preserving aspect
    final width = image.width;
    final height = image.height;
    img.Image base = image;
    if (width > max || height > max) {
      final scale = max / (width > height ? width : height);
      final newW = (width * scale).round();
      final newH = (height * scale).round();
      base = img.copyResize(image, width: newW, height: newH, interpolation: img.Interpolation.cubic);
    }

    final crops = <Uint8List>[];
    // Full image
    crops.add(Uint8List.fromList(img.encodeJpg(base, quality: 85)));

    final w = base.width;
    final h = base.height;

    // Center crop 60%
    final cW1 = (w * 0.6).round();
    final cH1 = (h * 0.6).round();
    final x1 = ((w - cW1) / 2).round();
    final y1 = ((h - cH1) / 2).round();
    final center60 = img.copyCrop(base, x: x1, y: y1, width: cW1, height: cH1);
    crops.add(Uint8List.fromList(img.encodeJpg(center60, quality: 85)));

    // Center crop 30%
    final cW2 = (w * 0.3).round();
    final cH2 = (h * 0.3).round();
    final x2 = ((w - cW2) / 2).round();
    final y2 = ((h - cH2) / 2).round();
    final center30 = img.copyCrop(base, x: x2, y: y2, width: cW2, height: cH2);
    crops.add(Uint8List.fromList(img.encodeJpg(center30, quality: 85)));

    // Top half
    final top = img.copyCrop(base, x: 0, y: 0, width: w, height: (h / 2).round());
    crops.add(Uint8List.fromList(img.encodeJpg(top, quality: 85)));

    // Bottom half
    final bottom = img.copyCrop(base, x: 0, y: (h / 2).round(), width: w, height: h - (h / 2).round());
    crops.add(Uint8List.fromList(img.encodeJpg(bottom, quality: 85)));

    return crops;
  } catch (e) {
    return [bytes];
  }
}
