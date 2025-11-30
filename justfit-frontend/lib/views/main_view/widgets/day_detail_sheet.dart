import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../workout_view/pre_workout_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../workout_view/active_workout_screen.dart';
import '../../../data/models/workout/workout_exercise.dart';
import '../../../data/models/workout/workout_set_model.dart';
import '../../../data/models/workout/exercise_model.dart';
import '../../../data/models/workout/simple_workout_models.dart'; // ✅ ADDED

class DayDetailScreen extends StatefulWidget {
  final int dayNumber;
  final int duration;
  final int calories;
  final String? heroImagePath;
  final List<WorkoutSet> workoutSets;
  final List<WorkoutSetModel>? workoutSetsData;
  final String intensity;
  final bool isLocked; // ✅ ADD THIS (not VoidCallback)
  final VoidCallback? onUnlockRequired;

  const DayDetailScreen({
    Key? key,
    required this.dayNumber,
    required this.duration,
    required this.calories,
    this.heroImagePath,
    required this.workoutSets,
    this.workoutSetsData,
    required this.intensity,
    this.isLocked = false, // ✅ FIXED: default value
    this.onUnlockRequired,
  }) : super(key: key);

  static void navigateTo(
    BuildContext context, {
    required int dayNumber,
    required int duration,
    required int calories,
    String? heroImagePath,
    required List<WorkoutSet> workoutSets,
    List<WorkoutSetModel>? workoutSetsData,
    required String intensity,
    bool isLocked = false, // ✅ FIXED: added 'bool' type
    VoidCallback? onUnlockRequired, // ✅ FIXED: added type
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayDetailScreen(
          dayNumber: dayNumber,
          duration: duration,
          calories: calories,
          heroImagePath: heroImagePath,
          workoutSets: workoutSets,
          workoutSetsData: workoutSetsData,
          intensity: intensity,
          isLocked: isLocked, // ✅ FIXED: proper named parameter
          onUnlockRequired: onUnlockRequired, // ✅ FIXED: proper named parameter
        ),
      ),
    );
  }

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headerOpacity = (_scrollOffset / 150).clamp(0.0, 1.0);
    final double imageHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      child: widget.heroImagePath != null
                          ? Image.asset(
                              widget.heroImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.fitness_center,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 60,
                      child: Opacity(
                        opacity: (1.0 - headerOpacity).clamp(0.0, 1.0),
                        child: Center(
                          child: Text(
                            'Day ${widget.dayNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildStats(),
                      const SizedBox(height: 12),
                      _buildIntensityBadge(widget.intensity),
                      _buildMotivationalMessage(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildWorkoutSets(context),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: headerOpacity,
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  height: 56,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Day ${widget.dayNumber}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: AnimatedOpacity(
              opacity: (1.0 - headerOpacity).clamp(0.0, 1.0),
              duration: const Duration(milliseconds: 100),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStartButton(context),
          ),
        ],
      ),
    );
  }

  Future<Exercise?> _fetchExerciseDetailsForCard(Exercise exercise) async {
    try {
      final exerciseId = exercise.name.toLowerCase().replaceAll(' ', '-');

      final response = await http.post(
        Uri.parse('https://justfit.onrender.com/api/workout/exercise-details'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'exerciseIds': [exerciseId]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final exercises = data['exercises'] as List;

        if (exercises.isNotEmpty) {
          final exerciseData = exercises[0];
          return Exercise(
            name: exerciseData['name'],
            duration: exercise.duration,
            thumbnailPath: exercise.thumbnailPath,
            actionSteps: List<String>.from(exerciseData['actionSteps'] ?? []),
            breathingRhythm:
                List<String>.from(exerciseData['breathingRhythm'] ?? []),
            actionFeeling:
                List<String>.from(exerciseData['actionFeeling'] ?? []),
            commonMistakes:
                List<String>.from(exerciseData['commonMistakes'] ?? []),
          );
        }
      }
    } catch (e) {
      print('Error fetching exercise details: $e');
    }
    return null;
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.duration} min',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.calories} kcal',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutSets(BuildContext context) {
    return Column(
      children: widget.workoutSets
          .map((set) => _buildWorkoutSet(context, set))
          .toList(),
    );
  }

  Widget _buildWorkoutSet(BuildContext context, WorkoutSet set) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              set.setName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          ...set.exercises
              .map((exercise) => _buildExerciseCard(context, exercise))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.pink),
              ),
            );

            final detailedExercise =
                await _fetchExerciseDetailsForCard(exercise);

            if (context.mounted) Navigator.pop(context);

            if (context.mounted) {
              ExerciseDetailSheet.show(
                context,
                exercise: detailedExercise ?? exercise,
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: exercise.thumbnailPath != null
                        ? Image.asset(
                            exercise.thumbnailPath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fitness_center,
                                size: 40,
                                color: Colors.grey[400],
                              );
                            },
                          )
                        : Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${exercise.duration} seconds',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63), // ✅ Always red, even when locked
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.isLocked) {
                  // ✅ Show lock dialog IN THIS SHEET (not navigate away)
                  _showLockedWorkoutDialog(context, widget.dayNumber);
                } else {
                  _navigateToPreWorkout(context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLocked)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      Text(
                        'Start Training',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPreWorkout(BuildContext context) {
    List<WorkoutExercise> exercises = [];

    if (widget.workoutSetsData != null && widget.workoutSetsData!.isNotEmpty) {
      for (var workoutSet in widget.workoutSetsData!) {
        for (var exercise in workoutSet.exercises) {
          exercises.add(WorkoutExercise(
            name: exercise.exerciseName,
            duration: exercise.duration ?? 30,
            sets: exercise.sets ?? 3,
            reps: exercise.reps ?? 12,
            rest: exercise.restAfter ?? 60,
            setType: workoutSet.setType
                .toString()
                .split('.')
                .last, // Convert enum to string
          ));
        }
      }
    }

    // ✅ ADD THIS DEBUG BLOCK HERE (after line 532, before line 534)
    print('🔍 DEBUG: Total exercises being passed: ${exercises.length}');
    print(
        '🔍 DEBUG: Total workout sets: ${widget.workoutSetsData?.length ?? 0}');
    for (var i = 0; i < exercises.length; i++) {
      print(
          '  📋 Exercise ${i + 1}: ${exercises[i].name}, Duration: ${exercises[i].duration}s, Sets/Rounds: ${exercises[i].sets}');
    }

    // Always navigate with exercises (whether they exist or not)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreWorkoutScreen(
          dayNumber: widget.dayNumber,
          duration: widget.duration,
          calories: widget.calories,
          exercises: exercises,
        ),
      ),
    );
  }

  void _showLockedWorkoutDialog(BuildContext context, int lockedDayNumber) {
    final previousDayNumber = lockedDayNumber - 1;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                'Take it easy!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                'Don\'t rush! Please complete previous days workout first!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Day image placeholder
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Day $previousDayNumber',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Start Day button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Close both dialogs (this one and the detail sheet)
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close detail sheet
                    // The user will now be back at My Plan screen showing the previous day
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
                    'OK',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
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

  // ========== INTENSITY & CYCLE AWARENESS ==========

  /// Returns intensity badge color based on workout intensity
  Color _getIntensityBadgeColor(String intensity) {
    if (intensity.toLowerCase().contains('gentle') ||
        intensity.toLowerCase().contains('light')) {
      return const Color(0xFFE8D5F2); // Light purple for gentle
    } else if (intensity.toLowerCase().contains('high') ||
        intensity.toLowerCase().contains('peak')) {
      return const Color(0xFFFFE5E5); // Light red for high
    } else {
      return const Color(0xFFE3F2FD); // Light blue for moderate
    }
  }

  /// Returns appropriate icon for intensity level
  IconData _getIntensityIcon(String intensity) {
    if (intensity.toLowerCase().contains('gentle') ||
        intensity.toLowerCase().contains('light')) {
      return Icons.favorite;
    } else if (intensity.toLowerCase().contains('high') ||
        intensity.toLowerCase().contains('peak')) {
      return Icons.local_fire_department;
    } else {
      return Icons.fitness_center;
    }
  }

  /// Builds intensity badge widget (shown for ALL users)
  Widget _buildIntensityBadge(String intensity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getIntensityBadgeColor(intensity),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getIntensityBadgeColor(intensity).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIntensityIcon(intensity),
              size: 16,
              color: Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              intensity,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if user has menstrual cycle sync enabled
  bool _hasCycleSync() {
    // Check if intensity contains cycle phase indicators
    return widget.intensity.contains('Menstruation') ||
        widget.intensity.contains('Follicular') ||
        widget.intensity.contains('Ovulation') ||
        widget.intensity.contains('Luteal') ||
        widget.intensity.contains('PMS');
  }

  /// Returns cycle phase emoji based on intensity
  String _getCycleEmoji(String intensity) {
    if (intensity.contains('Menstruation')) return '🩸';
    if (intensity.contains('Follicular')) return '⚡';
    if (intensity.contains('Ovulation') || intensity.contains('Peak'))
      return '🌟';
    if (intensity.contains('Luteal') || intensity.contains('PMS')) return '🌙';
    return '';
  }

  /// Returns motivational message based on intensity
  /// Generic messages for non-synced users, cycle-specific for synced users
  String _getMotivationalMessage(String intensity) {
    // Cycle-synced messages (shown only if cycle sync is detected)
    if (intensity.contains('Menstruation')) {
      return 'Taking it easy today. Your body needs gentle movement during this phase.';
    } else if (intensity.contains('Follicular')) {
      return 'Energy building phase! Your body is ready to build momentum and strength.';
    } else if (intensity.contains('Ovulation') || intensity.contains('Peak')) {
      return 'Peak power week! You\'re at your strongest—time to push your limits!';
    } else if (intensity.contains('Luteal') || intensity.contains('PMS')) {
      return 'Steady and consistent wins. Focus on quality over intensity today.';
    }

    // Generic messages for non-synced users (based on intensity level)
    if (intensity.toLowerCase().contains('gentle') ||
        intensity.toLowerCase().contains('light')) {
      return 'Light and gentle movement today. Perfect for active recovery!';
    } else if (intensity.toLowerCase().contains('high')) {
      return 'High intensity workout! Push yourself and feel the burn!';
    } else {
      return 'Balanced workout ahead. Stay focused and give it your best!';
    }
  }

  /// Builds motivational message widget (shown for ALL users)
  Widget _buildMotivationalMessage() {
    String emoji = _hasCycleSync() ? _getCycleEmoji(widget.intensity) : '💪';
    String message = _getMotivationalMessage(widget.intensity);
    Color bgColor =
        _hasCycleSync() ? const Color(0xFFFFF5F8) : const Color(0xFFF5F9FF);
    Color borderColor =
        _hasCycleSync() ? const Color(0xFFFFE0E8) : const Color(0xFFE0EEFF);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF333333),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailSheet {
  static Future<void> show(BuildContext context, {required Exercise exercise}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: exercise.thumbnailPath != null
                      ? Image.asset(
                          exercise.thumbnailPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        exercise.name,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Action Steps:',
                        items: exercise.actionSteps ??
                            [
                              'Stand with feet shoulder-width apart',
                              'Keep your core engaged and back straight',
                              'Perform the movement in a controlled manner',
                              'Maintain steady breathing throughout',
                            ],
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        title: 'Breathing Rhythm:',
                        items: exercise.breathingRhythm ??
                            [
                              'Inhale: During the preparation phase',
                              'Exhale: During the active movement',
                              'Keep breathing steady and controlled',
                            ],
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        title: 'Action Feeling:',
                        items: exercise.actionFeeling ??
                            [
                              'You should feel tension in the target muscle group',
                              'No pain or sharp discomfort',
                              'Controlled burn sensation is normal',
                            ],
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        title: 'Common Mistakes:',
                        items: exercise.commonMistakes ??
                            [
                              'Avoid holding your breath',
                              'Don\'t rush through the movement',
                              'Keep your core engaged at all times',
                              'Don\'t overextend beyond your comfort zone',
                            ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            print('Starting exercise: ${exercise.name}');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'Start',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildSection(
      {required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
