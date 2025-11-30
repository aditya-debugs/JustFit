import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../widgets/workout_detail_screen.dart';
import '../widgets/day_detail_sheet.dart';
import '../../../data/models/workout/simple_workout_models.dart';

class DanceCategoryDetailScreen extends StatelessWidget {
  final String categoryTitle;
  final int workoutCount;
  final List<Color> gradientColors;
  final List<Map<String, dynamic>> workouts;

  const DanceCategoryDetailScreen({
    Key? key,
    required this.categoryTitle,
    required this.workoutCount,
    required this.gradientColors,
    required this.workouts,
  }) : super(key: key);

  static void navigateTo(
    BuildContext context, {
    required String categoryTitle,
    required int workoutCount,
    required List<Color> gradientColors,
    required List<Map<String, dynamic>> workouts,
  }) {
    Get.to(
      () => DanceCategoryDetailScreen(
        categoryTitle: categoryTitle,
        workoutCount: workoutCount,
        gradientColors: gradientColors,
        workouts: workouts,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Hero Section with Gradient Background
          Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  
                  // Title and count
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$workoutCount workouts',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Workouts List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return _buildWorkoutItem(context, workout, index == workouts.length - 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(BuildContext context, Map<String, dynamic> workout, bool isLast) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Navigate to workout detail screen
              WorkoutDetailScreen.navigateTo(
                context,
                workoutTitle: workout['title'],
                duration: workout['duration'],
                calories: workout['calories'],
                heroImagePath: workout['image'],
                equipment: workout['equipment'] ?? 'None',
                focusZones: workout['focusZones'] ?? 'FullBody',
                workoutSets: _getDummyWorkoutSets(workout),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      height: 90,
                      color: Colors.grey[200],
                      child: workout['image'] != null
                          ? Image.asset(
                              workout['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey[400],
                                    size: 35,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey[400],
                                size: 35,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Workout info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${workout['duration']} min · ${workout['calories']} kcal',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFE91E63),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Arrow icon
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Divider (not full width)
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 152),
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
      ],
    );
  }

  // Helper method to generate dummy workout sets
  List<WorkoutSet> _getDummyWorkoutSets(Map<String, dynamic> workout) {
    return [
      WorkoutSet(
        setName: 'Set 1',
        exercises: [
          Exercise(
            name: workout['title'],
            duration: workout['duration'] * 60,
            thumbnailPath: null,
          ),
        ],
      ),
    ];
  }
}
