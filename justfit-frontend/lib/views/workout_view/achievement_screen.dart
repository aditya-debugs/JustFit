import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../data/models/achievement_model.dart';
import '../../controllers/workout_plan_controller.dart';
import 'streak_screen.dart';
import '../main_view/main_screen.dart'; // ✅ NEW

class AchievementScreen extends StatefulWidget {
  final AchievementModel achievement;
  final VoidCallback? onContinue;

  const AchievementScreen({
    Key? key,
    required this.achievement,
    this.onContinue,
  }) : super(key: key);

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with TickerProviderStateMixin {
  late AnimationController _badgeController;
  late AnimationController _confettiController;
  late AnimationController _spotlightController;
  late AnimationController _contentController;
  late AnimationController _floatingController;

  late Animation<double> _badgeScale;
  late Animation<double> _badgeRotation;
  late Animation<double> _badgeOpacity;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _floatingAnimation;

  List<ConfettiParticle> _confettiParticles = [];
  Timer? _confettiTimer;

  @override
  void initState() {
    super.initState();

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _badgeRotation = Tween<double>(begin: math.pi * 2, end: 0.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _spotlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOut,
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOut,
      ),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _generateConfetti();

    await Future.delayed(const Duration(milliseconds: 100));
    _spotlightController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _badgeController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _confettiController.forward();
    _startConfettiFall();

    await Future.delayed(const Duration(milliseconds: 800));
    _contentController.forward();
  }

  void _generateConfetti() {
    final random = math.Random();
    _confettiParticles.clear();

    for (int i = 0; i < 80; i++) {
      _confettiParticles.add(
        ConfettiParticle(
          x: random.nextDouble(),
          startY: -0.1 - random.nextDouble() * 0.4,
          size: 6 + random.nextDouble() * 6,
          color: _getRandomConfettiColor(),
          rotation: random.nextDouble() * math.pi * 2,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
          fallSpeed: 0.5 + random.nextDouble() * 0.6,
          horizontalDrift: (random.nextDouble() - 0.5) * 0.12,
          shape: random.nextInt(3),
        ),
      );
    }
  }

  Color _getRandomConfettiColor() {
    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFFFF6B9D),
      const Color(0xFF9D4EDD),
      const Color(0xFF06FFA5),
      const Color(0xFF4CC9F0),
      const Color(0xFFFFBE0B),
      const Color(0xFFFB5607),
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  void _startConfettiFall() {
    _confettiTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted && _confettiController.isAnimating) {
        setState(() {
          for (var particle in _confettiParticles) {
            particle.update(_confettiController.value);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _confettiController.dispose();
    _spotlightController.dispose();
    _contentController.dispose();
    _floatingController.dispose();
    _confettiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF2A1B3D),
              Color(0xFF1A1625),
              Color(0xFF0D0B15),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _buildSpotlight(),

            Positioned.fill(
              child: CustomPaint(
                painter: ConfettiPainter(
                  particles: _confettiParticles,
                  animation: _confettiController.value,
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBadge(),
                          const SizedBox(height: 60),
                          _buildContent(),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlight() {
    return AnimatedBuilder(
      animation: _spotlightController,
      builder: (context, child) {
        return Positioned(
          top: -200,
          left: MediaQuery.of(context).size.width / 2 - 200,
          child: Opacity(
            opacity: _spotlightController.value * 0.4,
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge() {
    return AnimatedBuilder(
      animation: Listenable.merge([_badgeController, _floatingController]),
      builder: (context, child) {
        return Opacity(
          opacity: _badgeOpacity.value,
          child: Transform.translate(
            offset: Offset(
              0,
              _badgeController.isCompleted ? _floatingAnimation.value : 0,
            ),
            child: Transform.scale(
              scale: _badgeScale.value,
              child: Transform.rotate(
                angle: _badgeRotation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_badgeController.isCompleted)
                      AnimatedBuilder(
                        animation: _floatingController,
                        builder: (context, child) {
                          final glowSize = 280 + (_floatingAnimation.value.abs() * 2);
                          return Container(
                            width: glowSize,
                            height: glowSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.achievement.badgeStyle.primaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    
                    Container(
                      width: 260,
                      height: 260,
                      child: CustomPaint(
                        painter: ColorfulBadgePainter(
                          number: widget.achievement.badgeNumber,
                          primaryColor: widget.achievement.badgeStyle.primaryColor,
                          accentColor: widget.achievement.badgeStyle.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _contentSlide,
      child: FadeTransition(
        opacity: _contentFade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Text(
                'ACHIEVEMENT',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.achievement.title,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.achievement.description,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                _getCurrentDate(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            if (widget.onContinue != null) {
              Navigator.pop(context);
              widget.onContinue!();
            } else {
              final controller = Get.find<WorkoutPlanController>();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StreakScreen(
                    currentStreak: controller.userStreak.value,
                    weeklyProgress: controller.weeklyProgress.toList(),
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}.${now.year}';
  }
}

class ConfettiParticle {
  double x;
  double startY;
  double currentY;
  final double size;
  final Color color;
  double rotation;
  final double rotationSpeed;
  final double fallSpeed;
  final double horizontalDrift;
  final int shape;

  ConfettiParticle({
    required this.x,
    required this.startY,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.fallSpeed,
    required this.horizontalDrift,
    required this.shape,
  }) : currentY = startY;

  void update(double progress) {
    currentY = startY + (3.5 * progress * fallSpeed);
    x += horizontalDrift * 0.01;
    rotation += rotationSpeed;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animation;

  ConfettiPainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = size.width * particle.x;
      final y = size.height * particle.currentY;
      
      double opacity = 1.0;
      if (particle.currentY > 0.7) {
        opacity = 1.0 - ((particle.currentY - 0.7) / 0.5).clamp(0.0, 1.0);
      }
      
      if (opacity <= 0.0) continue;
      if (y > size.height * 1.5) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      switch (particle.shape) {
        case 0:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
          break;
        case 1:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
        case 2:
          final path = Path()
            ..moveTo(0, -particle.size / 2)
            ..lineTo(particle.size / 2, particle.size / 2)
            ..lineTo(-particle.size / 2, particle.size / 2)
            ..close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class ColorfulBadgePainter extends CustomPainter {
  final int number;
  final Color primaryColor;
  final Color accentColor;

  ColorfulBadgePainter({
    required this.number,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final wavePath = Path();
    final waveCount = 8;
    final angleStep = (2 * math.pi) / waveCount;

    for (int i = 0; i < waveCount; i++) {
      final angle = i * angleStep;
      final nextAngle = (i + 1) * angleStep;

      final outerRadius = radius * 0.95;
      final outerX = center.dx + math.cos(angle) * outerRadius;
      final outerY = center.dy + math.sin(angle) * outerRadius;

      final innerRadius = radius * 0.75;
      final innerAngle = angle + angleStep / 2;
      final innerX = center.dx + math.cos(innerAngle) * innerRadius;
      final innerY = center.dy + math.sin(innerAngle) * innerRadius;

      if (i == 0) wavePath.moveTo(outerX, outerY);

      wavePath.quadraticBezierTo(
        innerX,
        innerY,
        center.dx + math.cos(nextAngle) * outerRadius,
        center.dy + math.sin(nextAngle) * outerRadius,
      );

      if (i % 2 == 0) {
        final petalPaint = Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;

        final petalPath = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(outerX, outerY)
          ..quadraticBezierTo(
            innerX,
            innerY,
            center.dx + math.cos(nextAngle) * outerRadius,
            center.dy + math.sin(nextAngle) * outerRadius,
          )
          ..close();

        canvas.drawPath(petalPath, petalPaint);
      }
    }

    wavePath.close();

    final borderPaint = Paint()
      ..color = const Color(0xFF8E8E93)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(wavePath, borderPaint);

    final circlePaint = Paint()
      ..color = const Color(0xFFF5F5F5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.65, circlePaint);

    final innerBorderPaint = Paint()
      ..color = const Color(0xFFD1D1D6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.65, innerBorderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: number.toString(),
        style: TextStyle(
          fontSize: size.width * 0.35,
          fontWeight: FontWeight.w300,
          color: const Color(0xFFBDBDBD),
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 - size.height * 0.08,
      ),
    );

    final workoutTextPainter = TextPainter(
      text: TextSpan(
        text: 'WORKOUT',
        style: TextStyle(
          fontSize: size.width * 0.08,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFC0C0C0),
          letterSpacing: 2,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    workoutTextPainter.layout();
    workoutTextPainter.paint(
      canvas,
      Offset(
        center.dx - workoutTextPainter.width / 2,
        center.dy + size.height * 0.05,
      ),
    );
  }

  @override
  bool shouldRepaint(ColorfulBadgePainter oldDelegate) => false;
}