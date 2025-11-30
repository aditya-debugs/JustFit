import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'heart_rate_measure_screen.dart';
import 'achievement_screen.dart';
import '../../core/animations/page_transitions.dart';
import '../../data/models/achievement_model.dart';
import '../../controllers/workout_plan_controller.dart';
import 'streak_screen.dart';
import 'package:get/get.dart';
import '../main_view/main_screen.dart'; // ✅ NEW
import '../../data/models/workout/workout_exercise.dart';
import '../../controllers/workout_audio_controller.dart';
import '../../data/models/workout/simple_workout_models.dart'; // ✅ ADD THIS

class WorkoutCompleteScreen extends StatefulWidget {
  final int dayNumber;
  final int totalCalories;
  final int totalMinutes;
  final int totalActions;
  final String workoutName;
  final AchievementModel? earnedAchievement;
  final bool isPartialWorkout; // ✅ NEW
  final List<WorkoutExercise> exercises;
  final String? discoveryWorkoutId; // ✅ NEW - null for plan workouts
  final String? discoveryWorkoutTitle; // ✅ NEW - null for plan workouts
  final String? discoveryCategory; // ✅ NEW - null for plan workouts
  final List<WorkoutSet>? fullWorkoutSets; // ✅ NEW

  const WorkoutCompleteScreen({
    Key? key,
    required this.dayNumber,
    required this.totalCalories,
    required this.totalMinutes,
    required this.totalActions,
    this.workoutName = 'Abs Starter: Quick Core Activation',
    this.earnedAchievement,
    this.isPartialWorkout = false, // ✅ NEW default
    required this.exercises, // ✅ ADD THIS
    this.discoveryWorkoutId, // ✅ NEW
    this.discoveryWorkoutTitle, // ✅ NEW
    this.discoveryCategory, // ✅ NEW
    this.fullWorkoutSets, // ✅ NEW
  }) : super(key: key);

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _thumbsUpController;
  late AnimationController _fireworksController;
  late AnimationController _contentController;

  late Animation<double> _thumbsUpScale;
  late Animation<double> _thumbsUpRotation;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  List<Firework> _fireworks = [];
  Timer? _fireworkTimer;

  // ✅ Flag to prevent multiple saves
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // ✅ Play "Woo-hoo" message with proper async handling
    Future.delayed(const Duration(milliseconds: 300), () async {
      try {
        final audioController = Get.find<WorkoutAudioController>();
        await audioController.playWorkoutComplete();
      } catch (e) {
        print('⚠️ Could not play workout complete audio: $e');
      }
    });

