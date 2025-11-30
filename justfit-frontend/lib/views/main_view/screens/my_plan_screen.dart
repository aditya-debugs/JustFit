import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/day_detail_sheet.dart';
import '../../../controllers/workout_plan_controller.dart';
import '../../../data/models/workout/phase_model.dart';
import '../../../data/models/workout/day_plan_model.dart';
import '../../../data/models/workout/workout_plan_model.dart';
import '../../../data/models/workout/workout_set_model.dart';
import '../../../data/models/workout/exercise_model.dart';
import '../../workout_view/rest_day_screen.dart';
import '../../../data/models/workout/simple_workout_models.dart';

// Keep the _convertToWorkoutSets method as is - it converts WorkoutSetModel to simple WorkoutSet

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToDay1Button = false;

  // Initialize controller
  late final WorkoutPlanController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize controller if not already registered
    if (!Get.isRegistered<WorkoutPlanController>()) {
      Get.put(WorkoutPlanController());
    }
    _controller = Get.find<WorkoutPlanController>();

    // // ✅ CRITICAL FIX: Reload plan whenever this screen is shown
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print('🔄 MyPlanScreen: Reloading workout plan...');
    //   _controller.loadUserWorkoutPlan();
    // });
    // Only reload if plan is not already loaded
    // Only reload if plan doesn't exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.currentPlan.value == null) {
        print('🔄 MyPlanScreen: No plan in memory, loading from Firestore...');
        _controller.loadUserWorkoutPlan();
      } else {
        print('✅ MyPlanScreen: Using existing plan from memory');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ... rest of the file stays exactly the same

  void _onScroll() {
    if (_scrollController.offset > 300 && !_showBackToDay1Button) {
      setState(() => _showBackToDay1Button = true);
    } else if (_scrollController.offset <= 300 && _showBackToDay1Button) {
      setState(() => _showBackToDay1Button = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToCurrentDay() {
    final plan = _controller.currentPlan.value;
    if (plan == null) return;

    // Calculate approximate position of current day
    // We want the current day card to be clearly visible and well-positioned
    double offset = 0.0;

    // Header height (approximate)
    offset += 180.0;

    // Count phases before the one containing current day
    int phasesBeforeCurrent = 0;
    int daysBeforeCurrent = 0;

    for (var phase in plan.phases) {
      bool foundCurrentDay = false;

      for (var day in phase.days) {
        if (day.dayNumber == plan.currentDay) {
          foundCurrentDay = true;
          break;
        }
        daysBeforeCurrent++;
      }

      if (foundCurrentDay) {
        break;
      } else {
        phasesBeforeCurrent++;
      }
    }

    // Add space for phase headers before current day's phase (each ~50px)
    offset += phasesBeforeCurrent * 50.0;

    // Add current phase header
    offset += 50.0;

    // Add space for days before current day in the same phase
    // Each day card is approximately 100-140px tall (average 115px)
    // Subtract some offset to show current day nicely positioned (not at top edge)
    final daysOffset = (daysBeforeCurrent * 115.0) - 150.0;
    offset += daysOffset > 0 ? daysOffset : 0;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildStreakBadge(int streakCount) {
    return SizedBox(
      width: 55,
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fire emoji - slightly larger
          const Text(
            '🔥',
            style: TextStyle(
              fontSize: 48, // ✅ Increased from 32, but not too large
              decoration: TextDecoration.none,
              height: 1.0,
            ),
          ),
          // Streak number - centered in the flame
          Positioned(
            bottom: 14, // ✅ Adjusted to sit in the middle of the flame
            child: Text(
              '$streakCount',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 3,
                  ),
                  Shadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF5F5F5), // ✅ Light grey background like Progress screen
      body: SafeArea(
        child: Obx(() {
          // Loading state
          if (_controller.isLoading.value) {
            return _buildLoadingState();
          }

          // Error state
          if (_controller.hasError.value) {
            return _buildErrorState();
          }

          // No plan state
          if (!_controller.hasPlan) {
            return _buildNoPlanState();
          }

          // Success state - show workout plan
          return _buildPlanContent();
        }),
      ),
    );
  }

  // ========== LOADING STATE ==========
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFFF1744),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your workout plan...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== ERROR STATE ==========
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load workout plan',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _controller.errorMessage.value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _controller.refreshPlan(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1744),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== NO PLAN STATE ==========
  Widget _buildNoPlanState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Workout Plan',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Complete your onboarding to get a personalized workout plan',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to onboarding
                Get.snackbar(
                  'Coming Soon',
                  'Re-onboarding feature will be added',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1744),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PLAN CONTENT ==========
  Widget _buildPlanContent() {
    final plan = _controller.currentPlan.value!;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => _controller.refreshPlan(),
          color: const Color(0xFFFF1744),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(plan),
              ),

              // Workout phases
              SliverToBoxAdapter(
                child: _buildWorkoutPhases(plan),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),

        // Floating "Back to Current Day" button
        if (_showBackToDay1Button)
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Center(
              child: _buildBackToDay1Button(plan),
            ),
          ),
      ],
    );
  }

  // ========== HEADER ==========
  Widget _buildHeader(WorkoutPlanModel plan) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 16, 8, 20), // ✅ Reduced right padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Expanded(
            child: Text(
              plan.planTitle,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
              maxLines: 2, // ✅ Allow 2 lines if needed
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8), // ✅ Reduced from 12 to 8

          // Streak badge
          _buildStreakBadge(_controller.userStreak.value),

          const SizedBox(width: 8), // ✅ Reduced from 12 to 8

          // Menu icon - matches streak badge size (55x55)
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'Plan Settings',
                'Coming soon: Edit plan, restart, archive, etc.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Container(
              width: 55, // ✅ Matches streak badge
              height: 55, // ✅ Matches streak badge
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.menu,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== WORKOUT PHASES ==========
  Widget _buildWorkoutPhases(WorkoutPlanModel plan) {
    return Column(
      children: plan.phases.map((phase) {
        return _buildPhaseBlock(plan, phase);
      }).toList(),
    );
  }

  Widget _buildPhaseBlock(WorkoutPlanModel plan, PhaseModel phase) {
    // ✅ Calculate phase progress (completed days only)
    final completedDaysInPhase = phase.days
        .where((day) => day.isCompleted || day.dayNumber < plan.currentDay)
        .length;
    final phaseProgress = phase.days.isEmpty
        ? 0
        : (completedDaysInPhase / phase.days.length * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phase header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Dot indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Phase title
                Expanded(
                  child: Text(
                    phase.phaseName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Progress bar
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: phaseProgress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1744),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$phaseProgress%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Days list
          ...phase.days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isCurrentDay = day.dayNumber == plan.currentDay;
            final isLastInPhase = index == phase.days.length - 1;

            return _buildDayCard(
              plan: plan,
              day: day,
              showStartButton: isCurrentDay,
              isLastInBlock: isLastInPhase,
            );
          }).toList(),
        ],
      ),
    );
  }

  // ========== DAY CARD ==========
  Widget _buildDayCard({
    required WorkoutPlanModel plan,
    required DayPlanModel day,
    bool showStartButton = false,
    bool isLastInBlock = false,
  }) {
    // ✅ HYBRID LOCK LOGIC (calendar + completion-based)
    final isCompleted = day.isCompleted;

    // Get current day from plan
    final currentDay = plan.currentDay;
    final dayNumber = day.dayNumber;

    final isPastDay = dayNumber < currentDay;
    final isCurrentDay = dayNumber == currentDay;
    final isFutureDay = dayNumber > currentDay;

    // Use controller's hybrid lock logic
    final isLocked = _controller.isDayLocked(dayNumber);

    // Current status
    final isCurrent = isCurrentDay && !isCompleted;

    final calories = _controller.calculateDayCalories(day);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline (dot and line with check mark)
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Circle indicator with check mark
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFFE91E63) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? const Color(0xFFE91E63)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                // Dotted line
                if (!isLastInBlock)
                  SizedBox(
                    height: showStartButton ? 140 : 90,
                    child: CustomPaint(
                      painter: DottedLinePainter(
                        color: Colors.grey[300]!,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Day card
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFFFEBEE) // Light pink for completed
                        : Colors
                            .white, // White for ALL others (current, past, future)
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrent
                        ? Border.all(color: const Color(0xFFE91E63), width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              _openDayDetail(plan, day, calories, isLocked),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Thumbnail - same for all non-completed
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                      _getDayImage(day.dayNumber),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: isCompleted
                                              ? const Color(0xFFFCE4EC)
                                              : Colors.grey[200],
                                          child: Icon(
                                            Icons.fitness_center,
                                            color: isCompleted
                                                ? const Color(0xFFE91E63)
                                                : Colors.grey[400],
                                            size: 30,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Day info - same text for all
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Day ${day.dayNumber}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black, // Same for all
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${day.estimatedDuration} min | $calories kcal', // Same for all
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Colors.grey[600], // Same for all
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status icon - always chevron
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Start Training button for current day (only if not completed)
                if (showStartButton && !isCompleted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () =>
                            _openDayDetail(plan, day, calories, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'START TRAINING',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to rotate through 4 day images
  String _getDayImage(int dayNumber) {
    final images = [
      'assets/images/day_1.jpeg',
      'assets/images/day_2.jpeg',
      'assets/images/day_3.jpeg',
      'assets/images/day_4.jpeg',
    ];
    return images[(dayNumber - 1) % 4];
  }

  /// ✅ Show dialog when user tries to access locked day
  void _showLockedDayDialog(int lockedDayNumber) {
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
                'You need to complete Day $previousDayNumber first.',
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
                    Navigator.pop(context);
                    // Navigate to the previous day
                    final plan = _controller.currentPlan.value;
                    if (plan != null) {
                      final previousDay = plan.phases
                          .expand((phase) => phase.days)
                          .firstWhere(
                              (day) => day.dayNumber == previousDayNumber);
                      final calories =
                          _controller.calculateDayCalories(previousDay);
                      _openDayDetail(plan, previousDay, calories, false);
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
                    'Start Day $previousDayNumber',
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

  // ========== DAY DETAIL NAVIGATION ==========
  void _openDayDetail(
      WorkoutPlanModel plan, DayPlanModel day, int calories, bool isLocked) {
    // Check if it's a rest day
    if (day.isRestDay) {
      // Navigate to Rest Day Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestDayScreen(
            dayNumber: day.dayNumber,
            description: day.dayTitle,
          ),
        ),
      );
      return;
    }

    // Regular workout day - navigate to day detail
    DayDetailScreen.navigateTo(
      context,
      dayNumber: day.dayNumber,
      duration: day.estimatedDuration,
      calories: calories,
      heroImagePath: _getDayImage(day.dayNumber),
      workoutSets: _convertToWorkoutSets(day.workoutSets),
      workoutSetsData: day.workoutSets,
      intensity: day.intensity,
      isLocked: isLocked, // ✅ Pass lock status
    );
  }

  // ========== TYPE CONVERSION HELPER ==========
  /// Convert WorkoutSetModel to WorkoutSet (for legacy day detail screen)
  List<WorkoutSet> _convertToWorkoutSets(List<WorkoutSetModel> models) {
    return models.map((setModel) {
      return WorkoutSet(
        setName: setModel.setTitle, // ← CHANGED FROM setName to setTitle
        exercises: setModel.exercises.map((exerciseModel) {
          return Exercise(
            name: exerciseModel.exerciseName,
            duration: exerciseModel.duration ??
                (exerciseModel.reps != null ? exerciseModel.reps! * 3 : 30),
            thumbnailPath: exerciseModel.thumbnailUrl,
            actionSteps: exerciseModel.instructions.isNotEmpty
                ? exerciseModel.instructions
                : null,
            breathingRhythm: exerciseModel.breathingRhythm,
            actionFeeling: exerciseModel.actionFeeling,
            commonMistakes: exerciseModel.commonMistakes,
          );
        }).toList(),
      );
    }).toList();
  }

  // ========== BACK TO CURRENT DAY BUTTON ==========
  Widget _buildBackToDay1Button(WorkoutPlanModel plan) {
    final currentDay = plan.currentDay;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF1744),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF1744).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _scrollToCurrentDay,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Back to Day $currentDay',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for dotted vertical line
class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// Compact flame painter for small streak badges (MyPlanScreen header)
/// Optimized proportions: 50x60 canvas size
// class SmallFlamePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     final width = size.width;
//     final height = size.height;

//     // ===== OUTER FLAME =====
//     final outerPath = Path();
    
//     outerPath.moveTo(width * 0.5, height * 0.98);
    
//     outerPath.quadraticBezierTo(
//       width * 0.28, height * 0.92,
//       width * 0.18, height * 0.75,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.12, height * 0.58,
//       width * 0.22, height * 0.38,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.28, height * 0.22,
//       width * 0.38, height * 0.12,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.42, height * 0.06,
//       width * 0.48, height * 0.02,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.5, 0,
//       width * 0.52, height * 0.02,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.58, height * 0.06,
//       width * 0.62, height * 0.12,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.72, height * 0.22,
//       width * 0.78, height * 0.38,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.88, height * 0.58,
//       width * 0.82, height * 0.75,
//     );
    
//     outerPath.quadraticBezierTo(
//       width * 0.72, height * 0.92,
//       width * 0.5, height * 0.98,
//     );
    
//     outerPath.close();

//     final outerGradient = RadialGradient(
//       center: const Alignment(0, -0.1),
//       radius: 1.1,
//       colors: [
//         const Color(0xFFFF4444),
//         const Color(0xFFFF1744),
//         const Color(0xFFE91E63),
//         const Color(0xFFD81B60),
//       ],
//       stops: const [0.0, 0.3, 0.7, 1.0],
//     );

//     paint.shader = outerGradient.createShader(
//       Rect.fromLTWH(0, 0, width, height),
//     );
    
//     canvas.drawPath(outerPath, paint);

//     // ===== INNER HIGHLIGHT =====
//     final innerPath = Path();
    
//     innerPath.moveTo(width * 0.5, height * 0.75);
    
//     innerPath.quadraticBezierTo(
//       width * 0.4, height * 0.68,
//       width * 0.35, height * 0.5,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.33, height * 0.35,
//       width * 0.4, height * 0.25,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.45, height * 0.18,
//       width * 0.5, height * 0.22,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.55, height * 0.18,
//       width * 0.6, height * 0.25,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.67, height * 0.35,
//       width * 0.65, height * 0.5,
//     );
    
//     innerPath.quadraticBezierTo(
//       width * 0.6, height * 0.68,
//       width * 0.5, height * 0.75,
//     );
    
//     innerPath.close();

//     final innerGradient = RadialGradient(
//       center: const Alignment(0, -0.25),
//       radius: 0.7,
//       colors: [
//         const Color(0xFFFFFFFF).withOpacity(0.35),
//         const Color(0xFFFF6B6B).withOpacity(0.25),
//         const Color(0xFFFF1744).withOpacity(0.0),
//       ],
//       stops: const [0.0, 0.5, 1.0],
//     );

//     paint.shader = innerGradient.createShader(
//       Rect.fromLTWH(0, 0, width, height),
//     );
    
//     canvas.drawPath(innerPath, paint);
//   }

//   @override
//   bool shouldRepaint(SmallFlamePainter oldDelegate) => false;
// }