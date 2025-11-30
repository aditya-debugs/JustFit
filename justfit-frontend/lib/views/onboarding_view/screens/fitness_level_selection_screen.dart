import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';
import '../widgets/custom_dot_slider.dart';

class FitnessLevelSelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const FitnessLevelSelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 3,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<FitnessLevelSelectionScreen> createState() =>
      _FitnessLevelSelectionScreenState();
}

class _FitnessLevelSelectionScreenState
    extends State<FitnessLevelSelectionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedLevel = 0; // 0: Beginner, 1: Intermediate, 2: Advanced

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _fitnessLevels = [
    {
      'title': 'BEGINNER',
      'description': 'I am new to regular workouts',
      'value': 'beginner',
      'progress': 0.33,
    },
    {
      'title': 'INTERMEDIATE',
      'description': 'I have been training on a regular basis',
      'value': 'intermediate',
      'progress': 0.66,
    },
    {
      'title': 'ADVANCED',
      'description': 'I have an abundant training experience',
      'value': 'advanced',
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    final savedValue = _controller.fitnessLevel.value;
    if (savedValue != null) {
      _selectedLevel = _fitnessLevels.indexWhere(
        (level) => level['value'] == savedValue
      );
      if (_selectedLevel == -1) _selectedLevel = 0;
    }

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setFitnessLevel(_fitnessLevels[_selectedLevel]['value']);
      print('Fitness level selected: ${_fitnessLevels[_selectedLevel]['value']}');
      widget.onNext!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      partTitle: widget.partTitle,
      currentPart: widget.currentPart,
      currentQuestionInPart: widget.currentQuestionInPart,
      totalQuestionsInPart: widget.totalQuestionsInPart,
      totalParts: widget.totalParts,
      showBackButton: true,
      onBack: widget.onBack,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'What\'s your fitness level?',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 80),

              // Circular progress ring with fire icon
              _buildCircularProgress(),

              const SizedBox(height: 80),

              // Level title
              Text(
                _fitnessLevels[_selectedLevel]['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Level description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  _fitnessLevels[_selectedLevel]['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF999999),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 60),

              // Smart slider
              _buildSmartSlider(),

              const Spacer(),

              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleNext,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    final progress = _fitnessLevels[_selectedLevel]['progress'] as double;
    
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
              color: const Color(0xFFF5F5F5),
            ),
          ),

          // Animated gradient progress ring
          CustomPaint(
            size: const Size(220, 220),
            painter: GradientCircularProgressPainter(
              progress: progress,
              level: _selectedLevel,
            ),
          ),

          // Fire icon in center
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.local_fire_department,
              key: ValueKey<int>(_selectedLevel),
              size: 80,
              color: _getFireColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFireColor() {
    switch (_selectedLevel) {
      case 0: // Beginner - light orange/yellow
        return const Color(0xFFFFB74D);
      case 1: // Intermediate - orange
        return const Color(0xFFFF7043);
      case 2: // Advanced - deep red/orange
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFFFB74D);
    }
  }

Widget _buildSmartSlider() {
  return CustomDotSlider(
    totalDots: 3,
    selectedIndex: _selectedLevel,
    onChanged: (index) {
      setState(() {
        _selectedLevel = index;
      });
      _controller.setFitnessLevel(_fitnessLevels[index]['value']);
    },
    leftLabel: 'Beginner',
    rightLabel: 'Advanced',
  );
}
}

// Custom painter for gradient circular progress
class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final int level;

  GradientCircularProgressPainter({
    required this.progress,
    required this.level,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // Gradient colors based on level
    List<Color> gradientColors;
    switch (level) {
      case 0: // Beginner - light yellow to orange
        gradientColors = [
          const Color(0xFFFFF9C4),
          const Color(0xFFFFB74D),
        ];
        break;
      case 1: // Intermediate - orange to red-orange
        gradientColors = [
          const Color(0xFFFFB74D),
          const Color(0xFFFF7043),
        ];
        break;
      case 2: // Advanced - red-orange to deep red
        gradientColors = [
          const Color(0xFFFF7043),
          const Color(0xFFE53935),
        ];
        break;
      default:
        gradientColors = [
          const Color(0xFFFFB74D),
          const Color(0xFFFF7043),
        ];
    }

    // Create gradient
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
      colors: gradientColors,
      stops: [0.0, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.level != level;
  }
}