// lib/views/onboarding_view/screens/age_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADDED

class AgeSelectionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const AgeSelectionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    this.currentPart = 3,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen>
    with SingleTickerProviderStateMixin {
  // ✅ ADDED CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  late FixedExtentScrollController _scrollController;
  int _selectedAge = 24; // Default age
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Age range: 18 to 80
  final int minAge = 18;
  final int maxAge = 80;

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD SAVED AGE FROM CONTROLLER
    _selectedAge = _controller.age.value;
    
    // Initialize scroll controller to start at saved age
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedAge - minAge,
    );

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
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleNext() {
    // ✅ SAVE AGE TO CONTROLLER
    _controller.setAge(_selectedAge);
    
    print('Selected age: $_selectedAge');
    print('✅ Saved to controller');
    
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
            children: [
              const SizedBox(height: 32),

              // Question
              Text(
                widget.question,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Info card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFF0CC),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '💡',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This will help select suitable workouts for you',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Age wheel picker with fixed "years old" label
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wheel picker (numbers only)
                    ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: 60,
                      diameterRatio: 1.5,
                      perspective: 0.002,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedAge = minAge + index;
                        });
                        // ✅ SAVE TO CONTROLLER ON CHANGE
                        _controller.setAge(_selectedAge);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= (maxAge - minAge + 1)) {
                            return null;
                          }
                          final age = minAge + index;
                          final isSelected = age == _selectedAge;
                          
                          return Center(
                            child: Text(
                              age.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: isSelected ? 48 : 36,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF000000)
                                    : const Color(0xFFCCCCCC),
                                height: 1.0,
                              ),
                            ),
                          );
                        },
                        childCount: maxAge - minAge + 1,
                      ),
                    ),
                    
                    // Fixed "years old" label positioned to the right of center
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 + 40,
                      child: Text(
                        'years old',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}