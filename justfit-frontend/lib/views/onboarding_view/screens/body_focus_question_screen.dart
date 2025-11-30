// lib/views/onboarding_view/screens/body_focus_question_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class BodyFocusQuestionScreen extends StatefulWidget {
  final String partTitle;
  final String question;
  final List<Map<String, dynamic>> options;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const BodyFocusQuestionScreen({
    Key? key,
    required this.partTitle,
    required this.question,
    required this.options,
    this.currentPart = 1,
    this.currentQuestionInPart = 3,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onNext,
    this.onBack,
  }) : super(key: key);

  @override
  State<BodyFocusQuestionScreen> createState() => _BodyFocusQuestionScreenState();
}

class _BodyFocusQuestionScreenState extends State<BodyFocusQuestionScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  final Set<String> _selectedBodyParts = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Load existing selections
    _selectedBodyParts.addAll(_controller.focusAreas.toList());
    
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

  void _toggleBodyPart(String bodyPart, String bodyPartValue) {
    setState(() {
      if (bodyPartValue == 'fullbody') {
        // ✅ Full Body: Select all body parts
        if (_selectedBodyParts.contains(bodyPartValue)) {
          // Deselect Full Body and all parts
          _selectedBodyParts.clear();
        } else {
          // Select Full Body and all individual parts
          _selectedBodyParts.clear();
          _selectedBodyParts.add(bodyPartValue);
          // Add all other body parts too
          for (var option in widget.options) {
            _selectedBodyParts.add(option['bodyPart'] as String);
          }
        }
      } else {
        // ✅ Multi-select for individual body parts
        if (_selectedBodyParts.contains(bodyPartValue)) {
          _selectedBodyParts.remove(bodyPartValue);
          // If removing individual part, also remove Full Body
          _selectedBodyParts.remove('fullbody');
        } else {
          _selectedBodyParts.add(bodyPartValue);
          
          // Check if all parts are selected → auto-select Full Body
          final allPartsSelected = widget.options
              .where((opt) => opt['bodyPart'] != 'fullbody')
              .every((opt) => _selectedBodyParts.contains(opt['bodyPart']));
          
          if (allPartsSelected) {
            _selectedBodyParts.add('fullbody');
          }
        }
      }
    });
    
    // Save to controller
    _controller.focusAreas.value = _selectedBodyParts.toList();
  }

  void _handleNext() {
    if (_selectedBodyParts.isEmpty) {
      Get.snackbar(
        '⚠️ Required',
        'Please select at least one body focus area',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _controller.focusAreas.value = _selectedBodyParts.toList();
    
    print('✅ Selected body focus areas: ${_selectedBodyParts.toList()}');

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
              const SizedBox(height: 24),

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

              const SizedBox(height: 32),

              // Content area - ✅ FIXED: Better layout
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left side - Options
                    Expanded(
                      flex: 48,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 24.0, right: 8.0, bottom: 16),
                        child: Column(
                          children: widget.options.map((option) {
                            final bodyPart = option['label'] as String;
                            final bodyPartValue = option['bodyPart'] as String;
                            final isSelected = _selectedBodyParts.contains(bodyPartValue);

                            return GestureDetector(
                              onTap: () => _toggleBodyPart(bodyPart, bodyPartValue),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFF5F7)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFA2A55)
                                        : const Color(0xFFE8E8E8),
                                    width: isSelected ? 2.0 : 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFFA2A55).withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bodyPart,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    AnimatedScale(
                                      scale: isSelected ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeOutBack,
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFFFA2A55),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Right side - ✅ FIXED: Better image sizing
                    Expanded(
                      flex: 52,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0, left: 8.0, bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/images/onboarding/body_focus.jpg',
                              fit: BoxFit.cover, // ✅ Changed from contain to cover
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFFF5F5F5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image_outlined,
                                        size: 64,
                                        color: Color(0xFFCCCCCC),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Body Focus Image',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _selectedBodyParts.isNotEmpty
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _selectedBodyParts.isNotEmpty
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedBodyParts.isNotEmpty ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedBodyParts.isNotEmpty
                                ? Colors.white
                                : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
