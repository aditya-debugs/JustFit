import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/heart_rate_gauge.dart';
import 'active_workout_screen.dart';
import '../../data/models/workout/workout_exercise.dart';

class HeartRateResultScreen extends StatefulWidget {
  final int heartRate;
  final int dayNumber;
  final int duration;
  final int calories;
  final List<WorkoutExercise> exercises;

  const HeartRateResultScreen({
    Key? key,
    required this.heartRate,
    required this.dayNumber,
    required this.duration,
    required this.calories,
    required this.exercises,
  }) : super(key: key);

  @override
  State<HeartRateResultScreen> createState() => _HeartRateResultScreenState();
}

class _HeartRateResultScreenState extends State<HeartRateResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  HeartRateZone _getZone() {
    if (widget.heartRate < 100) return HeartRateZone.resting;
    if (widget.heartRate < 120) return HeartRateZone.warmUp;
    if (widget.heartRate < 140) return HeartRateZone.fatBurning;
    return HeartRateZone.anaerobic;
  }

  String _getZoneTitle() {
    switch (_getZone()) {
      case HeartRateZone.resting:
        return 'Resting Heart Rate';
      case HeartRateZone.warmUp:
        return 'Warm Up';
      case HeartRateZone.fatBurning:
        return 'Fat Burning';
      case HeartRateZone.anaerobic:
        return 'Anaerobic';
    }
  }

  String _getZoneDescription() {
    switch (_getZone()) {
      case HeartRateZone.resting:
        return "You're not doing any activity. Start a workout and raise you heart rate in the warm up!";
      case HeartRateZone.warmUp:
        return "Great for warming up! Light activity to prepare your body. Increase intensity to reach the fat burning zone!";
      case HeartRateZone.fatBurning:
        return "Perfect zone! Your body is efficiently burning fat. Maintain this pace for optimal results.";
      case HeartRateZone.anaerobic:
        return "High intensity zone! Building power and speed. Great for short bursts, but recover between intervals.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'You are in:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF1744),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _getZoneTitle(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _scaleController,
                  curve: Curves.elasticOut,
                ),
                child: HeartRateGauge(
                  heartRate: widget.heartRate,
                  showZones: true,
                  size: 220,
                ),
              ),
              
              const Spacer(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _getZoneDescription(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF1744),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Start Training',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startTraining() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveWorkoutScreen(
          dayNumber: widget.dayNumber,
          exercises: widget.exercises,
          initialHeartRate: widget.heartRate,
          estimatedCalories: widget.calories,  // ✅ ADD THIS
          estimatedDuration: widget.duration,  // ✅ ADD THIS
        ),
      ),
    );
  }
}

enum HeartRateZone {
  resting,
  warmUp,
  fatBurning,
  anaerobic,
}