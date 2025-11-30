import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class WorkoutTypePreferenceScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const WorkoutTypePreferenceScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 3,
    this.currentQuestionInPart = 5,
    this.totalQuestionsInPart = 5,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<WorkoutTypePreferenceScreen> createState() => _WorkoutTypePreferenceScreenState();
}

class _WorkoutTypePreferenceScreenState extends State<WorkoutTypePreferenceScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedWorkoutType;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'no_equipment',
      'icon': Icons.block,
      'title': 'No equipment',
      'messageTitle': 'Ok, we got it!',
      'message': 'We will choose workouts that suit your lifestyle with no equipment.',
    },
    {
      'value': 'no_jumping',
      'icon': Icons.accessibility_new,
      'title': 'No jumping',
      'messageTitle': 'Ok, we got it!',
      'message': 'We will select workouts without jumping especially for you.',
    },
    {
      'value': 'lying_down',
      'icon': Icons.airline_seat_flat,
      'title': 'All lying down exercise',
      'messageTitle': 'Ok, we got it!',
      'message': 'We will offer you a broad suite of workouts without leaving your bed.',
    },
    {
      'value': 'none',
      'icon': Icons.not_interested,
      'title': 'None of all',
      'messageTitle': 'Good!',
      'message': 'We have achievable programs to progressively build your fitness.',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedWorkoutType = _controller.workoutType.value;

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
    if (_selectedWorkoutType != null && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setWorkoutType(_selectedWorkoutType!);
      print('Workout type preference selected: $_selectedWorkoutType');
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
                  'Choose your preferred workout type',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 60),

              // Options with dynamic info boxes
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _options.map((option) {
                      final isSelected = _selectedWorkoutType == option['value'];
                      return Column(
                        children: [
                          _buildWorkoutTypeCard(
                            value: option['value']!,
                            icon: option['icon'] as IconData,
                            title: option['title']!,
                            isSelected: isSelected,
                          ),
                          
                          // Info box appears below selected option
                          if (isSelected)
                            _buildInfoBox(
                              messageTitle: option['messageTitle']!,
                              message: option['message']!,
                            ),
                          
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _selectedWorkoutType != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedWorkoutType != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedWorkoutType != null
                                ? Colors.white
                                : const Color(0xFF999999),
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

  Widget _buildWorkoutTypeCard({
    required String value,
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWorkoutType = value;
        });
        // Update controller immediately
        _controller.setWorkoutType(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFFF5F7)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFE8E8E8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFFFA2A55).withOpacity(0.1)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected 
                    ? const Color(0xFFFA2A55)
                    : const Color(0xFF666666),
              ),
            ),

            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required String messageTitle,
    required String message,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Robot/AI icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF5B6B7C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '👁️👁️',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3E50),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}