import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class InjurySelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const InjurySelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 3,
    this.currentQuestionInPart = 7,
    this.totalQuestionsInPart = 7,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<InjurySelectionScreen> createState() => _InjurySelectionScreenState();
}

class _InjurySelectionScreenState extends State<InjurySelectionScreen>
    with SingleTickerProviderStateMixin {
  Set<String> _selectedInjuries = {};

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'none',
      'icon': Icons.block,
      'label': 'None',
    },
    {
      'value': 'knee',
      'icon': Icons.accessibility_new,
      'label': 'Knee',
    },
    {
      'value': 'lower_back',
      'icon': Icons.airline_seat_individual_suite,
      'label': 'LowerBack',
    },
    {
      'value': 'ankle',
      'icon': Icons.downhill_skiing,
      'label': 'Ankle',
    },
    {
      'value': 'wrist',
      'icon': Icons.back_hand,
      'label': 'Wrist',
    },
    {
      'value': 'hip',
      'icon': Icons.airline_seat_legroom_normal,
      'label': 'Hip',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected values from controller
    _selectedInjuries = Set.from(_controller.injuries);

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

  void _handleOptionTap(String value) {
    setState(() {
      if (value == 'none') {
        // If "None" is tapped
        if (_selectedInjuries.contains('none')) {
          // Deselect "None"
          _selectedInjuries.remove('none');
        } else {
          // Select "None" and clear all others
          _selectedInjuries.clear();
          _selectedInjuries.add('none');
        }
      } else {
        // If any other option is tapped
        if (_selectedInjuries.contains(value)) {
          // Deselect the option
          _selectedInjuries.remove(value);
        } else {
          // Remove "None" if it was selected, then add the new option
          _selectedInjuries.remove('none');
          _selectedInjuries.add(value);
        }
      }
    });
    // Update controller immediately
    _controller.setInjuries(_selectedInjuries.toList());
  }

  void _handleNext() {
    if (_selectedInjuries.isNotEmpty && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setInjuries(_selectedInjuries.toList());
      print('Selected injuries: $_selectedInjuries');
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

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Have you ever suffered any injuries in these areas?',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Info box with light bulb
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFEE9B3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '💡',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We will filter unsuitable workouts for you',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B7355),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Options list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _options.map((option) {
                      final isSelected = _selectedInjuries.contains(option['value']);
                      return _buildInjuryCard(
                        value: option['value']!,
                        icon: option['icon'] as IconData,
                        label: option['label']!,
                        isSelected: isSelected,
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
                    color: _selectedInjuries.isNotEmpty
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedInjuries.isNotEmpty ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedInjuries.isNotEmpty
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

  Widget _buildInjuryCard({
    required String value,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _handleOptionTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F7) : Colors.white,
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

            // Label
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

            // Checkmark circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFFA2A55) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}