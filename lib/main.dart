import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'design_system.dart';
import 'widgets/status_monitor.dart';
import 'widgets/balance_card.dart';
import 'widgets/info_tiles.dart';
import 'widgets/statement_summary.dart';
import 'widgets/connection_buttons.dart';

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
                const StatusMonitor(),
                const SizedBox(height: 20),
                const BalanceCard(),
                const InfoTiles(),
                const StatementSummary(),
                const SizedBox(height: 20),
                const ConnectionButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
