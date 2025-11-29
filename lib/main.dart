import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'design_system.dart';
import 'widgets/connection_buttons.dart';
import 'widgets/contract_draft_section.dart';
import 'widgets/funds_released_section.dart';
import 'widgets/lock_funds_section.dart';
import 'widgets/proof_submission_section.dart';
import 'widgets/status_monitor.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verifi - AI Escrow',
      theme: VerifiTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const EscrowScreen(),
    );
  }
}

class EscrowScreen extends ConsumerWidget {
  const EscrowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("VERIFI"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [VerifiTheme.voidBlack, VerifiTheme.voidBlackLight],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  StatusMonitor(),
                  ConnectionButtons(),
                  SizedBox(height: 20),
                  ContractDraftSection(),
                  LockFundsSection(),
                  ProofSubmissionSection(),
                  FundsReleasedSection(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
