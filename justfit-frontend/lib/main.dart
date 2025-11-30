import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'get_it.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';
import 'controllers/workout_plan_controller.dart'; // ← NEW LINE
import 'core/services/firestore_service.dart';
// import 'data/seed/seed_discovery_workouts.dart';  // ✅ CORRECT PATH
import 'core/services/discovery_workout_service.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized successfully');

  // // 🔥 CLEAR AND RE-SEED (DELETE AFTER USE!)
  // await SeedDiscoveryWorkouts.clearAll();
  // await SeedDiscoveryWorkouts.seedAll();


  // Initialize Services (GetX)
  Get.put(AuthService(), permanent: true);
  Get.put(UserService(), permanent: true);
  Get.put(FirestoreService(), permanent: true);
  Get.put(WorkoutPlanController(), permanent: true); // ← NEW LINE
  Get.put(DiscoveryWorkoutService(), permanent: true); // ✅ ADD THIS LINE
  
  print('✅ Auth Service initialized');
  print('✅ User Service initialized');
  print('✅ Firestore Service initialized');
  print('✅ Workout Plan Controller initialized'); // ← NEW LINE
  print('✅ Discovery Workout Service initialized'); // ✅ ADD THIS LINE


  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JustFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}








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
//   final List<WorkoutExercise> exercises;
//   final int? initialHeartRate;

//   const ActiveWorkoutScreen({
//     Key? key,
//     required this.dayNumber,
//     required this.exercises,
//     this.initialHeartRate,
//   }) : super(key: key);

//   @override
//   State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
// }

// class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
//     with TickerProviderStateMixin {
  
//   // Workout state
//   int _currentExerciseIndex = 0;
//   int _currentSet = 1;
//   int _totalSets = 3;
//   bool _isGetReadyPhase = true;
//   bool _isRestPhase = false;
//   bool _isPaused = false;
//   double _countdown = 10.0;
//   double _exerciseTime = 0.0;
//   double _restTime = 0.0;
//   int _completedExercises = 0;
//   Timer? _timer;
  
//   // UI state
//   bool _isLandscape = false;
  
//   // Animation controllers
//   late AnimationController _countdownScaleController;
//   late AnimationController _countdownFadeController;
//   late AnimationController _pulseController;
  
//   // Audio controller
//   late WorkoutAudioController _audioController;
//   late FirestoreService _firestoreService;

//   @override
//   void initState() {
//     super.initState();

//     // Set total sets from first exercise
//     if (widget.exercises.isNotEmpty && widget.exercises.first.sets != null) {
//       _totalSets = widget.exercises.first.sets!;
//     }

//     // Initialize audio controller
//     if (!Get.isRegistered<WorkoutAudioController>()) {
//       Get.put(WorkoutAudioController());
//     }
//     _audioController = Get.find<WorkoutAudioController>();
//     _firestoreService = Get.find<FirestoreService>();
    
//     _audioController.setWorkoutPaused(false);
    
//     // Start background music
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _audioController.startBackgroundMusic();
//     });
    
//     // Animation controllers
//     _countdownScaleController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
    
//     _countdownFadeController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     )..repeat(reverse: true);
    
//     // Start countdown
//     _startCountdown();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _countdownScaleController.dispose();
//     _countdownFadeController.dispose();
//     _pulseController.dispose();
//     _audioController.stopBackgroundMusic();
//     super.dispose();
//   }

//   void _startCountdown() {
//     _timer?.cancel();
//     _countdown = 10.0;
//     _isGetReadyPhase = true;
//     _isRestPhase = false;
    
