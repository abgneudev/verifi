import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';
import 'finding_merchant_screen.dart';

class ConnectionButtons extends ConsumerWidget {
  const ConnectionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionStateProvider);

    if (connectionState.connectedEndpointId != null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: NeoPopButton(
                    icon: Icons.send,
                    text: "Send",
                    onPressed: () {
                      // Start advertising
                      ref
                          .read(connectionStateProvider.notifier)
                          .startAdvertising();

                      // Navigate to finding merchant screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FindingMerchantScreen(),
                        ),
                      );
                    },
                    color: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: NeoPopButton(
                    icon: Icons.radar,
                    text: "Receive",
                    onPressed: () {
                      // Start discovery
                      ref
                          .read(connectionStateProvider.notifier)
                          .startDiscovery();

                      // Navigate to finding merchant screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FindingMerchantScreen(),
                        ),
                      );
                    },
                    color: VerifiTheme.neonMint,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
