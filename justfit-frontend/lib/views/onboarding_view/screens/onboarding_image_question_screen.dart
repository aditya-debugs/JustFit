import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/image_option_card.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADD THIS

class OnboardingImageQuestionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final List<Map<String, dynamic>> options;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const OnboardingImageQuestionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    required this.options,
    this.currentPart = 1,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<OnboardingImageQuestionScreen> createState() =>
      _OnboardingImageQuestionScreenState();
}

class _OnboardingImageQuestionScreenState
    extends State<OnboardingImageQuestionScreen>
    with SingleTickerProviderStateMixin {
  // ✅ GET CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  int? _selectedIndex;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD EXISTING SELECTION FROM CONTROLLER
    if (widget.question == "What's your main goal?") {
      final savedGoal = _controller.mainGoal.value;
      if (savedGoal != null) {
        _selectedIndex = widget.options.indexWhere(
          (opt) => opt['label'].toString().toLowerCase().replaceAll(' ', '_') == savedGoal,
        );
        if (_selectedIndex == -1) _selectedIndex = null;
      }
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

  void _selectOption(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // ✅ SAVE TO CONTROLLER IMMEDIATELY
    if (widget.question == "What's your main goal?") {
      final label = widget.options[index]['label'] as String;
      final goalValue = label.toLowerCase().replaceAll(' ', '_');
      _controller.setMainGoal(goalValue);
      print('✅ Saved main goal: $goalValue');
    }
  }

  void _handleNext() {
    if (_selectedIndex == null) {
      Get.snackbar(
        '⚠️ Required',
        'Please select your main goal',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ FINAL SAVE BEFORE PROCEEDING
    if (widget.question == "What's your main goal?") {
      final label = widget.options[_selectedIndex!]['label'] as String;
      final goalValue = label.toLowerCase().replaceAll(' ', '_');
      _controller.setMainGoal(goalValue);
      print('Selected goal: $label ($goalValue)');
    }

    if (widget.onNext != null) {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Question text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.question,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                    height: 1.3,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 80),
           
              // Image options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: List.generate(
                      widget.options.length,
                      (index) {
                        final option = widget.options[index];
                        final isSelected = _selectedIndex == index;

                        return ImageOptionCard(
                          label: option['label'],
                          imageUrl: option['image'],
                          isSelected: isSelected,
                          onTap: () => _selectOption(index),
                        );
                      },
                    ),
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
                    color: _selectedIndex != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedIndex != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedIndex != null
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
}
