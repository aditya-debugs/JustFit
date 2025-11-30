import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/heart_rate_gauge.dart';
import 'heart_rate_measure_screen.dart';
import 'active_workout_screen.dart';
import '../../data/models/workout/workout_exercise.dart';
import '../../data/models/workout/simple_workout_models.dart'; // ✅ ADD THIS

class PreWorkoutScreen extends StatefulWidget {
  final int dayNumber;
  final int duration;
  final int calories;
  final List<WorkoutExercise> exercises;
  final String? discoveryWorkoutId; // ✅ NEW
  final String? discoveryWorkoutTitle; // ✅ NEW
  final String? discoveryCategory; // ✅ NEW
  final List<WorkoutSet>? fullWorkoutSets; // ✅ NEW

  const PreWorkoutScreen({
    Key? key,
    required this.dayNumber,
    required this.duration,
    required this.calories,
    required this.exercises,
    this.discoveryWorkoutId, // ✅ NEW
    this.discoveryWorkoutTitle, // ✅ NEW
    this.discoveryCategory, // ✅ NEW
    this.fullWorkoutSets, // ✅ NEW
  }) : super(key: key);

  @override
  State<PreWorkoutScreen> createState() => _PreWorkoutScreenState();
}

class _PreWorkoutScreenState extends State<PreWorkoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate available space
            final availableHeight = constraints.maxHeight;
            
            // Dynamically adjust phone mockup size
            final mockupHeight = (availableHeight * 0.40).clamp(240.0, 360.0);
            
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Title section - Fixed
                  Text(
                    'Get Ready',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF1744),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get the most out of\nyour workout',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  
                  const Spacer(flex: 2),

                  _buildIntensityIndicator(),
                  
                  const Spacer(flex: 1),
                  
                  // Responsive phone mockup - Shrinks on small screens
                  SizedBox(
                    height: mockupHeight,
                    child: _buildPhoneMockup(),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Bottom text - Fixed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Training in your target heart rate zone can help you burn more calories and fat',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildActionButtons(),
                  
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

    Widget _buildIntensityIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EEFF), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 24, color: Color(0xFF64B5F6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Get ready to give it your all today!',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF333333),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPhoneMockup() {
    return Container(
      width: 280,
      height: 360,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[300]!, width: 8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black),
                        const SizedBox(width: 4),
                        Icon(Icons.wifi, size: 14, color: Colors.black),
                        const SizedBox(width: 4),
                        Icon(Icons.battery_full, size: 14, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.05),
                    child: const HeartRateGauge(
                      heartRate: 121,
                      size: 140,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Please hold the camera until the end',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _navigateToHeartRateMeasure,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1744),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Measure Heart Rate',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: _isLoading ? null : _startTrainingDirectly,
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: const Color(0xFFFF1744),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFFF1744),
                    ),
                  )
                : Text(
                    'Just Start Training',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _navigateToHeartRateMeasure() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeartRateMeasureScreen(
          dayNumber: widget.dayNumber,
          duration: widget.duration,
          calories: widget.calories,
          exercises: widget.exercises, // ✅ PASS EXERCISES
          discoveryWorkoutId: widget.discoveryWorkoutId, // ✅ ADD
          discoveryWorkoutTitle: widget.discoveryWorkoutTitle, // ✅ ADD
          discoveryCategory: widget.discoveryCategory, // ✅ ADD
          fullWorkoutSets: widget.fullWorkoutSets, // ✅ ADD
        ),
      ),
    );
  }

  Future<void> _startTrainingDirectly() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ActiveWorkoutScreen(
          dayNumber: widget.dayNumber,
          exercises: widget.exercises,
          initialHeartRate: null,
          estimatedCalories: widget.calories,  // ✅ ADD THIS
          estimatedDuration: widget.duration,  // ✅ ADD THIS
          discoveryWorkoutId: widget.discoveryWorkoutId, // ✅ ADD
          discoveryWorkoutTitle: widget.discoveryWorkoutTitle, // ✅ ADD
          discoveryCategory: widget.discoveryCategory, // ✅ ADD
          fullWorkoutSets: widget.fullWorkoutSets, // ✅ ADD
        ),
      ),
    );
  }
}