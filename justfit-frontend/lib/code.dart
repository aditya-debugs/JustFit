// // day detail sheet


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../workout_view/pre_workout_screen.dart';
// import 'dart:convert';  // ← ADD THIS
// import 'package:http/http.dart' as http;  // ← ADD THIS

// class DayDetailScreen extends StatefulWidget {
//   final int dayNumber;
//   final int duration;
//   final int calories;
//   final String? heroImagePath;
//   final List<WorkoutSet> workoutSets;

//   const DayDetailScreen({
//     Key? key,
//     required this.dayNumber,
//     required this.duration,
//     required this.calories,
//     this.heroImagePath,
//     required this.workoutSets,
//   }) : super(key: key);

//   // Static method to navigate to this screen
//   static void navigateTo(
//     BuildContext context, {
//     required int dayNumber,
//     required int duration,
//     required int calories,
//     String? heroImagePath,
//     required List<WorkoutSet> workoutSets,
//   }) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DayDetailScreen(
//           dayNumber: dayNumber,
//           duration: duration,
//           calories: calories,
//           heroImagePath: heroImagePath,
//           workoutSets: workoutSets,
//         ),
//       ),
//     );
//   }

//   @override
//   State<DayDetailScreen> createState() => _DayDetailScreenState();
// }

// class _DayDetailScreenState extends State<DayDetailScreen> {
//   final ScrollController _scrollController = ScrollController();
//   double _scrollOffset = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       setState(() {
//         _scrollOffset = _scrollController.offset;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Calculate header opacity based on scroll (fade in between 100-200 pixels)
//     final double headerOpacity = (_scrollOffset / 150).clamp(0.0, 1.0);
//     final double imageHeight = MediaQuery.of(context).size.height * 0.4;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Main scrollable content
//           CustomScrollView(
//             controller: _scrollController,
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               // Hero Image with overlaid title
//               SliverToBoxAdapter(
//                 child: Stack(
//                   children: [
//                     // Hero Image
//                     Container(
//                       height: imageHeight,
//                       width: double.infinity,
//                       child: widget.heroImagePath != null
//                           ? Image.asset(
//                               widget.heroImagePath!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   color: Colors.grey[200],
//                                   child: Icon(
//                                     Icons.fitness_center,
//                                     size: 80,
//                                     color: Colors.grey[400],
//                                   ),
//                                 );
//                               },
//                             )
//                           : Container(
//                               color: Colors.grey[200],
//                               child: Icon(
//                                 Icons.fitness_center,
//                                 size: 80,
//                                 color: Colors.grey[400],
//                               ),
//                             ),
//                     ),

//                     // Gradient overlay at bottom
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         height: 120,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Day title on image (fades out as you scroll)
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 60,
//                       child: Opacity(
//                         opacity: (1.0 - headerOpacity).clamp(0.0, 1.0),
//                         child: Center(
//                           child: Text(
//                             'Day ${widget.dayNumber}',
//                             style: GoogleFonts.poppins(
//                               fontSize: 36,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // White content area
//               SliverToBoxAdapter(
//                 child: Container(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 20),

//                       // Stats
//                       _buildStats(),

//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),

//               // Workout sets
//               SliverToBoxAdapter(
//                 child: _buildWorkoutSets(context),
//               ),

//               // Bottom padding for button
//               const SliverToBoxAdapter(
//                 child: SizedBox(height: 100),
//               ),
//             ],
//           ),

//                     // Sticky header bar (fades in as you scroll)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: AnimatedOpacity(
//               opacity: headerOpacity,
//               duration: const Duration(milliseconds: 100),
//               child: Container(
//                 padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).padding.top,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Container(
//                   height: 56,
//                   child: Stack(
//                     children: [
//                       // Back button (absolute positioned on left)
//                       Positioned(
//                         left: 8,
//                         top: 0,
//                         bottom: 0,
//                         child: GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             child: const Icon(
//                               Icons.arrow_back,
//                               size: 24,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Day title (centered)
//                       Center(
//                         child: Text(
//                           'Day ${widget.dayNumber}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Back button overlay (top left) - visible when at top
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 8,
//             left: 16,
//             child: AnimatedOpacity(
//               opacity: (1.0 - headerOpacity).clamp(0.0, 1.0),
//               duration: const Duration(milliseconds: 100),
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.3),  // CHANGED: Semi-transparent black
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     size: 24,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Fixed start button at bottom
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: _buildStartButton(context),
//           ),
//         ],
//       ),
//     );
//   }

//     Future<Exercise?> _fetchExerciseDetailsForCard(Exercise exercise) async {
//     try {
//       // Convert exercise name to exercise ID (lowercase, replace spaces with hyphens)
//       final exerciseId = exercise.name.toLowerCase().replaceAll(' ', '-');
      
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:8000/api/workout/exercise-details'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'exerciseIds': [exerciseId]}),
//       );
      
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final exercises = data['exercises'] as List;
        
//         if (exercises.isNotEmpty) {
//           final exerciseData = exercises[0];
//           return Exercise(
//             name: exerciseData['name'],
//             duration: exercise.duration,
//             thumbnailPath: exercise.thumbnailPath,
//             actionSteps: List<String>.from(exerciseData['actionSteps'] ?? []),
//             breathingRhythm: List<String>.from(exerciseData['breathingRhythm'] ?? []),
//             actionFeeling: List<String>.from(exerciseData['actionFeeling'] ?? []),
//             commonMistakes: List<String>.from(exerciseData['commonMistakes'] ?? []),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error fetching exercise details: $e');
//     }
//     return null;
//   }

//   Widget _buildStats() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Duration
//           Row(
//             children: [
//               Icon(
//                 Icons.access_time,
//                 size: 18,
//                 color: Colors.grey[600],
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 '${widget.duration} min',
//                 style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(width: 24),

//           // Calories
//           Row(
//             children: [
//               Icon(
//                 Icons.local_fire_department,
//                 size: 18,
//                 color: Colors.grey[600],
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 '${widget.calories} kcal',
//                 style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkoutSets(BuildContext context) {
//     return Column(
//       children: widget.workoutSets.map((set) => _buildWorkoutSet(context, set)).toList(),
//     );
//   }

//   Widget _buildWorkoutSet(BuildContext context, WorkoutSet set) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Set title
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               set.setName,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//           ),

