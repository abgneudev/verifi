import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';
import '../models/contract_state.dart';

class ContractDraftSection extends ConsumerStatefulWidget {
  const ContractDraftSection({super.key});

  @override
  ConsumerState<ContractDraftSection> createState() =>
      _ContractDraftSectionState();
}

class _ContractDraftSectionState extends ConsumerState<ContractDraftSection> {
  late TextEditingController _privateInputController;

  @override
  void initState() {
    super.initState();
    _privateInputController = TextEditingController();
  }

  @override
  void dispose() {
    _privateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionStateProvider);
    final contractState = ref.watch(contractStateProvider);

    if (connectionState.connectedEndpointId == null ||
        contractState.isFinalized) {
      return const SizedBox.shrink();
    }

    // Determine if it's user's turn or waiting
    final isMyTurn =
        contractState.status == NegotiationStatus.awaitingMyResponse ||
        contractState.status == NegotiationStatus.idle;
    final canSubmit = _privateInputController.text.isNotEmpty && isMyTurn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "📝 STEP 1: CONTRACT NEGOTIATION",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Role indicator
        if (contractState.myRole != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StatusBadge(
              text:
                  "Your Role: ${contractState.myRole == UserRole.seller ? 'SELLER' : 'BUYER'}",
              color: contractState.myRole == UserRole.seller
                  ? VerifiTheme.signalOrange
                  : VerifiTheme.neonMint,
              icon: contractState.myRole == UserRole.seller
                  ? Icons.sell
                  : Icons.shopping_bag,
            ),
          ),

        // Current contract draft (read-only, shared view)
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'CURRENT CONTRACT DRAFT',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const Spacer(),
                  if (contractState.currentDraft != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: VerifiTheme.neonMint.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'v${contractState.currentDraft!.version}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: VerifiTheme.neonMint,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VerifiTheme.voidBlack.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: VerifiTheme.glassBorder),
                ),
                child: contractState.currentDraft != null
                    ? Text(
                        contractState.currentDraft!.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Text(
                        contractState.myRole == UserRole.seller
                            ? "You'll create the initial draft below"
                            : "Waiting for seller to propose initial draft...",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VerifiTheme.ghostGrey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              if (contractState.currentDraft != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      contractState.currentDraft!.proposedBy == UserRole.seller
                          ? Icons.sell
                          : Icons.shopping_bag,
                      size: 14,
                      color: VerifiTheme.ghostGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Proposed by: ${contractState.currentDraft!.proposedBy == UserRole.seller ? 'SELLER' : 'BUYER'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: VerifiTheme.ghostGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // AI Mediation insight
        if (contractState.aiMediation != null)
          GlassCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      size: 16,
                      color: VerifiTheme.neonMint,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI MEDIATOR INSIGHT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: VerifiTheme.neonMint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  contractState.aiMediation!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

        if (contractState.aiMediation != null) const SizedBox(height: 20),

        // Private input section (only visible when it's user's turn)
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMyTurn ? 'YOUR PRIVATE INPUT' : 'WAITING FOR RESPONSE',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _privateInputController,
                enabled: isMyTurn,
                onChanged: (text) {
                  HapticFeedback.selectionClick();
                  setState(() {}); // Rebuild to update button state
                },
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: isMyTurn
                      ? (contractState.currentDraft == null
                            ? "Enter initial contract terms (e.g., Deliver 5kg Grade A apples, \$50, within 24 hours)"
                            : "Enter your concerns/edits, or type 'agree' to accept")
                      : "Waiting for other party to respond...",
                  filled: true,
                  fillColor: isMyTurn
                      ? VerifiTheme.voidBlack.withValues(alpha: 0.3)
                      : VerifiTheme.voidBlack.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    isMyTurn ? Icons.lock_outline : Icons.pending,
                    size: 14,
                    color: isMyTurn
                        ? VerifiTheme.signalOrange
                        : VerifiTheme.ghostGrey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isMyTurn
                          ? "Private - only you can see this until submitted"
                          : contractState.status ==
                                NegotiationStatus.awaitingPeerResponse
                          ? "Awaiting peer response..."
                          : "Not your turn",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isMyTurn
                            ? VerifiTheme.signalOrange
                            : VerifiTheme.ghostGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: NeoPopButton(
                icon: Icons.send,
                text: contractState.currentDraft == null
                    ? "Propose Draft"
                    : "Submit Response",
                onPressed: canSubmit
                    ? () {
                        final input = _privateInputController.text.trim();
                        ref
                            .read(contractStateProvider.notifier)
                            .submitResponse(input);
                        _privateInputController.clear();
                        setState(() {});
                      }
                    : null,
                color: VerifiTheme.neonMint,
              ),
            ),
            if (contractState.status == NegotiationStatus.agreed) ...[
              const SizedBox(width: 15),
              Expanded(
                child: NeoPopButton(
                  icon: contractState.myApproval
                      ? Icons.check_circle
                      : Icons.lock_outline,
                  text: contractState.myApproval ? "Approved" : "Finalize",
                  onPressed: contractState.myApproval
                      ? null
                      : () {
                          ref
                              .read(contractStateProvider.notifier)
                              .finalizeContract();
                        },
                  color: contractState.myApproval
                      ? VerifiTheme.neonMint
                      : VerifiTheme.signalOrange,
                ),
              ),
            ],
          ],
        ),

        // Status indicators
        if (contractState.status == NegotiationStatus.agreed)
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: StatusBadge(
              text: "✅ Both parties agreed! Ready to finalize.",
              color: VerifiTheme.neonMint,
              icon: Icons.handshake,
            ),
          ),

        if (contractState.myApproval || contractState.peerApproval)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: StatusBadge(
                    text: contractState.myApproval
                        ? "You: Approved ✅"
                        : "You: Pending",
                    color: contractState.myApproval
                        ? VerifiTheme.neonMint
                        : VerifiTheme.ghostGrey,
                    icon: contractState.myApproval
                        ? Icons.check
                        : Icons.pending,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatusBadge(
                    text: contractState.peerApproval
                        ? "Peer: Approved ✅"
                        : "Peer: Pending",
                    color: contractState.peerApproval
                        ? VerifiTheme.neonMint
                        : VerifiTheme.ghostGrey,
                    icon: contractState.peerApproval
                        ? Icons.check
                        : Icons.pending,
                  ),
                ),
              ],
            ),
          ),

        // Draft history
        if (contractState.draftHistory.length > 1) ...[
          const SizedBox(height: 20),
          Text(
            "NEGOTIATION HISTORY",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          ...contractState.draftHistory.reversed.take(3).map((draft) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VerifiTheme.obsidianGlass,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: VerifiTheme.glassBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: VerifiTheme.ghostGrey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'v${draft.version}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        draft.text,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
