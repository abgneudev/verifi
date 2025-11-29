import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';
import '../models/contract_state.dart';
import 'delivery_confirmation_page.dart';

class EscrowPaymentPage extends ConsumerWidget {
  const EscrowPaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractState = ref.watch(contractStateProvider);
    final isBuyer = contractState.myRole == UserRole.buyer;

    // Auto-navigate to Step 3 when escrow is deposited
    if (contractState.escrowDeposited &&
        contractState.currentStep == TransactionStep.delivery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DeliveryConfirmationPage(),
            ),
          );
        }
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("ESCROW PAYMENT"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [VerifiTheme.voidBlack, VerifiTheme.voidBlackLight],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "💰 STEP 2: ESCROW PAYMENT",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Role indicator
                StatusBadge(
                  text: "Your Role: ${isBuyer ? 'BUYER' : 'SELLER'}",
                  color: isBuyer
                      ? VerifiTheme.neonMint
                      : VerifiTheme.signalOrange,
                  icon: isBuyer ? Icons.shopping_bag : Icons.sell,
                ),

                const SizedBox(height: 20),

                // Contract summary
                GlassCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FINALIZED CONTRACT',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: VerifiTheme.voidBlack.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: VerifiTheme.glassBorder),
                        ),
                        child: Text(
                          contractState.currentDraft?.text ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (contractState.finalHash != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: VerifiTheme.neonMint,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Hash: ${contractState.finalHash}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: VerifiTheme.ghostGrey,
                                      fontFamily: 'monospace',
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Payment instructions based on role
                if (isBuyer) ...[
                  GlassCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              size: 20,
                              color: VerifiTheme.neonMint,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DEPOSIT FUNDS TO ESCROW',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please deposit the agreed amount into the escrow account. Funds will be held securely until delivery is confirmed.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        NeoPopButton(
                          icon: Icons.payment,
                          text: "Deposit to Escrow",
                          onPressed: () {
                            // Mark escrow as deposited and navigate to Step 3
                            ref
                                .read(contractStateProvider.notifier)
                                .markEscrowDeposited();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DeliveryConfirmationPage(),
                              ),
                            );
                          },
                          color: VerifiTheme.neonMint,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  GlassCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.hourglass_empty,
                              size: 20,
                              color: VerifiTheme.signalOrange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AWAITING BUYER PAYMENT',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Waiting for the buyer to deposit funds into escrow. You will be notified once the payment is received.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Status indicator
                const StatusBadge(
                  text: "Escrow wallet active - funds secured",
                  color: VerifiTheme.neonMint,
                  icon: Icons.lock,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
