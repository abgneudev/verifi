import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../models/contract_state.dart';
import '../models/escrow_state.dart';
import '../models/ai_consensus_state.dart';
import '../models/connection_state.dart' as conn;
import '../services/cactus_ai_service.dart';
import '../services/contract_service.dart';
import '../services/crypto_service.dart';
import '../services/nearby_connections_service.dart';

// Service Providers
final cryptoServiceProvider = Provider((ref) => CryptoService());
final contractServiceProvider = Provider((ref) => ContractService());
final cactusAIServiceProvider = Provider((ref) => CactusAIService());
final nearbyConnectionsServiceProvider = Provider(
  (ref) => NearbyConnectionsService(),
);
final imagePickerProvider = Provider((ref) => ImagePicker());

// State Providers
final connectionStateProvider =
    StateNotifierProvider<ConnectionStateNotifier, conn.AppConnectionState>(
      (ref) => ConnectionStateNotifier(ref),
    );
final contractStateProvider =
    StateNotifierProvider<ContractStateNotifier, ContractState>(
      (ref) => ContractStateNotifier(ref),
    );

final escrowStateProvider =
    StateNotifierProvider<EscrowStateNotifier, EscrowState>(
      (ref) => EscrowStateNotifier(ref),
    );

final aiConsensusStateProvider =
    StateNotifierProvider<AIConsensusStateNotifier, AIConsensusState>(
      (ref) => AIConsensusStateNotifier(ref),
    );

final walletStateProvider = StateNotifierProvider<WalletStateNotifier, WalletState>((ref) => WalletStateNotifier());

// Connection State Notifier
class ConnectionStateNotifier extends StateNotifier<conn.AppConnectionState> {
  ConnectionStateNotifier(this.ref) : super(conn.initialConnectionState) {
    _initialize();
  }

  final Ref ref;

  Future<void> _initialize() async {
    final cryptoService = ref.read(cryptoServiceProvider);
    final cactusService = ref.read(cactusAIServiceProvider);

    try {
      await cryptoService.generateKeys();
      updateLog("✅ Keys Generated.\nReady to Connect.");

      updateLog("🧠 Initializing Cactus AI...");
      await cactusService.initialize();
      updateLog("✅ Keys Generated.\n🧠 Cactus AI Ready.\nReady to Connect.");
    } catch (e) {
      updateLog("❌ Initialization Failed: $e");
    }
  }

  void updateLog(String message) {
    debugPrint(message);
    state = state.copyWith(logText: message);
  }

  Future<void> startAdvertising() async {
    final nearbyService = ref.read(nearbyConnectionsServiceProvider);
    updateLog("📡 Advertising as Tourist (Sender)...");

    state = state.copyWith(
      status: conn.ConnectionStatus.advertising,
      isAdvertiser: true,
    );

    final success = await nearbyService.startAdvertising(
      userName: "Send",
      onConnectionInit: _onConnectionInit,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );

    if (!success) {
      updateLog("Failed to start advertising");
      state = state.copyWith(status: conn.ConnectionStatus.disconnected);
    }
  }

  Future<void> startDiscovery() async {
    final nearbyService = ref.read(nearbyConnectionsServiceProvider);
    updateLog("🔍 Searching for Send...");

    state = state.copyWith(
      status: conn.ConnectionStatus.discovering,
      isAdvertiser: false,
    );

    final success = await nearbyService.startDiscovery(
      userName: "Receive",
      onEndpointFound: (id, name, serviceId) {
        updateLog("Found $name. Connecting...");
      },
      onEndpointLost: (id) {
        updateLog("Lost connection to endpoint $id");
      },
      onConnectionInit: _onConnectionInit,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );

    if (!success) {
      updateLog("Failed to start discovery");
      state = state.copyWith(status: conn.ConnectionStatus.disconnected);
    }
  }

  void _onConnectionInit(String id, ConnectionInfo info) {
    final nearbyService = ref.read(nearbyConnectionsServiceProvider);
    updateLog("Connecting to ${info.endpointName}...");

    // Accept the connection - but don't send messages yet!
    nearbyService.acceptConnection(id, _onPayloadReceived);
  }

  void _onConnectionResult(String id, Status status) {
    if (status == Status.CONNECTED) {
      updateLog("✅ Connected successfully!");

      state = state.copyWith(
        connectedEndpointId: id,
        status: conn.ConnectionStatus.connected,
      );

      // Now that we're connected, set up roles and send initial message
      // Advertiser (Send button) = Buyer (sends money)
      // Discoverer (Receive button) = Seller (receives money)
      debugPrint('🔍 Role assignment: isAdvertiser=${state.isAdvertiser}');
      if (state.isAdvertiser) {
        debugPrint('   → Assigning BUYER role (Send button was clicked)');
        ref
            .read(contractStateProvider.notifier)
            .initializeAsRole(UserRole.buyer);
      } else {
        debugPrint('   → Assigning SELLER role (Receive button was clicked)');
        ref
            .read(contractStateProvider.notifier)
            .initializeAsRole(UserRole.seller);
      }
    } else {
      updateLog("❌ Connection failed: $status");
      state = state.copyWith(status: conn.ConnectionStatus.disconnected);
    }
  }

  void _onDisconnected(String id) {
    state = state.copyWith(
      connectedEndpointId: null,
      status: conn.ConnectionStatus.disconnected,
    );
    updateLog("Disconnected from endpoint");
  }

