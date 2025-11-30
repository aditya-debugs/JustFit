import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../controllers/workout_plan_controller.dart';

class PlanCreationLoadingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const PlanCreationLoadingScreen({
    Key? key,
    this.onComplete,
  }) : super(key: key);

  @override
  State<PlanCreationLoadingScreen> createState() => _PlanCreationLoadingScreenState();
}

class _PlanCreationLoadingScreenState extends State<PlanCreationLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _floatController1;
  late AnimationController _floatController2;
  late AnimationController _floatController3;
  late AnimationController _pulseController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _float1;
  late Animation<double> _float2;
  late Animation<double> _float3;
  late Animation<double> _pulseAnimation;

  Timer? _pollTimer;
  bool _planReady = false;

  final WorkoutPlanController _planController = Get.find<WorkoutPlanController>();

  // Loading messages that rotate
  final List<String> _loadingMessages = [
    'Analyzing your fitness goals...',
    'Creating personalized workouts...',
    'Calculating optimal rest days...',
    'Building progressive training...',
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

    // Pulse animation for the progress ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating animations for profile circles
    _floatController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _float1 = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController1, curve: Curves.easeInOut),
    );

    _float2 = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController2, curve: Curves.easeInOut),
    );

    _float3 = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController3, curve: Curves.easeInOut),
    );

    // Start fake progress animation
    _progressController.forward();

    // Rotate loading messages every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_planReady) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      } else {
        timer.cancel();
      }
    });

    // ✅ Check if plan already exists (user might be refreshing)
    if (_planController.currentPlan.value != null && 
        _planController.currentPlan.value!.phases.isNotEmpty) {
      print('✅ Plan already exists, completing immediately');
      _completePlanLoading();
    } else {
      // ✅ Poll for plan completion every 1 second
      print('⏳ Starting to poll for plan completion...');
      _pollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _checkPlanStatus();
      });
    }
  }

  void _checkPlanStatus() {
    // Check if plan is loaded and ready
    if (_planController.currentPlan.value != null && 
        _planController.currentPlan.value!.phases.isNotEmpty) {
      
      print('✅ Plan detected! Days: ${_planController.currentPlan.value!.phases.length}');
      _completePlanLoading();
    } else {
      print('⏳ Still waiting for plan... (${DateTime.now().second}s)');
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Wait a bit for the animation, then complete
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _pollTimer?.cancel();
          widget.onComplete?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatController1.dispose();
    _floatController2.dispose();
    _floatController3.dispose();
    _pulseController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  const SizedBox(height: 100),
                  
                  // Circular progress indicator with pulse effect
                  _buildCircularProgress(),
                  
                  const SizedBox(height: 24),
                  
                  // Loading text with fade animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _loadingMessages[_currentMessageIndex],
                        key: ValueKey<int>(_currentMessageIndex),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // User statistics
                  _buildUserStats(),
                  
                  const SizedBox(height: 180), // Space for floating circles
                ],
              ),

              // Floating profile circles (at the bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 250,
                  child: _buildFloatingCircles(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _pulseAnimation]),
      builder: (context, child) {
        final percentage = (_progressAnimation.value * 100).toInt();
        
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[50],
                  ),
                ),
                
                // Progress circle
                SizedBox(
                  width: 200,
                  height: 200,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: _progressAnimation.value,
                    ),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value,
                      strokeWidth: 14,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _planReady 
                            ? const Color(0xFF4CAF50) // Green when complete
                            : const Color(0xFFFA2A55), // Pink while loading
                      ),
                    ),
                  ),
                ),
                
                // Percentage text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: GoogleFonts.poppins(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                    if (_planReady)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF50),
                        size: 32,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserStats() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '1,000,000+',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFA2A55),
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: ' Users',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFA2A55),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'have chosen JustFit!',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircles() {
    return Stack(
      children: [
        // Bottom left - small
        _buildFloatingCircle(
          left: 20,
          bottom: 130,
          size: 50,
          color: Colors.pink[100]!,
          animation: _float1,
        ),
        
        // Left side - medium
        _buildFloatingCircle(
          left: 60,
          bottom: 20,
          size: 80,
          color: Colors.purple[100]!,
          animation: _float2,
        ),
        
        // Center large
        _buildFloatingCircle(
          left: null,
          bottom: 60,
          size: 200,
          color: Colors.grey[200]!,
          animation: _float3,
          centered: true,
        ),
        
        // Top right - very small
        _buildFloatingCircle(
          right: 120,
          bottom: 160,
          size: 40,
          color: Colors.orange[100]!,
          animation: _float1,
        ),
        
        // Right side - small
        _buildFloatingCircle(
          right: 30,
          bottom: 110,
          size: 60,
          color: Colors.blue[100]!,
          animation: _float2,
        ),
        
        // Bottom right - medium
        _buildFloatingCircle(
          right: 10,
          bottom: 10,
          size: 90,
          color: Colors.green[100]!,
          animation: _float3,
        ),
        
        // Bottom center left - small
        _buildFloatingCircle(
          left: 100,
          bottom: 5,
          size: 55,
          color: Colors.amber[100]!,
          animation: _float2,
        ),
        
        // Bottom center right - small
        _buildFloatingCircle(
          right: 100,
          bottom: 40,
          size: 65,
          color: Colors.teal[100]!,
          animation: _float3,
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
    required Animation<double> animation,
    bool centered = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        Widget circle = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.grey[600],
            ),
          ),
        );

        if (centered) {
          return Positioned(
            left: MediaQuery.of(context).size.width / 2 - size / 2,
            bottom: bottom + animation.value,
            child: circle,
          );
        }

        return Positioned(
          left: left,
          right: right,
          bottom: bottom + animation.value,
          child: circle,
        );
      },
    );
  }
}