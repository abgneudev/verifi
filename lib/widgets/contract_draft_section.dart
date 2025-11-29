import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system.dart';
import '../providers/app_providers.dart';
import '../models/contract_state.dart';
import 'contract_negotiation_page.dart';

class ContractDraftSection extends ConsumerStatefulWidget {
  const ContractDraftSection({super.key});

  @override
  ConsumerState<ContractDraftSection> createState() =>
      _ContractDraftSectionState();
}

class _ContractDraftSectionState extends ConsumerState<ContractDraftSection> {
  String? _lastNavigatedEndpointId;
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionStateProvider);
    final contractState = ref.watch(contractStateProvider);

    // Debug prints
    debugPrint('🔍 ContractDraftSection build:');
    debugPrint(
      '   connectedEndpointId: ${connectionState.connectedEndpointId}',
    );
    debugPrint('   isFinalized: ${contractState.isFinalized}');
    debugPrint('   myRole: ${contractState.myRole}');
    debugPrint('   status: ${contractState.status}');
    debugPrint('   _lastNavigatedEndpointId: $_lastNavigatedEndpointId');
    debugPrint('   _isNavigating: $_isNavigating');

    // Navigate to contract negotiation page when connected and not finalized
    // Only navigate once per connection (compare endpoint IDs)
    if (connectionState.connectedEndpointId != null &&
        !contractState.isFinalized &&
        !_isNavigating &&
        _lastNavigatedEndpointId != connectionState.connectedEndpointId) {
      debugPrint('   🚀 Navigating to ContractNegotiationPage');
      _isNavigating = true;
      _lastNavigatedEndpointId = connectionState.connectedEndpointId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const ContractNegotiationPage(),
                ),
              )
              .then((_) {
                // Reset navigation tracking when returning from page
                if (mounted) {
                  setState(() {
                    _lastNavigatedEndpointId = null;
                    _isNavigating = false;
                  });
                }
              });
        }
      });
    }

    // Reset navigation tracking if disconnected or finalized
    if ((connectionState.connectedEndpointId == null ||
            contractState.isFinalized) &&
        (_lastNavigatedEndpointId != null || _isNavigating)) {
      _lastNavigatedEndpointId = null;
      _isNavigating = false;
    }

    return const SizedBox.shrink();
  }
}