//           // Exercise cards
//           ...set.exercises.map((exercise) => _buildExerciseCard(context, exercise)).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.white,
//         child: InkWell(
//           onTap: () async {
//   // Show loading indicator
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => const Center(
//       child: CircularProgressIndicator(color: Colors.pink),
//     ),
//   );
  
//   // Fetch real exercise details
//   final detailedExercise = await _fetchExerciseDetailsForCard(exercise);
  
//   // Close loading indicator
//   if (context.mounted) Navigator.pop(context);
  
//   // Show exercise detail bottom sheet with real data
//   if (context.mounted) {
//     ExerciseDetailSheet.show(
//       context,
//       exercise: detailedExercise ?? exercise,
//     );
//   }
// },
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(4),
//             child: Row(
//               children: [
//                 // Thumbnail
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     color: Colors.grey[200],
//                     child: exercise.thumbnailPath != null
//                         ? Image.asset(
//                             exercise.thumbnailPath!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Icon(
//                                 Icons.fitness_center,
//                                 size: 40,
//                                 color: Colors.grey[400],
//                               );
//                             },
//                           )
//                         : Icon(
//                             Icons.fitness_center,
//                             size: 40,
//                             color: Colors.grey[400],
//                           ),
//                   ),
//                 ),

//                 const SizedBox(width: 16),

//                 // Exercise info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         exercise.name,
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${exercise.duration} seconds',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStartButton(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color(0xFFE91E63),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 // Navigate to Pre-Workout Screen
//                 _navigateToPreWorkout(context);
//               },
//               borderRadius: BorderRadius.circular(12),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: Center(
//                   child: Text(
//                     'Start Training',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // New method to navigate to Pre-Workout Screen
//   void _navigateToPreWorkout(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PreWorkoutScreen(
//           dayNumber: widget.dayNumber,
//           duration: widget.duration,
//           calories: widget.calories,
//         ),
//       ),
//     );
//   }
// }

// // Exercise Detail Bottom Sheet (keep the same as before)
// class ExerciseDetailSheet {
//   static Future<void> show(BuildContext context, {required Exercise exercise}) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.9,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         builder: (context, scrollController) {
//           return Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Drag handle and close button
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//                   child: Row(
//                     children: [
//                       const Spacer(),
//                       Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           child: Icon(
//                             Icons.close,
//                             size: 24,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Exercise demonstration image/video
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.35,
//                   width: double.infinity,
//                   color: Colors.grey[200],
//                   child: exercise.thumbnailPath != null
//                       ? Image.asset(
//                           exercise.thumbnailPath!,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Center(
//                               child: Icon(
//                                 Icons.fitness_center,
//                                 size: 80,
//                                 color: Colors.grey[400],
//                               ),
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Icon(
//                             Icons.fitness_center,
//                             size: 80,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                 ),

//                 // Scrollable content
//                 Expanded(
//                   child: ListView(
//                     controller: scrollController,
//                     padding: const EdgeInsets.all(20),
//                     children: [
//                       // Exercise name
//                       Text(
//                         exercise.name,
//                         style: GoogleFonts.poppins(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),

//                       const SizedBox(height: 24),

//                       // Action Steps
//                       _buildSection(
//                         title: 'Action Steps:',
//                         items: exercise.actionSteps ?? [
//                           'Stand with feet shoulder-width apart',
//                           'Keep your core engaged and back straight',
//                           'Perform the movement in a controlled manner',
//                           'Maintain steady breathing throughout',
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // Breathing Rhythm
//                       _buildSection(
//                         title: 'Breathing Rhythm:',
//                         items: exercise.breathingRhythm ?? [
//                           'Inhale: During the preparation phase',
//                           'Exhale: During the active movement',
//                           'Keep breathing steady and controlled',
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // Action Feeling
//                       _buildSection(
//                         title: 'Action Feeling:',
//                         items: exercise.actionFeeling ?? [
//                           'You should feel tension in the target muscle group',
//                           'No pain or sharp discomfort',
//                           'Controlled burn sensation is normal',
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // Common Mistakes
//                       _buildSection(
//                         title: 'Common Mistakes:',
//                         items: exercise.commonMistakes ?? [
//                           'Avoid holding your breath',
//                           'Don\'t rush through the movement',
//                           'Keep your core engaged at all times',
//                           'Don\'t overextend beyond your comfort zone',
//                         ],
//                       ),

//                       const SizedBox(height: 100), // Space for button
//                     ],
//                   ),
//                 ),

//                 // Start button
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: SafeArea(
//                     top: false,
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE91E63),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () {
//                             // TODO: Start this specific exercise
//                             Navigator.pop(context);
//                             print('Starting exercise: ${exercise.name}');
//                           },
//                           borderRadius: BorderRadius.circular(12),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             child: Center(
//                               child: Text(
//                                 'Start',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   static Widget _buildSection({required String title, required List<String> items}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...items.map((item) => Padding(
//           padding: const EdgeInsets.only(bottom: 8, left: 8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '• ',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   item,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey[700],
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )).toList(),
//       ],
//     );
//   }
// }

// // Data models for workout structure
// class WorkoutSet {
//   final String setName;
//   final List<Exercise> exercises;

//   WorkoutSet({
//     required this.setName,
//     required this.exercises,
//   });
// }

// class Exercise {
//   final String name;
//   final int duration; // in seconds
//   final String? thumbnailPath;
//   final List<String>? actionSteps;
//   final List<String>? breathingRhythm;
//   final List<String>? actionFeeling;
//   final List<String>? commonMistakes;

//   Exercise({
//     required this.name,
//     required this.duration,
//     this.thumbnailPath,
//     this.actionSteps,
//     this.breathingRhythm,
//     this.actionFeeling,
//     this.commonMistakes,
//   });
// }


//activate workout screen


// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'dart:math' as math;
// import '../main_view/widgets/day_detail_sheet.dart';
// import '../../data/models/achievement_model.dart';
// import '../../controllers/workout_plan_controller.dart';
// import 'workout_complete_screen.dart';
// import '../../controllers/workout_audio_controller.dart';
// import 'music_bottom_sheet.dart';
// import '../main_view/screens/activity_screen.dart';
// import '../../core/services/firestore_service.dart';
// import '../../core/services/user_service.dart';
// import '../../data/models/workout/workout_exercise.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ActiveWorkoutScreen extends StatefulWidget {
//   final int dayNumber;
//   final List<WorkoutExercise> exercises; // ✅ CHANGED: Accept exercises from workout plan
//   final int? initialHeartRate;

//   const ActiveWorkoutScreen({
//     Key? key,
//     required this.dayNumber,
//     required this.exercises, // ✅ CHANGED: Exercises instead of duration/calories
//     this.initialHeartRate,
//   }) : super(key: key);

//   @override
//   State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
// }

// class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
//     with TickerProviderStateMixin {
  
//   // Workout state
//   int _currentExerciseIndex = 0;
//   int _currentSet = 1; // ✅ NEW: Track current set
//   int _totalSets = 3; // ✅ NEW: Total sets per exercise
//   bool _isGetReadyPhase = true;
//   bool _isRestPhase = false; // ✅ NEW: Track rest phase
//   bool _isPaused = false;
//   double _countdown = 10.0;
//   double _exerciseTime = 0.0;
//   double _restTime = 0.0; // ✅ NEW: Rest timer
//   Timer? _timer;
  
//   // UI state
//   bool _isLandscape = false;
  
//   // Animation controllers
//   late AnimationController _countdownScaleController;
//   late AnimationController _countdownFadeController;
  
//   // Audio controller
//   late WorkoutAudioController _audioController;
//   // Firestore service
//   late FirestoreService _firestoreService;

//   @override
//   void initState() {
//     super.initState();

//     // ✅ Set total sets from first exercise
//     if (widget.exercises.isNotEmpty) {
//       _totalSets = widget.exercises.first.sets;
//     }

//     // Initialize audio controller
//     if (!Get.isRegistered<WorkoutAudioController>()) {
//       Get.put(WorkoutAudioController());
//     }
//     _audioController = Get.find<WorkoutAudioController>();

//     // Initialize Firestore service
//     _firestoreService = Get.find<FirestoreService>();
    
//     _audioController.setWorkoutPaused(false);
    
//     // Start background music after short delay
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _audioController.startBackgroundMusic();
//     });
    
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
//     _countdownScaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
    
//     _countdownFadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
    
//     _startWorkout();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
//     _audioController.setWorkoutPaused(false);
//     _countdownScaleController.dispose();
//     _countdownFadeController.dispose();
    
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
    
//     super.dispose();
//   }

//   // ✅ UPDATED: Use dynamic exercises
//   List<WorkoutExercise> get _exercises => widget.exercises.isNotEmpty 
//       ? widget.exercises 
//       : [WorkoutExercise(name: 'Sample Exercise', duration: 30, sets: 3, reps: 12, rest: 30)];

//   void _startWorkout() {
//     if (_exercises.isEmpty) return;
//     _audioController.announceGetReady(_exercises[_currentExerciseIndex].name);
//     _startGetReadyPhase();
//   }

//   void _startGetReadyPhase() {
//     setState(() {
//       _isGetReadyPhase = true;
//       _isRestPhase = false; // ✅ NEW
//       _countdown = 10.0;
//       _isPaused = false;
//     });
    
//     bool has3Announced = false;
//     bool has2Announced = false;
//     bool has1Announced = false;
//     bool hasGoAnnounced = false;
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isPaused) return;
      
//       setState(() {
//         _countdown -= 0.1;
        
//         if (_countdown <= 3 && _countdown > 0 && _countdown % 1 < 0.1) {
//           _countdownScaleController.forward(from: 0);
//           _countdownFadeController.forward(from: 0);
//         }
        
//         if (_countdown <= 3.0 && _countdown > 2.9 && !has3Announced) {
//           _audioController.announceCountdown(3);
//           has3Announced = true;
//         }
        
//         if (_countdown <= 2.0 && _countdown > 1.9 && !has2Announced) {
//           _audioController.announceCountdown(2);
//           has2Announced = true;
//         }
        
//         if (_countdown <= 1.0 && _countdown > 0.9 && !has1Announced) {
//           _audioController.announceCountdown(1);
//           has1Announced = true;
//         }
      
//         if (_countdown <= 0.1 && _countdown > 0.0 && !hasGoAnnounced) {
//           _audioController.announceGo();
//           hasGoAnnounced = true;
//         }
        
//         if (_countdown <= 0) {
//           timer.cancel();
//           _startExercisePhase();
//         }
//       });
//     });
//   }

//   void _startExercisePhase() {
//     setState(() {
//       _isGetReadyPhase = false;
//       _isRestPhase = false; // ✅ NEW
//       _exerciseTime = 0.0;
//       _isPaused = false;
//     });
    
//     bool halfwayAnnounced = false;
//     bool tenSecondsAnnounced = false;
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isPaused) return;
      
//       setState(() {
//         _exerciseTime += 0.1;
        
//         final currentExercise = _exercises[_currentExerciseIndex];
//         final duration = currentExercise.duration.toDouble();
//         final halfwayPoint = duration / 2;
        
//         if (_exerciseTime >= halfwayPoint && _exerciseTime < halfwayPoint + 0.2 && !halfwayAnnounced) {
//           _audioController.announceHalfway();
//           halfwayAnnounced = true;
//         }
        
//         if (_exerciseTime >= duration - 10 && _exerciseTime < duration - 9.8 && !tenSecondsAnnounced) {
//           _audioController.announceLastTenSeconds();
//           tenSecondsAnnounced = true;
//         }
        
//         if (_exerciseTime >= duration) {
//           timer.cancel();
//           _onExerciseComplete(); // ✅ CHANGED: Handle sets/reps
//         }
//       });
//     });
//   }

