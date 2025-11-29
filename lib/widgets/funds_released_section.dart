import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../models/escrow_state.dart';
import '../providers/app_providers.dart';

class FundsReleasedSection extends ConsumerWidget {
  const FundsReleasedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escrowState = ref.watch(escrowStateProvider);
    final contractState = ref.watch(contractStateProvider);

    if (escrowState.status != EscrowStatus.unlocked) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(32),
          color: VerifiTheme.neonMint,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: VerifiTheme.neonMint.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: VerifiTheme.neonMint.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration,
                  size: 80,
                  color: VerifiTheme.neonMint,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "FUNDS RELEASED!",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: VerifiTheme.neonMint,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              AmountDisplay(
                amount: escrowState.amount,
                color: VerifiTheme.neonMint,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VerifiTheme.voidBlack.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: VerifiTheme.neonMint,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Both AIs verified the proof",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: VerifiTheme.neonMint,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: VerifiTheme.glassBorder, thickness: 1),
                    const SizedBox(height: 12),
                    Text(
                      'CONTRACT',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contractState.currentDraft?.text ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
