import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class GoalRewardScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const GoalRewardScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 13,
    this.totalQuestionsInPart = 13,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<GoalRewardScreen> createState() => _GoalRewardScreenState();
}

class _GoalRewardScreenState extends State<GoalRewardScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _options = [
    {'icon': Icons.checkroom, 'label': 'Buying new clothes'},
    {'icon': Icons.flight_takeoff, 'label': 'Traveling somewhere new'},
    {'icon': Icons.camera_alt, 'label': 'Taking pictures of myself'},
    {
      'icon': Icons.emoji_emotions_outlined,
      'label': 'Plan a fun hang-out with friends'
    },
    {'icon': Icons.wb_sunny_outlined, 'label': 'Take a personal day'},
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedOption = _controller.goalReward.value;

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_selectedOption != null && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setGoalReward(_selectedOption!);
      print('Goal reward selected: $_selectedOption');
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
                  'After reaching your goal weight, how would you reward yourself?',
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

              // Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _options.map((option) {
                      final isSelected = _selectedOption == option['label'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildOptionCard(
                          icon: option['icon'] as IconData,
                          label: option['label'] as String,
                          isSelected: isSelected,
                        ),
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
                    color: _selectedOption != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedOption != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedOption != null
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

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = _selectedOption == label ? null : label;
        });
        // Update controller immediately
        if (_selectedOption != null) {
          _controller.setGoalReward(_selectedOption!);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F7) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFA2A55)
                : const Color(0xFFE8E8E8),
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
            Expanded(
              child: Text(
                label,
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
}
