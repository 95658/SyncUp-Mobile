import 'package:flutter/material.dart';
import 'package:syncup/app/core/extensions/size_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/widgets/common/syncup_logo.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  // Logo Card Entrance animations
  late final Animation<double> _cardScaleAnimation;
  late final Animation<double> _cardRotationAnimation;
  late final Animation<double> _cardFadeAnimation;

  // Path Drawing & Connection animations
  late final Animation<double> _pathDrawAnimation;
  late final Animation<double> _nodePopAnimation;
  late final Animation<double> _centerPulseAnimation;
  late final Animation<double> _rippleAuraAnimation;
  late final Animation<double> _shimmerAnimation;

  // Typography animations
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _subtitleSlideAnimation;
  late final Animation<double> _subtitleFadeAnimation;
  late final Animation<double> _badgeFadeAnimation;

  // Ambient Floating & Glow
  late final Animation<double> _floatAnimation;
  late final Animation<double> _ambientGlowAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Master Entrance Sequence (1650ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    );

    // Card Scale & Spring Bounce (0ms - 650ms)
    _cardScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.42, curve: Curves.easeOutBack),
      ),
    );

    // Subtle 3D Tilt rotation settling to 0 (0ms - 550ms)
    _cardRotationAnimation = Tween<double>(begin: -0.10, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // Dynamic "Connected S" Path Drawing (250ms - 950ms)
    _pathDrawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.60, curve: Curves.easeInOutCubic),
      ),
    );

    // Top & Bottom Connection Nodes Elastic Pop (600ms - 1050ms)
    _nodePopAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.38, 0.68, curve: Curves.elasticOut),
      ),
    );

    // Center Node Connection Pulse Flash (650ms - 1000ms)
    _centerPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.40, 0.65),
      ),
    );

    // Energy Ripple Ring expanding outwards (550ms - 1250ms)
    _rippleAuraAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // Subtle Glass Shimmer Sweep across the card (700ms - 1350ms)
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.82, curve: Curves.easeInOutSine),
      ),
    );

    // Title Reveal (850ms - 1350ms)
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.82, curve: Curves.easeOutCubic),
      ),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.78, curve: Curves.easeIn),
      ),
    );

    // Subtitle Reveal (950ms - 1500ms)
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.58, 0.88, curve: Curves.easeIn),
      ),
    );

    // Bottom Badge Reveal (1100ms - 1650ms)
    _badgeFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. Ambient Floating & Breathing Controller (2400ms loop)
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _floatAnimation = Tween<double>(begin: -3.5, end: 3.5).animate(
      CurvedAnimation(
        parent: _ambientController,
        curve: Curves.easeInOutSine,
      ),
    );

    _ambientGlowAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(
        parent: _ambientController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Chain entrance -> ambient loop
    _entranceController.forward().then((_) {
      if (mounted) {
        _ambientController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0F1D),
        gradient: RadialGradient(
          center: Alignment(0, -0.15),
          radius: 1.1,
          colors: [
            Color(0xFF13203C),
            Color(0xFF090D1A),
            Color(0xFF050811),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            // Animated Logo Presentation
            AnimatedBuilder(
              animation: Listenable.merge([_entranceController, _ambientController]),
              builder: (context, child) {
                final isDone = _entranceController.isCompleted;
                final floatY = isDone ? _floatAnimation.value : 0.0;
                final glowPulse = isDone ? _ambientGlowAnimation.value : 1.0;

                return Transform.translate(
                  offset: Offset(0, floatY),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Expanding Aura Energy Rings
                      if (_rippleAuraAnimation.value > 0.0)
                        CustomPaint(
                          size: const Size(220, 220),
                          painter: _AuraRipplePainter(
                            progress: _rippleAuraAnimation.value,
                            pulse: glowPulse,
                          ),
                        ),

                      // Animated Logo Card
                      Transform.rotate(
                        angle: _cardRotationAnimation.value,
                        child: Transform.scale(
                          scale: _cardScaleAnimation.value * (isDone ? glowPulse : 1.0),
                          child: Opacity(
                            opacity: _cardFadeAnimation.value,
                            child: Stack(
                              clipBehavior: Clip.antiAlias,
                              children: [
                                SyncUpLogo(
                                  size: 96,
                                  borderRadius: 26,
                                  showGlow: true,
                                  isDark: true,
                                  drawProgress: _pathDrawAnimation.value,
                                  nodeProgress: _nodePopAnimation.value,
                                  centerDotPulse: _centerPulseAnimation.value,
                                ),

                                // Diagonal glass shimmer reflection sweep
                                if (_shimmerAnimation.value > -0.5 && _shimmerAnimation.value < 1.5)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26),
                                      child: Transform.translate(
                                        offset: Offset(96 * (_shimmerAnimation.value - 0.5), 0),
                                        child: Transform.rotate(
                                          angle: 0.5,
                                          child: Container(
                                            width: 32,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withAlpha(0),
                                                  Colors.white.withAlpha(45),
                                                  Colors.white.withAlpha(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Height(32),

            // Animated App Name
            SlideTransition(
              position: _titleSlideAnimation,
              child: FadeTransition(
                opacity: _titleFadeAnimation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sync',
                      style: context.bold24TextMain.copyWith(
                        color: Colors.white,
                        letterSpacing: -0.7,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Up',
                      style: context.bold24TextMain.copyWith(
                        color: const Color(0xFFFB7185),
                        letterSpacing: -0.7,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Height(10),

            // Animated Slogan
            SlideTransition(
              position: _subtitleSlideAnimation,
              child: FadeTransition(
                opacity: _subtitleFadeAnimation,
                child: Text(
                  tr.splash.tagline,
                  style: context.roman14Secondary.copyWith(
                    color: const Color(0xFFE3D1D8),
                    letterSpacing: 0.3,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Bottom Platform Security & Enterprise Badge
            FadeTransition(
              opacity: _badgeFadeAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1118).withAlpha(160),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFB7185).withAlpha(45),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF10B981),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const Width(8),
                    Text(
                      tr.splash.architecture,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Height(24),
          ],
        ),
      ),
    );
  }
}

/// Dynamic expanding aura rings behind the logo during splash entrance
class _AuraRipplePainter extends CustomPainter {
  final double progress;
  final double pulse;

  _AuraRipplePainter({required this.progress, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ring 1 (Crimson Energy Wave)
    final radius1 = 48 + (progress * 46);
    final opacity1 = (1.0 - progress).clamp(0.0, 1.0) * 0.35;
    final paint1 = Paint()
      ..color = const Color(0xFFE11D48).withAlpha((opacity1 * 255).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius1, paint1);

    // Ring 2 (Deep Burgundy Aura)
    if (progress > 0.2) {
      final subProg = (progress - 0.2) / 0.8;
      final radius2 = 48 + (subProg * 58);
      final opacity2 = (1.0 - subProg).clamp(0.0, 1.0) * 0.25;
      final paint2 = Paint()
        ..color = const Color(0xFF8B0021).withAlpha((opacity2 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius2, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant _AuraRipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulse != pulse;
  }
}