//     // Play "Get Ready" audio
//     _audioController.playGetReady(widget.exercises[_currentExerciseIndex].name);
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (!_isPaused) {
//         setState(() {
//           _countdown -= 0.1;
          
//           // Countdown beeps
//           if (_countdown <= 3.0 && _countdown > 2.9) {
//             _audioController.playCountdownBeep();
//           } else if (_countdown <= 2.0 && _countdown > 1.9) {
//             _audioController.playCountdownBeep();
//           } else if (_countdown <= 1.0 && _countdown > 0.9) {
//             _audioController.playCountdownBeep();
//           }
          
//           if (_countdown <= 0) {
//             _isGetReadyPhase = false;
//             _exerciseTime = widget.exercises[_currentExerciseIndex].duration.toDouble();
//             _timer?.cancel();
//             _startExercise();
//           }
//         });
//       }
//     });
//   }

//   void _startExercise() {
//     _timer?.cancel();
    
//     // Play motivational cue based on set number
//     if (_currentSet == 1) {
//       _audioController.playMotivation("Let's go! Set 1!");
//     } else if (_currentSet == _totalSets) {
//       _audioController.playMotivation("Final set! Give it everything!");
//     } else {
//       _audioController.playMotivation("Set $_currentSet! Keep pushing!");
//     }
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (!_isPaused) {
//         setState(() {
//           _exerciseTime -= 0.1;
          
//           // Halfway encouragement
//           if (_exerciseTime <= (widget.exercises[_currentExerciseIndex].duration / 2) && 
//               _exerciseTime > (widget.exercises[_currentExerciseIndex].duration / 2) - 0.2) {
//             _audioController.playMotivation("Halfway there!");
//           }
          
//           // Final countdown
//           if (_exerciseTime <= 3.0 && _exerciseTime > 2.9) {
//             _audioController.playCountdownBeep();
//           } else if (_exerciseTime <= 2.0 && _exerciseTime > 1.9) {
//             _audioController.playCountdownBeep();
//           } else if (_exerciseTime <= 1.0 && _exerciseTime > 0.9) {
//             _audioController.playCountdownBeep();
//           }
          
//           if (_exerciseTime <= 0) {
//             _timer?.cancel();
//             _onExerciseComplete();
//           }
//         });
//       }
//     });
//   }

//   void _onExerciseComplete() {
//     // Check if we need to do more sets
//     if (_currentSet < _totalSets) {
//       // Start rest period
//       _startRestPeriod();
//     } else {
//       // Move to next exercise or complete workout
//       _completedExercises++;
      
//       if (_currentExerciseIndex < widget.exercises.length - 1) {
//         // Move to next exercise
//         _currentExerciseIndex++;
//         _currentSet = 1;
//         _startCountdown();
//       } else {
//         // Workout complete!
//         _showWorkoutCompleteDialog();
//       }
//     }
//   }

//   void _startRestPeriod() {
//     _timer?.cancel();
//     _isRestPhase = true;
    
//     // Get rest time for current exercise
//     _restTime = (widget.exercises[_currentExerciseIndex].rest ?? 60).toDouble();
    
//     // Play rest audio
//     _audioController.playMotivation("Rest! Take a breather.");
    
//     _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (!_isPaused) {
//         setState(() {
//           _restTime -= 0.1;
          
//           // 10 second warning
//           if (_restTime <= 10.0 && _restTime > 9.9) {
//             _audioController.playMotivation("10 seconds left!");
//           }
          
//           // Final countdown
//           if (_restTime <= 3.0 && _restTime > 2.9) {
//             _audioController.playCountdownBeep();
//           } else if (_restTime <= 2.0 && _restTime > 1.9) {
//             _audioController.playCountdownBeep();
//           } else if (_restTime <= 1.0 && _restTime > 0.9) {
//             _audioController.playCountdownBeep();
//           }
          
//           if (_restTime <= 0) {
//             _timer?.cancel();
//             _currentSet++;
//             _isRestPhase = false;
//             _startCountdown();
//           }
//         });
//       }
//     });
//   }

//   void _togglePause() {
//     setState(() {
//       _isPaused = !_isPaused;
//       _audioController.setWorkoutPaused(_isPaused);
      
//       if (_isPaused) {
//         _audioController.pauseBackgroundMusic();
//         _showPauseDialog();
//       } else {
//         _audioController.resumeBackgroundMusic();
//       }
//     });
//   }

//   void _showPauseDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => _buildPauseDialog(context),
//     );
//   }

//   Widget _buildPauseDialog(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Pulsing fire emoji
//             AnimatedBuilder(
//               animation: _pulseController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: 1.0 + (_pulseController.value * 0.1),
//                   child: const Text(
//                     '🔥',
//                     style: TextStyle(fontSize: 64, decoration: TextDecoration.none),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Workout Paused',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Take a break, but don't give up!",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       setState(() => _isPaused = false);
//                       _audioController.resumeBackgroundMusic();
//                     },
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         side: const BorderSide(color: Color(0xFFE91E63)),
//                       ),
//                     ),
//                     child: Text(
//                       'Resume',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFFE91E63),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _showQuitConfirmation();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFE91E63),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'Quit',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
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

//   void _showQuitConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Quit Workout?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
//         content: Text(
//           'Are you sure you want to quit? Your progress will not be saved.',
//           style: GoogleFonts.poppins(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() => _isPaused = false);
//               _audioController.resumeBackgroundMusic();
//             },
//             child: Text('Cancel', style: GoogleFonts.poppins()),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Quit', style: GoogleFonts.poppins(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//   void _showWorkoutCompleteDialog() async {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
    
//     // Calculate total minutes
//     final totalMinutes = widget.exercises.fold<int>(
//       0, (sum, e) => sum + ((e.duration * (e.sets ?? 1)) ~/ 60)
//     );
    
//     // Play completion audio (no parameters version)
//     // _audioController.playWorkoutComplete(totalMinutes, 250, widget.exercises.length);

//     // Save workout completion to Firestore
//     // Save workout completion to Firestore
//     final userService = Get.find<UserService>();
//     final userId = userService.currentUser.value?.uid;
//     final workoutPlanController = Get.find<WorkoutPlanController>();
//     final planId = workoutPlanController.currentPlan.value?.planId ?? '';

//     if (userId != null && planId.isNotEmpty) {
//       await _firestoreService.saveWorkoutCompletion(
//         userId: userId,
//         workoutId: '${planId}_day_${widget.dayNumber}',
//         planId: planId,
//         day: widget.dayNumber,
//         date: DateTime.now().toIso8601String().split('T')[0],
//         duration: totalMinutes,
//         calories: 250,
//         exercisesCompleted: widget.exercises.map((e) => e.name).toList(),
//         isComplete: true,
//       );
//     }

//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WorkoutCompleteScreen(
//             dayNumber: widget.dayNumber,
//             totalCalories: 250,
//             totalMinutes: totalMinutes,
//             totalActions: widget.exercises.length,
//           ),
//         ),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _togglePause();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               // Main content
//               Column(
//                 children: [
//                   _buildHeader(),
//                   Expanded(
//                     child: _buildWorkoutContent(),
//                   ),
//                   _buildBottomControls(),
//                 ],
//               ),
              
//               // Pause overlay
//               if (_isPaused)
//                 Container(
//                   color: Colors.black.withOpacity(0.7),
//                   child: Center(
//                     child: Text(
//                       'PAUSED',
//                       style: GoogleFonts.poppins(
//                         fontSize: 48,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     final progress = (_currentExerciseIndex + (_currentSet / _totalSets)) / widget.exercises.length;
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white, size: 28),
//                 onPressed: _togglePause,
//               ),
//               Text(
//                 'Day ${widget.dayNumber}',
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.music_note, color: Colors.white, size: 28),
//                 onPressed: () {
//                   MusicBottomSheet.show(context);
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Progress bar
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: progress,
//               minHeight: 8,
//               backgroundColor: Colors.grey[800],
//               valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Exercise ${_currentExerciseIndex + 1}/${widget.exercises.length} • Set $_currentSet/$_totalSets',
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey[400],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkoutContent() {
//     if (_isGetReadyPhase) {
//       return _buildGetReadyPhase();
//     } else if (_isRestPhase) {
//       return _buildRestPhase();
//     } else {
//       return _buildExercisePhase();
//     }
//   }

//   Widget _buildGetReadyPhase() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'GET READY',
//             style: GoogleFonts.poppins(
//               fontSize: 32,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               letterSpacing: 2,
//             ),
//           ),
//           const SizedBox(height: 32),
//           Text(
//             widget.exercises[_currentExerciseIndex].name.toUpperCase(),
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFFE91E63),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Set $_currentSet/$_totalSets • ${widget.exercises[_currentExerciseIndex].reps ?? 12} reps',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 64),
//           _buildCountdownCircle(_countdown),
//         ],
//       ),
//     );
//   }

