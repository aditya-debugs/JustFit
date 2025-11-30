# justfit

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class ActiveWorkoutScreen extends StatefulWidget {
  final int dayNumber;
  final int duration;
  final int calories;
  final int? initialHeartRate;

  const ActiveWorkoutScreen({
    Key? key,
    required this.dayNumber,
    required this.duration,
    required this.calories,
    this.initialHeartRate,
  }) : super(key: key);

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  
  // Workout state
  int _currentExerciseIndex = 0;
  bool _isGetReadyPhase = true;
  bool _isPaused = false;
  double _countdown = 10.0;  // Changed to double
  double _exerciseTime = 0.0;  // Changed to double
  Timer? _timer;
  
  // UI state
  bool _isLandscape = false;
  
  // Animation controllers
  late AnimationController _countdownScaleController;
  late AnimationController _countdownFadeController;
  
  // Sample exercises
  final List<WorkoutExercise> _exercises = [
    WorkoutExercise(name: 'Arm Circles', duration: 30),
    WorkoutExercise(name: 'Jumping Jacks', duration: 45),
    WorkoutExercise(name: 'High Knees', duration: 30),
    WorkoutExercise(name: 'Squats', duration: 40),
    WorkoutExercise(name: 'Lunges', duration: 35),
    WorkoutExercise(name: 'Push-ups', duration: 30),
    WorkoutExercise(name: 'Plank', duration: 45),
    WorkoutExercise(name: 'Mountain Climbers', duration: 30),
    WorkoutExercise(name: 'Burpees', duration: 40),
    WorkoutExercise(name: 'Jumping Lunges', duration: 35),
    WorkoutExercise(name: 'Russian Twists', duration: 30),
    WorkoutExercise(name: 'Bicycle Crunches', duration: 35),
    WorkoutExercise(name: 'Side Plank', duration: 30),
    WorkoutExercise(name: 'Leg Raises', duration: 30),
    WorkoutExercise(name: 'Cool Down Stretch', duration: 45),
  ];

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    _countdownScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _countdownFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _startWorkout();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownScaleController.dispose();
    _countdownFadeController.dispose();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    super.dispose();
  }

  void _startWorkout() {
    _startGetReadyPhase();
  }

  void _startGetReadyPhase() {
    setState(() {
      _isGetReadyPhase = true;
      _countdown = 10.0;
      _isPaused = false;
    });
    
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;
      
      setState(() {
        _countdown -= 0.1;
        
        if (_countdown <= 3 && _countdown > 0 && _countdown % 1 < 0.1) {
          _countdownScaleController.forward(from: 0);
          _countdownFadeController.forward(from: 0);
        }
        
        if (_countdown <= 0) {
          timer.cancel();
          _startExercisePhase();
        }
      });
    });
  }

  void _startExercisePhase() {
    setState(() {
      _isGetReadyPhase = false;
      _exerciseTime = 0.0;
      _isPaused = false;
    });
    
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPaused) return;
      
      setState(() {
        _exerciseTime += 0.1;
        
        final currentExercise = _exercises[_currentExerciseIndex];
        if (_exerciseTime >= currentExercise.duration) {
          timer.cancel();
          _moveToNextExercise();
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _goToPrevious() {
    _timer?.cancel();
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }
    _startGetReadyPhase();
  }

  void _goToNext() {
    _timer?.cancel();
    _moveToNextExercise();
  }

  void _moveToNextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
      _startGetReadyPhase();
    } else {
      _completeWorkout();
    }
  }

  void _completeWorkout() {
    _showWorkoutCompleteDialog();
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
    return (_currentExerciseIndex + 1) / _exercises.length;
  }

  double _getCurrentProgress() {
    if (_isGetReadyPhase) {
      return (10 - _countdown) / 10;
    } else {
      final currentExercise = _exercises[_currentExerciseIndex];
      return _exerciseTime / currentExercise.duration;
    }
  }

  String _getTimerDisplay() {
    if (_isGetReadyPhase) {
      return _countdown.ceil().toString().padLeft(2, '0');
    } else {
      int minutes = _exerciseTime ~/ 60;
      int seconds = _exerciseTime.toInt() % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
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
    );
  }

  Widget _buildPortraitLayout() {
    final currentExercise = _exercises[_currentExerciseIndex];
    
    return Stack(
      children: [
        Column(
          children: [
            // Top progress bar
            _buildTopProgressBar(),
            
            // Top buttons
            _buildTopButtons(),
            
            // Video area
            Expanded(
              child: _buildExerciseArea(),
            ),
            
            // Bottom info and control bar
            _buildBottomSection(currentExercise),
          ],
        ),
        
        // Countdown overlay
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
            // Top progress bar
            _buildTopProgressBar(),
            
            // Main content
            Expanded(
              child: Row(
                children: [
                  // Left side - circular progress
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    padding: const EdgeInsets.all(16),
                    child: _buildCircularProgress(currentExercise),
                  ),
                  
                  // Center - video
                  Expanded(
                    child: _buildExerciseArea(),
                  ),
                  
                  // Right side - timer/get ready text
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
            ),
            
            // Bottom navigation arrows
            _buildLandscapeBottomControls(),
          ],
        ),
        
        // Rotation button
        Positioned(
          top: 16,
          right: 16,
          child: _buildCircularButton(
            icon: Icons.screen_rotation_outlined,
            onPressed: _toggleOrientation,
          ),
        ),
        
        // Countdown overlay
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
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              _buildCircularButton(
                icon: Icons.info_outline,
                onPressed: _showExerciseDetails,
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
      child: Center(
        child: Image.asset(
          'assets/images/exercise_placeholder.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.fitness_center,
              size: 100,
              color: Colors.grey[300],
            );
          },
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
                // Main heading - "Get Ready" or Timer
                Text(
                  _isGetReadyPhase ? 'Get Ready' : _getTimerDisplay(),
                  style: GoogleFonts.poppins(
                    fontSize: _isGetReadyPhase ? 32 : 56,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Exercise name
                Text(
                  exercise.name,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 4),
                
                // Step counter
                Text(
                  'STEP ${_currentExerciseIndex + 1}/${_exercises.length}',
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
          
          // Thick combined control bar
          _buildThickControlBar(),
        ],
      ),
    );
  }

  Widget _buildThickControlBar() {
  final progress = _getCurrentProgress();
  
  return Container(
    height: 56,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // Full gray background (always visible)
          Container(
            width: double.infinity,
            height: 56,
            color: const Color(0xFFE0E0E0),
          ),
          
          // Pink progress overlay (smooth continuous fill)
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
          
          // Interactive button layer (on top, with icons)
          Row(
            children: [
              // Previous button
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
              
              // Pause/Play button
              Expanded(
                flex: 4,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _togglePause,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Next button
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
              // Background circle
              CustomPaint(
                size: const Size(120, 120),
                painter: _CircularProgressPainter(
                  progress: 1.0,
                  color: const Color(0xFFE0E0E0),
                  strokeWidth: 10,
                ),
              ),
              
              // Progress circle
              CustomPaint(
                size: const Size(120, 120),
                painter: _CircularProgressPainter(
                  progress: progress,
                  color: const Color(0xFFE91E63),
                  strokeWidth: 10,
                ),
              ),
              
              // Pause button in center
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
          'STEP ${_currentExerciseIndex + 1}/${_exercises.length}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF757575),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: _goToPrevious,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 32),
            onPressed: _goToNext,
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails() {
    final currentExercise = _exercises[_currentExerciseIndex];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                currentExercise.name,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${currentExercise.duration} seconds',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Instructions:\n\n'
                  '1. Stand with feet shoulder-width apart\n'
                  '2. Keep your core engaged\n'
                  '3. Perform the movement with control\n'
                  '4. Breathe steadily throughout',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'GOT IT',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    _timer?.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Exit Workout?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        content: Text(
          'Are you sure you want to exit?',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_isGetReadyPhase) {
                _startGetReadyPhase();
              } else {
                _startExercisePhase();
              }
            },
            child: Text(
              'CANCEL',
              style: GoogleFonts.poppins(
                color: const Color(0xFF757575),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'EXIT',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE91E63),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'Workout Complete!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Great job!',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'FINISH',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Circular progress painter for landscape mode
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

    const startAngle = -math.pi / 2; // Start from top
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

// Exercise model
class WorkoutExercise {
  final String name;
  final int duration;

  WorkoutExercise({
    required this.name,
    required this.duration,
  });
}