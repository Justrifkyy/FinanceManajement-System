import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/runway_logo.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Animasi Logo Garis Tiga (Slash Kinetik)
  late final AnimationController _logoController;

  // Animasi Loading Progress Bar & Persentase Digital
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  // Animasi Bergerak Diagonal Barber-Pole Stripes
  late final AnimationController _stripeController;

  // Animasi Breathing Pulse untuk Glow & LED
  late final AnimationController _pulseController;

  Timer? _navigationTimer;
  bool _hasNavigated = false;
  int _currentStage = 1;

  final List<String> _stages = [
    '⚡ BOOTING CORE BUKU BESAR LOKAL...',
    '🛡️ MEMINDAI BANTALAN BULAN DEPAN (BUFFER)...',
    '📊 MENGKALKULASI RUNWAY & SURVIVAL RATIO...',
    '🔒 MENGUNCI ENKRIPSI PRIVASI DEVICE...',
    '🚀 SISTEM SIAP! MEMBUKA COCKPIT RUNWAY...',
  ];

  @override
  void initState() {
    super.initState();

    // 1. Controller Animasi Logo Garis Tiga
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // 2. Controller Strip Barber-Pole Bergerak
    _stripeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat();

    // 3. Controller Breathing Pulse untuk LED & Efek Glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // 4. Controller Progress Loading Kinetik
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // Listener progress untuk update tahapan status & haptik
    _progressController.addListener(() {
      final p = _progressController.value;
      int newStage = 1;
      if (p >= 0.88) {
        newStage = 5;
      } else if (p >= 0.65) {
        newStage = 4;
      } else if (p >= 0.40) {
        newStage = 3;
      } else if (p >= 0.18) {
        newStage = 2;
      }

      if (newStage != _currentStage) {
        setState(() {
          _currentStage = newStage;
        });
        HapticFeedback.lightImpact();
      }
    });

    // Jalankan animasi bertahap
    _logoController.forward();
    _progressController.forward();

    // Auto-navigate setelah selesai penuh
    _navigationTimer = Timer(const Duration(milliseconds: 2700), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _navigationTimer?.cancel();
    HapticFeedback.mediumImpact();
    context.go('/home');
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _logoController.dispose();
    _progressController.dispose();
    _stripeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: Stack(
        children: [
          // 1. Blueprint Tactical Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: _TacticalGridPainter(),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- TOP COCKPIT BAR ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Versi & Status Privasi
                      const Stamp(
                        text: 'RUNWAY // SYS.V1.0',
                        backgroundColor: BrutalTokens.paper,
                      ),

                      // Heartbeat LED
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final pulse = _pulseController.value;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: 1.5,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: BrutalTokens.safe,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: BrutalTokens.ink,
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: BrutalTokens.safe.withValues(alpha: 0.3 + pulse * 0.7),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'COCKPIT ONLINE',
                                  style: TextStyle(
                                    fontFamily: BrutalTokens.fontNumbers,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    color: BrutalTokens.ink,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // --- CENTER STAGE: ANIMATED 3-LINES LOGO & BRAND ---
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Frame Logo Neo-Brutalism dengan Animasi Garis Tiga
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Yellow Offset Backplate
                              Transform.translate(
                                offset: const Offset(6, 6),
                                child: Container(
                                  width: 136,
                                  height: 136,
                                  color: BrutalTokens.ink,
                                ),
                              ),

                              // Kotak Utama Logo
                              Container(
                                width: 136,
                                height: 136,
                                decoration: BoxDecoration(
                                  color: BrutalTokens.paper,
                                  border: Border.all(
                                    color: BrutalTokens.ink,
                                    width: BrutalTokens.borderBase,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Tactical corner tabs
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        color: BrutalTokens.warn,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        color: BrutalTokens.ink,
                                      ),
                                    ),

                                    // Logo Garis Tiga dengan Animasi Slash Kinetik
                                    Center(
                                      child: AnimatedBuilder(
                                        animation: _logoController,
                                        builder: (context, child) {
                                          return AnimatedRunwayThreeLines(
                                            size: 110,
                                            progress: _logoController.value,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          // Brand Title: RUNWAY ///
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'RUNWAY',
                                style: TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Text(
                                    '///',
                                    style: TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.0,
                                      color: BrutalTokens.warn,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Tagline Keuangan & Daya Tahan
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                            ),
                            child: const Text(
                              'MANAJEMEN DAYA TAHAN HIDUP & KEUANGAN',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- BOTTOM STAGE: LOADING EFFECT HUD ---
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _progressAnimation,
                      _stripeController,
                    ]),
                    builder: (context, child) {
                      final progress = _progressAnimation.value;
                      final percentInt = (progress * 100).toInt().clamp(0, 100);
                      final isComplete = percentInt >= 100;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Giant Digital Percentage Display & Status Step
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Ticker Status Title
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    color: BrutalTokens.ink,
                                    child: Text(
                                      'TAHAP [0$_currentStage/05]',
                                      style: const TextStyle(
                                        fontFamily: BrutalTokens.fontNumbers,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color: BrutalTokens.paper,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isComplete
                                        ? 'SIAP BERTAHAN!'
                                        : 'MEMPERSIAPKAN SISTEM...',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                ],
                              ),

                              // Giant Percentage Readout
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    percentInt.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.0,
                                      color: BrutalTokens.ink,
                                      height: 1.0,
                                    ),
                                  ),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Dynamic Barber-Pole Animated Progress Bar
                          Container(
                            height: 18,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderBase,
                              ),
                              boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                            ),
                            child: Stack(
                              children: [
                                // Active animated fill with moving diagonal stripes
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progress.clamp(0.02, 1.0),
                                  child: ClipRect(
                                    child: CustomPaint(
                                      size: const Size(double.infinity, 18),
                                      painter: _AnimatedBarberPolePainter(
                                        stripeOffset: _stripeController.value,
                                        primaryColor: isComplete ? BrutalTokens.safe : BrutalTokens.warn,
                                        stripeColor: BrutalTokens.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Detailed Step Ticker Terminal
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: BrutalTokens.borderThin,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (!isComplete)
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: BrutalTokens.ink,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: BrutalTokens.ink,
                                  ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _stages[_currentStage - 1],
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontNumbers,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.4,
                                      color: BrutalTokens.ink,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Action Button jika sudah selesai / ingin langsung masuk
                          if (isComplete)
                            BrutalButton(
                              text: 'MASUK KE COCKPIT ➔',
                              variant: BrutalButtonVariant.primary,
                              isFullWidth: true,
                              onPressed: _navigateToHome,
                            )
                          else
                            const Text(
                              'DATA TERSIMPAN LOKAL · TANPA SERVER PIHAK KETIGA',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: BrutalTokens.muted,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter untuk efek garis miring bergerak (Barber-Pole Striped Loading Bar)
class _AnimatedBarberPolePainter extends CustomPainter {
  final double stripeOffset; // 0.0 to 1.0
  final Color primaryColor;
  final Color stripeColor;

  _AnimatedBarberPolePainter({
    required this.stripeOffset,
    required this.primaryColor,
    required this.stripeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double stripeWidth = 10.0;
    final bgPaint = Paint()..color = primaryColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final stripePaint = Paint()
      ..color = stripeColor
      ..style = PaintingStyle.fill;

    final double step = stripeWidth * 2;
    final double shift = stripeOffset * step;

    final path = Path();
    for (double x = -size.height - step + shift; x < size.width + size.height; x += step) {
      path.reset();
      path.moveTo(x, size.height);
      path.lineTo(x + stripeWidth, size.height);
      path.lineTo(x + stripeWidth + size.height, 0);
      path.lineTo(x + size.height, 0);
      path.close();
      canvas.drawPath(path, stripePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedBarberPolePainter oldDelegate) {
    return oldDelegate.stripeOffset != stripeOffset ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.stripeColor != stripeColor;
  }
}

/// Painter latar belakang kotak-kotak blueprint teknikal (Tactical Grid)
class _TacticalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = BrutalTokens.ink.withValues(alpha: 0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double gridSize = 32.0;

    // Horizontal & Vertical Grid Lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Corner Tactical Brackets
    final cornerPaint = Paint()
      ..color = BrutalTokens.ink.withValues(alpha: 0.25)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const bracketSize = 16.0;
    const margin = 12.0;

    // Top-Left
    canvas.drawLine(const Offset(margin, margin), const Offset(margin + bracketSize, margin), cornerPaint);
    canvas.drawLine(const Offset(margin, margin), const Offset(margin, margin + bracketSize), cornerPaint);

    // Top-Right
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin - bracketSize, margin), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin, margin + bracketSize), cornerPaint);

    // Bottom-Left
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin + bracketSize, size.height - margin), cornerPaint);
    canvas.drawLine(Offset(margin, size.height - margin), Offset(margin, size.height - margin - bracketSize), cornerPaint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin - bracketSize, size.height - margin), cornerPaint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin), Offset(size.width - margin, size.height - margin - bracketSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _TacticalGridPainter oldDelegate) => false;
}
