// lib/views/onboarding_view/screens/cycle_phase_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart'; // ← ADDED

class CyclePhaseSelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const CyclePhaseSelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 3,
    this.currentQuestionInPart = 3,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<CyclePhaseSelectionScreen> createState() => _CyclePhaseSelectionScreenState();
}

class _CyclePhaseSelectionScreenState extends State<CyclePhaseSelectionScreen>
    with SingleTickerProviderStateMixin {
  // ✅ ADDED CONTROLLER
  final OnboardingController _controller = Get.find<OnboardingController>();
  
  String? _selectedPhase;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _phases = [
    {
      'value': 'week1',
      'icon': '🩸',
      'label': 'Week 1: Currently on my period',
    },
    {
      'value': 'week2',
      'icon': '⚡',
      'label': 'Week 2: Period just ended (high energy phase)',
    },
    {
      'value': 'week3',
      'icon': '🌟',
      'label': 'Week 3: Mid-cycle',
    },
    {
      'value': 'week4',
      'icon': '🌙',
      'label': 'Week 4: PMS / Period coming soon',
    },
    {
      'value': 'irregular',
      'icon': '❓',
      'label': 'Irregular cycle / Not sure',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // ✅ LOAD SAVED PHASE FROM CONTROLLER
    _selectedPhase = _controller.currentCycleWeek.value;

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
    if (_selectedPhase != null && widget.onNext != null) {
      // ✅ SAVE TO CONTROLLER
      _controller.setCurrentCycleWeek(_selectedPhase);
      
      print('Selected cycle phase: $_selectedPhase');
      print('✅ Saved to controller');
      
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
                  'Where are you in your cycle right now?',
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
                  'This helps us start your plan at the right intensity',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _phases.map((phase) {
                      final isSelected = _selectedPhase == phase['value'];
                      return _buildPhaseCard(
                        value: phase['value']!,
                        icon: phase['icon']!,
                        label: phase['label']!,
                        isSelected: isSelected,
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Helper text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Don\'t worry if you\'re not sure - you can update this anytime',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF999999),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
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
                    color: _selectedPhase != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedPhase != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedPhase != null
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

  Widget _buildPhaseCard({
    required String value,
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPhase = value;
        });
        // ✅ SAVE TO CONTROLLER IMMEDIATELY
        _controller.setCurrentCycleWeek(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon/Emoji
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
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