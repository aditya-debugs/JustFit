import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../screens/body_part_detail_screen.dart';
import '../screens/dance_category_detail_screen.dart';
import '../widgets/workout_detail_screen.dart';
import '../widgets/day_detail_sheet.dart';
import '../../../data/datasources/body_part_workouts_data.dart';
import '../../../data/models/workout/simple_workout_models.dart';
import '../../../core/services/discovery_workout_service.dart';
import '../../../data/models/workout/workout_set_model.dart';


// Body Specific Section
class BodySpecificSection extends StatelessWidget {
  final List<Map<String, dynamic>> bodyParts;

  const BodySpecificSection({
    Key? key,
    required this.bodyParts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Body Specific',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: bodyParts.length,
              itemBuilder: (context, index) {
                final bodyPart = bodyParts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildBodyPartItem(context, bodyPart),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPartItem(BuildContext context, Map<String, dynamic> bodyPart) {
    return GestureDetector(
      onTap: () {
        BodyPartDetailScreen.navigateTo(
          context,
          bodyPartName: bodyPart['name'],
          workoutCount: bodyPart['workoutCount'],
          heroImage: bodyPart['heroImage'],
          workouts: BodyPartWorkoutsData.getWorkoutsByBodyPart(bodyPart['name']),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child: Image.asset(
                bodyPart['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: Colors.grey[400],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bodyPart['name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${bodyPart['workoutCount']} workouts',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Workout Category Section (Reusable)
class WorkoutCategorySection extends StatelessWidget {
  final String title;
  final String? categoryLabel;
  final List<Map<String, dynamic>> workouts;

  const WorkoutCategorySection({
    Key? key,
    required this.title,
    this.categoryLabel,
    required this.workouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (categoryLabel != null) ...[
                //   Text(
                //     categoryLabel!,
                //     style: GoogleFonts.poppins(
                //       fontSize: 11,
                //       fontWeight: FontWeight.w700,
                //       color: const Color(0xFFFF1744),
                //       letterSpacing: 0.5,
                //     ),
                //   ),
                //   const SizedBox(height: 4),
                // ],
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: WorkoutCard(workout: workout),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Workout Card (Reusable)
class WorkoutCard extends StatelessWidget {
  final Map<String, dynamic> workout;

  const WorkoutCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Fetch full workout from Firestore
        final workoutId = workout['id'] as String;
        final discoveryService = Get.find<DiscoveryWorkoutService>();
        
        // Show loading
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        
        final fullWorkout = await discoveryService.getWorkoutById(workoutId);
        
        // Close loading
        Get.back();
        
        if (fullWorkout == null) {
          Get.snackbar('Error', 'Workout not found');
          return;
        }
        
        // Navigate to workout detail screen with real data
        WorkoutDetailScreen.navigateTo(
          context,
          workoutTitle: fullWorkout.title,
          duration: fullWorkout.duration,
          calories: fullWorkout.calories,
          heroImagePath: fullWorkout.imageUrl,
          equipment: fullWorkout.equipment,
          focusZones: fullWorkout.focusZones,
          workoutSets: _convertToWorkoutSets(fullWorkout.workoutSets),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    width: 160,
                    color: Colors.grey[200],
                    child: Image.asset(
                      workout['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: workout['isVip'] == true
                          ? Colors.black.withOpacity(0.7)
                          : const Color(0xFFFF1744).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      workout['isVip'] == true ? 'VIP' : 'FREE',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${workout['duration']} min',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${workout['type'] ?? 'FullBody'}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${workout['calories']} kcal',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert WorkoutSetModel from Firestore to WorkoutSet for UI
  List<WorkoutSet> _convertToWorkoutSets(List<WorkoutSetModel> models) {
    return models.map((setModel) {
      return WorkoutSet(
        setName: setModel.setTitle,
        exercises: setModel.exercises.map((exerciseModel) {
          return Exercise(
            name: exerciseModel.exerciseName,
            duration: exerciseModel.duration ?? 30,
            thumbnailPath: exerciseModel.thumbnailUrl,
            actionSteps: exerciseModel.instructions.isNotEmpty 
                ? exerciseModel.instructions 
                : null,
            breathingRhythm: exerciseModel.breathingRhythm,
            actionFeeling: exerciseModel.actionFeeling,
            commonMistakes: (exerciseModel.commonMistakes?.isNotEmpty ?? false)
                ? exerciseModel.commonMistakes
                : null,
          );
        }).toList(),
      );
    }).toList();
  }

  // Helper method to generate dummy workout sets (KEEP for fallback)
  List<WorkoutSet> _getDummyWorkoutSets() {
    return [
      WorkoutSet(
        setName: 'Set 1',
        exercises: [
          Exercise(name: 'Cardio Dance Fusion', duration: 300, thumbnailPath: null),
        ],
      ),
    ];
  }
}

// Dance Party Section
class DancePartySection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> sections;

  const DancePartySection({
    Key? key,
    required this.title,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title header (without trainer image)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal list of big purple cards
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DancePartyCard(section: section),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dance Party Card (Big purple gradient card)
class DancePartyCard extends StatelessWidget {
  final Map<String, dynamic> section;

  const DancePartyCard({
    Key? key,
    required this.section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to dance category detail screen (list of workouts)
        DanceCategoryDetailScreen.navigateTo(
          context,
          categoryTitle: section['title'],
          workoutCount: (section['workouts'] as List).length,
          gradientColors: [
            Color(int.parse(section['gradientStart'].replaceAll('#', '0xFF'))),
            Color(int.parse(section['gradientEnd'].replaceAll('#', '0xFF'))),
          ],
          workouts: section['workouts'],
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(section['gradientStart'].replaceAll('#', '0xFF'))),
              Color(int.parse(section['gradientEnd'].replaceAll('#', '0xFF'))),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                section['subtitle'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: section['workouts'].length,
                  itemBuilder: (context, index) {
                    final workout = section['workouts'][index];
                    final isLast = index == section['workouts'].length - 1;
                    return Padding(
                      padding: EdgeInsets.only(right: isLast ? 0 : 10),
                      child: DanceCard(workout: workout),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dance Card (Small cards inside the purple card)
class DanceCard extends StatelessWidget {
  final Map<String, dynamic> workout;

  const DanceCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Fetch full workout from Firestore
        final workoutId = workout['id'] as String;
        final discoveryService = Get.find<DiscoveryWorkoutService>();
        
        // Show loading
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        
        final fullWorkout = await discoveryService.getWorkoutById(workoutId);
        
        // Close loading
        Get.back();
        
        if (fullWorkout == null) {
          Get.snackbar('Error', 'Workout not found');
          return;
        }
        
        // Navigate to workout detail screen with real data
        WorkoutDetailScreen.navigateTo(
          context,
          workoutTitle: fullWorkout.title,
          duration: fullWorkout.duration,
          calories: fullWorkout.calories,
          heroImagePath: fullWorkout.imageUrl,
          equipment: fullWorkout.equipment,
          focusZones: fullWorkout.focusZones,
          workoutSets: _convertToWorkoutSets(fullWorkout.workoutSets),
        );
      },
      child: Container(
        width: 105,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                workout['image'],
                width: 105,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.fitness_center,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Text overlay
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                workout['title'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert WorkoutSetModel from Firestore to WorkoutSet for UI
  List<WorkoutSet> _convertToWorkoutSets(List<WorkoutSetModel> models) {
    return models.map((setModel) {
      return WorkoutSet(
        setName: setModel.setTitle,
        exercises: setModel.exercises.map((exerciseModel) {
          return Exercise(
            name: exerciseModel.exerciseName,
            duration: exerciseModel.duration ?? 30,
            thumbnailPath: exerciseModel.thumbnailUrl,
            actionSteps: exerciseModel.instructions.isNotEmpty 
                ? exerciseModel.instructions 
                : null,
            breathingRhythm: exerciseModel.breathingRhythm,
            actionFeeling: exerciseModel.actionFeeling,
            commonMistakes: (exerciseModel.commonMistakes?.isNotEmpty ?? false)
                ? exerciseModel.commonMistakes
                : null,
          );
        }).toList(),
      );
    }).toList();
  }

  // Helper method to generate dummy workout sets (KEEP for fallback)
  List<WorkoutSet> _getDummyWorkoutSets() {
    return [
      WorkoutSet(
        setName: 'Set 1',
        exercises: [
          Exercise(name: workout['title'], duration: workout['duration'] * 60, thumbnailPath: null),
        ],
      ),
    ];
  }
}