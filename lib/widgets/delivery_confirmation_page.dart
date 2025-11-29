import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';
import '../models/contract_state.dart';

class DeliveryConfirmationPage extends ConsumerWidget {
  const DeliveryConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractState = ref.watch(contractStateProvider);
    final isBuyer = contractState.myRole == UserRole.buyer;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("DELIVERY CONFIRMATION"),
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
                  "📦 STEP 3: DELIVERY CONFIRMATION",
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
                        'CONTRACT DETAILS',
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Delivery confirmation based on role
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
                              Icons.check_circle_outline,
                              size: 20,
                              color: VerifiTheme.neonMint,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'CONFIRM DELIVERY',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Once you have received the goods/services and verified they meet the contract terms, confirm delivery to release funds from escrow.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: NeoPopButton(
                                icon: Icons.cancel,
                                text: "Dispute",
                                onPressed: () {
                                  // TODO: Implement dispute flow
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Dispute initiated'),
                                    ),
                                  );
                                },
                                color: VerifiTheme.signalOrange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: NeoPopButton(
                                icon: Icons.check_circle,
                                text: "Confirm Delivery",
                                onPressed: () {
                                  // Mark delivery as confirmed
                                  ref
                                      .read(contractStateProvider.notifier)
                                      .markDeliveryConfirmed();

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '✅ Delivery confirmed! Funds released.',
                                      ),
                                      backgroundColor: VerifiTheme.neonMint,
                                    ),
                                  );

                                  // Return to home after a delay
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      if (context.mounted) {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      }
                                    },
                                  );
                                },
                                color: VerifiTheme.neonMint,
                              ),
                            ),
                          ],
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
                              Icons.local_shipping,
                              size: 20,
                              color: VerifiTheme.signalOrange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DELIVERY STATUS',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please fulfill the contract terms and deliver the goods/services to the buyer. Funds will be released from escrow once the buyer confirms delivery.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        const StatusBadge(
                          text: "Awaiting buyer confirmation",
                          color: VerifiTheme.signalOrange,
                          icon: Icons.pending,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // AI Monitoring
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
                            'AI MONITORING',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: VerifiTheme.neonMint),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transaction is being monitored for compliance with contract terms. Any disputes will be reviewed by AI mediator.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
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
