import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'day_detail_sheet.dart';
import '../../../data/models/workout/simple_workout_models.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutTitle;
  final int duration;
  final int calories;
  final String? heroImagePath;
  final String equipment;
  final String focusZones;
  final List<WorkoutSet> workoutSets;

  const WorkoutDetailScreen({
    Key? key,
    required this.workoutTitle,
    required this.duration,
    required this.calories,
    this.heroImagePath,
    required this.equipment,
    required this.focusZones,
    required this.workoutSets,
  }) : super(key: key);

  static void navigateTo(
    BuildContext context, {
    required String workoutTitle,
    required int duration,
    required int calories,
    String? heroImagePath,
    required String equipment,
    required String focusZones,
    required List<WorkoutSet> workoutSets,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(
          workoutTitle: workoutTitle,
          duration: duration,
          calories: calories,
          heroImagePath: heroImagePath,
          equipment: equipment,
          focusZones: focusZones,
          workoutSets: workoutSets,
        ),
      ),
    );
  }

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
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
          // Main scrollable content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image with overlaid title
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Hero Image
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

                    // Gradient overlay at bottom
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

                    // Workout title on image (fades out as you scroll)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 40,
                      child: Opacity(
                        opacity: (1.0 - headerOpacity).clamp(0.0, 1.0),
                        child: Text(
                          widget.workoutTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // White content area
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Stats (Duration & Calories)
                      _buildStats(),

                      const SizedBox(height: 16),

                      // Divider line
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.grey[200],
                      ),

                      const SizedBox(height: 16),

                      // Equipment and Focus Zones section
                      _buildDetailsSection(),

                      const SizedBox(height: 16),

                      // Divider line
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.grey[200],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Workout sets
              SliverToBoxAdapter(
                child: _buildWorkoutSets(context),
              ),

              // Bottom padding for button
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Sticky header bar (fades in as you scroll)
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
                      // Back button
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

                      // Workout title (centered, truncated)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Text(
                            widget.workoutTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back button overlay (top left) - visible when at top
          // Semi-transparent blackish circular background
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

          // Fixed start button at bottom
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

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Duration
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

          // Calories
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

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Equipment
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'Equipment:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.equipment,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Focus Zones
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  'Focus Zones:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.focusZones,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
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
      children: widget.workoutSets.map((set) => _buildWorkoutSet(context, set)).toList(),
    );
  }

  Widget _buildWorkoutSet(BuildContext context, WorkoutSet set) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set title
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

          // Exercise cards
          ...set.exercises.map((exercise) => _buildExerciseCard(context, exercise)).toList(),
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
          onTap: () {
            ExerciseDetailSheet.show(context, exercise: exercise);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                // Thumbnail
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

                // Exercise info
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
            color: const Color(0xFFFF1744),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print('Starting workout: ${widget.workoutTitle}');
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
    );
  }
}