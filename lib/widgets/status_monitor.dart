import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';

class StatusMonitor extends ConsumerWidget {
  const StatusMonitor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionStateProvider);
    final cactusService = ref.watch(cactusAIServiceProvider);

    return Center(
      child: GlassCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: VerifiTheme.neonMint,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: VerifiTheme.neonMint.withAlpha(40),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'READY TO CONNECT',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