  Future<void> _onPayloadReceived(String endId, Payload payload) async {
    if (payload.bytes == null) return;

    final bytes = payload.bytes!;

    debugPrint('📨 Received payload from $endId, size: ${bytes.length} bytes');

    // Try JSON first
    try {
      final jsonString = utf8.decode(bytes);
      final data = jsonDecode(jsonString);
      debugPrint('📦 Decoded message type: ${data["type"]}');

      if (data["type"] == "ROLE_SETUP") {
        ref
            .read(contractStateProvider.notifier)
            .setupRoles(isSeller: data["isSeller"] as bool);
        updateLog(
          "🤝 Roles established: ${data["isSeller"] ? 'You are BUYER' : 'You are SELLER'}",
        );
        return;
      }

      if (data["type"] == "DRAFT_PROPOSAL") {
        await ref
            .read(contractStateProvider.notifier)
            .receiveDraftProposal(
              version: data["version"] as int,
              text: data["text"] as String,
              proposedBy: data["proposedBy"] as String,
              aiSuggestion: data["aiSuggestion"] as String?,
            );
        updateLog("📝 New draft v${data["version"]} received from peer.");
        return;
      }

      if (data["type"] == "AGREEMENT") {
        ref.read(contractStateProvider.notifier).receiveAgreement();
        updateLog("✅ Peer agreed to current draft!");
        return;
      }

      if (data["type"] == "FINALIZE") {
        await ref
            .read(contractStateProvider.notifier)
            .receivePeerFinalization(
              peerHash: data["hash"],
              signature: data["signature"],
              publicKey: data["publicKey"],
            );
        return;
      }

      if (data["type"] == "ESCROW_DEPOSITED") {
        ref.read(contractStateProvider.notifier).receiveEscrowDeposited();
        return;
      }

      if (data["type"] == "DELIVERY_CONFIRMED") {
        ref.read(contractStateProvider.notifier).receiveDeliveryConfirmed();
        return;
      }

      if (data["type"] == "PROOF_SUBMITTED") {
        ref
            .read(contractStateProvider.notifier)
            .receiveProofSubmission(
              textProof: data["textProof"] as String,
              hasImage: data["hasImage"] as bool,
              aiAnalysis: data["aiAnalysis"] as String,
              aiApproved: data["aiApproved"] as bool,
            );
        return;
      }

      if (data["type"] == "BUYER_APPROVED_DELIVERY") {
        ref.read(contractStateProvider.notifier).receiveBuyerApproval();
        return;
      }

      if (data["type"] == "PROOF_SUBMISSION") {
        updateLog("📨 Received proof payload from peer. Running AI check...");
        await ref
            .read(aiConsensusStateProvider.notifier)
            .receivePeerProof(
              textProof: data["textProof"] as String?,
              imageData: data["imageData"] as String?,
              imageExtension: data["imageExtension"] as String?,
            );
        return;
      }

      if (data["type"] == "AI_VOTE" && data["verdict"] == "YES") {
        updateLog("📨 Received AI vote from peer...");
        await ref
            .read(aiConsensusStateProvider.notifier)
            .receivePeerVote(
              voteData: data["voteData"],
              signature: data["signature"],
              publicKey: data["publicKey"],
            );
        return;
      }
    } catch (e) {
      // Not JSON, might be old format
    }

    // Handle escrow lock message
    if (bytes.length > 96) {
      await ref.read(escrowStateProvider.notifier).receiveLockedFunds(bytes);
    }
  }

  void sendMessage(Map<String, dynamic> data) {
    if (state.connectedEndpointId == null) {
      debugPrint('❌ Cannot send message - no connected endpoint!');
      updateLog("❌ Cannot send message - not connected to peer!");
      return;
    }

    debugPrint(
      '📤 Sending message type: ${data["type"]} to endpoint: ${state.connectedEndpointId}',
    );
    final nearbyService = ref.read(nearbyConnectionsServiceProvider);
    nearbyService.sendJsonPayload(state.connectedEndpointId!, data);
    debugPrint('✅ Message sent successfully');
  }

  void sendBytes(Uint8List bytes) {
    if (state.connectedEndpointId == null) return;

    final nearbyService = ref.read(nearbyConnectionsServiceProvider);
    nearbyService.sendBytesPayload(state.connectedEndpointId!, bytes);
  }
}

// Contract State Notifier
class ContractStateNotifier extends StateNotifier<ContractState> {
  ContractStateNotifier(this.ref) : super(initialContractState);

  final Ref ref;

  /// Set up roles after connection
  void setupRoles({required bool isSeller}) {
    // isSeller indicates the SENDER's role, so we assign the OPPOSITE role
    final myRole = isSeller ? UserRole.buyer : UserRole.seller;
    debugPrint(
      '🔄 setupRoles: sender is ${isSeller ? "SELLER" : "BUYER"}, so I am ${myRole == UserRole.seller ? "SELLER" : "BUYER"}',
    );
    state = state.copyWith(
      myRole: myRole,
      status: myRole == UserRole.seller
          ? NegotiationStatus.awaitingMyResponse
          : NegotiationStatus.awaitingPeerResponse,
    );
  }

