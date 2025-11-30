import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADD THIS

class OnboardingQuestionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final List<Map<String, dynamic>> options;
  final bool isMultiSelect;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onNext;

  const OnboardingQuestionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    required this.options,
    this.isMultiSelect = false,
    this.currentPart = 1,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onNext,
  }) : super(key: key);

  @override
  State<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState extends State<OnboardingQuestionScreen>
    with SingleTickerProviderStateMixin {
  // ✅ GET CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  final List<int> _selectedIndices = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD EXISTING SELECTIONS FROM CONTROLLER
    if (widget.question == 'What motivates you most?') {
      // Load saved motivations
      final savedMotivations = _controller.motivations.toList();
      for (var motivation in savedMotivations) {
        final index = widget.options.indexWhere(
          (opt) => opt['label'] == motivation,
        );
        if (index != -1) {
          _selectedIndices.add(index);
        }
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

  void _toggleSelection(int index) {
    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      } else {
        _selectedIndices.clear();
        _selectedIndices.add(index);
      }
    });
    
    // ✅ SAVE TO CONTROLLER IMMEDIATELY
    if (widget.question == 'What motivates you most?') {
      final selectedMotivations = _selectedIndices
          .map((i) => widget.options[i]['label'] as String)
          .toList();
      _controller.motivations.value = selectedMotivations;
      print('✅ Saved motivations: $selectedMotivations');
    }
  }

  void _handleNext() {
    if (_selectedIndices.isEmpty) {
      Get.snackbar(
        '⚠️ Required',
        'Please select at least one option',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // ✅ FINAL SAVE BEFORE PROCEEDING
    if (widget.question == 'What motivates you most?') {
      final selectedMotivations = _selectedIndices
          .map((i) => widget.options[i]['label'] as String)
          .toList();
      _controller.motivations.value = selectedMotivations;
      
      print('Selected motivations:');
      for (var motivation in selectedMotivations) {
        print('- $motivation');
      }
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
      onBack: () => Get.back(),
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

              // Options list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: List.generate(
                      widget.options.length,
                      (index) {
                        final option = widget.options[index];
                        final isSelected = _selectedIndices.contains(index);

                        return GestureDetector(
                          onTap: () => _toggleSelection(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF5F7)
                                  : Colors.white,
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
                                Icon(
                                  option['icon'] as IconData,
                                  size: 28,
                                  color: isSelected
                                      ? const Color(0xFFFA2A55)
                                      : const Color(0xFF666666),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option['label'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFFA2A55),
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
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
                    color: _selectedIndices.isNotEmpty
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedIndices.isNotEmpty ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedIndices.isNotEmpty
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