// lib/views/onboarding_view/screens/menstrual_cycle_awareness_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADDED

class MenstrualCycleAwarenessScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final Function(String selection)? onNext;

  const MenstrualCycleAwarenessScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 3,
    this.currentQuestionInPart = 2,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<MenstrualCycleAwarenessScreen> createState() => _MenstrualCycleAwarenessScreenState();
}

class _MenstrualCycleAwarenessScreenState extends State<MenstrualCycleAwarenessScreen>
    with SingleTickerProviderStateMixin {
  // ✅ ADDED CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  String? _selectedOption;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _options = [
    {'value': 'yes', 'label': 'Yes, adjust for my cycle'},
    {'value': 'no', 'label': 'No, keep it consistent'},
    {'value': 'not_applicable', 'label': 'Not applicable'},
  ];

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD SAVED SELECTION FROM CONTROLLER
    _selectedOption = _controller.menstrualCycleAdaptation.value;

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
    if (_selectedOption != null && widget.onNext != null) {
      // ✅ SAVE TO CONTROLLER
      _controller.setMenstrualCycleAdaptation(_selectedOption!);
      
      print('Selected menstrual cycle adaptation: $_selectedOption');
      print('✅ Saved to controller');
      
      widget.onNext!(_selectedOption!);
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
              const SizedBox(height: 24),

              // Icon
              const Text(
                '🌸',
                style: TextStyle(fontSize: 48),
              ),

              const SizedBox(height: 20),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Do you want your plan to adapt to your menstrual cycle?',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'We\'ll adjust workout intensity based on your energy levels throughout the month',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: _options.map((option) {
                      final isSelected = _selectedOption == option['value'];
                      return _buildOptionCard(
                        value: option['value']!,
                        label: option['label']!,
                        isSelected: isSelected,
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String value,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
        // ✅ SAVE TO CONTROLLER IMMEDIATELY
        _controller.setMenstrualCycleAdaptation(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFA2A55),
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000000),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}