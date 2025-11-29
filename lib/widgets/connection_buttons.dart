import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';

class ConnectionButtons extends ConsumerWidget {
  const ConnectionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionStateProvider);

    if (connectionState.connectedEndpointId != null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        NeoPopButton(
          icon: Icons.send,
          text: "Tourist (Phone A)",
          onPressed: () {
            ref.read(connectionStateProvider.notifier).startAdvertising();
          },
          color: VerifiTheme.hyperViolet,
        ),
        const SizedBox(height: 15),
        NeoPopButton(
          icon: Icons.radar,
          text: "Guide (Phone B)",
          onPressed: () {
            ref.read(connectionStateProvider.notifier).startDiscovery();
          },
          color: VerifiTheme.electricPink,
        ),
      ],
    );
  }
}