//   // ✅ NEW: Handle exercise completion with sets
//   void _onExerciseComplete() {
//     if (_currentSet < _totalSets) {
//       // More sets to do, start rest period
//       _currentSet++;
//       _startRestPeriod();
//     } else {
//       // All sets done, move to next exercise
//       _currentSet = 1;
//       _moveToNextExercise();
//     }
//   }

//   // ✅ NEW: Rest period between sets
//   void _startRestPeriod() {
//     final currentExercise = _exercises[_currentExerciseIndex];
    
//     setState(() {
//       _isRestPhase = true;
//       _isGetReadyPhase = false;
//       _restTime = currentExercise.rest.toDouble();
//       _isPaused = false;
//     });
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isPaused) return;
      
//       setState(() {
//         _restTime -= 0.1;
        
//         if (_restTime <= 0) {
//           timer.cancel();
//           _startGetReadyPhase(); // Go back to get ready for next set
//         }
//       });
//     });
//   }

//   void _togglePause() {
//     setState(() {
//       _isPaused = !_isPaused;
//     });
    
//     _audioController.setWorkoutPaused(_isPaused);
//   }

//   void _goToPrevious() {
//     _timer?.cancel();
//     if (_currentExerciseIndex > 0) {
//       setState(() {
//         _currentExerciseIndex--;
//         _currentSet = 1; // ✅ Reset sets
//       });
//       _audioController.announceGetReady(_exercises[_currentExerciseIndex].name);
//     }
//     _startGetReadyPhase();
//   }

//   void _goToNext() {
//     _timer?.cancel();
//     _moveToNextExercise();
//   }

//   void _moveToNextExercise() {
//     if (_currentExerciseIndex < _exercises.length - 1) {
//       setState(() {
//         _currentExerciseIndex++;
//         _currentSet = 1; // ✅ Reset sets for new exercise
//         if (_exercises.isNotEmpty) {
//           _totalSets = _exercises[_currentExerciseIndex].sets; // ✅ Update total sets
//         }
//       });
//       _audioController.announceNextExercise(_exercises[_currentExerciseIndex].name);
//       _startGetReadyPhase();
//     } else {
//       _completeWorkout();
//     }
//   }

//   void _completeWorkout() {
//     _audioController.announceWorkoutComplete();
//     Future.delayed(const Duration(seconds: 2), () {
//       _showWorkoutCompleteDialog();
//     });
//   }

//   Future<Exercise?> _fetchExerciseDetails(String exerciseName) async {
//     try {
//       final exerciseId = exerciseName.toLowerCase().replaceAll(' ', '-');
      
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:8000/api/workout/exercise-details'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'exerciseIds': [exerciseId]}),
//       );
      
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final exercises = data['exercises'] as List;
        
//         if (exercises.isNotEmpty) {
//           final exerciseData = exercises[0];
//           return Exercise(
//             name: exerciseData['name'],
//             duration: _exercises[_currentExerciseIndex].duration,
//             actionSteps: List<String>.from(exerciseData['actionSteps'] ?? []),
//             breathingRhythm: List<String>.from(exerciseData['breathingRhythm'] ?? []),
//             actionFeeling: List<String>.from(exerciseData['actionFeeling'] ?? []),
//             commonMistakes: List<String>.from(exerciseData['commonMistakes'] ?? []),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error fetching exercise details: $e');
//     }
//     return null;
//   }

//   void _toggleOrientation() {
//     setState(() {
//       _isLandscape = !_isLandscape;
//     });
    
//     if (_isLandscape) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//     }
//   }

//   double _getOverallProgress() {
//     // ✅ UPDATED: Factor in sets for accurate progress
//     final totalSteps = _exercises.fold<int>(0, (sum, e) => sum + e.sets);
//     final currentStep = _exercises.take(_currentExerciseIndex).fold<int>(0, (sum, e) => sum + e.sets) + _currentSet;
//     return currentStep / totalSteps;
//   }

//   double _getCurrentProgress() {
//     if (_isGetReadyPhase) {
//       return (10 - _countdown) / 10;
//     } else if (_isRestPhase) {
//       // ✅ NEW: Show rest progress
//       final currentExercise = _exercises[_currentExerciseIndex];
//       return (_currentExercise.rest - _restTime) / currentExercise.rest;
//     } else {
//       final currentExercise = _exercises[_currentExerciseIndex];
//       return _exerciseTime / currentExercise.duration;
//     }
//   }

//   String _getTimerDisplay() {
//     if (_isGetReadyPhase) {
//       return _countdown.ceil().toString().padLeft(2, '0');
//     } else if (_isRestPhase) {
//       // ✅ NEW: Show rest time
//       return _restTime.ceil().toString().padLeft(2, '0');
//     } else {
//       int minutes = _exerciseTime ~/ 60;
//       int seconds = _exerciseTime.toInt() % 60;
//       return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF5F5F5),
//           body: SafeArea(
//             child: _isLandscape
//                 ? _buildLandscapeLayout()
//                 : _buildPortraitLayout(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPortraitLayout() {
//     final currentExercise = _exercises[_currentExerciseIndex];
    
//     return Stack(
//       children: [
//         Column(
//           children: [
//             _buildTopProgressBar(),
//             _buildTopButtons(),
//             Expanded(
//               child: _buildExerciseArea(),
//             ),
//             _buildBottomSection(currentExercise),
//           ],
//         ),
        
//         if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
//           _buildCountdownOverlay(),
//       ],
//     );
//   }

//   Widget _buildLandscapeLayout() {
//     final currentExercise = _exercises[_currentExerciseIndex];
    
//     return Stack(
//       children: [
//         Column(
//           children: [
//             _buildTopProgressBar(),
            
//             Expanded(
//               child: Stack(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.25,
//                         padding: const EdgeInsets.all(16),
//                         child: _buildCircularProgress(currentExercise),
//                       ),
                      
//                       Expanded(
//                         child: _buildExerciseArea(),
//                       ),
                      
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.25,
//                         child: Center(
//                           child: _isGetReadyPhase
//                               ? Text(
//                                   'Get Ready',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w800,
//                                     color: Colors.black,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 )
//                               : _isRestPhase // ✅ NEW
//                                   ? Text(
//                                       'Rest',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 40,
//                                         fontWeight: FontWeight.w800,
//                                         color: Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     )
//                                   : Text(
//                                       _getTimerDisplay(),
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 56,
//                                         fontWeight: FontWeight.w800,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   Positioned(
//                     bottom: 24,
//                     left: 0,
//                     right: 0,
//                     child: _buildLandscapeBottomControls(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
        
//         Positioned(
//           top: 16,
//           right: 16,
//           child: _buildCircularButton(
//             icon: Icons.screen_rotation_outlined,
//             onPressed: _toggleOrientation,
//           ),
//         ),
        
//         if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
//           _buildCountdownOverlay(),
//       ],
//     );
//   }

//   Widget _buildTopProgressBar() {
//     return Container(
//       height: 4,
//       child: Row(
//         children: List.generate(_exercises.length, (index) {
//           bool isCompleted = index < _currentExerciseIndex;
//           bool isCurrent = index == _currentExerciseIndex;
          
//           return Expanded(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 0.5),
//               decoration: BoxDecoration(
//                 color: isCompleted 
//                     ? const Color(0xFFE91E63)
//                     : isCurrent 
//                         ? const Color(0xFFE91E63).withOpacity(0.5)
//                         : const Color(0xFFE0E0E0),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildTopButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildCircularButton(
//             icon: Icons.chevron_left,
//             onPressed: _showExitDialog,
//           ),
          
//           const Spacer(),
          
//           Column(
//             children: [
//               _buildCircularButton(
//                 icon: Icons.screen_rotation_outlined,
//                 onPressed: _toggleOrientation,
//               ),
//               const SizedBox(height: 12),
//               _buildCircularButton(
//                 icon: Icons.music_note,
//                 onPressed: () {
//                   MusicBottomSheet.show(context);
//                 },
//               ),
//               const SizedBox(height: 12),
//               _buildCircularButton(
//                 icon: Icons.info_outline,
//                 onPressed: () async {
//                   setState(() {
//                     _isPaused = true;
//                   });
//                   _audioController.setWorkoutPaused(true);
                  
//                   final currentExercise = _exercises[_currentExerciseIndex];
                  
//                   final exerciseDetails = await _fetchExerciseDetails(currentExercise.name);
                  
//                   await ExerciseDetailSheet.show(
//                     context,
//                     exercise: exerciseDetails ?? Exercise(
//                       name: currentExercise.name,
//                       duration: currentExercise.duration,
//                       actionSteps: ['Loading...'],
//                     ),
//                   );
                  
