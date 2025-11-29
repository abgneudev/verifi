import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../design_system.dart';
import '../providers/app_providers.dart';
import '../models/contract_state.dart';

class DeliveryConfirmationPage extends ConsumerStatefulWidget {
  const DeliveryConfirmationPage({super.key});

  @override
  ConsumerState<DeliveryConfirmationPage> createState() =>
      _DeliveryConfirmationPageState();
}

class _DeliveryConfirmationPageState
    extends ConsumerState<DeliveryConfirmationPage> {
  final TextEditingController _proofTextController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _proofTextController.dispose();
    super.dispose();
  }

  String _getAutoReleaseMessage(DateTime submittedAt) {
    final now = DateTime.now();
    final hoursPassed = now.difference(submittedAt).inHours;
    final hoursRemaining = 24 - hoursPassed;

    if (hoursRemaining <= 0) {
      return 'Auto-release time has passed. Funds can be released automatically.';
    }

    return 'AI approved. Funds auto-release in $hoursRemaining hours if not disputed.';
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitProof() async {
    if (_selectedImage == null && _proofTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide either an image or text proof'),
          backgroundColor: VerifiTheme.signalOrange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(contractStateProvider.notifier)
          .submitProof(
            textProof: _proofTextController.text.trim(),
            imagePath: _selectedImage?.path,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proof submitted! AI is analyzing...'),
            backgroundColor: VerifiTheme.neonMint,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: VerifiTheme.signalOrange,
          ),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  // Show AI analysis if proof submitted
                  if (contractState.proofSubmitted &&
                      contractState.aiProofAnalysis != null) ...[
                    GlassCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                contractState.aiApprovedProof
                                    ? Icons.check_circle
                                    : Icons.warning,
                                size: 20,
                                color: contractState.aiApprovedProof
                                    ? VerifiTheme.neonMint
                                    : VerifiTheme.signalOrange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI ANALYSIS RESULT',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: contractState.aiApprovedProof
                                  ? VerifiTheme.neonMint.withValues(alpha: 0.2)
                                  : VerifiTheme.signalOrange.withValues(
                                      alpha: 0.2,
                                    ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: contractState.aiApprovedProof
                                    ? VerifiTheme.neonMint
                                    : VerifiTheme.signalOrange,
                              ),
                            ),
                            child: Text(
                              contractState.aiProofAnalysis!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          if (contractState.proofText != null &&
                              contractState.proofText!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Seller\'s description:',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: VerifiTheme.voidBlack.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: VerifiTheme.glassBorder,
                                ),
                              ),
                              child: Text(
                                contractState.proofText!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Buyer actions
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
                              contractState.proofSubmitted
                                  ? 'REVIEW & CONFIRM'
                                  : 'AWAITING SELLER',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          contractState.proofSubmitted
                              ? 'Review the seller\'s proof and AI analysis. Approve to release funds, or dispute if unsatisfied.'
                              : 'Waiting for seller to submit proof of work completion.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (contractState.proofSubmitted) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: NeoPopButton(
                                  icon: Icons.report_problem,
                                  text: "Dispute",
                                  onPressed: () {
                                    // TODO: Implement dispute flow
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Dispute initiated'),
                                        backgroundColor:
                                            VerifiTheme.signalOrange,
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
                                  text: "Approve & Release Funds",
                                  onPressed: () {
                                    ref
                                        .read(contractStateProvider.notifier)
                                        .buyerApprovesDelivery();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '✅ Delivery approved! Funds released.',
                                        ),
                                        backgroundColor: VerifiTheme.neonMint,
                                      ),
                                    );

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
                          if (contractState.aiApprovedProof) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: VerifiTheme.neonMint.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: VerifiTheme.neonMint.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: VerifiTheme.neonMint,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'AI approved this work. Funds will auto-release in 24h if not disputed.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: VerifiTheme.neonMint,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  // Seller: Submit proof of work
                  if (!contractState.proofSubmitted) ...[
                    GlassCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.upload_file,
                                size: 20,
                                color: VerifiTheme.signalOrange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SUBMIT PROOF OF COMPLETION',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Upload evidence showing you have fulfilled the contract terms. AI will analyze your submission.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),

                          // Image picker
                          if (_selectedImage != null) ...[
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: VerifiTheme.glassBorder,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          NeoPopButton(
                            icon: Icons.add_photo_alternate,
                            text: _selectedImage == null
                                ? "Add Image Proof"
                                : "Change Image",
                            onPressed: _pickImage,
                            color: VerifiTheme.ghostGrey,
                          ),

                          const SizedBox(height: 20),

                          // Text proof
                          TextField(
                            controller: _proofTextController,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText:
                                  'Describe what you have delivered (optional if image provided)',
                              filled: true,
                              fillColor: VerifiTheme.voidBlack.withValues(
                                alpha: 0.3,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          NeoPopButton(
                            icon: Icons.send,
                            text: _isSubmitting
                                ? "Submitting..."
                                : "Submit Proof",
                            onPressed: _isSubmitting ? null : _submitProof,
                            color: VerifiTheme.neonMint,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Proof submitted, waiting for AI analysis
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
                                'PROOF SUBMITTED',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your proof has been submitted and is being analyzed by AI. The buyer will be notified of the results.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (contractState.aiProofAnalysis != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: contractState.aiApprovedProof
                                    ? VerifiTheme.neonMint.withValues(
                                        alpha: 0.2,
                                      )
                                    : VerifiTheme.signalOrange.withValues(
                                        alpha: 0.2,
                                      ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: contractState.aiApprovedProof
                                      ? VerifiTheme.neonMint
                                      : VerifiTheme.signalOrange,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        contractState.aiApprovedProof
                                            ? Icons.check_circle
                                            : Icons.warning,
                                        size: 16,
                                        color: contractState.aiApprovedProof
                                            ? VerifiTheme.neonMint
                                            : VerifiTheme.signalOrange,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        contractState.aiApprovedProof
                                            ? 'AI APPROVED'
                                            : 'AI REJECTED',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color:
                                                  contractState.aiApprovedProof
                                                  ? VerifiTheme.neonMint
                                                  : VerifiTheme.signalOrange,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    contractState.aiProofAnalysis!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            // If AI rejected, allow resubmission
                            if (!contractState.aiApprovedProof) ...[
                              const SizedBox(height: 16),
                              NeoPopButton(
                                icon: Icons.refresh,
                                text: "Resubmit Proof",
                                onPressed: () {
                                  ref
                                      .read(contractStateProvider.notifier)
                                      .resetProofSubmission();
                                  setState(() {
                                    _selectedImage = null;
                                    _proofTextController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You can now submit new proof',
                                      ),
                                      backgroundColor: VerifiTheme.neonMint,
                                    ),
                                  );
                                },
                                color: VerifiTheme.signalOrange,
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
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