  /// Initialize roles when advertising (seller) or discovering (buyer)
  void initializeAsRole(UserRole role) {
    state = state.copyWith(myRole: role);

    // If seller, ready to create initial draft
    if (role == UserRole.seller) {
      state = state.copyWith(status: NegotiationStatus.awaitingMyResponse);
    } else {
      state = state.copyWith(status: NegotiationStatus.awaitingPeerResponse);
    }

    // Notify peer of role setup
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "ROLE_SETUP",
      "isSeller": role == UserRole.seller,
    });
  }

  /// User submits their response (initial draft or counter-proposal)
  Future<void> submitResponse(String userInput) async {
    if (userInput.isEmpty) return;

    final contractService = ref.read(contractServiceProvider);
    final cactusService = ref.read(cactusAIServiceProvider);

    // Check if user is agreeing to current draft
    if (state.currentDraft != null &&
        contractService.shouldMoveToApproval(
          userInput: userInput,
          currentDraftText: state.currentDraft!.text,
        )) {
      // User agrees!
      _handleAgreement();
      return;
    }

    // If this is the first draft (seller)
    if (state.currentDraft == null && state.myRole == UserRole.seller) {
      final initialDraft = contractService.createInitialDraft(userInput);
      state = state.copyWith(
        currentDraft: initialDraft,
        draftHistory: [initialDraft],
        status: NegotiationStatus.awaitingPeerResponse,
      );

      // Append chat message representing this draft
      final msg = NegotiationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.contract,
        text: initialDraft.text,
        senderRole: state.myRole,
        senderName: null,
        attachments: [],
        timestamp: DateTime.now(),
        aiAnalysis: null,
      );
      state = state.copyWith(messages: [...state.messages, msg]);

      // Send to peer
      ref.read(connectionStateProvider.notifier).sendMessage({
        "type": "DRAFT_PROPOSAL",
        "version": initialDraft.version,
        "text": initialDraft.text,
        "proposedBy": "seller",
        "aiSuggestion": null,
      });

      ref
          .read(connectionStateProvider.notifier)
          .updateLog("📝 Initial draft v1 sent to buyer.");
      return;
    }

    // This is a counter-proposal - invoke AI mediation
    if (state.currentDraft != null && cactusService.isReady) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("🧠 AI analyzing negotiation...");

      try {
        final response = await cactusService.mediateContractNegotiation(
          currentDraft: state.currentDraft!.text,
          userResponse: userInput,
          respondingRole: state.myRole == UserRole.seller ? 'seller' : 'buyer',
          draftVersion: state.currentDraft!.version,
          previousVersions: state.draftHistory.map((d) => d.text).toList(),
        );

        final parsed = cactusService.parseMediationResponse(response);

        if (parsed != null && parsed['revisedContract'] != null) {
          final newDraft = contractService.createCounterProposal(
            currentDraft: state.currentDraft!,
            newText: parsed['revisedContract'] as String,
            proposedBy: state.myRole!,
            aiSuggestion: parsed['reasoning'] as String?,
          );

          final updatedHistory = [...state.draftHistory, newDraft];

          state = state.copyWith(
            currentDraft: newDraft,
            draftHistory: updatedHistory,
            status: NegotiationStatus.awaitingPeerResponse,
            aiMediation: parsed['analysis'] as String?,
          );

          // Send to peer
          ref.read(connectionStateProvider.notifier).sendMessage({
            "type": "DRAFT_PROPOSAL",
            "version": newDraft.version,
            "text": newDraft.text,
            "proposedBy": state.myRole == UserRole.seller ? "seller" : "buyer",
            "aiSuggestion": parsed['reasoning'] as String?,
          });

          ref
              .read(connectionStateProvider.notifier)
              .updateLog(
                "📝 AI-mediated draft v${newDraft.version} sent.\n${parsed['analysis']}",
              );

          // Check convergence
          final convergence = parsed['convergenceEstimate'];
          if (convergence is int && convergence >= 5) {
            ref
                .read(connectionStateProvider.notifier)
                .updateLog("🎯 AI predicts agreement is near!");
          }
        } else {
          // Fallback if AI parsing fails
          _sendDirectCounterProposal(userInput);
        }
      } catch (e) {
        ref
            .read(connectionStateProvider.notifier)
            .updateLog("⚠️ AI mediation failed: $e. Sending direct proposal.");
        _sendDirectCounterProposal(userInput);
      }
    } else {
      // AI not ready or no current draft - send direct
      _sendDirectCounterProposal(userInput);
    }
  }

  void _sendDirectCounterProposal(String userInput) {
    final contractService = ref.read(contractServiceProvider);

    final newDraft = contractService.createCounterProposal(
      currentDraft: state.currentDraft!,
      newText: userInput,
      proposedBy: state.myRole!,
    );

    final updatedHistory = [...state.draftHistory, newDraft];

    state = state.copyWith(
      currentDraft: newDraft,
      draftHistory: updatedHistory,
      status: NegotiationStatus.awaitingPeerResponse,
    );

    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "DRAFT_PROPOSAL",
      "version": newDraft.version,
      "text": newDraft.text,
      "proposedBy": state.myRole == UserRole.seller ? "seller" : "buyer",
      "aiSuggestion": null,
    });
  }

  /// Receive draft proposal from peer
  Future<void> receiveDraftProposal({
    required int version,
    required String text,
    required String proposedBy,
    String? aiSuggestion,
  }) async {
    final role = proposedBy == "seller" ? UserRole.seller : UserRole.buyer;
    final draft = ContractDraft(
      version: version,
      text: text,
      proposedBy: role,
      timestamp: DateTime.now(),
      aiSuggestion: aiSuggestion,
    );

    final updatedHistory = [...state.draftHistory, draft];

    state = state.copyWith(
      currentDraft: draft,
      draftHistory: updatedHistory,
      status: NegotiationStatus.awaitingMyResponse,
      aiMediation: aiSuggestion,
    );

    // Append chat message for this incoming draft
    final incomingMsg = NegotiationMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.contract,
      text: text,
      senderRole: role,
      senderName: null,
      attachments: [],
      timestamp: DateTime.now(),
      aiAnalysis: null,
    );
    state = state.copyWith(messages: [...state.messages, incomingMsg]);

    // Run AI pricing assessment in background and insert AI moderation message
    final cactus = ref.read(cactusAIServiceProvider);
    if (cactus.isReady) {
      cactus.assessPricing(contractText: text).then((assessment) {
        if (assessment != null) {
          // Build follow-up questions to help buyer/seller collect missing info
          final List<String> followUps = [];

          // If AI indicates more info is required, convert missing fields into user-facing prompts
          if (assessment['needs_more_info'] == true) {
            final missing = assessment['missing_fields'] as List<dynamic>?;
            if (missing != null && missing.isNotEmpty) {
              for (var f in missing) {
                final key = f.toString().toLowerCase();
                if (key.contains('weight') || key == 'weight') {
                  followUps.add('Provide weight (e.g., 5 kg) or count (e.g., 10 apples).');
                } else if (key.contains('variety') || key == 'variety') {
                  followUps.add('Specify variety (e.g., Granny Smith, Fuji).');
                } else if (key.contains('label') || key == 'label') {
                  followUps.add('Upload a photo that clearly shows the product label/packaging.');
                } else if (key.contains('size') || key == 'size') {
                  followUps.add('Indicate size or dimensions (e.g., 500 ml, 1 L).');
                } else if (key.contains('condition') || key == 'condition') {
                  followUps.add('Describe condition/grade (e.g., Grade A, bruised, like-new).');
                } else {
                  followUps.add('Provide $f.');
                }
              }
            } else {
              followUps.add('Please provide clear images, weight/size, and label/variety information.');
            }
          }

          // Add prompts when AI confidence is low
          final confidence = (assessment['confidence'] is num) ? (assessment['confidence'] as num).toDouble() : null;
          if (confidence == null || confidence < 0.7) {
            followUps.add('Add clearer photos (top/side/scale) and explicit weight/size to increase AI confidence.');
          }

          // Category-specific guidance inferred from contract text
          final lc = text.toLowerCase();
          if (lc.contains('apple') || lc.contains('apples')) {
            followUps.add('For apples: specify variety, weight or count, and condition (grade).');
          } else if (lc.contains('bottle')) {
            followUps.add('For bottles: specify capacity (e.g., 500 ml), unopened vs opened, and show label/brand.');
          }

          // Compose message text including follow-up action suggestions
          final summaryText = (assessment['isAnomalous'] == true)
              ? 'AI: Pricing looks anomalous. Suggested: \$${assessment['suggestedPrice']} (confidence ${assessment['confidence']}).'
              : 'AI: Pricing appears reasonable (confidence ${assessment['confidence']}).';

          final followText = followUps.isNotEmpty
              ? '\nSuggested follow-up questions:\n' + followUps.map((q) => '- $q').join('\n')
              : '';

          final analysis = Map<String, dynamic>.from(assessment);
          analysis['followUpQuestions'] = followUps;

          final aiMsg = NegotiationMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: MessageType.ai,
            text: summaryText + followText,
            senderRole: null,
            senderName: 'AI Moderator',
            attachments: [],
            timestamp: DateTime.now(),
            aiAnalysis: analysis,
          );

          state = state.copyWith(messages: [...state.messages, aiMsg]);
        }
      });
    }
  }

  /// Handle agreement from user
  void _handleAgreement() {
    state = state.copyWith(status: NegotiationStatus.agreed);

    // Notify peer
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "AGREEMENT",
    });

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("✅ You agreed to draft v${state.currentDraft?.version}!");
  }

  /// Receive agreement from peer
  void receiveAgreement() {
    state = state.copyWith(status: NegotiationStatus.agreed);
  }

  /// Finalize the contract with cryptographic commitment
  Future<void> finalizeContract() async {
    if (state.currentDraft == null ||
        state.status != NegotiationStatus.agreed) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Contract must be agreed upon first!");
      return;
    }

    final contractService = ref.read(contractServiceProvider);
    final cryptoService = ref.read(cryptoServiceProvider);

    final hash = contractService.generateHash(state.currentDraft!.text);
    final signature = await cryptoService.sign(utf8.encode(hash));
    final pubKey = await cryptoService.getPublicKey();

    state = state.copyWith(finalHash: hash, myApproval: true);

    // Send to peer
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "FINALIZE",
      "hash": hash,
      "signature": base64Encode(signature.bytes),
      "publicKey": base64Encode(pubKey.bytes),
    });

    ref
        .read(connectionStateProvider.notifier)
        .updateLog(
          "✅ Contract finalized on my side.\nHash: ${hash.substring(0, 16)}...",
        );

    _checkIfLocked();
  }

  Future<void> receivePeerFinalization({
    required String peerHash,
    required String signature,
    required String publicKey,
  }) async {
    final contractService = ref.read(contractServiceProvider);

    // Generate our hash if not done
    String? ourHash = state.finalHash;
    if (ourHash == null && state.currentDraft != null) {
      ourHash = contractService.generateHash(state.currentDraft!.text);
      state = state.copyWith(finalHash: ourHash);
    }

    if (ourHash == peerHash) {
      state = state.copyWith(peerApproval: true);
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("✅ Peer finalized contract. Hash matches!");

      _checkIfLocked();
    } else {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Hash mismatch! Contract text differs.");
    }
  }

  void _checkIfLocked() {
    if (state.myApproval && state.peerApproval) {
      state = state.copyWith(
        isFinalized: true,
        status: NegotiationStatus.finalized,
        currentStep: TransactionStep.escrow,
      );
      ref
          .read(connectionStateProvider.notifier)
          .updateLog(
            "🔒 CONTRACT LOCKED! Both parties agreed.\nHash: ${state.finalHash!.substring(0, 16)}...",
          );
    }
  }

  /// Mark escrow as deposited and move to delivery step
  void markEscrowDeposited() {
    state = state.copyWith(
      escrowDeposited: true,
      currentStep: TransactionStep.delivery,
    );
    ref
        .read(connectionStateProvider.notifier)
        .updateLog("💰 Escrow deposited. Proceeding to delivery...");

    // Notify peer
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "ESCROW_DEPOSITED",
    });
  }

  /// Receive escrow deposited notification from peer
  void receiveEscrowDeposited() {
    state = state.copyWith(
      escrowDeposited: true,
      currentStep: TransactionStep.delivery,
    );
    ref
        .read(connectionStateProvider.notifier)
        .updateLog("💰 Peer deposited to escrow!");
  }

  /// Mark delivery as confirmed
  void markDeliveryConfirmed() {
    state = state.copyWith(
      deliveryConfirmed: true,
      currentStep: TransactionStep.completed,
    );
    ref
        .read(connectionStateProvider.notifier)
        .updateLog("✅ Delivery confirmed! Transaction complete.");

    // Notify peer
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "DELIVERY_CONFIRMED",
    });
  }

  /// Receive delivery confirmation from peer
  void receiveDeliveryConfirmed() {
    state = state.copyWith(
      deliveryConfirmed: true,
      currentStep: TransactionStep.completed,
    );
    ref
        .read(connectionStateProvider.notifier)
        .updateLog("✅ Peer confirmed delivery! Transaction complete.");
  }

  /// Seller submits proof of work completion
  Future<void> submitProof({String? textProof, String? imagePath}) async {
    if (state.currentDraft == null) {
      throw Exception('No contract to verify against');
    }

    final cactusService = ref.read(cactusAIServiceProvider);

    // Analyze proof using Cactus AI
    debugPrint('🔍 Analyzing proof with Cactus AI...');
    final analysis = await cactusService.analyzeProof(
      imagePath: imagePath,
      textProof: textProof,
      contractText: state.currentDraft!.text,
    );

    debugPrint('🤖 AI Analysis: $analysis');

    final isApproved = cactusService.isApproved(analysis);

    state = state.copyWith(
      proofSubmitted: true,
      proofText: textProof,
      proofImagePath: imagePath,
      aiProofAnalysis: analysis,
      aiApprovedProof: isApproved,
      proofSubmittedAt: DateTime.now(),
    );

    // Notify buyer about proof submission
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "PROOF_SUBMITTED",
      "textProof": textProof ?? '',
      "hasImage": imagePath != null,
      "aiAnalysis": analysis,
      "aiApproved": isApproved,
    });

    ref
        .read(connectionStateProvider.notifier)
        .updateLog(
          isApproved
              ? "✅ Proof submitted! AI approved."
              : "⚠️ Proof submitted but AI has concerns.",
        );
  }

  /// Receive proof submission notification from seller
  void receiveProofSubmission({
    required String textProof,
    required bool hasImage,
    required String aiAnalysis,
    required bool aiApproved,
  }) {
    state = state.copyWith(
      proofSubmitted: true,
      proofText: textProof,
      aiProofAnalysis: aiAnalysis,
      aiApprovedProof: aiApproved,
      proofSubmittedAt: DateTime.now(),
    );

    ref
        .read(connectionStateProvider.notifier)
        .updateLog(
          aiApproved
              ? "📦 Seller submitted proof. AI approved! Review to confirm."
              : "📦 Seller submitted proof. AI has concerns. Please review.",
        );
  }

  /// Buyer approves delivery after reviewing proof
  void buyerApprovesDelivery() {
    state = state.copyWith(
      buyerApprovedDelivery: true,
      deliveryConfirmed: true,
      currentStep: TransactionStep.completed,
    );

    // Transfer funds locally: buyer should deduct their wallet balance
    final escrow = ref.read(escrowStateProvider);
    final amount = escrow.amount;
    try {
      final myRole = ref.read(contractStateProvider).myRole;
      final bool iAmBuyer = myRole == UserRole.buyer;
      // If I'm the buyer, deduct my balance. (Seller will credit on receiveBuyerApproval.)
      ref.read(walletStateProvider.notifier).applyBuyerToVendorTransfer(iAmBuyer: iAmBuyer, amount: amount);
    } catch (e) {
      debugPrint('⚠️ Wallet transfer failed locally: $e');
    }

    // Notify seller
    ref.read(connectionStateProvider.notifier).sendMessage({
      "type": "BUYER_APPROVED_DELIVERY",
    });

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("✅ You approved delivery! Funds released to seller.");
  }

  /// Seller receives buyer approval
  void receiveBuyerApproval() {
    state = state.copyWith(
      buyerApprovedDelivery: true,
      deliveryConfirmed: true,
      currentStep: TransactionStep.completed,
    );

    // Transfer funds locally: seller should credit their wallet
    final escrow = ref.read(escrowStateProvider);
    final amount = escrow.amount;
    try {
      final myRole = ref.read(contractStateProvider).myRole;
      final bool iAmBuyer = myRole == UserRole.buyer;
      // If I'm the seller (iAmBuyer==false), credit my balance.
      ref.read(walletStateProvider.notifier).applyBuyerToVendorTransfer(iAmBuyer: iAmBuyer, amount: amount);
    } catch (e) {
      debugPrint('⚠️ Wallet transfer failed locally on receive: $e');
    }

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("✅ Buyer approved delivery! Funds released.");
  }

  /// Reset proof submission to allow resubmission (when AI rejects)
  void resetProofSubmission() {
    state = state.copyWith(
      proofSubmitted: false,
      proofText: null,
      proofImagePath: null,
      aiProofAnalysis: null,
      aiApprovedProof: false,
      proofSubmittedAt: null,
    );

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("🔄 Proof submission reset. Please resubmit.");
  }

  /// Create and apply an AI suggested counter-proposal (by suggested price)
  void applyAISuggestion(num suggestedPrice) {
    if (state.currentDraft == null || state.myRole == null) return;

    final contractService = ref.read(contractServiceProvider);

    // Improved price extraction to support multiple formats
    final currentText = state.currentDraft!.text;
    String? originalFound;

    // Patterns to try in order
    final patterns = [
      RegExp(r"USD\s*([0-9]{1,6}(?:\.[0-9]{1,2})?)", caseSensitive: false),
      RegExp(r"\$([0-9]{1,6}(?:\.[0-9]{1,2})?)"),
      RegExp(r"([0-9]{1,6}(?:\.[0-9]{1,2})?)\s*USD", caseSensitive: false),
      RegExp(r"([0-9]{1,6}(?:\.[0-9]{1,2})?)\s*(?:dollars|usd|us\$)", caseSensitive: false),
      RegExp(r"\b([0-9]{1,6}(?:\.[0-9]{1,2})?)\b"),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(currentText);
      if (m != null) {
        originalFound = m.group(0);
        break;
      }
    }

    String newText;
    if (originalFound != null) {
      // Replace only the first occurrence to avoid accidental multiple replacements
      newText = currentText.replaceFirst(originalFound, '\$${suggestedPrice.toStringAsFixed(2)}');
    } else {
      newText = '${currentText.trim()} Price: \$${suggestedPrice.toStringAsFixed(2)}';
    }

    final newDraft = contractService.createCounterProposal(
      currentDraft: state.currentDraft!,
      newText: newText,
      proposedBy: state.myRole!,
      aiSuggestion: 'Applied AI suggested price: \$${suggestedPrice.toStringAsFixed(2)}',
    );

    final updatedHistory = [...state.draftHistory, newDraft];

    state = state.copyWith(
      currentDraft: newDraft,
      draftHistory: updatedHistory,
      status: NegotiationStatus.awaitingPeerResponse,
    );

    // Append as chat message
    final msg = NegotiationMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.contract,
      text: newDraft.text,
      senderRole: state.myRole,
      senderName: null,
      attachments: [],
      timestamp: DateTime.now(),
      aiAnalysis: {'appliedSuggestion': suggestedPrice},
    );
    state = state.copyWith(messages: [...state.messages, msg]);

    // Send to peer
    ref.read(connectionStateProvider.notifier).sendMessage({
      'type': 'DRAFT_PROPOSAL',
      'version': newDraft.version,
      'text': newDraft.text,
      'proposedBy': state.myRole == UserRole.seller ? 'seller' : 'buyer',
      'aiSuggestion': newDraft.aiSuggestion,
    });
  }
}

