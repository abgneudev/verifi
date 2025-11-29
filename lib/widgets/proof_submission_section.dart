import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../models/escrow_state.dart';
import '../providers/app_providers.dart';

class ProofSubmissionSection extends ConsumerStatefulWidget {
  const ProofSubmissionSection({super.key});

  @override
  ConsumerState<ProofSubmissionSection> createState() =>
      _ProofSubmissionSectionState();
}

class _ProofSubmissionSectionState
    extends ConsumerState<ProofSubmissionSection> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final escrowState = ref.watch(escrowStateProvider);
    final contractState = ref.watch(contractStateProvider);
    final aiState = ref.watch(aiConsensusStateProvider);

    // Debug: Print state changes
    debugPrint(
      '🔍 ProofSubmission rebuild - My AI: ${aiState.myAIApproved}, Peer AI: ${aiState.peerAIApproved}, Escrow: ${escrowState.status}',
    );

    if (escrowState.status != EscrowStatus.locked) {
      debugPrint(
        '⚠️ ProofSubmission hidden - Escrow status is ${escrowState.status}, not locked',
      );
      return const SizedBox.shrink();
    }

    debugPrint('✅ ProofSubmission visible - Escrow is locked');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        Text(
          "📸 STEP 3: SUBMIT PROOF",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VerifiTheme.electricPink.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: VerifiTheme.electricPink,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTRACT REQUIREMENT',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contractState.currentDraft?.text ?? '',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: VerifiTheme.glassBorder, thickness: 1),
              const SizedBox(height: 16),
              Text(
                "Provide proof of contract fulfillment. You can capture a photo, describe in text, or both.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Text proof input
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEXT PROOF (OPTIONAL)',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _textController,
                onChanged: (text) {
                  ref
                      .read(aiConsensusStateProvider.notifier)
                      .updateProofText(text);
                },
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText:
                      "Describe what you've done to fulfill the contract (e.g., 'Delivered 5kg of Grade A apples')",
                  filled: true,
                  fillColor: VerifiTheme.voidBlack.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: VerifiTheme.ghostGrey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Add context to help AI verify your proof",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: VerifiTheme.ghostGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: NeoPopButton(
                icon: Icons.camera_alt,
                text: "Capture Photo",
                onPressed: () {
                  ref
                      .read(aiConsensusStateProvider.notifier)
                      .captureAndAnalyzeProof();
                },
                color: VerifiTheme.electricPink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NeoPopButton(
                icon: Icons.check,
                text: "Submit Text",
                onPressed: _textController.text.isEmpty
                    ? null
                    : () {
                        ref
                            .read(aiConsensusStateProvider.notifier)
                            .submitTextProof();
                      },
                color: VerifiTheme.neonMint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AIConsensusWidget(
          myAIApproved: aiState.myAIApproved,
          peerAIApproved: aiState.peerAIApproved,
        ),
      ],
    );
  }
}

class AIConsensusWidget extends StatelessWidget {
  final bool myAIApproved;
  final bool peerAIApproved;

  const AIConsensusWidget({
    super.key,
    required this.myAIApproved,
    required this.peerAIApproved,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24),
      color: VerifiTheme.hyperViolet,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.psychology,
                color: VerifiTheme.hyperViolet,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "AI CONSENSUS (AND GATE)",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: VerifiTheme.hyperViolet,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AIStatusIndicator(
                context: context,
                label: "MY AI",
                isApproved: myAIApproved,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: VerifiTheme.hyperViolet.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: VerifiTheme.hyperViolet,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "AND",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: VerifiTheme.hyperViolet,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _AIStatusIndicator(
                context: context,
                label: "PEER AI",
                isApproved: peerAIApproved,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (myAIApproved && peerAIApproved)
            const StatusBadge(
              text: "Consensus Reached",
              color: VerifiTheme.neonMint,
              icon: Icons.check_circle,
            )
          else
            const StatusBadge(
              text: "Waiting for approval",
              color: VerifiTheme.signalOrange,
              icon: Icons.pending,
            ),
        ],
      ),
    );
  }

  Widget _AIStatusIndicator({
    required BuildContext context,
    required String label,
    required bool isApproved,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isApproved
                ? VerifiTheme.neonMint.withValues(alpha: 0.2)
                : VerifiTheme.obsidianGlass.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isApproved
                  ? VerifiTheme.neonMint
                  : VerifiTheme.glassBorder,
              width: 2,
            ),
            boxShadow: isApproved
                ? [
                    BoxShadow(
                      color: VerifiTheme.neonMint.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            isApproved ? Icons.check_circle : Icons.pending_outlined,
            color: isApproved ? VerifiTheme.neonMint : VerifiTheme.ghostGrey,
            size: 40,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isApproved ? VerifiTheme.neonMint : VerifiTheme.ghostGrey,
          ),
        ),
      ],
    );
  }
}
