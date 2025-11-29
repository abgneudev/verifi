import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../models/escrow_state.dart';
import '../providers/app_providers.dart';

class LockFundsSection extends ConsumerWidget {
  const LockFundsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractState = ref.watch(contractStateProvider);
    final escrowState = ref.watch(escrowStateProvider);

    if (!contractState.isFinalized || escrowState.status != EscrowStatus.idle) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(24),
          color: VerifiTheme.neonMint,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VerifiTheme.neonMint.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: VerifiTheme.neonMint,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "CONTRACT LOCKED",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: VerifiTheme.neonMint,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VerifiTheme.voidBlack.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  contractState.currentDraft?.text ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "💰 STEP 2: LOCK FUNDS",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Center(
          child: NeoPopButton(
            icon: Icons.lock,
            text: "Lock & Send \$50",
            onPressed: () {
              HapticFeedback.heavyImpact();
              ref.read(escrowStateProvider.notifier).lockAndSendFunds(50.0);
            },
            color: VerifiTheme.signalOrange,
          ),
        ),
      ],
    );
  }
}