// Escrow State Notifier
class EscrowStateNotifier extends StateNotifier<EscrowState> {
  EscrowStateNotifier(this.ref) : super(initialEscrowState);

  final Ref ref;

  Future<void> lockAndSendFunds(double amount) async {
    final cryptoService = ref.read(cryptoServiceProvider);

    final contractMap = {
      "amount": amount,
      "currency": "USD",
      "status": "LOCKED",
      "timestamp": DateTime.now().toIso8601String(),
    };

    final jsonString = jsonEncode(contractMap);
    final messageBytes = utf8.encode(jsonString);
    final signature = await cryptoService.sign(messageBytes);
    final pubKey = await cryptoService.getPublicKey();

    final List<int> fullPayload = [
      ...pubKey.bytes,
      ...signature.bytes,
      ...messageBytes,
    ];

    ref
        .read(connectionStateProvider.notifier)
        .sendBytes(Uint8List.fromList(fullPayload));

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("💸 Sent \$$amount (Locked) to Guide.");
  }

  Future<void> receiveLockedFunds(Uint8List bytes) async {
    final cryptoService = ref.read(cryptoServiceProvider);

    final pubKeyBytes = bytes.sublist(0, 32);
    final sigBytes = bytes.sublist(32, 96);
    final dataBytes = bytes.sublist(96);

    final remotePubKey = SimplePublicKey(
      pubKeyBytes,
      type: KeyPairType.ed25519,
    );
    final signature = Signature(sigBytes, publicKey: remotePubKey);

    final isValid = await cryptoService.verify(dataBytes, signature);

    if (isValid) {
      final jsonString = utf8.decode(dataBytes);
      final data = jsonDecode(jsonString);

      state = state.copyWith(
        amount: (data["amount"] as num).toDouble(),
        status: EscrowStatus.locked,
      );

      ref
          .read(connectionStateProvider.notifier)
          .updateLog(
            "🔒 RECEIVED SECURE CONTRACT:\nAmount: \$${state.amount}\nSignature: VALID ✅",
          );
    } else {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ INVALID SIGNATURE! DO NOT TRUST.");
    }
  }

