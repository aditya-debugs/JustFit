import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../data/models/achievement_model.dart';
import 'achievement_screen.dart';
import 'package:get/get.dart';
import '../../controllers/workout_plan_controller.dart';
import '../main_view/main_screen.dart'; // ✅ NEW

class StreakScreen extends StatefulWidget {
  final int currentStreak;
  final List<bool> weeklyProgress;
  final AchievementModel? achievement;

  const StreakScreen({
    Key? key,
    this.currentStreak = 1,
    this.weeklyProgress = const [true, false, false, false, false, false, false],
    this.achievement,
  }) : super(key: key);

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with TickerProviderStateMixin {
  late AnimationController _flameController;
  late AnimationController _contentController;
  late AnimationController _buttonController;
  late AnimationController _sparkleController;

  late Animation<double> _flameScale;
  late Animation<double> _flameOpacity;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _buttonScale;
  late Animation<Offset> _buttonSlide;

  List<SparkleParticle> _sparkles = [];

  @override
  void initState() {
    super.initState();

    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _flameScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flameController,
        curve: Curves.elasticOut,
      ),
    );

    _flameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flameController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _buttonScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOut,
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOut,
      ),
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _generateSparkles();
    _startAnimations();
  }

  void _generateSparkles() {
    final random = math.Random();
    for (int i = 0; i < 6; i++) {
      _sparkles.add(
        SparkleParticle(
          angle: random.nextDouble() * math.pi * 2,
          distance: 80 + random.nextDouble() * 40,
          size: 5 + random.nextDouble() * 3,
          delay: random.nextDouble() * 0.5,
        ),
      );
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _flameController.forward();

    await Future.delayed(const Duration(milliseconds: 1400));
    _contentController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _flameController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFlameWithSparkles(),
                        const SizedBox(height: 48),
                        AnimatedBuilder(
                          animation: _flameController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _flameOpacity.value,
                              child: Text(
                                'Day Streak!',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 60),
                        _buildWeeklyAchievement(),
                      ],
                    ),
                  ),
                ),
                _buildBottomSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildFlameWithSparkles() {
    return AnimatedBuilder(
      animation: _flameController,
      builder: (context, child) {
        return Opacity(
          opacity: _flameOpacity.value,
          child: Transform.scale(
            scale: _flameScale.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Yellow star sparkles
                ...List.generate(_sparkles.length, (index) {
                  return _buildSparkle(_sparkles[index]);
                }),
                // Main flame container
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Fire emoji - large version
                      const Text(
                        '🔥',
                        style: TextStyle(
                          fontSize: 80,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // Streak number
                      Positioned(
                        bottom: 30,
                        child: Text(
                          '${widget.currentStreak}',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSparkle(SparkleParticle particle) {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        final progress = (_sparkleController.value - particle.delay) % 1.0;
        final opacity = (math.sin(progress * math.pi) * 0.9).clamp(0.0, 1.0);
        final scale = 0.7 + (math.sin(progress * math.pi) * 0.3);

        final x = math.cos(particle.angle) * particle.distance;
        final y = math.sin(particle.angle) * particle.distance;

        return Transform.translate(
          offset: Offset(x, y),
          child: Transform.scale(
            scale: scale,
            child: CustomPaint(
              size: Size(particle.size * 2, particle.size * 2),
              painter: StarPainter(
                color: const Color(0xFFFFD700).withOpacity(opacity),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklyAchievement() {
    return SlideTransition(
      position: _contentSlide,
      child: FadeTransition(
        opacity: _contentFade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                'Weekly Achievement',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF424242),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildDayCircle(index),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(int index) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final isCompleted = index < widget.weeklyProgress.length && widget.weeklyProgress[index];

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFE91E63) : const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : Container(),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          days[index],
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return SlideTransition(
      position: _buttonSlide,
      child: ScaleTransition(
        scale: _buttonScale,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            children: [
              Text(
                'Do a workout every day to increase your streak!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ Check if there's a streak achievement to show
                    if (widget.achievement != null) {
                      // Show streak achievement first
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AchievementScreen(
                            achievement: widget.achievement!,
                            onContinue: () {
                              // After claiming streak achievement, go to Activity
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(initialIndex: 2),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      // No achievement - go directly to Activity
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(initialIndex: 2),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Claim Reward',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
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

class SparkleParticle {
  final double angle;
  final double distance;
  final double size;
  final double delay;

  SparkleParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });
}

// ✅ Star painter for yellow sparkles
class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;

    // Draw 5-pointed star
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;

      final outerX = center.dx + outerRadius * math.cos(outerAngle);
      final outerY = center.dy + outerRadius * math.sin(outerAngle);

      final innerX = center.dx + innerRadius * math.cos(innerAngle);
      final innerY = center.dy + innerRadius * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => oldDelegate.color != color;
}

/// Professional flame painter for large streak displays (StreakScreen)
/// Optimized proportions: 80x110 canvas size
// class FlamePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final width = size.width;
//     final height = size.height;

//     // ===== OUTER FLAME (Main Shape) =====
//     final outerPath = Path();
    
//     // Start at bottom center
//     outerPath.moveTo(width * 0.5, height * 0.98);
    
//     // Bottom left curve
//     outerPath.quadraticBezierTo(
//       width * 0.28, height * 0.92,
//       width * 0.18, height * 0.75,
//     );
    
//     // Left side mid curve
//     outerPath.quadraticBezierTo(
//       width * 0.12, height * 0.58,
//       width * 0.22, height * 0.38,
//     );
    
//     // Left upper curve
//     outerPath.quadraticBezierTo(
//       width * 0.28, height * 0.22,
//       width * 0.38, height * 0.12,
//     );
    
//     // Left tip
//     outerPath.quadraticBezierTo(
//       width * 0.42, height * 0.06,
//       width * 0.48, height * 0.02,
//     );
    
//     // Top peak
//     outerPath.quadraticBezierTo(
//       width * 0.5, 0,
//       width * 0.52, height * 0.02,
//     );
    
//     // Right tip
//     outerPath.quadraticBezierTo(
//       width * 0.58, height * 0.06,
//       width * 0.62, height * 0.12,
//     );
    
//     // Right upper curve
//     outerPath.quadraticBezierTo(
//       width * 0.72, height * 0.22,
//       width * 0.78, height * 0.38,
//     );
    
//     // Right side mid curve
//     outerPath.quadraticBezierTo(
//       width * 0.88, height * 0.58,
//       width * 0.82, height * 0.75,
//     );
    
//     // Bottom right curve
//     outerPath.quadraticBezierTo(
//       width * 0.72, height * 0.92,
//       width * 0.5, height * 0.98,
//     );
    
//     outerPath.close();

//     // Outer flame gradient (red to pink to dark pink)
//     final outerGradient = RadialGradient(
//       center: const Alignment(0, -0.1),
//       radius: 1.1,
//       colors: [
//         const Color(0xFFFF4444), // Bright red center
//         const Color(0xFFFF1744), // Primary red
//         const Color(0xFFE91E63), // Pink
//         const Color(0xFFD81B60), // Darker pink edge
//       ],
//       stops: const [0.0, 0.3, 0.7, 1.0],
//     );

//     paint.shader = outerGradient.createShader(
//       Rect.fromLTWH(0, 0, width, height),
//     );
    
//     canvas.drawPath(outerPath, paint);

//     // ===== MIDDLE HIGHLIGHT (Adds depth) =====
//     final middlePath = Path();
    
//     middlePath.moveTo(width * 0.5, height * 0.85);
    
//     middlePath.quadraticBezierTo(
//       width * 0.35, height * 0.78,
//       width * 0.28, height * 0.58,
//     );
    
//     middlePath.quadraticBezierTo(
//       width * 0.25, height * 0.42,
//       width * 0.35, height * 0.25,
//     );
    
//     middlePath.quadraticBezierTo(
//       width * 0.42, height * 0.12,
//       width * 0.5, height * 0.15,
//     );
    
//     middlePath.quadraticBezierTo(
//       width * 0.58, height * 0.12,
//       width * 0.65, height * 0.25,
//     );
    
//     middlePath.quadraticBezierTo(
//       width * 0.75, height * 0.42,
//       width * 0.72, height * 0.58,
//     );
    
//     middlePath.quadraticBezierTo(
//       width * 0.65, height * 0.78,
//       width * 0.5, height * 0.85,
//     );
    
//     middlePath.close();

//     final middleGradient = RadialGradient(
//       center: const Alignment(0, -0.2),
//       radius: 0.8,
//       colors: [
//         const Color(0xFFFF5252).withOpacity(0.9), // Bright highlight
//         const Color(0xFFFF1744).withOpacity(0.6), // Fade to transparent
//       ],
//     );

//     paint.shader = middleGradient.createShader(
//       Rect.fromLTWH(0, 0, width, height),
//     );
    
//     canvas.drawPath(middlePath, paint);

//     // ===== INNER HIGHLIGHT (Brightest core) =====
//     final innerPath = Path();
    
//     innerPath.moveTo(width * 0.5, height * 0.72);
    
//     innerPath.quadraticBezierTo(
//       width * 0.42, height * 0.65,
//       width * 0.38, height * 0.48,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.36, height * 0.35,
//       width * 0.42, height * 0.25,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.46, height * 0.18,
//       width * 0.5, height * 0.22,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.54, height * 0.18,
//       width * 0.58, height * 0.25,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.64, height * 0.35,
//       width * 0.62, height * 0.48,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.58, height * 0.65,
//       width * 0.5, height * 0.72,
//     );
    
//     innerPath.close();

//     final innerGradient = RadialGradient(
//       center: const Alignment(0, -0.3),
//       radius: 0.6,
//       colors: [
//         const Color(0xFFFFFFFF).withOpacity(0.4), // White hot center
//         const Color(0xFFFF6B6B).withOpacity(0.3), // Light red
//         const Color(0xFFFF1744).withOpacity(0.0), // Fade to transparent
//       ],
//       stops: const [0.0, 0.5, 1.0],
//     );

//     paint.shader = innerGradient.createShader(
//       Rect.fromLTWH(0, 0, width, height),
//     );
    
//     canvas.drawPath(innerPath, paint);

//     // ===== SUBTLE GLOW EFFECT =====
//     paint.shader = null;
//     paint.color = const Color(0xFFFF1744).withOpacity(0.1);
//     paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    
//     canvas.drawPath(outerPath, paint);
//   }

//   @override
//   bool shouldRepaint(FlamePainter oldDelegate) => false;
// }