import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../providers/app_providers.dart';
import '../models/connection_state.dart' as conn;

class FindingMerchantScreen extends ConsumerStatefulWidget {
  final VoidCallback? onTimeout;
  final Duration timeout;

  const FindingMerchantScreen({
    Key? key,
    this.onTimeout,
    this.timeout = const Duration(seconds: 30),
  }) : super(key: key);

  @override
  ConsumerState<FindingMerchantScreen> createState() =>
      _FindingMerchantScreenState();
}

class _FindingMerchantScreenState extends ConsumerState<FindingMerchantScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _dotsController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  ProviderSubscription<conn.AppConnectionState>? _connectionSubscription;
  bool _hasPoppedAfterConnect = false;

  String _statusText = 'Finding merchant';
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    _connectionSubscription = ref.listenManual(connectionStateProvider, (
      previous,
      next,
    ) {
      debugPrint(
        '🔔 FindingMerchantScreen: Connection status changed to ${next.status}',
      );
      final shouldClose =
          !_hasPoppedAfterConnect &&
          next.status == conn.ConnectionStatus.connected &&
          mounted;
      if (shouldClose) {
        _hasPoppedAfterConnect = true;
        debugPrint('🚪 Closing FindingMerchantScreen...');
        Navigator.of(context).pop();
      }
    });

    // Rotation animation for the outer ring
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Pulse animation for the center circle
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Dots animation for loading text
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _dotsController.addListener(() {
      setState(() {
        _dotCount = (_dotsController.value * 4).floor() % 4;
      });
    });

    // Fade animation for status text
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.repeat(reverse: true);

    // Cycle through different status messages
    _cycleStatusMessages();

    // Handle timeout
    if (widget.onTimeout != null) {
      Future.delayed(widget.timeout, () {
        if (mounted) {
          widget.onTimeout!();
        }
      });
    }
  }

  void _cycleStatusMessages() {
    final messages = [
      'Finding merchant',
      'Establishing connection',
      'Securing channel',
      'Almost there',
    ];

    int index = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;

      setState(() {
        index = (index + 1) % messages.length;
        _statusText = messages[index];
      });

      return true;
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.close();
    _rotationController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main animation container
              SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating rings
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: CustomPaint(
                            size: const Size(250, 250),
                            painter: RingsPainter(
                              color: Colors.blueAccent.withOpacity(0.3),
                            ),
                          ),
                        );
                      },
                    ),

                    // Middle rotating ring (opposite direction)
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: -_rotationAnimation.value * 0.5,
                          child: CustomPaint(
                            size: const Size(180, 180),
                            painter: RingsPainter(
                              color: Colors.cyanAccent.withOpacity(0.4),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),

                    // Pulsing center circle
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  Colors.blueAccent.shade200,
                                  Colors.blueAccent.shade400,
                                ],
                                stops: const [0.3, 0.7, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.store_mall_directory_rounded,
                              color: Color(0xFF0A0E27),
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),

                    // Orbiting dots
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          final angle =
                              _rotationAnimation.value +
                              (index * 2 * math.pi / 3);
                          final radius = 100.0;
                          return Transform.translate(
                            offset: Offset(
                              radius * math.cos(angle),
                              radius * math.sin(angle),
                            ),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.cyanAccent.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Status text with fade animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      '$_statusText${'.' * _dotCount}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Loading bar
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: (_rotationController.value * 2) % 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.cyanAccent,
                                  Colors.blueAccent,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 80),

              // Cancel button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the rotating rings
class RingsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  RingsPainter({required this.color, this.strokeWidth = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw main ring
    canvas.drawCircle(center, radius, paint);

    // Draw decorative arcs
    paint.color = color.withOpacity(0.6);
    paint.strokeWidth = strokeWidth * 1.5;

    for (int i = 0; i < 4; i++) {
      final startAngle = i * math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        startAngle,
        math.pi / 6,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative Wave Animation Style
class WaveConnectionScreen extends StatefulWidget {
  const WaveConnectionScreen({Key? key}) : super(key: key);

  @override
  State<WaveConnectionScreen> createState() => _WaveConnectionScreenState();
}

class _WaveConnectionScreenState extends State<WaveConnectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final delay = index * 0.1;
                      final value = math.sin(
                        (_waveController.value + delay) * 2 * math.pi,
                      );

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 40 + value * 20,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, value * 5),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Connecting to Merchant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