  void releaseFunds() {
    state = state.copyWith(status: EscrowStatus.unlocked);
    ref
        .read(connectionStateProvider.notifier)
        .updateLog(
          "💰 FUNDS RELEASED! \$${state.amount} transferred successfully.",
        );
  }
}

// AI Consensus State Notifier
class AIConsensusStateNotifier extends StateNotifier<AIConsensusState> {
  AIConsensusStateNotifier(this.ref) : super(initialAIConsensusState);

  final Ref ref;

  void updateProofText(String text) {
    state = state.copyWith(myProofText: text);
  }

  Future<void> captureAndAnalyzeProof() async {
    final cactusService = ref.read(cactusAIServiceProvider);
    final picker = ref.read(imagePickerProvider);
    final contractState = ref.read(contractStateProvider);

    if (!cactusService.isReady) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Cactus AI not ready yet!");
      return;
    }

    if (!contractState.isFinalized) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Contract must be finalized first!");
      return;
    }

    final photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (photo == null) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ No photo captured.");
      return;
    }

    state = state.copyWith(myProofImagePath: photo.path);
    await _analyzeProof(
      imagePath: photo.path,
      textProof: state.myProofText.isEmpty ? null : state.myProofText,
      contractText: contractState.currentDraft?.text ?? '',
    );
  }

  Future<void> submitTextProof() async {
    final cactusService = ref.read(cactusAIServiceProvider);
    final contractState = ref.read(contractStateProvider);

    if (!cactusService.isReady) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Cactus AI not ready yet!");
      return;
    }

    if (!contractState.isFinalized) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Contract must be finalized first!");
      return;
    }

    if (state.myProofText.isEmpty) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Please provide a text description of the proof.");
      return;
    }

    await _analyzeProof(
      textProof: state.myProofText,
      contractText: contractState.currentDraft?.text ?? '',
    );
  }

  Future<void> _analyzeProof({
    String? imagePath,
    String? textProof,
    required String contractText,
    bool shareWithPeer = true,
  }) async {
    final cactusService = ref.read(cactusAIServiceProvider);
    final cryptoService = ref.read(cryptoServiceProvider);
    final contractState = ref.read(contractStateProvider);

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("🧠 Cactus AI Analyzing proof...");

    if (shareWithPeer) {
      await _shareProofWithPeer(
        imagePath: imagePath,
        textProof: textProof ?? state.myProofText,
      );
    }

    try {
      final response = await cactusService.analyzeProof(
        imagePath: imagePath,
        textProof: textProof,
        contractText: contractText,
      );

      ref
          .read(connectionStateProvider.notifier)
          .updateLog("🧠 AI Response: $response");

      if (cactusService.isApproved(response)) {
        final oldState = state;
        state = state.copyWith(myAIApproved: true);

        debugPrint(
          '🔄 State changed - Old: myAI=${oldState.myAIApproved}, New: myAI=${state.myAIApproved}',
        );

        ref
            .read(connectionStateProvider.notifier)
            .updateLog("✅ My AI Approved! Sending vote to peer...");

        // Sign and send vote
        final voteData =
            "AI_VOTE_YES_${contractState.finalHash}_${DateTime.now().millisecondsSinceEpoch}";
        final signature = await cryptoService.sign(utf8.encode(voteData));
        final pubKey = await cryptoService.getPublicKey();

        final voteMessage = {
          "type": "AI_VOTE",
          "verdict": "YES",
          "signature": base64Encode(signature.bytes),
          "publicKey": base64Encode(pubKey.bytes),
          "voteData": voteData,
        };

        ref
            .read(connectionStateProvider.notifier)
            .updateLog("📤 Sending AI vote message to peer...");

        ref.read(connectionStateProvider.notifier).sendMessage(voteMessage);

        ref
            .read(connectionStateProvider.notifier)
            .updateLog(
              "📊 My state - My AI: ${state.myAIApproved}, Peer AI: ${state.peerAIApproved}",
            );

        _checkConsensus();
      } else {
        ref
            .read(connectionStateProvider.notifier)
            .updateLog("❌ My AI Rejected the proof.\nReason: $response");
      }
    } catch (e) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ AI Analysis Error: $e");
    }
  }

  Future<void> _shareProofWithPeer({
    String? imagePath,
    String? textProof,
  }) async {
    final connectionNotifier = ref.read(connectionStateProvider.notifier);

    final hasText = textProof != null && textProof.trim().isNotEmpty;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    if (!hasText && !hasImage) {
      return;
    }

    String? encodedImage;
    String? imageExtension;

    if (hasImage) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          encodedImage = base64Encode(bytes);
          final dotIndex = imagePath.lastIndexOf('.');
          imageExtension = dotIndex != -1
              ? imagePath.substring(dotIndex + 1)
              : 'jpg';
        }
      } catch (e) {
        connectionNotifier.updateLog(
          "⚠️ Failed to prepare proof image for peer: $e",
        );
      }
    }

    connectionNotifier.updateLog("📤 Sharing proof with peer...");
    connectionNotifier.sendMessage({
      "type": "PROOF_SUBMISSION",
      "textProof": hasText ? textProof : null,
      "imageData": encodedImage,
      "imageExtension": imageExtension,
    });
  }

  Future<void> receivePeerProof({
    String? textProof,
    String? imageData,
    String? imageExtension,
  }) async {
    String? imagePath;

    if (imageData != null && imageData.isNotEmpty) {
      try {
        final bytes = base64Decode(imageData);
        final ext = (imageExtension != null && imageExtension.isNotEmpty)
            ? imageExtension
            : 'jpg';
        final fileName =
            'peer_proof_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final file = File('${Directory.systemTemp.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        imagePath = file.path;
        state = state.copyWith(peerProofImagePath: imagePath);
      } catch (e) {
        ref
            .read(connectionStateProvider.notifier)
            .updateLog("❌ Failed to store peer proof image: $e");
        return;
      }
    }

    final hasText = textProof != null && textProof.trim().isNotEmpty;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    if (!hasText && !hasImage) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("⚠️ Received empty proof payload from peer.");
      return;
    }

    final contractText =
        ref.read(contractStateProvider).currentDraft?.text ?? '';

    await _analyzeProof(
      imagePath: imagePath,
      textProof: textProof,
      contractText: contractText,
      shareWithPeer: false,
    );
  }

  Future<void> receivePeerVote({
    required String voteData,
    required String signature,
    required String publicKey,
  }) async {
    final cryptoService = ref.read(cryptoServiceProvider);

    ref
        .read(connectionStateProvider.notifier)
        .updateLog("🔐 Verifying peer AI vote signature...");

    final pubKeyBytes = base64Decode(publicKey);
    final sigBytes = base64Decode(signature);

    final remotePubKey = SimplePublicKey(
      pubKeyBytes,
      type: KeyPairType.ed25519,
    );
    final sig = Signature(sigBytes, publicKey: remotePubKey);

    final isValid = await cryptoService.verify(utf8.encode(voteData), sig);

    if (isValid) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("✅ Received Peer AI Approval (Verified)");

      // Update state to show peer approved
      final oldState = state;
      state = state.copyWith(peerAIApproved: true);

      debugPrint(
        '🔄 State changed - Old: peerAI=${oldState.peerAIApproved}, New: peerAI=${state.peerAIApproved}',
      );

      ref
          .read(connectionStateProvider.notifier)
          .updateLog(
            "📊 State updated - Peer AI: ${state.peerAIApproved}, My AI: ${state.myAIApproved}",
          );

      _checkConsensus();
    } else {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog("❌ Invalid AI vote signature!");
    }
  }

  void _checkConsensus() {
    ref
        .read(connectionStateProvider.notifier)
        .updateLog(
          "🔍 Checking consensus...\nMy AI: ${state.myAIApproved ? '✅' : '❌'} | Peer AI: ${state.peerAIApproved ? '✅' : '❌'}",
        );

    if (state.myAIApproved && state.peerAIApproved) {
      ref
          .read(connectionStateProvider.notifier)
          .updateLog(
            "🎉 CONSENSUS REACHED! Both AIs approved. Releasing funds...",
          );
      ref.read(escrowStateProvider.notifier).releaseFunds();
    }
  }
}