//                   setState(() {
//                     _isPaused = false;
//                   });
//                   _audioController.setWorkoutPaused(false);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCircularButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(25),
//         child: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExerciseArea() {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: Image.asset(
//           'assets/images/exercise_placeholder.png',
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(
//               Icons.fitness_center,
//               size: 100,
//               color: Colors.grey[300],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCountdownOverlay() {
//     int displayNumber = _countdown.ceil();
//     String displayText = displayNumber > 0 ? '$displayNumber' : 'GO!';
    
//     return Container(
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: ScaleTransition(
//           scale: Tween<double>(begin: 0.5, end: 1.2).animate(
//             CurvedAnimation(
//               parent: _countdownScaleController,
//               curve: Curves.elasticOut,
//             ),
//           ),
//           child: Text(
//             displayText,
//             style: GoogleFonts.poppins(
//               fontSize: 100,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomSection(WorkoutExercise exercise) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//             child: Column(
//               children: [
//                 Text(
//                   _isGetReadyPhase 
//                       ? 'Get Ready' 
//                       : _isRestPhase // ✅ NEW
//                           ? 'Rest'
//                           : _getTimerDisplay(),
//                   style: GoogleFonts.poppins(
//                     fontSize: _isGetReadyPhase || _isRestPhase ? 32 : 56,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     height: 1.1,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 const SizedBox(height: 8),
                
//                 Text(
//                   exercise.name,
//                   style: GoogleFonts.poppins(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 const SizedBox(height: 4),
                
//                 // ✅ UPDATED: Show set progress
//                 Text(
//                   'STEP ${_currentExerciseIndex + 1}/${_exercises.length} • SET $_currentSet/$_totalSets',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF757575),
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           _buildThickControlBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildThickControlBar() {
//     final progress = _getCurrentProgress();
    
//     return Container(
//       height: 56,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Stack(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 56,
//               color: const Color(0xFFE0E0E0),
//             ),
            
//             TweenAnimationBuilder<double>(
//               duration: const Duration(milliseconds: 100),
//               curve: Curves.linear,
//               tween: Tween<double>(
//                 begin: 0,
//                 end: progress.clamp(0.0, 1.0),
//               ),
//               builder: (context, value, child) {
//                 return FractionallySizedBox(
//                   widthFactor: value,
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     height: 56,
//                     color: const Color(0xFFE91E63),
//                   ),
//                 );
//               },
//             ),
            
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: _goToPrevious,
//                       borderRadius: const BorderRadius.horizontal(
//                         left: Radius.circular(28),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.skip_previous_rounded,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 Expanded(
//                   flex: 4,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: _togglePause,
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: Icon(
//                           _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 Expanded(
//                   flex: 3,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: _goToNext,
//                       borderRadius: const BorderRadius.horizontal(
//                         right: Radius.circular(28),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.skip_next_rounded,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCircularProgress(WorkoutExercise exercise) {
//     final progress = _getCurrentProgress();
    
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 120,
//           height: 120,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CustomPaint(
//                 size: const Size(120, 120),
//                 painter: _CircularProgressPainter(
//                   progress: 1.0,
//                   color: const Color(0xFFE0E0E0),
//                   strokeWidth: 10,
//                 ),
//               ),
              
//               CustomPaint(
//                 size: const Size(120, 120),
//                 painter: _CircularProgressPainter(
//                   progress: progress,
//                   color: const Color(0xFFE91E63),
//                   strokeWidth: 10,
//                 ),
//               ),
              
//               GestureDetector(
//                 onTap: _togglePause,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                     color: Colors.grey[700],
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         const SizedBox(height: 16),
        
//         Text(
//           exercise.name,
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
        
//         const SizedBox(height: 4),
        
//         Text(
//           'STEP ${_currentExerciseIndex + 1}/${_exercises.length}',
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF757575),
//             letterSpacing: 1.2,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLandscapeBottomControls() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _goToPrevious,
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.chevron_left,
//                   size: 32,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
          
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _goToNext,
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.chevron_right,
//                   size: 32,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showExitDialog() {
//     setState(() {
//       _isPaused = true;
//     });
//     _audioController.setWorkoutPaused(true);
    
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: '',
//       barrierColor: Colors.transparent,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return Container();
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         final blurAnimation = Tween<double>(begin: 0, end: 5).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOut),
//         );
        
//         final scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
//         );
        
//         final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOut),
//         );
        
//         return Stack(
//           children: [
//             BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: blurAnimation.value,
//                 sigmaY: blurAnimation.value,
//               ),
//               child: Container(
//                 color: Colors.white.withOpacity(0.2),
//               ),
//             ),
            
//             Center(
//               child: FadeTransition(
//                 opacity: fadeAnimation,
//                 child: ScaleTransition(
//                   scale: scaleAnimation,
//                   child: _buildPauseDialogContent(),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildPauseDialogContent() {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     final remainingExercises = _exercises.length - _currentExerciseIndex;
    
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 30,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 48),
          
//           TweenAnimationBuilder<double>(
//             key: ValueKey('fire_pulse_${DateTime.now().millisecondsSinceEpoch}'),
//             duration: const Duration(milliseconds: 1200),
//             tween: Tween(begin: 0.95, end: 1.05),
//             curve: Curves.easeInOut,
//             builder: (context, scale, child) {
//               return Transform.scale(
//                 scale: scale,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFEBEE),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFE91E63).withOpacity(0.2),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: const Center(
//                     child: Text(
//                       '🔥',
//                       style: TextStyle(
//                         fontSize: 48,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             onEnd: () {
//               if (mounted) {
//                 setState(() {});
//               }
//             },
//           ),
          
//           const SizedBox(height: 28),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Hang in There!\nYou got this!',
//               style: GoogleFonts.poppins(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.black,
//                 height: 1.3,
//                 decoration: TextDecoration.none,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
          
//           const SizedBox(height: 12),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'There\'re only $remainingExercises actions left',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF757575),
//                 height: 1.4,
//                 decoration: TextDecoration.none,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
          
//           const SizedBox(height: 40),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     _isPaused = false;
//                   });
//                   _audioController.setWorkoutPaused(false);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                 ),
//                 child: Text(
//                   'Keep Exercising',
//                   style: GoogleFonts.poppins(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.3,
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           TextButton(
//             onPressed: () {
//               _timer?.cancel();
//               _audioController.stopBackgroundMusic();
//               Navigator.pop(context);
              
//               _showPartialWorkoutCompleteDialog();
//             },
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               overlayColor: Colors.transparent,
//               foregroundColor: const Color(0xFF757575),
//             ),
//             child: Text(
//               'Finish workout',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF757575),
//                 letterSpacing: 0.2,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 28),
//         ],
//       ),
//     );
//   }

//   // ✅ UPDATED: Handle partial workout completion
//   void _showPartialWorkoutCompleteDialog() async {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
    
//     final completedExercises = _isGetReadyPhase 
//         ? _currentExerciseIndex 
//         : _currentExerciseIndex + 1;
    
//     final totalMinutes = completedExercises > 0
//         ? _exercises.take(completedExercises).fold<int>(0, (sum, e) => sum + e.duration) ~/ 60
//         : 1;
    
//     final totalActions = completedExercises;
//     final totalCalories = (totalMinutes * 5); // Rough estimate: 5 cal/min
    
//     final user = Get.find<UserService>().currentUser.value;
//     final workoutPlanController = Get.find<WorkoutPlanController>();
//     final planId = workoutPlanController.currentPlan.value?.planId;
    
//     if (user != null && planId != null) {
//       try {
//         await _firestoreService.saveWorkoutCompletion(
//           userId: user.uid,
//           workoutId: 'workout_partial_${DateTime.now().millisecondsSinceEpoch}',
//           planId: planId,
//           day: widget.dayNumber,
//           date: DateTime.now().toIso8601String().split('T')[0],
//           duration: totalMinutes,
//           calories: totalCalories,
//           exercisesCompleted: _exercises.take(completedExercises).map((e) => e.name).toList(),
//           isComplete: false,
//         );
//         print('✅ Partial workout saved to Firestore');
//       } catch (e) {
//         print('❌ Failed to save partial workout: $e');
//       }
//     }
    
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WorkoutCompleteScreen(
//           dayNumber: widget.dayNumber,
//           totalCalories: totalCalories,
//           totalMinutes: totalMinutes,
//           totalActions: totalActions,
//           workoutName: 'Day ${widget.dayNumber} Workout (Incomplete)',
//           earnedAchievement: null,
//           isPartialWorkout: true,
//         ),
//       ),
//     );
//   }

//   // ✅ UPDATED: Handle full workout completion with Firestore
//   void _showWorkoutCompleteDialog() async {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
    
//     final totalMinutes = _exercises.fold<int>(0, (sum, e) => sum + e.duration) ~/ 60;
//     final totalCalories = (totalMinutes * 5); // Rough estimate
//     final totalActions = _exercises.length;
    
//     final user = Get.find<UserService>().currentUser.value;
//     final workoutPlanController = Get.find<WorkoutPlanController>();
//     final planId = workoutPlanController.currentPlan.value?.planId;
    
//     if (user != null && planId != null) {
//       try {
//         await _firestoreService.saveWorkoutCompletion(
//           userId: user.uid,
//           workoutId: 'workout_${DateTime.now().millisecondsSinceEpoch}',
//           planId: planId,
//           day: widget.dayNumber,
//           date: DateTime.now().toIso8601String().split('T')[0],
//           duration: totalMinutes,
//           calories: totalCalories,
//           exercisesCompleted: _exercises.map((e) => e.name).toList(),
//           isComplete: true,
//         );
//         print('✅ Workout saved to Firestore');
//       } catch (e) {
//         print('❌ Failed to save workout: $e');
//       }
//     }
    
//     AchievementModel? earnedAchievement;
//     try {
//       earnedAchievement = await workoutPlanController.updateStreakAfterWorkout(widget.dayNumber);
//     } catch (e) {
//       print('⚠️ Could not update streak: $e');
//     }
    
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WorkoutCompleteScreen(
//           dayNumber: widget.dayNumber,
//           totalCalories: totalCalories,
//           totalMinutes: totalMinutes,
//           totalActions: totalActions,
//           workoutName: 'Day ${widget.dayNumber} Workout',
//           earnedAchievement: earnedAchievement,
//           isPartialWorkout: false,
//         ),
//       ),
//     );
//   }
// }

// class _CircularProgressPainter extends CustomPainter {
//   final double progress;
//   final Color color;
//   final double strokeWidth;

//   _CircularProgressPainter({
//     required this.progress,
//     required this.color,
//     required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;

//     const startAngle = -math.pi / 2;
//     final sweepAngle = 2 * math.pi * progress;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
//       oldDelegate.progress != progress;
// }



// Active Workout Screen


// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'dart:math' as math;
// import '../main_view/widgets/day_detail_sheet.dart';
// import '../../data/models/achievement_model.dart';
// import '../../controllers/workout_plan_controller.dart';
// import 'workout_complete_screen.dart';
// import '../../controllers/workout_audio_controller.dart';
// import 'music_bottom_sheet.dart';
// import '../main_view/screens/activity_screen.dart';
// import '../../core/services/firestore_service.dart';
// import '../../core/services/user_service.dart';
// import '../../data/models/workout/workout_exercise.dart';
// import '../../../data/models/workout/simple_workout_models.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ActiveWorkoutScreen extends StatefulWidget {
//   final int dayNumber;
//   final List<WorkoutExercise> exercises;
//   final int? initialHeartRate;
//   final int? estimatedCalories;  // ✅ ADD THIS
//   final int? estimatedDuration;

//   const ActiveWorkoutScreen({
//     Key? key,
//     required this.dayNumber,
//     required this.exercises,
//     this.initialHeartRate,
//     this.estimatedCalories,  // ✅ ADD THIS
//     this.estimatedDuration,  // ✅ ADD THIS
//   }) : super(key: key);

//   @override
//   State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
// }

// class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
//     with TickerProviderStateMixin {
  
//   int _currentExerciseIndex = 0;
//   int _currentRound = 1;
//   int _totalRounds = 3;
//   String _currentPhase = 'warmup';  // 'warmup', 'main', 'cooldown'
//   late List<WorkoutExercise> _warmupExercises;
//   late List<WorkoutExercise> _mainExercises;
//   late List<WorkoutExercise> _cooldownExercises;
//   bool _isGetReadyPhase = true;
//   bool _isRestPhase = false;
//   bool _isRoundRestPhase = false;
//   bool _isPaused = false;
//   double _countdown = 10.0;
//   double _exerciseTime = 0.0;
//   double _restTime = 0.0;
//   Timer? _timer;
  
//   bool _isLandscape = false;
  
//   late AnimationController _countdownScaleController;
//   late AnimationController _countdownFadeController;
  
//   late WorkoutAudioController _audioController;
//   late FirestoreService _firestoreService;
//   DateTime? _workoutStartTime; // ✅ ADD THIS LINE

//   @override
//   void initState() {
//     super.initState();

//     // Split exercises by type
//     _warmupExercises = widget.exercises.where((e) => e.setType == 'warmup').toList();
//     _mainExercises = widget.exercises.where((e) => e.setType == 'main').toList();
//     _cooldownExercises = widget.exercises.where((e) => e.setType == 'cooldown').toList();
    
//     if (_mainExercises.isNotEmpty) {
//       _totalRounds = _mainExercises.first.sets ?? 3;
//     }
    
//     print('🔍 Workout Split:');
//     print('  Warmup: ${_warmupExercises.length} exercises');
//     print('  Main: ${_mainExercises.length} exercises (${_totalRounds} rounds)');
//     print('  Cooldown: ${_cooldownExercises.length} exercises');
//     // ✅ ADD DEBUG LOGGING
//     print('🔍 All exercises (${widget.exercises.length}):');
//     for (var i = 0; i < widget.exercises.length; i++) {
//       print('  $i: ${widget.exercises[i].name} - setType: "${widget.exercises[i].setType}"');
//     }

    

//     if (!Get.isRegistered<WorkoutAudioController>()) {
//       Get.put(WorkoutAudioController());
//     }
//     _audioController = Get.find<WorkoutAudioController>();
//     // ✅ SET CYCLE PHASE for personalized messages
//     try {
//       final workoutPlanController = Get.find<WorkoutPlanController>();
//       if (workoutPlanController.currentPlan.value != null) {
//         final currentDay = workoutPlanController.currentPlan.value!.getDayByNumber(widget.dayNumber);
//         if (currentDay != null) {
//           _audioController.setCyclePhase(currentDay.intensity);
//         }
//       }
//     } catch (e) {
//       print('⚠️ Could not get cycle phase: $e');
//     }

//     _firestoreService = Get.find<FirestoreService>();
    
//     _audioController.setWorkoutPaused(false);
    
    
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
//     _countdownScaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
    
//     _countdownFadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
    
//     _startWorkout();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
//     _audioController.stopCurrentSpeech();
//     _audioController.setWorkoutPaused(false);
//     _countdownScaleController.dispose();
//     _countdownFadeController.dispose();
    
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
    
//     super.dispose();
//   }

//   List<WorkoutExercise> get _currentExerciseList {
//   switch (_currentPhase) {
//     case 'warmup':
//       return _warmupExercises;
//     case 'main':
//       return _mainExercises;
//     case 'cooldown':
//       return _cooldownExercises;
//     default:
//       return [];
//   }
// }

// WorkoutExercise get currentExercise => _currentExerciseList[_currentExerciseIndex];

// // Keep for backwards compatibility
// List<WorkoutExercise> get _exercises => widget.exercises;

// void _startWorkout() {
//   if (_exercises.isEmpty) return;

//   _workoutStartTime = DateTime.now();
  
//   // ✅ START MUSIC WITH A WELCOMING MESSAGE
//   _audioController.startBackgroundMusic();
  
  
//   // ✅ Play a generic "Let's get started!" for first exercise
//   Future.delayed(const Duration(milliseconds: 200), () {
//     if (mounted) {
//       _audioController.playGetReadyForExercise(
//         _exercises[_currentExerciseIndex].name,
//         isFirstExercise: true, // This will trigger special first-exercise behavior
//       );
//     }
//   });
  
//   _startGetReadyPhase();
// }

//   void _startGetReadyPhase() {
//     setState(() {
//       _isGetReadyPhase = true;
//       _isRestPhase = false;
//       _isRoundRestPhase = false;
//       _countdown = 10.0;
//       _isPaused = false;
//     });
    
//     // ✅ Play "Get ready for {exercise}" ONLY if NOT first exercise
//     final isFirstExercise = _currentPhase == 'warmup' && _currentExerciseIndex == 0;
//     if (!isFirstExercise) {
//       final currentExercise = _exercises[_currentExerciseIndex];
//       _audioController.playGetReadyForExercise(
//         currentExercise.name,
//         isFirstExercise: false,
//       );
//     }
    
//     bool hasCountdownStarted = false;
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isPaused) return;
      
//       setState(() {
//         _countdown -= 0.1;
        
//         if (_countdown <= 3 && _countdown > 0 && _countdown % 1 < 0.1) {
//           _countdownScaleController.forward(from: 0);
//           _countdownFadeController.forward(from: 0);
//         }
        
//         // ✅ Play countdown "3...2...1...GO!" at 3.5 seconds
//         if (_countdown <= 3.5 && _countdown > 3.4 && !hasCountdownStarted) {
//           _audioController.playCountdown321Go();
//           hasCountdownStarted = true;
//         }
        
//         if (_countdown <= 0) {
//           timer.cancel();
//           _startExercisePhase();
//         }
//       });
//     });
//   }

// void _startExercisePhase() {
//   final currentExercise = _exercises[_currentExerciseIndex];
//   final adjustedDuration = _getExerciseDuration(currentExercise.duration);
  
//   setState(() {
//     _isGetReadyPhase = false;
//     _isRestPhase = false;
//     _isRoundRestPhase = false;
//     _exerciseTime = 0.0;
//     _isPaused = false;
//   });
  
//   print('🏋️ Starting exercise: ${currentExercise.name}');
//   print('  Base Duration: ${currentExercise.duration}s, Adjusted for Round $_currentRound: ${adjustedDuration}s');
  
//   // ✅ Play motivation randomly - only every 2-3 exercises
//   // Use exercise index and round to determine if we should play
//   final shouldPlayMotivation = (_currentExerciseIndex + _currentRound) % 2 == 0;
  
//   if (shouldPlayMotivation) {
//     final midpoint = adjustedDuration / 2;
//     Future.delayed(Duration(milliseconds: (midpoint * 1000).toInt()), () {
//       if (mounted && !_isPaused && !_isGetReadyPhase && !_isRestPhase) {
//         _audioController.playRandomMotivation();
//       }
//     });
//   }
  
//   _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//     if (_isPaused) return;
    
//     setState(() {
//       _exerciseTime += 0.1;
      
//       final duration = adjustedDuration.toDouble();
      
//       if (_exerciseTime >= duration) {
//         timer.cancel();
//         _onExerciseComplete();
//       }
//     });
//   });
// }

//   void _onExerciseComplete() {
//   print('🔍 Exercise Complete!');
//   print('  Current Phase: $_currentPhase');
//   print('  Current Exercise Index: $_currentExerciseIndex / ${_currentExerciseList.length - 1}');
  
//   if (_currentPhase == 'main') {
//     print('  Current Round: $_currentRound / $_totalRounds');
//   }
  
//   // Move to next exercise in current phase
//   if (_currentExerciseIndex < _currentExerciseList.length - 1) {
//     setState(() {
//       _currentExerciseIndex++;
//       _isGetReadyPhase = true;
//     });
//     _startGetReadyPhase();
//   } else {
//     // Completed all exercises in current phase
//     if (_currentPhase == 'warmup') {
//       print('  ✅ Warmup complete! Starting Main Workout Round 1');
//       setState(() {
//         _currentPhase = 'main';
//         _currentExerciseIndex = 0;
//         _currentRound = 1;
//         _isGetReadyPhase = true;
//       });
//       _startGetReadyPhase();
//     } else if (_currentPhase == 'main') {
//       if (_currentRound < _totalRounds) {
//         print('  🔄 Main Round $_currentRound complete! Starting 60s rest');
//         _startRoundRestPeriod();
//       } else {
//         print('  ✅ All main rounds complete! Starting Cooldown');
//         setState(() {
//           _currentPhase = 'cooldown';
//           _currentExerciseIndex = 0;
//           _isGetReadyPhase = true;
//         });
//         _startGetReadyPhase();
//       }
//     } else if (_currentPhase == 'cooldown') {
//       print('  ✅ Cooldown complete! Workout finished!');
//       _completeWorkout();
//     }
//   }
// }

//   void _startRoundRestPeriod() {
//   setState(() {
//     _isRoundRestPhase = true;
//     _isRestPhase = false;
//     _isGetReadyPhase = false;
//     _restTime = 60.0; // 60 seconds between rounds
//     _isPaused = false;
//   });
  
//   // ✅ Play rest message based on round just completed
//   _audioController.playRestTime(_currentRound);
  
//   _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//     if (_isPaused) return;
    
//     setState(() {
//       _restTime -= 0.1;
      
//       if (_restTime <= 0) {
//         timer.cancel();
//         setState(() {
//           _isRoundRestPhase = false;
//           _currentRound++;
//           _currentExerciseIndex = 0;
//         });
//         _startGetReadyPhase();
//       }
//     });
//   });
// }

//   void _extendRestTime() {
//   setState(() {
//     _restTime = math.min(_restTime + 30.0, 120.0); // Max 120 seconds
//   });
//   // No audio message for extending rest
// }

//   void _skipRoundRest() {
//   _timer?.cancel();
  
//   // ✅ Stop any ongoing speech
//   _audioController.stopCurrentSpeech();
  
//   setState(() {
//     _isRoundRestPhase = false;
//     _currentRound++;
//     _currentExerciseIndex = 0;
//   });
//   _startGetReadyPhase();
// }

//   void _togglePause() {
//     setState(() {
//       _isPaused = !_isPaused;
//     });
    
//     _audioController.setWorkoutPaused(_isPaused);
//   }

//   void _goToPrevious() {
//   _timer?.cancel();
  
//   // ✅ Stop any ongoing speech
//   _audioController.stopCurrentSpeech();
  
//   if (_currentExerciseIndex > 0) {
//     setState(() {
//       _currentExerciseIndex--;
//     });
//   }
//   _startGetReadyPhase();
// }

//   void _goToNext() {
//     _timer?.cancel();
    
//     // ✅ Stop any ongoing speech when skipping
//     _audioController.stopCurrentSpeech();
    
//     _moveToNextExercise();
//   }

// void _moveToNextExercise() {
//   print('🔍 Skip button pressed - Moving to next exercise');
//   print('  Current Phase: $_currentPhase');
//   print('  Current Round: $_currentRound / $_totalRounds');
//   print('  Current Exercise Index: $_currentExerciseIndex / ${_currentExerciseList.length - 1}');
  
//   // Same logic as _onExerciseComplete
//   if (_currentExerciseIndex < _currentExerciseList.length - 1) {
//     // More exercises in current phase
//     print('  ⏭️  Skipping to next exercise in same phase');
//     setState(() {
//       _currentExerciseIndex++;
//       _isGetReadyPhase = true;
//     });
//     _startGetReadyPhase();
//   } else {
//     // Last exercise in current phase - transition to next phase
//     print('  ✅ Last exercise in $_currentPhase - transitioning');
    
//     if (_currentPhase == 'warmup') {
//       print('  → Starting Main Workout Round 1');
//       setState(() {
//         _currentPhase = 'main';
//         _currentExerciseIndex = 0;
//         _currentRound = 1;
//         _isGetReadyPhase = true;
//       });
//       _startGetReadyPhase();
//     } else if (_currentPhase == 'main') {
//       if (_currentRound < _totalRounds) {
//         print('  → Starting round rest');
//         _startRoundRestPeriod();
//       } else {
//         print('  → Starting Cooldown');
//         setState(() {
//           _currentPhase = 'cooldown';
//           _currentExerciseIndex = 0;
//           _isGetReadyPhase = true;
//         });
//         _startGetReadyPhase();
//       }
//     } else if (_currentPhase == 'cooldown') {
//       print('  → Workout Complete!');
//       _completeWorkout();
//     }
//   }
// }

//   void _completeWorkout() {
//     _timer?.cancel();
    
//     // ✅ STOP background music when workout is complete
//     _audioController.stopBackgroundMusic();
    
//     // Show completion dialog immediately (no delay)
//     _showWorkoutCompleteDialog();
//   }

//   Future<Exercise?> _fetchExerciseDetails(String exerciseName) async {
//     try {
//       final exerciseId = exerciseName.toLowerCase().replaceAll(' ', '-');
      
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:8000/api/workout/exercise-details'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'exerciseIds': [exerciseId]}),
//       );
      
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final exercises = data['exercises'] as List;
        
//         if (exercises.isNotEmpty) {
//           final exerciseData = exercises[0];
//           return Exercise(
//             name: exerciseData['name'],
//             duration: _exercises[_currentExerciseIndex].duration,
//             actionSteps: List<String>.from(exerciseData['actionSteps'] ?? []),
//             breathingRhythm: List<String>.from(exerciseData['breathingRhythm'] ?? []),
//             actionFeeling: List<String>.from(exerciseData['actionFeeling'] ?? []),
//             commonMistakes: List<String>.from(exerciseData['commonMistakes'] ?? []),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error fetching exercise details: $e');
//     }
//     return null;
//   }

//   void _toggleOrientation() {
//     setState(() {
//       _isLandscape = !_isLandscape;
//     });
    
//     if (_isLandscape) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//     }
//   }

//   double _getOverallProgress() {
//   int totalSteps = _warmupExercises.length + 
//                    (_mainExercises.length * _totalRounds) + 
//                    _cooldownExercises.length;
  
//   int completedSteps = 0;
  
//   if (_currentPhase == 'warmup') {
//     completedSteps = _currentExerciseIndex;
//   } else if (_currentPhase == 'main') {
//     completedSteps = _warmupExercises.length + 
//                      (_currentRound - 1) * _mainExercises.length + 
//                      _currentExerciseIndex;
//   } else if (_currentPhase == 'cooldown') {
//     completedSteps = _warmupExercises.length + 
//                      (_mainExercises.length * _totalRounds) + 
//                      _currentExerciseIndex;
//   }
  
//   return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
// }

//   double _getCurrentProgress() {
//   if (_isGetReadyPhase) {
//     return (10.0 - _countdown) / 10.0;  // ✅ Fills from 0 to 1
//   } else if (_isRoundRestPhase) {
//     return (60.0 - _restTime) / 60.0;   // ✅ Fills from 0 to 1
//   } else if (_isRestPhase) {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     final restDuration = (currentExercise.rest ?? 30).toDouble();
//     return (restDuration - _restTime) / restDuration;  // ✅ Fills from 0 to 1
//   } else {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     final adjustedDuration = _getExerciseDuration(currentExercise.duration); // ✅ NEW
//     return _exerciseTime / adjustedDuration.toDouble();  // ✅ Fills from 0 to 1
//   }
// }

//   int _getExerciseDuration(int baseDuration, [int? forRound]) {
//   int round = forRound ?? _currentRound;
  
//   if (round == 1) {
//     return baseDuration;
//   } else if (round == 2) {
//     return baseDuration + 10;
//   } else {
//     return baseDuration + 15;
//   }
// }

// // ✅ Calculate actual workout duration including rounds and rest
// int _calculateActualDuration() {
//   // ✅ Use ACTUAL elapsed time from start
//   if (_workoutStartTime != null) {
//     final elapsed = DateTime.now().difference(_workoutStartTime!);
//     return elapsed.inMinutes;
//   }
  
//   // Fallback if somehow start time wasn't set
//   return 0;
// }

// // ✅ Calculate calories based on actual time
//   int _calculateActualCalories(int actualMinutes) {
//     // Use backend estimate as baseline, scale by actual vs estimated
//     if (widget.estimatedDuration != null && widget.estimatedCalories != null && widget.estimatedDuration! > 0) {
//       double ratio = actualMinutes / widget.estimatedDuration!;
//       return (widget.estimatedCalories! * ratio).round();
//     }
    
//     // Fallback: ~6 cal/min for moderate intensity women's workout
//     return actualMinutes * 6;
//   }

//   String _getTimerDisplay() {
//   if (_isGetReadyPhase) {
//     return _countdown.ceil().toString().padLeft(2, '0');
//   } else if (_isRestPhase) {
//     return _restTime.ceil().toString().padLeft(2, '0');
//   } else if (_isRoundRestPhase) {
//     return _restTime.ceil().toString().padLeft(2, '0');
//   } else {
//     // ✅ COUNTDOWN: Show remaining time instead of elapsed time
//     final currentExercise = _exercises[_currentExerciseIndex];
//     final adjustedDuration = _getExerciseDuration(currentExercise.duration);
//     final remainingTime = adjustedDuration - _exerciseTime;
    
//     // Ensure we don't show negative time
//     final timeToShow = remainingTime > 0 ? remainingTime : 0;
    
//     int minutes = timeToShow ~/ 60;
//     int seconds = timeToShow.toInt() % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF5F5F5),
//           body: SafeArea(
//             child: _isLandscape
//                 ? _buildLandscapeLayout()
//                 : _buildPortraitLayout(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPortraitLayout() {
//     final currentExercise = _exercises[_currentExerciseIndex];
    
//     return Stack(
//       children: [
//         Column(
//           children: [
//             _buildTopProgressBar(),
//             _buildTopButtons(),
//             Expanded(
//               child: _buildExerciseArea(),
//             ),
//             _buildBottomSection(currentExercise),
//           ],
//         ),
        
//         if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
//           _buildCountdownOverlay(),
//       ],
//     );
//   }

//   Widget _buildLandscapeLayout() {
//     final currentExercise = _exercises[_currentExerciseIndex];
    
//     return Stack(
//       children: [
//         Column(
//           children: [
//             _buildTopProgressBar(),
            
//             Expanded(
//               child: Stack(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.25,
//                         padding: const EdgeInsets.all(16),
//                         child: _buildCircularProgress(currentExercise),
//                       ),
                      
//                       Expanded(
//                         child: _buildExerciseArea(),
//                       ),
                      
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.25,
//                         child: Center(
//                           child: _isGetReadyPhase
//                               ? Text(
//                                   'Get Ready',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w800,
//                                     color: Colors.black,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 )
//                               : _isRestPhase
//                                   ? Text(
//                                       'Rest',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 40,
//                                         fontWeight: FontWeight.w800,
//                                         color: Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     )
//                                   : Text(
//                                       _getTimerDisplay(),
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 56,
//                                         fontWeight: FontWeight.w800,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   Positioned(
//                     bottom: 24,
//                     left: 0,
//                     right: 0,
//                     child: _buildLandscapeBottomControls(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
        
//         Positioned(
//           top: 16,
//           right: 16,
//           child: _buildCircularButton(
//             icon: Icons.screen_rotation_outlined,
//             onPressed: _toggleOrientation,
//           ),
//         ),
        
//         if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
//           _buildCountdownOverlay(),
//       ],
//     );
//   }

//   Widget _buildTopProgressBar() {
//     return Container(
//       height: 4,
//       child: Row(
//         children: List.generate(_exercises.length, (index) {
//           bool isCompleted = index < _currentExerciseIndex;
//           bool isCurrent = index == _currentExerciseIndex;
          
//           return Expanded(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 0.5),
//               decoration: BoxDecoration(
//                 color: isCompleted 
//                     ? const Color(0xFFE91E63)
//                     : isCurrent 
//                         ? const Color(0xFFE91E63).withOpacity(0.5)
//                         : const Color(0xFFE0E0E0),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildTopButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildCircularButton(
//             icon: Icons.chevron_left,
//             onPressed: _showExitDialog,
//           ),
          
//           const Spacer(),
          
//           Column(
//             children: [
//               _buildCircularButton(
//                 icon: Icons.screen_rotation_outlined,
//                 onPressed: _toggleOrientation,
//               ),
//               const SizedBox(height: 12),
//               _buildCircularButton(
//                 icon: Icons.music_note,
//                 onPressed: () {
//                   MusicBottomSheet.show(context);
//                 },
//               ),
//               const SizedBox(height: 12),
//               _buildCircularButton(
//                 icon: Icons.info_outline,
//                 onPressed: () async {
//                   setState(() {
//                     _isPaused = true;
//                   });
//                   _audioController.setWorkoutPaused(true);
                  
//                   final exercise = currentExercise;  // Use the getter from the correct phase
                  
//                   final exerciseDetails = await _fetchExerciseDetails(exercise.name);
                  
//                   await ExerciseDetailSheet.show(
//                     context,
//                     exercise: exerciseDetails ?? Exercise(
//                       name: exercise.name,
//                       duration: exercise.duration,
//                       actionSteps: ['Loading...'],
//                     ),
//                   );
                  
//                   setState(() {
//                     _isPaused = false;
//                   });
//                   _audioController.setWorkoutPaused(false);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCircularButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(25),
//         child: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildExerciseArea() {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: Image.asset(
//           'assets/images/exercise_placeholder.png',
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(
//               Icons.fitness_center,
//               size: 100,
//               color: Colors.grey[300],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCountdownOverlay() {
//     int displayNumber = _countdown.ceil();
//     String displayText = displayNumber > 0 ? '$displayNumber' : 'GO!';
    
//     return Container(
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: ScaleTransition(
//           scale: Tween<double>(begin: 0.5, end: 1.2).animate(
//             CurvedAnimation(
//               parent: _countdownScaleController,
//               curve: Curves.elasticOut,
//             ),
//           ),
//           child: Text(
//             displayText,
//             style: GoogleFonts.poppins(
//               fontSize: 100,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomSection(WorkoutExercise exercise) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//             child: Column(
//               children: [
//                 Text(
//                     _isGetReadyPhase 
//                         ? 'Get Ready' 
//                         : _isRoundRestPhase
//                             ? '${_restTime.ceil()}'  // ✅ SHOW COUNTDOWN NUMBER
//                             : _isRestPhase
//                                 ? 'Rest'
//                                 : _getTimerDisplay(),
//                     style: GoogleFonts.poppins(
//                       fontSize: _isGetReadyPhase || _isRestPhase ? 32 : _isRoundRestPhase ? 72 : 56,  // ✅ BIGGER for countdown
//                       fontWeight: FontWeight.w800,
//                       color: _isRoundRestPhase ? const Color(0xFFE91E63) : Colors.black,  // ✅ PINK for countdown
//                       height: 1.1,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
                
//                 const SizedBox(height: 8),
                
//                   Text(
//                     _isRoundRestPhase 
//                         ? 'Round $_currentRound Complete!'  // ✅ SHOW COMPLETION MESSAGE
//                         : exercise.name,
//                     style: GoogleFonts.poppins(
//                       fontSize: _isRoundRestPhase ? 18 : 22,  // ✅ SMALLER for subtitle
//                       fontWeight: FontWeight.w600,
//                       color: _isRoundRestPhase ? Colors.grey[600] : Colors.black,  // ✅ GREY for subtitle
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
                
//                 const SizedBox(height: 4),
                
//                 Text(
//                   _currentPhase == 'warmup' 
//                       ? 'WARM UP • EXERCISE ${_currentExerciseIndex + 1}/${_warmupExercises.length}'
//                       : _currentPhase == 'main'
//                           ? 'ROUND $_currentRound/$_totalRounds • EXERCISE ${_currentExerciseIndex + 1}/${_mainExercises.length}'
//                           : 'COOL DOWN • EXERCISE ${_currentExerciseIndex + 1}/${_cooldownExercises.length}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF757575),
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           _buildThickControlBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildThickControlBar() {
//   final progress = _getCurrentProgress();
  
//   // ✅ DIFFERENT UI FOR ROUND REST
//   if (_isRoundRestPhase) {
//     return Container(
//       height: 56,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//       child: Row(
//         children: [
//           // +30s Button
//           Expanded(
//             child: ElevatedButton(
//               onPressed: _extendRestTime,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey[300],
//                 foregroundColor: Colors.black87,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.add, size: 20),
//                   const SizedBox(width: 4),
//                   Text(
//                     '30s',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           const SizedBox(width: 12),
          
//           // Skip Button
//           Expanded(
//             child: ElevatedButton(
//               onPressed: _skipRoundRest,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFE91E63),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//               ),
//               child: Text(
//                 'Skip',
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // ✅ NORMAL CONTROL BAR FOR EXERCISE/GET READY
//   return Container(
//     height: 56,
//     margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(28),
//       child: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 56,
//             color: const Color(0xFFE0E0E0),
//           ),
          
//           TweenAnimationBuilder<double>(
//             duration: const Duration(milliseconds: 100),
//             curve: Curves.linear,
//             tween: Tween<double>(
//               begin: 0,
//               end: progress.clamp(0.0, 1.0),
//             ),
//             builder: (context, value, child) {
//               return FractionallySizedBox(
//                 widthFactor: value,
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   height: 56,
//                   color: const Color(0xFFE91E63),
//                 ),
//               );
//             },
//           ),
          
//           Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: _goToPrevious,
//                     borderRadius: const BorderRadius.horizontal(
//                       left: Radius.circular(28),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: const Icon(
//                         Icons.skip_previous_rounded,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//               Expanded(
//                 flex: 4,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: _togglePause,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Icon(
//                         _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//               Expanded(
//                 flex: 3,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: _goToNext,
//                     borderRadius: const BorderRadius.horizontal(
//                       right: Radius.circular(28),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: const Icon(
//                         Icons.skip_next_rounded,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );

//   Widget _buildCircularProgress(WorkoutExercise exercise) {
//     final progress = _getCurrentProgress();
    
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 120,
//           height: 120,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CustomPaint(
//                 size: const Size(120, 120),
//                 painter: _CircularProgressPainter(
//                   progress: 1.0,
//                   color: const Color(0xFFE0E0E0),
//                   strokeWidth: 10,
//                 ),
//               ),
              
//               CustomPaint(
//                 size: const Size(120, 120),
//                 painter: _CircularProgressPainter(
//                   progress: progress,
//                   color: const Color(0xFFE91E63),
//                   strokeWidth: 10,
//                 ),
//               ),
              
//               GestureDetector(
//                 onTap: _togglePause,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                     color: Colors.grey[700],
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         const SizedBox(height: 16),
        
//         Text(
//           exercise.name,
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
        
//         const SizedBox(height: 4),
        
//         Text(
//           _currentPhase == 'warmup' 
//               ? 'WARM UP • EXERCISE ${_currentExerciseIndex + 1}/${_warmupExercises.length}'
//               : _currentPhase == 'main'
//                   ? 'ROUND $_currentRound/$_totalRounds • EXERCISE ${_currentExerciseIndex + 1}/${_mainExercises.length}'
//                   : 'COOL DOWN • EXERCISE ${_currentExerciseIndex + 1}/${_cooldownExercises.length}',
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildLandscapeBottomControls() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _goToPrevious,
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.chevron_left,
//                   size: 32,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
          
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _goToNext,
//               borderRadius: BorderRadius.circular(24),
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.chevron_right,
//                   size: 32,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showExitDialog() {
//     setState(() {
//       _isPaused = true;
//     });
//     _audioController.setWorkoutPaused(true);
    
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: '',
//       barrierColor: Colors.transparent,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return Container();
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         final blurAnimation = Tween<double>(begin: 0, end: 5).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOut),
//         );
        
//         final scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
//         );
        
//         final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//           CurvedAnimation(parent: animation, curve: Curves.easeOut),
//         );
        
//         return Stack(
//           children: [
//             BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: blurAnimation.value,
//                 sigmaY: blurAnimation.value,
//               ),
//               child: Container(
//                 color: Colors.white.withOpacity(0.2),
//               ),
//             ),
            
//             Center(
//               child: FadeTransition(
//                 opacity: fadeAnimation,
//                 child: ScaleTransition(
//                   scale: scaleAnimation,
//                   child: _buildPauseDialogContent(),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildPauseDialogContent() {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     final remainingExercises = _exercises.length - _currentExerciseIndex;
    
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 30,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 48),
          
//           TweenAnimationBuilder<double>(
//             key: ValueKey('fire_pulse_${DateTime.now().millisecondsSinceEpoch}'),
//             duration: const Duration(milliseconds: 1200),
//             tween: Tween(begin: 0.95, end: 1.05),
//             curve: Curves.easeInOut,
//             builder: (context, scale, child) {
//               return Transform.scale(
//                 scale: scale,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFEBEE),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFE91E63).withOpacity(0.2),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: const Center(
//                     child: Text(
//                       '🔥',
//                       style: TextStyle(
//                         fontSize: 48,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             onEnd: () {
//               if (mounted) {
//                 setState(() {});
//               }
//             },
//           ),
          
//           const SizedBox(height: 28),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Hang in There!\nYou got this!',
//               style: GoogleFonts.poppins(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.black,
//                 height: 1.3,
//                 decoration: TextDecoration.none,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
          
//           const SizedBox(height: 12),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'There\'re only $remainingExercises actions left',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF757575),
//                 height: 1.4,
//                 decoration: TextDecoration.none,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
          
//           const SizedBox(height: 40),
          
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     _isPaused = false;
//                   });
//                   _audioController.setWorkoutPaused(false);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                 ),
//                 child: Text(
//                   'Keep Exercising',
//                   style: GoogleFonts.poppins(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.3,
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           TextButton(
//             onPressed: () {
//               _timer?.cancel();
//               _audioController.stopBackgroundMusic();
//               Navigator.pop(context);
              
//               _showPartialWorkoutCompleteDialog();
//             },
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               overlayColor: Colors.transparent,
//               foregroundColor: const Color(0xFF757575),
//             ),
//             child: Text(
//               'Finish workout',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF757575),
//                 letterSpacing: 0.2,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 28),
//         ],
//       ),
//     );
//   }
 

//   void _showPartialWorkoutCompleteDialog() async {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
    
//     final completedExercises = _isGetReadyPhase 
//         ? _currentExerciseIndex 
//         : _currentExerciseIndex + 1;
    
//     // Calculate partial workout time (with progressive duration)
//     int partialExerciseTime = 0;
//     for (int i = 0; i < completedExercises && i < _exercises.length; i++) {
//       partialExerciseTime += _getExerciseDuration(_exercises[i].duration);
//     }

//     // Add rest time if multiple rounds were attempted
//     int partialRestTime = (_currentRound > 1) ? (_currentRound - 1) * 60 : 0;

//     final totalMinutes = (partialExerciseTime + partialRestTime) ~/ 60;
//     final totalActions = completedExercises;

//     // Calculate proportional calories using actual elapsed time
//     final actualTotalMinutes = _calculateActualDuration();
//     final actualTotalCalories = _calculateActualCalories(actualTotalMinutes);
//     final totalCalories = actualTotalMinutes > 0 
//         ? ((actualTotalCalories * totalMinutes) / actualTotalMinutes).round()
//         : totalMinutes * 6;
    
//     // ✅ Navigate directly to WorkoutCompleteScreen with partial flag
//     // The controller.completeWorkout() will be called from there with isFullCompletion: false
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WorkoutCompleteScreen(
//           dayNumber: widget.dayNumber,
//           totalCalories: totalCalories,
//           totalMinutes: totalMinutes,
//           totalActions: totalActions,
//           workoutName: 'Day ${widget.dayNumber} Workout (Incomplete)',
//           earnedAchievement: null,
//           isPartialWorkout: true,
//           exercises: widget.exercises,
//         ),
//       ),
//     );
//   }

//   void _showWorkoutCompleteDialog() async {
//     _timer?.cancel();
    
//     // ✅ STOP ALL AUDIO BEFORE NAVIGATING
//     await _audioController.stopBackgroundMusic();
//     _audioController.stopCurrentSpeech(); // Stop any ongoing speech
//     _audioController.setWorkoutPaused(false);
    
//     // Small delay to ensure audio is fully stopped
//     await Future.delayed(const Duration(milliseconds: 100));
    
//     // ✅ Use accurate calculation
//     final totalMinutes = _calculateActualDuration();
//     final totalCalories = _calculateActualCalories(totalMinutes);
//     final totalActions = _exercises.length * _totalRounds;

//     // ✅ Navigate directly to WorkoutCompleteScreen
//     // The controller.completeWorkout() will be called from there
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WorkoutCompleteScreen(
//           dayNumber: widget.dayNumber,
//           totalCalories: totalCalories,
//           totalMinutes: totalMinutes,
//           totalActions: totalActions,
//           workoutName: 'Day ${widget.dayNumber} Workout',
//           earnedAchievement: null, // Will be determined by controller
//           isPartialWorkout: false,
//           exercises: widget.exercises,
//         ),
//       ),
//     );
//   }
// }

// class _CircularProgressPainter extends CustomPainter {
//   final double progress;
//   final Color color;
//   final double strokeWidth;

//   _CircularProgressPainter({
//     required this.progress,
//     required this.color,
//     required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;

//     const startAngle = -math.pi / 2;
//     final sweepAngle = 2 * math.pi * progress;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
//       oldDelegate.progress != progress;
// }
