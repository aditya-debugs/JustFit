import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'core/services/storage_service.dart';
import 'core/services/discovery_workout_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  final logger = Logger();

  try {
    // ====================
    // 1. CORE SERVICES
    // ====================

    getIt.registerLazySingleton<StorageService>(() => StorageService());
    getIt.registerLazySingleton<DiscoveryWorkoutService>(() => DiscoveryWorkoutService()); // ✅ ADD THIS

    // ====================
    // 2. INITIALIZE SERVICES (Order Matters!)
    // ====================

    await getIt<StorageService>().init();

    logger.i('✅ Dependency injection setup complete');
  } catch (e) {
    logger.e('❌ Dependency injection setup failed: $e');
    rethrow;
  }
}


//active workout


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
  
//   int _currentExerciseIndex = 0;
//   int _currentSet = 1;
//   int _totalSets = 3;
//   bool _isGetReadyPhase = true;
//   bool _isRestPhase = false;
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

//   @override
//   void initState() {
//     super.initState();

//     if (widget.exercises.isNotEmpty) {
//       _totalSets = widget.exercises.first.sets ?? 3; // ✅ FIXED: Added ?? 3
//     }

//     if (!Get.isRegistered<WorkoutAudioController>()) {
//       Get.put(WorkoutAudioController());
//     }
//     _audioController = Get.find<WorkoutAudioController>();

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

//   List<WorkoutExercise> get _exercises => widget.exercises.isNotEmpty 
//       ? widget.exercises 
//       : [WorkoutExercise(name: 'Sample Exercise', duration: 30, sets: 3, reps: 12, rest: 30)];


//   void _startWorkout() {
//     if (_exercises.isEmpty) return;
    
//     // ✅ START MUSIC WITH "GET READY" MESSAGE
//     _audioController.startBackgroundMusic();
//     _audioController.playGetReady(_exercises[_currentExerciseIndex].name);
    
//     _startGetReadyPhase();
//   }

//   void _startGetReadyPhase() {
//     setState(() {
//       _isGetReadyPhase = true;
//       _isRestPhase = false;
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
//           _audioController.playCountdownBeep(); // ✅ FIXED: Changed method name
//           has3Announced = true;
//         }
        
//         if (_countdown <= 2.0 && _countdown > 1.9 && !has2Announced) {
//           _audioController.playCountdownBeep(); // ✅ FIXED: Changed method name
//           has2Announced = true;
//         }
        
//         if (_countdown <= 1.0 && _countdown > 0.9 && !has1Announced) {
//           _audioController.playCountdownBeep(); // ✅ FIXED: Changed method name
//           has1Announced = true;
//         }
      
//         if (_countdown <= 0.1 && _countdown > 0.0 && !hasGoAnnounced) {
//           _audioController.playCountdown321Go(); // ✅ FIXED: Changed method name
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
//       _isRestPhase = false;
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
//           _audioController.playMotivation("Halfway there!"); // ✅ FIXED: Changed method name
//           halfwayAnnounced = true;
//         }
        
//         if (_exerciseTime >= duration - 10 && _exerciseTime < duration - 9.8 && !tenSecondsAnnounced) {
//           _audioController.playMotivation("10 seconds left!"); // ✅ FIXED: Changed method name
//           tenSecondsAnnounced = true;
//         }
        
//         if (_exerciseTime >= duration) {
//           timer.cancel();
//           _onExerciseComplete();
//         }
//       });
//     });
//   }

//   void _onExerciseComplete() {
//     if (_currentSet < _totalSets) {
//       _currentSet++;
//       _startRestPeriod();
//     } else {
//       _currentSet = 1;
//       _moveToNextExercise();
//     }
//   }

//   void _startRestPeriod() {
//   final currentExercise = _exercises[_currentExerciseIndex];
  
//   setState(() {
//     _isRestPhase = true;
//     _isGetReadyPhase = false;
//     _restTime = (currentExercise.rest ?? 30).toDouble();
//     _isPaused = false;
//   });
  
//   // ✅ ADD REST TIME AUDIO MESSAGE
//   _audioController.playRestTime(_restTime.toInt());
  
//   bool hasAlmostOverAnnounced = false;
  
//   _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//     if (_isPaused) return;
    
//     setState(() {
//       _restTime -= 0.1;
      
//       // ✅ ADD "REST ALMOST OVER" MESSAGE AT 5 SECONDS
//       if (_restTime <= 5.0 && _restTime > 4.9 && !hasAlmostOverAnnounced) {
//         _audioController.playRestAlmostOver();
//         hasAlmostOverAnnounced = true;
//       }
      
//       if (_restTime <= 0) {
//         timer.cancel();
//         _startGetReadyPhase();
//       }
//     });
//   });
// }

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
//         _currentSet = 1;
//       });
//       _audioController.playGetReady(_exercises[_currentExerciseIndex].name); // ✅ FIXED: Changed method name
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
//         _currentSet = 1;
//         if (_exercises.isNotEmpty) {
//           _totalSets = _exercises[_currentExerciseIndex].sets ?? 3; // ✅ FIXED: Added ?? 3
//         }
//       });
//       _audioController.playMotivation("Next exercise: ${_exercises[_currentExerciseIndex].name}"); // ✅ FIXED: Changed method
//       _startGetReadyPhase();
//     } else {
//       _completeWorkout();
//     }
//   }

//   void _completeWorkout() {
//     _audioController.playWorkoutComplete(10, 250, _exercises.length); // ✅ FIXED: Changed method name
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
//     final totalSteps = _exercises.fold<int>(0, (sum, e) => sum + (e.sets ?? 3)); // ✅ FIXED: Added ?? 3
//     final currentStep = _exercises.take(_currentExerciseIndex).fold<int>(0, (sum, e) => sum + (e.sets ?? 3)) + _currentSet; // ✅ FIXED: Added ?? 3
//     return currentStep / totalSteps;
//   }

// double _getCurrentProgress() {
//   if (_isGetReadyPhase) {
//     return (10 - _countdown) / 10;
//   } else if (_isRestPhase) {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     return ((currentExercise.rest ?? 30) - _restTime) / (currentExercise.rest ?? 30); // ✅ FIXED
//   } else {
//     final currentExercise = _exercises[_currentExerciseIndex];
//     return _exerciseTime / currentExercise.duration;
//   }
// }

//   String _getTimerDisplay() {
//     if (_isGetReadyPhase) {
//       return _countdown.ceil().toString().padLeft(2, '0');
//     } else if (_isRestPhase) {
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
//                       : _isRestPhase
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
//     final totalCalories = (totalMinutes * 5);
    
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
//           exercises: widget.exercises,
//         ),
//       ),
//     );
//   }

//   void _showWorkoutCompleteDialog() async {
//     _timer?.cancel();
//     _audioController.stopBackgroundMusic();
//     _audioController.setWorkoutPaused(false); // ✅ RESET STATE
    
//     final totalMinutes = _exercises.fold<int>(0, (sum, e) => sum + e.duration) ~/ 60;
//     final totalCalories = (totalMinutes * 5);
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