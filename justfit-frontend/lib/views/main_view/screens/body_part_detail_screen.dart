import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../widgets/workout_detail_screen.dart';
import '../widgets/day_detail_sheet.dart';
import '../../../data/models/workout/simple_workout_models.dart';

class BodyPartDetailScreen extends StatelessWidget {
  final String bodyPartName;
  final int workoutCount;
  final String heroImage;
  final List<Map<String, dynamic>> workouts;

  const BodyPartDetailScreen({
    Key? key,
    required this.bodyPartName,
    required this.workoutCount,
    required this.heroImage,
    required this.workouts,
  }) : super(key: key);

  static void navigateTo(
    BuildContext context, {
    required String bodyPartName,
    required int workoutCount,
    required String heroImage,
    required List<Map<String, dynamic>> workouts,
  }) {
    Get.to(
      () => BodyPartDetailScreen(
        bodyPartName: bodyPartName,
        workoutCount: workoutCount,
        heroImage: heroImage,
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
          // Hero Image Section with Back Button
          Stack(
            children: [
              // Hero Image Container
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Image.asset(
                  heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Title and workout count overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyPartName,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
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
              ),

              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),  // Semi-transparent dark background
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ),
            ],
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
                equipment: workout['equipment'] ?? 'Yoga Mat',
                focusZones: workout['focusZones'] ?? 'FullBody',
                workoutSets: _getDummyWorkoutSets(),
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
                            color: const Color(0xFFFF1744),
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
  List<WorkoutSet> _getDummyWorkoutSets() {
    return [
      WorkoutSet(
        setName: 'Set 1',
        exercises: [
          Exercise(
            name: 'Standing Leg Circles',
            duration: 20,
            thumbnailPath: null,
          ),
          Exercise(
            name: 'Side Lunges',
            duration: 30,
            thumbnailPath: null,
          ),
          Exercise(
            name: 'Squats',
            duration: 30,
            thumbnailPath: null,
          ),
        ],
      ),
      WorkoutSet(
        setName: 'Set 2',
        exercises: [
          Exercise(
            name: 'Fire Hydrants',
            duration: 25,
            thumbnailPath: null,
          ),
          Exercise(
            name: 'Glute Bridges',
            duration: 30,
            thumbnailPath: null,
          ),
          Exercise(
            name: 'Donkey Kicks',
            duration: 20,
            thumbnailPath: null,
          ),
        ],
      ),
    ];
  }
}