//   Widget _buildRestPhase() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.spa,
//             size: 80,
//             color: Color(0xFF4CAF50),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'REST',
//             style: GoogleFonts.poppins(
//               fontSize: 32,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               letterSpacing: 2,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Take a breather!',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 64),
//           _buildCountdownCircle(_restTime),
//           const SizedBox(height: 32),
//           Text(
//             'Next: Set ${_currentSet + 1}/$_totalSets',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExercisePhase() {
//     final exercise = widget.exercises[_currentExerciseIndex];
    
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             exercise.name.toUpperCase(),
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 28,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               letterSpacing: 1,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Set $_currentSet/$_totalSets • ${exercise.reps ?? 12} reps',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               color: const Color(0xFFE91E63),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 64),
//           _buildCountdownCircle(_exerciseTime),
//           const SizedBox(height: 48),
//           // Exercise illustration placeholder
//           Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(
//               Icons.fitness_center,
//               size: 80,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCountdownCircle(double time) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         SizedBox(
//           width: 200,
//           height: 200,
//           child: CircularProgressIndicator(
//             value: _isGetReadyPhase 
//               ? (_countdown / 10.0)
//               : _isRestPhase
//                 ? (_restTime / (widget.exercises[_currentExerciseIndex].rest ?? 60))
//                 : (_exerciseTime / widget.exercises[_currentExerciseIndex].duration),
//             strokeWidth: 12,
//             backgroundColor: Colors.grey[800],
//             valueColor: AlwaysStoppedAnimation<Color>(
//               _isRestPhase ? const Color(0xFF4CAF50) : const Color(0xFFE91E63),
//             ),
//           ),
//         ),
//         Text(
//           time.toStringAsFixed(0),
//           style: GoogleFonts.poppins(
//             fontSize: 72,
//             fontWeight: FontWeight.w900,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomControls() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildControlButton(
//             icon: Icons.skip_previous,
//             label: 'Previous',
//             onPressed: _currentExerciseIndex > 0
//                 ? () {
//                     setState(() {
//                       _currentExerciseIndex--;
//                       _currentSet = 1;
//                       _startCountdown();
//                     });
//                   }
//                 : null,
//           ),
//           _buildControlButton(
//             icon: _isPaused ? Icons.play_arrow : Icons.pause,
//             label: _isPaused ? 'Resume' : 'Pause',
//             onPressed: _togglePause,
//             isPrimary: true,
//           ),
//           _buildControlButton(
//             icon: Icons.skip_next,
//             label: 'Skip',
//             onPressed: () {
//               if (_currentSet < _totalSets) {
//                 setState(() {
//                   _currentSet++;
//                   _startCountdown();
//                 });
//               } else if (_currentExerciseIndex < widget.exercises.length - 1) {
//                 setState(() {
//                   _currentExerciseIndex++;
//                   _currentSet = 1;
//                   _startCountdown();
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback? onPressed,
//     bool isPrimary = false,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 64,
//           height: 64,
//           decoration: BoxDecoration(
//             color: onPressed == null
//                 ? Colors.grey[800]
//                 : isPrimary
//                     ? const Color(0xFFE91E63)
//                     : Colors.grey[900],
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: Icon(
//               icon,
//               color: onPressed == null ? Colors.grey[600] : Colors.white,
//               size: 32,
//             ),
//             onPressed: onPressed,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             color: Colors.grey[400],
//           ),
//         ),
//       ],
//     );
//   }
// }