    // Thumbs up animation
    _thumbsUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _thumbsUpScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _thumbsUpController,
        curve: Curves.elasticOut,
      ),
    );

    _thumbsUpRotation = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _thumbsUpController,
        curve: Curves.easeOut,
      ),
    );

    // Fireworks controller (continuous loop)
    _fireworksController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Content fade in
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOut,
      ),
    );

    // Start animations
    _startAnimations();
    _startFireworks();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _thumbsUpController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();
  }

  void _startFireworks() {
    // Generate initial fireworks
    _generateFireworks();

    // Periodically add new fireworks
    _fireworkTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _generateFireworks();
        });
      }
    });
  }

  void _generateFireworks() {
    final random = math.Random();

    // Add 2-3 new fireworks at random positions
    for (int i = 0; i < 2 + random.nextInt(2); i++) {
      _fireworks.add(
        Firework(
          x: 0.2 + random.nextDouble() * 0.6, // Random position (20% - 80%)
          y: 0.15 + random.nextDouble() * 0.3, // Upper portion (15% - 45%)
          color: _getRandomFireworkColor(),
          particleCount: 8 + random.nextInt(5), // 8-12 particles
          startTime: DateTime.now(),
        ),
      );
    }

    // Remove old fireworks (older than 2 seconds)
    _fireworks.removeWhere((fw) {
      return DateTime.now().difference(fw.startTime).inMilliseconds > 2000;
    });
  }

  Color _getRandomFireworkColor() {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFF98FB98), // Pale green
      const Color(0xFFDDA0DD), // Plum
      const Color(0xFFFFA07A), // Light salmon
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    _thumbsUpController.dispose();
    _fireworksController.dispose();
    _contentController.dispose();
    _fireworkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // ✅ Navigate to Activity tab
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainScreen(initialIndex: 2),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Fireworks background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _fireworksController,
              builder: (context, child) {
                return CustomPaint(
                  painter: FireworksPainter(
                    fireworks: _fireworks,
                    animation: _fireworksController.value,
                  ),
                );
              },
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Thumbs up emoji with animation
                    AnimatedBuilder(
                      animation: _thumbsUpController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _thumbsUpScale.value,
                          child: Transform.rotate(
                            angle: _thumbsUpRotation.value,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '👍',
                                  style: TextStyle(fontSize: 90),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Animated content
                    SlideTransition(
                      position: _contentSlide,
                      child: FadeTransition(
                        opacity: _contentFade,
                        child: Column(
                          children: [
                            // Congrats text - dynamic based on completion
                            Text(
                              widget.isPartialWorkout
                                  ? 'Good Effort!'
                                  : 'Congrats!',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Completion text - dynamic based on completion
                            Text(
                              widget.isPartialWorkout
                                  ? 'You completed part of ${widget.workoutName}'
                                  : 'You completed 「${widget.workoutName}」',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF757575),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 48),

                            // Stats section
                            _buildStatsSection(),

                            const SizedBox(height: 48),

                            // Save and Continue button
                            _buildSaveButton(),

                            const SizedBox(height: 16),

                            // Measure Heart Rate button
                            _buildMeasureHeartRateButton(),

                            const SizedBox(height: 32),
                          ],
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
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            emoji: '🔥',
            value: '${widget.totalCalories}',
            label: 'Kcal',
          ),
          Container(
            width: 1,
            height: 50,
            color: const Color(0xFFE0E0E0),
          ),
          _buildStatItem(
            emoji: '⏱️',
            value: '${widget.totalMinutes}',
            label: 'Min',
          ),
          Container(
            width: 1,
            height: 50,
            color: const Color(0xFFE0E0E0),
          ),
          _buildStatItem(
            emoji: '💪',
            value: '${widget.totalActions}',
            label: widget.isPartialWorkout ? 'Done' : 'Action',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE91E63),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleSaveAndContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          'Save and Continue',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  /// ✅ PRODUCTION-GRADE FLOW HANDLER
  Future<void> _handleSaveAndContinue() async {
    // ✅ Prevent multiple taps
    if (_isSaving) {
      print('⚠️ Already saving workout, ignoring duplicate tap');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final workoutPlanController = Get.find<WorkoutPlanController>();

      // ✅ CHECK: Is this a discovery workout or plan workout?
      final isDiscoveryWorkout = widget.discoveryWorkoutId != null;

      Map<String, dynamic> result;

      if (isDiscoveryWorkout) {
        // ===== DISCOVERY WORKOUT FLOW =====
        print('🔍 Processing DISCOVERY workout completion...');

        result = await workoutPlanController.completeDiscoveryWorkout(
          workoutId: widget.discoveryWorkoutId!,
          workoutTitle: widget.discoveryWorkoutTitle ?? 'Discovery Workout',
          caloriesBurned: widget.totalCalories,
          durationMinutes: widget.totalMinutes,
          workoutCategory: widget.discoveryCategory ?? 'general',
        );
      } else {
        // ===== PLAN WORKOUT FLOW (ORIGINAL - UNTOUCHED) =====
        print('📅 Processing PLAN workout completion...');

        result = await workoutPlanController.completeWorkout(
          dayNumber: widget.dayNumber,
          caloriesBurned: widget.totalCalories,
          durationMinutes: widget.totalMinutes,
          workoutType: 'daily_workout',
          isFullCompletion: !widget.isPartialWorkout,
        );
      }

      if (result['success'] != true) {
        print('⚠️ Failed to save workout completion');
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScreen(initialIndex: 2),
            ),
            (route) => false,
          );
        }
        return;
      }

      // 2. Get achievements from result (same for both flows)
      final workoutAchievement =
          result['workoutAchievement'] as AchievementModel?;
      final streakAchievement =
          result['streakAchievement'] as AchievementModel?;
      final currentStreak = result['currentStreak'] as int? ?? 0;
      final weeklyProgress = result['weeklyProgress'] as List<bool>? ?? [];

      print('🏆 Workout achievement: ${workoutAchievement?.title ?? 'None'}');
      print('🔥 Streak achievement: ${streakAchievement?.title ?? 'None'}');
      print('🔥 Current streak: $currentStreak days');

      if (!mounted) return;

      // 3. NAVIGATION FLOW

      // ✅ Check for workout count achievement FIRST (even for partial workouts)
      if (workoutAchievement != null) {
        // Show workout achievement
        Navigator.pushReplacement(
          context,
          PageTransitions.scale(
            AchievementScreen(
              achievement: workoutAchievement,
              onContinue: () {
                // After workout achievement
                if (widget.isPartialWorkout) {
                  // Partial workout - skip streak screen, go to activity
                  print(
                      '⚠️ Partial workout - skipping streak screen after achievement');
                  // Use pushAndRemoveUntil to clear entire stack
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                } else if (currentStreak >= 1) {
                  // Full workout - show streak screen
                  Navigator.of(context).pushReplacement(
                    PageTransitions.fadeSlideFromRight(
                      StreakScreen(
                        currentStreak: currentStreak,
                        weeklyProgress: weeklyProgress,
                        achievement: streakAchievement,
                      ),
                      durationMs: 300,
                    ),
                  );
                } else {
                  // No streak - go to activity
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        );
        return;
      }

      // No workout achievement
      if (widget.isPartialWorkout) {
        // Partial workout with no achievement - go straight to activity
        print('⚠️ Partial workout (no achievement) - navigating to Activity');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 2),
          ),
          (route) => false,
        );
        return;
      }

      // Full workout with no workout achievement - go to streak screen
      if (currentStreak >= 1) {
        Navigator.pushReplacement(
          context,
          PageTransitions.fadeSlideFromRight(
            StreakScreen(
              currentStreak: currentStreak,
              weeklyProgress: weeklyProgress,
              achievement: streakAchievement,
            ),
            durationMs: 300,
          ),
        );
      } else {
        // No streak - go straight to activity
        print('📍 No streak - navigating to Activity screen');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 2),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print('❌ Error in save and continue: $e');
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 2),
          ),
          (route) => false,
        );
      }
    } finally {
      // ✅ Reset flag in case of error (though navigation should remove screen)
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

// AchievementModel? _checkWorkoutAchievement(int totalWorkouts) {
//   if (totalWorkouts == 1) {
//     return AchievementModel(
//       title: 'First Workout!',
//       description: 'You completed your first workout!',
//       type: AchievementType.workout,
//       badgeNumber: 1,
//     );
//   } else if (totalWorkouts == 5) {
//     return AchievementModel(
//       title: '5 Workouts!',
//       description: 'You\'re on a roll! Keep it up!',
//       type: AchievementType.workout,
//       badgeNumber: 5,
//     );
//   } else if (totalWorkouts == 10) {
//     return AchievementModel(
//       title: '10 Workouts!',
//       description: 'Double digits! You\'re unstoppable!',
//       type: AchievementType.workout,
//       badgeNumber: 10,
//     );
//   }
//   return null;
// }

// AchievementModel? _checkStreakAchievement(int streak) {
//   if (streak == 3) {
//     return AchievementModel(
//       title: '3-Day Streak!',
//       description: 'Three days in a row! Amazing!',
//       type: AchievementType.streak,
//       badgeNumber: 3,
//     );
//   } else if (streak == 7) {
//     return AchievementModel(
//       title: 'Week Warrior!',
//       description: 'A full week of workouts!',
//       type: AchievementType.streak,
//       badgeNumber: 7,
//     );
//   } else if (streak == 14) {
//     return AchievementModel(
//       title: '2-Week Champion!',
//       description: 'Two weeks strong! Incredible!',
//       type: AchievementType.streak,
//       badgeNumber: 14,
//     );
//   }
//   return null;
// }

  Widget _buildMeasureHeartRateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeartRateMeasureScreen(
                dayNumber: widget.dayNumber,
                duration: widget.totalMinutes,
                calories: widget.totalCalories,
                exercises: widget.exercises, // ✅ ADD THIS
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE91E63),
          side: const BorderSide(
            color: Color(0xFFE91E63),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Measure Heart Rate',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Firework data model
class Firework {
  final double x; // 0.0 to 1.0 (percentage of screen width)
  final double y; // 0.0 to 1.0 (percentage of screen height)
  final Color color;
  final int particleCount;
  final DateTime startTime;

  Firework({
    required this.x,
    required this.y,
    required this.color,
    required this.particleCount,
    required this.startTime,
  });
}

// Fireworks painter
class FireworksPainter extends CustomPainter {
  final List<Firework> fireworks;
  final double animation;

  FireworksPainter({
    required this.fireworks,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final firework in fireworks) {
      final age = DateTime.now().difference(firework.startTime).inMilliseconds;
      final progress = (age / 2000.0).clamp(0.0, 1.0); // 2 second duration

      if (progress >= 1.0) continue;

      final centerX = size.width * firework.x;
      final centerY = size.height * firework.y;

      // Draw particles in a circle pattern
      for (int i = 0; i < firework.particleCount; i++) {
        final angle = (2 * math.pi * i) / firework.particleCount;

        // Particle expands outward and fades
        final distance =
            30 * progress * (1.2 - progress * 0.5); // Expands then slows
        final opacity = (1.0 - progress) * 0.6; // Fades out

        final x = centerX + math.cos(angle) * distance;
        final y = centerY + math.sin(angle) * distance;

        // Draw particle as small line/dash
        final paint = Paint()
          ..color = firework.color.withOpacity(opacity)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

        // Draw a small dash pointing outward
        final dashLength = 8.0;
        final endX = x + math.cos(angle) * dashLength;
        final endY = y + math.sin(angle) * dashLength;

        canvas.drawLine(
          Offset(x, y),
          Offset(endX, endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) => true;
}