// Wallet State
class WalletState {
  final double myBalance;
  final double peerBalance;

  const WalletState({this.myBalance = 1538.1, this.peerBalance = 0.0});

  WalletState copyWith({double? myBalance, double? peerBalance}) {
    return WalletState(
      myBalance: myBalance ?? this.myBalance,
      peerBalance: peerBalance ?? this.peerBalance,
    );
  }
}

class WalletStateNotifier extends StateNotifier<WalletState> {
  WalletStateNotifier() : super(const WalletState());

  void creditMyBalance(double amount) {
    state = state.copyWith(myBalance: state.myBalance + amount);
  }

  void deductMyBalance(double amount) {
    state = state.copyWith(myBalance: (state.myBalance - amount).clamp(0.0, double.infinity));
  }

  void creditPeer(double amount) {
    state = state.copyWith(peerBalance: state.peerBalance + amount);
  }

  void deductPeer(double amount) {
    state = state.copyWith(peerBalance: (state.peerBalance - amount).clamp(0.0, double.infinity));
  }

  /// Convenience: buyer paid vendor
  void applyBuyerToVendorTransfer({required bool iAmBuyer, required double amount}) {
    if (iAmBuyer) {
      // I'm the buyer: deduct my balance
      deductMyBalance(amount);
    } else {
      // I'm the seller: credit my balance
      creditMyBalance(amount);
    }
  }
}
