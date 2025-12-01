import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../core/animations/page_transitions.dart';
import 'dart:math' as math;
import '../main_view/widgets/day_detail_sheet.dart';
import '../../data/models/achievement_model.dart';
import '../../controllers/workout_plan_controller.dart';
import 'workout_complete_screen.dart';
import '../../controllers/workout_audio_controller.dart';
import 'music_bottom_sheet.dart';
import '../main_view/screens/activity_screen.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/user_service.dart';
import '../../data/models/workout/workout_exercise.dart';
import '../../../data/models/workout/simple_workout_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/app_config.dart';
import 'package:video_player/video_player.dart';
import 'dart:io' show Platform; // ✅ ADD THIS
import 'package:wakelock_plus/wakelock_plus.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final int dayNumber;
  final List<WorkoutExercise> exercises;
  final int? initialHeartRate;
  final int? estimatedCalories;
  final int? estimatedDuration;
  final String? discoveryWorkoutId; // ✅ NEW - null for plan workouts
  final String? discoveryWorkoutTitle; // ✅ NEW - null for plan workouts
  final String? discoveryCategory; // ✅ NEW - null for plan workouts
  final List<WorkoutSet>? fullWorkoutSets; // ✅ NEW - complete exercise details

  const ActiveWorkoutScreen({
    Key? key,
    required this.dayNumber,
    required this.exercises,
    this.initialHeartRate,
    this.estimatedCalories,
    this.estimatedDuration,
    this.discoveryWorkoutId, // ✅ NEW
    this.discoveryWorkoutTitle, // ✅ NEW
    this.discoveryCategory, // ✅ NEW
    this.fullWorkoutSets, // ✅ NEW
  }) : super(key: key);

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  int _currentRound = 1;
  int _totalRounds = 3;
  String _currentPhase = 'warmup';
  late List<WorkoutExercise> _warmupExercises;
  late List<WorkoutExercise> _mainExercises;
  late List<WorkoutExercise> _cooldownExercises;
  bool _isGetReadyPhase = true;
  bool _isRestPhase = false;
  bool _isRoundRestPhase = false;
  bool _isPaused = false;
  double _countdown = 10.0;
  double _exerciseTime = 0.0;
  double _restTime = 0.0;
  Timer? _timer;

  bool _isLandscape = false;

  late AnimationController _countdownScaleController;
  late AnimationController _countdownFadeController;

  late WorkoutAudioController _audioController;
  late FirestoreService _firestoreService;
  DateTime? _workoutStartTime;
  VideoPlayerController? _videoController;
  VideoPlayerController? _nextVideoController; // Pre-load next video
  int _currentVideoIndex = 0; // 0, 1, or 2 for rotating videos
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    _warmupExercises =
        widget.exercises.where((e) => e.setType == 'warmup').toList();
    _mainExercises =
        widget.exercises.where((e) => e.setType == 'main').toList();
    _cooldownExercises =
        widget.exercises.where((e) => e.setType == 'cooldown').toList();

    if (_mainExercises.isNotEmpty) {
      _totalRounds = _mainExercises.first.sets ?? 3;
    }

    print('🔍 Workout Split:');
    print('  Warmup: ${_warmupExercises.length} exercises');
    print(
        '  Main: ${_mainExercises.length} exercises (${_totalRounds} rounds)');
    print('  Cooldown: ${_cooldownExercises.length} exercises');
    print('🔍 All exercises (${widget.exercises.length}):');
    for (var i = 0; i < widget.exercises.length; i++) {
      print(
          '  $i: ${widget.exercises[i].name} - setType: "${widget.exercises[i].setType}"');
    }

    if (!Get.isRegistered<WorkoutAudioController>()) {
      Get.put(WorkoutAudioController());
    }
    _audioController = Get.find<WorkoutAudioController>();
    try {
      final workoutPlanController = Get.find<WorkoutPlanController>();
      if (workoutPlanController.currentPlan.value != null) {
        final currentDay = workoutPlanController.currentPlan.value!
            .getDayByNumber(widget.dayNumber);
        if (currentDay != null) {
          _audioController.setCyclePhase(currentDay.intensity);
        }
      }
    } catch (e) {
      print('⚠️ Could not get cycle phase: $e');
    }

    _firestoreService = Get.find<FirestoreService>();

    _audioController.setWorkoutPaused(false);

    // Keep screen awake during workout
    WakelockPlus.enable();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _countdownScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _countdownFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _initializeVideos(); // ✅ Initialize videos
    _startWorkout();
  }

  // ✅ ADD THIS METHOD after initState (line 138):
  Future<void> _initializeVideos() async {
    try {
      // ✅ CRITICAL: Configure video player to mix with other audio
      // This prevents the video from taking audio focus from background music

      // Initialize first video
      _videoController = VideoPlayerController.asset(
        'assets/workout_jsons/video_1.mp4',
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // ✅ KEY FIX: Allow mixing with background music
          allowBackgroundPlayback: false, // We don't need background playback
        ),
      );

      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!
          .setVolume(0.0); // Mute (video has no audio anyway)
      await _videoController!.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      // Pre-load second video for seamless transition
      _nextVideoController = VideoPlayerController.asset(
        'assets/workout_jsons/video_2.mp4',
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // ✅ KEY FIX: Allow mixing
          allowBackgroundPlayback: false,
        ),
      );
      await _nextVideoController!.initialize();
      await _nextVideoController!.setLooping(true);
      await _nextVideoController!.setVolume(0.0);

      print('✅ Videos initialized with audio mixing enabled');
    } catch (e) {
      print('❌ Error initializing videos: $e');
    }
  }

  // ✅ ADD THIS METHOD to switch videos smoothly:
  Future<void> _switchToNextVideo() async {
    if (_nextVideoController == null || !mounted) return;

    try {
      // Swap controllers
      final oldController = _videoController;
      _videoController = _nextVideoController;

      // Start new video immediately (already configured for mixing)
      await _videoController!.setVolume(0.0);
      await _videoController!.play();

      setState(() {
        _currentVideoIndex = (_currentVideoIndex + 1) % 3; // Rotate 0→1→2→0
      });

      // Dispose old controller and prepare next one
      await oldController?.pause();
      await oldController?.dispose();

      // Pre-load NEXT video in the rotation (looking ahead)
      final nextVideoNumber =
          ((_currentVideoIndex + 1) % 3) + 1; // Next video: 1, 2, or 3
      final nextVideoPath = 'assets/workout_jsons/video_$nextVideoNumber.mp4';

      _nextVideoController = VideoPlayerController.asset(
        nextVideoPath,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // ✅ KEY FIX: Always allow mixing
          allowBackgroundPlayback: false,
        ),
      );
      await _nextVideoController!.initialize();
      await _nextVideoController!.setLooping(true);
      await _nextVideoController!.setVolume(0.0);

      print(
          '✅ Switched to video ${_currentVideoIndex + 1}, pre-loaded video $nextVideoNumber');
    } catch (e) {
      print('❌ Error switching video: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioController.stopBackgroundMusic();
    _audioController.stopCurrentSpeech();
    _audioController.setWorkoutPaused(false);
    _countdownScaleController.dispose();
    _countdownFadeController.dispose();

    _videoController?.pause();
    _videoController?.dispose();
    _nextVideoController?.pause();
    _nextVideoController?.dispose();

    // Allow screen to sleep again
    WakelockPlus.disable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  List<WorkoutExercise> get _currentExerciseList {
    switch (_currentPhase) {
      case 'warmup':
        return _warmupExercises;
      case 'main':
        return _mainExercises;
      case 'cooldown':
        return _cooldownExercises;
      default:
        return [];
    }
  }

  WorkoutExercise get currentExercise =>
      _currentExerciseList[_currentExerciseIndex];

  List<WorkoutExercise> get _exercises => widget.exercises;

  void _startWorkout() {
    if (_exercises.isEmpty) return;

    _workoutStartTime = DateTime.now();

    _audioController.startBackgroundMusic();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _audioController.playGetReadyForExercise(
          _exercises[_currentExerciseIndex].name,
          isFirstExercise: true,
        );
      }
    });

    _startGetReadyPhase();
  }

  void _startGetReadyPhase() {
    setState(() {
      _isGetReadyPhase = true;
      _isRestPhase = false;
      _isRoundRestPhase = false;
      _countdown = 10.0;
      _isPaused = false;
    });

    final isFirstExercise =
        _currentPhase == 'warmup' && _currentExerciseIndex == 0;
    if (!isFirstExercise) {
      final currentExercise = _exercises[_currentExerciseIndex];
      _audioController.playGetReadyForExercise(
        currentExercise.name,
        isFirstExercise: false,
      );
    }

    bool hasCountdownStarted = false;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;

      setState(() {
        _countdown -= 0.1;

        if (_countdown <= 3 && _countdown > 0 && _countdown % 1 < 0.1) {
          _countdownScaleController.forward(from: 0);
          _countdownFadeController.forward(from: 0);
        }

        if (_countdown <= 3.5 && _countdown > 3.4 && !hasCountdownStarted) {
          _audioController.playCountdown321Go();
          hasCountdownStarted = true;
        }

        if (_countdown <= 0) {
          timer.cancel();
          _startExercisePhase();
        }
      });
    });
  }

  void _startExercisePhase() {
    final currentExercise = _exercises[_currentExerciseIndex];
    final adjustedDuration = _getExerciseDuration(currentExercise.duration);

    setState(() {
      _isGetReadyPhase = false;
      _isRestPhase = false;
      _isRoundRestPhase = false;
      _exerciseTime = 0.0;
      _isPaused = false;
    });

    print('🏋️ Starting exercise: ${currentExercise.name}');
    print(
        '  Base Duration: ${currentExercise.duration}s, Adjusted for Round $_currentRound: ${adjustedDuration}s');

    final shouldPlayMotivation =
        (_currentExerciseIndex + _currentRound) % 2 == 0;

    if (shouldPlayMotivation) {
      final midpoint = adjustedDuration / 2;
      Future.delayed(Duration(milliseconds: (midpoint * 1000).toInt()), () {
        if (mounted && !_isPaused && !_isGetReadyPhase && !_isRestPhase) {
          _audioController.playRandomMotivation();
        }
      });
    }

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;

      setState(() {
        _exerciseTime += 0.1;

        final duration = adjustedDuration.toDouble();

        if (_exerciseTime >= duration) {
          timer.cancel();
          _onExerciseComplete();
        }
      });
    });
  }

  void _onExerciseComplete() {
    print('🔍 Exercise Complete!');
    print('  Current Phase: $_currentPhase');
    print(
        '  Current Exercise Index: $_currentExerciseIndex / ${_currentExerciseList.length - 1}');

    if (_currentPhase == 'main') {
      print('  Current Round: $_currentRound / $_totalRounds');
    }

    if (_currentExerciseIndex < _currentExerciseList.length - 1) {
      _switchToNextVideo(); // ✅ ADD THIS LINE - Switch video for next exercise
      setState(() {
        _currentExerciseIndex++;
        _isGetReadyPhase = true;
      });
      _startGetReadyPhase();
    } else {
      if (_currentPhase == 'warmup') {
        print('  ✅ Warmup complete! Starting Main Workout Round 1');
        setState(() {
          _currentPhase = 'main';
          _currentExerciseIndex = 0;
          _currentRound = 1;
          _isGetReadyPhase = true;
        });
        _startGetReadyPhase();
      } else if (_currentPhase == 'main') {
        if (_currentRound < _totalRounds) {
          print('  🔄 Main Round $_currentRound complete! Starting 60s rest');
          _startRoundRestPeriod();
        } else {
          print('  ✅ All main rounds complete! Starting Cooldown');
          setState(() {
            _currentPhase = 'cooldown';
            _currentExerciseIndex = 0;
            _isGetReadyPhase = true;
          });
          _startGetReadyPhase();
        }
      } else if (_currentPhase == 'cooldown') {
        print('  ✅ Cooldown complete! Workout finished!');
        _completeWorkout();
      }
    }
  }

  void _startRoundRestPeriod() {
    setState(() {
      _isRoundRestPhase = true;
      _isRestPhase = false;
      _isGetReadyPhase = false;
      _restTime = 60.0;
      _isPaused = false;
    });

    _audioController.playRestTime(_currentRound);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;

      setState(() {
        _restTime -= 0.1;

        if (_restTime <= 0) {
          timer.cancel();
          setState(() {
            _isRoundRestPhase = false;
            _currentRound++;
            _currentExerciseIndex = 0;
          });
          _startGetReadyPhase();
        }
      });
    });
  }

  void _extendRestTime() {
    setState(() {
      _restTime = math.min(_restTime + 30.0, 120.0);
    });
  }

  void _skipRoundRest() {
    _timer?.cancel();

    _audioController.stopCurrentSpeech();

    setState(() {
      _isRoundRestPhase = false;
      _currentRound++;
      _currentExerciseIndex = 0;
    });
    _startGetReadyPhase();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    _audioController.setWorkoutPaused(_isPaused);

    // ✅ ADD THESE LINES - Sync video with pause state
    if (_isPaused) {
      _videoController?.pause();
    } else {
      _videoController?.play();
    }
  }

  void _goToPrevious() {
    _timer?.cancel();

    _audioController.stopCurrentSpeech();

    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }

    // ✅ Switch to next video when changing exercise
    _switchToNextVideo();

    _startGetReadyPhase();
  }

  void _goToNext() {
    _timer?.cancel();

    _audioController.stopCurrentSpeech();

    // ✅ Switch to next video when changing exercise
    _switchToNextVideo();

    _moveToNextExercise();
  }

  void _moveToNextExercise() {
    print('🔍 Skip button pressed - Moving to next exercise');
    print('  Current Phase: $_currentPhase');
    print('  Current Round: $_currentRound / $_totalRounds');
    print(
        '  Current Exercise Index: $_currentExerciseIndex / ${_currentExerciseList.length - 1}');

    if (_currentExerciseIndex < _currentExerciseList.length - 1) {
      print('  ⏭️  Skipping to next exercise in same phase');
      setState(() {
        _currentExerciseIndex++;
        _isGetReadyPhase = true;
      });
      _startGetReadyPhase();
    } else {
      print('  ✅ Last exercise in $_currentPhase - transitioning');

      if (_currentPhase == 'warmup') {
        print('  → Starting Main Workout Round 1');
        setState(() {
          _currentPhase = 'main';
          _currentExerciseIndex = 0;
          _currentRound = 1;
          _isGetReadyPhase = true;
        });
        _startGetReadyPhase();
      } else if (_currentPhase == 'main') {
        if (_currentRound < _totalRounds) {
          print('  → Starting round rest');
          _startRoundRestPeriod();
        } else {
          print('  → Starting Cooldown');
          setState(() {
            _currentPhase = 'cooldown';
            _currentExerciseIndex = 0;
            _isGetReadyPhase = true;
          });
          _startGetReadyPhase();
        }
      } else if (_currentPhase == 'cooldown') {
        print('  → Workout Complete!');
        _completeWorkout();
      }
    }
  }

  Future<void> _completeWorkout() async {
    _timer?.cancel();

    // ✅ CRITICAL FIX: Await stopBackgroundMusic before proceeding
    await _audioController.stopBackgroundMusic();

    _showWorkoutCompleteDialog();
  }

  Future<Exercise?> _fetchExerciseDetails(String exerciseName) async {
    try {
      final exerciseId = exerciseName.toLowerCase().replaceAll(' ', '-');

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
            duration: _exercises[_currentExerciseIndex].duration,
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

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
    });

    if (_isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  double _getOverallProgress() {
    int totalSteps = _warmupExercises.length +
        (_mainExercises.length * _totalRounds) +
        _cooldownExercises.length;

    int completedSteps = 0;

    if (_currentPhase == 'warmup') {
      completedSteps = _currentExerciseIndex;
    } else if (_currentPhase == 'main') {
      completedSteps = _warmupExercises.length +
          (_currentRound - 1) * _mainExercises.length +
          _currentExerciseIndex;
    } else if (_currentPhase == 'cooldown') {
      completedSteps = _warmupExercises.length +
          (_mainExercises.length * _totalRounds) +
          _currentExerciseIndex;
    }

    return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
  }

  double _getCurrentProgress() {
    if (_isGetReadyPhase) {
      return (10.0 - _countdown) / 10.0;
    } else if (_isRoundRestPhase) {
      return (60.0 - _restTime) / 60.0;
    } else if (_isRestPhase) {
      final currentExercise = _exercises[_currentExerciseIndex];
      final restDuration = (currentExercise.rest ?? 30).toDouble();
      return (restDuration - _restTime) / restDuration;
    } else {
      final currentExercise = _exercises[_currentExerciseIndex];
      final adjustedDuration = _getExerciseDuration(currentExercise.duration);
      return _exerciseTime / adjustedDuration.toDouble();
    }
  }

  int _getExerciseDuration(int baseDuration, [int? forRound]) {
    // ✅ TEST MODE: Override with quick 5-second exercises
    if (AppConfig.isTestingMode) {
      return AppConfig.testExerciseDuration;
    }

    // ✅ WARMUP & COOLDOWN: Always base - 5 (no round progression)
    if (_currentPhase == 'warmup' || _currentPhase == 'cooldown') {
      return (baseDuration - 5).clamp(5, 999); // Minimum 5 seconds
    }

    // ✅ MAIN WORKOUT: Progressive duration based on round
    int round = forRound ?? _currentRound;

    if (round == 1) {
      return baseDuration;
    } else if (round == 2) {
      return baseDuration + 10;
    } else {
      return baseDuration + 15;
    }
  }

  int _calculateActualDuration() {
    if (_workoutStartTime != null) {
      final elapsed = DateTime.now().difference(_workoutStartTime!);
      return elapsed.inMinutes;
    }

    return 0;
  }

  int _calculateActualCalories(int actualMinutes) {
    if (widget.estimatedDuration != null &&
        widget.estimatedCalories != null &&
        widget.estimatedDuration! > 0) {
      double ratio = actualMinutes / widget.estimatedDuration!;
      return (widget.estimatedCalories! * ratio).round();
    }

    return actualMinutes * 6;
  }

  String _getTimerDisplay() {
    if (_isGetReadyPhase) {
      return _countdown.ceil().toString().padLeft(2, '0');
    } else if (_isRestPhase) {
      return _restTime.ceil().toString().padLeft(2, '0');
    } else if (_isRoundRestPhase) {
      return _restTime.ceil().toString().padLeft(2, '0');
    } else {
      final currentExercise = _exercises[_currentExerciseIndex];
      final adjustedDuration = _getExerciseDuration(currentExercise.duration);
      final remainingTime = adjustedDuration - _exerciseTime;

      final timeToShow = remainingTime > 0 ? remainingTime : 0;

      int minutes = timeToShow ~/ 60;
      int seconds = timeToShow.toInt() % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitDialog();
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: SafeArea(
              child: _isLandscape
                  ? _buildLandscapeLayout()
                  : _buildPortraitLayout(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    final currentExercise = _exercises[_currentExerciseIndex];

    return Stack(
      children: [
        Column(
          children: [
            _buildTopProgressBar(),
            _buildTopButtons(),
            Expanded(
              child: _buildExerciseArea(),
            ),
            _buildBottomSection(currentExercise),
          ],
        ),
        if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
          _buildCountdownOverlay(),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    final currentExercise = _exercises[_currentExerciseIndex];

    return Stack(
      children: [
        Column(
          children: [
            _buildTopProgressBar(),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        padding: const EdgeInsets.all(16),
                        child: _buildCircularProgress(currentExercise),
                      ),
                      Expanded(
                        child: _buildExerciseArea(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Center(
                          child: _isGetReadyPhase
                              ? Text(
                                  'Get Ready',
                                  style: GoogleFonts.poppins(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : _isRestPhase
                                  ? Text(
                                      'Rest',
                                      style: GoogleFonts.poppins(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      _getTimerDisplay(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: _buildLandscapeBottomControls(),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: _buildCircularButton(
            icon: Icons.screen_rotation_outlined,
            onPressed: _toggleOrientation,
          ),
        ),
        if (_isGetReadyPhase && _countdown <= 3 && _countdown > 0)
          _buildCountdownOverlay(),
      ],
    );
  }

  Widget _buildTopProgressBar() {
    return Container(
      height: 4,
      child: Row(
        children: List.generate(_exercises.length, (index) {
          bool isCompleted = index < _currentExerciseIndex;
          bool isCurrent = index == _currentExerciseIndex;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFE91E63)
                    : isCurrent
                        ? const Color(0xFFE91E63).withOpacity(0.5)
                        : const Color(0xFFE0E0E0),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCircularButton(
            icon: Icons.chevron_left,
            onPressed: _showExitDialog,
          ),
          const Spacer(),
          Column(
            children: [
              _buildCircularButton(
                icon: Icons.screen_rotation_outlined,
                onPressed: _toggleOrientation,
              ),
              const SizedBox(height: 12),
              _buildCircularButton(
                icon: Icons.music_note,
                onPressed: () {
                  MusicBottomSheet.show(context);
                },
              ),
              const SizedBox(height: 12),
              _buildCircularButton(
                icon: Icons.info_outline,
                onPressed: () async {
                  setState(() {
                    _isPaused = true;
                  });
                  _videoController?.pause(); // ✅ ADD THIS LINE
                  _audioController.setWorkoutPaused(true);

                  final exercise = currentExercise;
                  Exercise? exerciseDetails;

                  // ✅ For discovery workouts with full details, use them directly (INSTANT)
                  if (widget.fullWorkoutSets != null) {
                    for (var set in widget.fullWorkoutSets!) {
                      for (var ex in set.exercises) {
                        if (ex.name == exercise.name) {
                          exerciseDetails = ex;
                          print('✅ Using cached exercise details (instant)');
                          break;
                        }
                      }
                      if (exerciseDetails != null) break;
                    }
                  }

                  // Fallback: fetch from API if not found (for plan workouts)
                  if (exerciseDetails == null) {
                    print('📡 Fetching from API...');
                    exerciseDetails =
                        await _fetchExerciseDetails(exercise.name);
                  }

                  if (context.mounted) {
                    await ExerciseDetailSheet.show(
                      context,
                      exercise: exerciseDetails ??
                          Exercise(
                            name: exercise.name,
                            duration: exercise.duration,
                            actionSteps: ['Exercise details not available'],
                          ),
                    );
                  }

                  setState(() {
                    _isPaused = false;
                  });
                  _videoController?.play(); // ✅ ADD THIS LINE
                  _audioController.setWorkoutPaused(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseArea() {
    return Container(
      color: Colors.white,
      child: _isVideoInitialized && _videoController != null
          ? Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          : Center(
              child: Icon(
                Icons.fitness_center,
                size: 100,
                color: Colors.grey[300],
              ),
            ),
    );
  }

  Widget _buildCountdownOverlay() {
    int displayNumber = _countdown.ceil();
    String displayText = displayNumber > 0 ? '$displayNumber' : 'GO!';

    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.2).animate(
            CurvedAnimation(
              parent: _countdownScaleController,
              curve: Curves.elasticOut,
            ),
          ),
          child: Text(
            displayText,
            style: GoogleFonts.poppins(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(WorkoutExercise exercise) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              children: [
                Text(
                  _isGetReadyPhase
                      ? 'Get Ready'
                      : _isRoundRestPhase
                          ? '${_restTime.ceil()}'
                          : _isRestPhase
                              ? 'Rest'
                              : _getTimerDisplay(),
                  style: GoogleFonts.poppins(
                    fontSize: _isGetReadyPhase || _isRestPhase
                        ? 32
                        : _isRoundRestPhase
                            ? 72
                            : 56,
                    fontWeight: FontWeight.w800,
                    color: _isRoundRestPhase
                        ? const Color(0xFFE91E63)
                        : Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isRoundRestPhase
                      ? 'Round $_currentRound Complete!'
                      : exercise.name,
                  style: GoogleFonts.poppins(
                    fontSize: _isRoundRestPhase ? 18 : 22,
                    fontWeight: FontWeight.w600,
                    color: _isRoundRestPhase ? Colors.grey[600] : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  _currentPhase == 'warmup'
                      ? 'WARM UP • EXERCISE ${_currentExerciseIndex + 1}/${_warmupExercises.length}'
                      : _currentPhase == 'main'
                          ? 'ROUND $_currentRound/$_totalRounds • EXERCISE ${_currentExerciseIndex + 1}/${_mainExercises.length}'
                          : 'COOL DOWN • EXERCISE ${_currentExerciseIndex + 1}/${_cooldownExercises.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          _buildThickControlBar(),
        ],
      ),
    );
  }

  Widget _buildThickControlBar() {
    final progress = _getCurrentProgress();

    if (_isRoundRestPhase) {
      return Container(
        height: 56,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _extendRestTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '30s',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _skipRoundRest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 56,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 56,
              color: const Color(0xFFE0E0E0),
            ),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
              tween: Tween<double>(
                begin: 0,
                end: progress.clamp(0.0, 1.0),
              ),
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 56,
                    color: const Color(0xFFE91E63),
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _goToPrevious,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(28),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _togglePause,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          _isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _goToNext,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(28),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(WorkoutExercise exercise) {
    final progress = _getCurrentProgress();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(120, 120),
                painter: _CircularProgressPainter(
                  progress: 1.0,
                  color: const Color(0xFFE0E0E0),
                  strokeWidth: 10,
                ),
              ),
              CustomPaint(
                size: const Size(120, 120),
                painter: _CircularProgressPainter(
                  progress: progress,
                  color: const Color(0xFFE91E63),
                  strokeWidth: 10,
                ),
              ),
              GestureDetector(
                onTap: _togglePause,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          exercise.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _currentPhase == 'warmup'
              ? 'WARM UP • EXERCISE ${_currentExerciseIndex + 1}/${_warmupExercises.length}'
              : _currentPhase == 'main'
                  ? 'ROUND $_currentRound/$_totalRounds • EXERCISE ${_currentExerciseIndex + 1}/${_mainExercises.length}'
                  : 'COOL DOWN • EXERCISE ${_currentExerciseIndex + 1}/${_cooldownExercises.length}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildLandscapeBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _goToPrevious,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  size: 32,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _goToNext,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  size: 32,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    setState(() {
      _isPaused = true;
    });
    _videoController?.pause(); // ✅ ADD THIS LINE
    _audioController.setWorkoutPaused(true);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final blurAnimation = Tween<double>(begin: 0, end: 5).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );

        final scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );

        final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );

        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurAnimation.value,
                sigmaY: blurAnimation.value,
              ),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: _buildPauseDialogContent(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPauseDialogContent() {
    final currentExercise = _exercises[_currentExerciseIndex];
    final remainingExercises = _exercises.length - _currentExerciseIndex;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 48),
          TweenAnimationBuilder<double>(
            key:
                ValueKey('fire_pulse_${DateTime.now().millisecondsSinceEpoch}'),
            duration: const Duration(milliseconds: 1200),
            tween: Tween(begin: 0.95, end: 1.05),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🔥',
                      style: TextStyle(
                        fontSize: 48,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              if (mounted) {
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Hang in There!\nYou got this!',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.3,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'There\'re only $remainingExercises actions left',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF757575),
                height: 1.4,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isPaused = false;
                  });
                  _videoController?.play(); // ✅ ADD THIS LINE
                  _audioController.setWorkoutPaused(false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Keep Exercising',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              _timer?.cancel();

              // Stop background music completely
              await _audioController.stopBackgroundMusic();
              _audioController.stopCurrentSpeech();

              Navigator.pop(context);
              _showPartialWorkoutCompleteDialog();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              overlayColor: Colors.transparent,
              foregroundColor: const Color(0xFF757575),
            ),
            child: Text(
              'Finish workout',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF757575),
                letterSpacing: 0.2,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  void _showPartialWorkoutCompleteDialog() async {
    _timer?.cancel();

    // Stop background music completely before navigating
    await _audioController.stopBackgroundMusic();
    _audioController.stopCurrentSpeech();

    final completedExercises =
        _isGetReadyPhase ? _currentExerciseIndex : _currentExerciseIndex + 1;

    int partialExerciseTime = 0;
    for (int i = 0; i < completedExercises && i < _exercises.length; i++) {
      partialExerciseTime += _getExerciseDuration(_exercises[i].duration);
    }

    int partialRestTime = (_currentRound > 1) ? (_currentRound - 1) * 60 : 0;

    final totalMinutes = (partialExerciseTime + partialRestTime) ~/ 60;
    final totalActions = completedExercises;

    final actualTotalMinutes = _calculateActualDuration();
    final actualTotalCalories = _calculateActualCalories(actualTotalMinutes);
    final totalCalories = actualTotalMinutes > 0
        ? ((actualTotalCalories * totalMinutes) / actualTotalMinutes).round()
        : totalMinutes * 6;

    Navigator.pushReplacement(
      context,
      PageTransitions.fade(
        WorkoutCompleteScreen(
          dayNumber: widget.dayNumber,
          totalCalories: totalCalories,
          totalMinutes: totalMinutes,
          totalActions: totalActions,
          workoutName: widget.dayNumber == 0
              ? (widget.discoveryWorkoutTitle ??
                  'Discovery Workout (Incomplete)')
              : 'Day ${widget.dayNumber} Workout (Incomplete)',
          earnedAchievement: null,
          isPartialWorkout: widget.dayNumber != 0,
          exercises: widget.exercises,
          discoveryWorkoutId: widget.discoveryWorkoutId,
          discoveryWorkoutTitle: widget.discoveryWorkoutTitle,
          discoveryCategory: widget.discoveryCategory,
          fullWorkoutSets: widget.fullWorkoutSets, // ✅ ADD THIS
        ),
        durationMs: 300,
      ),
    );
  }

  void _showWorkoutCompleteDialog() async {
    _timer?.cancel();

    // Stop background music completely before navigating
    await _audioController.stopBackgroundMusic();
    _audioController.stopCurrentSpeech();
    _audioController.setWorkoutPaused(false);

    await Future.delayed(const Duration(milliseconds: 100));

    final totalMinutes = _calculateActualDuration();
    final totalCalories = _calculateActualCalories(totalMinutes);
    final totalActions = _exercises.length * _totalRounds;

    // ✅ PRODUCTION CONFIGURATION with test override
    final estimatedMinutes = AppConfig.isTestingMode
        ? AppConfig.minimumWorkoutDuration
        : (widget.estimatedDuration ?? 20);

    final minimumMinutes =
        (estimatedMinutes * AppConfig.qualityThreshold).ceil();

    // For discovery workouts (dayNumber = 0), always treat as quality if any time recorded
    final isQualityWorkout = widget.dayNumber == 0
        ? totalMinutes > 0 // Discovery: just needs some time
        : totalMinutes >= minimumMinutes; // Plan: needs quality threshold

    if (AppConfig.isTestingMode) {
      print('${AppConfig.modeLabel} - Workout check bypassed');
    }

    print('⏱️ Workout duration check:');
    print('   Estimated: $estimatedMinutes min');
    print('   Actual: $totalMinutes min');
    print('   Minimum required: $minimumMinutes min');
    print('   Quality workout: $isQualityWorkout');

    Navigator.pushReplacement(
      context,
      PageTransitions.scale(
        WorkoutCompleteScreen(
          dayNumber: widget.dayNumber,
          totalCalories: totalCalories,
          totalMinutes: totalMinutes,
          totalActions: totalActions,
          workoutName: widget.dayNumber == 0
              ? (widget.discoveryWorkoutTitle ?? 'Discovery Workout')
              : 'Day ${widget.dayNumber} Workout',
          earnedAchievement: null,
          isPartialWorkout: !isQualityWorkout,
          exercises: widget.exercises,
          discoveryWorkoutId: widget.discoveryWorkoutId,
          discoveryWorkoutTitle: widget.discoveryWorkoutTitle,
          discoveryCategory: widget.discoveryCategory,
          fullWorkoutSets: widget.fullWorkoutSets, // ✅ ADD THIS
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
