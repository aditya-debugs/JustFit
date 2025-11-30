import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../controllers/workout_plan_controller.dart';
import '../../../controllers/onboarding_controller.dart'; // ✅ ADD THIS

class PlanCreationLoadingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const PlanCreationLoadingScreen({
    Key? key,
    this.onComplete,
  }) : super(key: key);

  @override
  State<PlanCreationLoadingScreen> createState() =>
      _PlanCreationLoadingScreenState();
}

class _PlanCreationLoadingScreenState extends State<PlanCreationLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _floatController;

  late Animation<double> _progressAnimation;
  late Animation<double> _floatAnimation;

  Timer? _pollTimer;
  bool _planReady = false;

  final WorkoutPlanController _planController =
      Get.find<WorkoutPlanController>();
  final OnboardingController _onboardingController =
      Get.find<OnboardingController>(); // ✅ ADD THIS

  // Loading messages that rotate
  final List<String> _loadingMessages = [
    'Creating your personal plan...',
    'Analyzing your fitness goals...',
    'Building personalized workouts...',
    'Calculating optimal rest days...',
    'Almost there...',
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Progress animation (smooth, never reaches 100 until plan is ready)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Slow fake progress
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.85).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    // Floating animation for profile circles only
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start fake progress animation
    _progressController.forward();

    // Rotate loading messages every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_planReady) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      } else {
        timer.cancel();
      }
    });

    // ✅ Start polling for plan immediately
    print('⏳ Starting to poll for plan completion...');
    _pollTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // ✅ Check every 500ms
      _checkPlanStatus();
    });
  }

  void _checkPlanStatus() {
    // Check if plan is loaded and ready
    if (_planController.currentPlan.value != null &&
        _planController.currentPlan.value!.phases.isNotEmpty) {
      print(
          '✅ Plan detected! Phases: ${_planController.currentPlan.value!.phases.length}');
      _completePlanLoading();
    } else {
      // Only print every 2 seconds to avoid log spam
      if (DateTime.now().second % 2 == 0) {
        print('⏳ Still waiting for plan generation...');
      }
    }
  }

  void _completePlanLoading() {
    if (!_planReady && mounted) {
      setState(() {
        _planReady = true;
      });

      // Animate to 100% completion
      _progressController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );

      // Wait for animation to complete, then navigate
      Future.delayed(const Duration(milliseconds: 1200), () async {
        if (mounted) {
          _pollTimer?.cancel();

          // ✅ Save initial weight entry
          try {
            await _onboardingController.saveInitialWeight();
            print('✅ Initial weight saved');
          } catch (e) {
            print('⚠️ Failed to save initial weight: $e');
          }

          widget.onComplete?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with centered content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Circular progress indicator (NO PULSE)
                    _buildCircularProgress(),

                    const SizedBox(height: 32),

                    // Loading text with fade animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          _loadingMessages[_currentMessageIndex],
                          key: ValueKey<int>(_currentMessageIndex),
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // User statistics
                    _buildUserStats(),
                  ],
                ),
              ),
            ),

            // Bottom section with floating profile circles
            SizedBox(
              height: 280,
              child: _buildFloatingCircles(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final percentage = (_progressAnimation.value * 100).toInt();

        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFAFAFA),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // Progress circle
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _planReady
                        ? const Color(0xFF4CAF50) // Green when complete
                        : const Color(0xFFFA2A55), // Pink while loading
                  ),
                ),
              ),

              // Percentage text
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.0,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '1,000,000+\n',
                  style: GoogleFonts.poppins(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFA2A55),
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Users',
                  style: GoogleFonts.poppins(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFA2A55),
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'have chosen JustFit!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCircles() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Row 1 (Top) - 3 circles
        _buildFloatingCircle(
          left: screenWidth * 0.05,
          bottom: 200,
          size: 60,
          color: Colors.pink[100]!,
        ),
        _buildFloatingCircle(
          left: screenWidth * 0.35,
          bottom: 210,
          size: 55,
          color: Colors.yellow[100]!,
        ),
        _buildFloatingCircle(
          right: screenWidth * 0.05,
          bottom: 195,
          size: 65,
          color: Colors.blue[100]!,
        ),

        // Row 2 (Middle-Top) - 2 circles
        _buildFloatingCircle(
          left: screenWidth * 0.02,
          bottom: 115,
          size: 70,
          color: Colors.orange[100]!,
        ),
        _buildFloatingCircle(
          right: screenWidth * 0.15,
          bottom: 125,
          size: 100,
          color: Colors.pink[50]!,
        ),

        // Row 3 (Middle) - 3 circles including center large
        _buildFloatingCircle(
          left: screenWidth * 0.08,
          bottom: 35,
          size: 85,
          color: Colors.purple[100]!,
        ),
        _buildFloatingCircle(
          left: screenWidth * 0.5 - 110,
          bottom: 25,
          size: 220,
          color: Colors.grey[300]!,
        ),
        _buildFloatingCircle(
          right: screenWidth * 0.02,
          bottom: 40,
          size: 110,
          color: Colors.green[100]!,
        ),

        // Row 4 (Bottom) - 2 circles
        _buildFloatingCircle(
          left: screenWidth * 0.25,
          bottom: 5,
          size: 75,
          color: Colors.cyan[100]!,
        ),
        _buildFloatingCircle(
          right: screenWidth * 0.25,
          bottom: 0,
          size: 80,
          color: Colors.amber[100]!,
        ),
      ],
    );
  }

  Widget _buildFloatingCircle({
    double? left,
    double? right,
    required double bottom,
    required double size,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Positioned(
          left: left,
          right: right,
          bottom: bottom + _floatAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: size * 0.45,
                color: Colors.grey[500],
              ),
            ),
          ),
        );
      },
    );
  }
}
