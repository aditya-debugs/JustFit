import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class CardioTestScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const CardioTestScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 8,
    this.totalQuestionsInPart = 8,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<CardioTestScreen> createState() => _CardioTestScreenState();
}

class _CardioTestScreenState extends State<CardioTestScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'breath',
      'icon': Icons.sentiment_dissatisfied_outlined,
      'title': 'Out of breath',
      'messageTitle': 'We can help!',
      'message': 'Getting some cardio can be very helpful. We will select some simple but helpful exercises for you.',
    },
    {
      'value': 'tired',
      'icon': Icons.sentiment_neutral_outlined,
      'title': 'Somewhat tired but okay',
      'messageTitle': 'Pretty good!',
      'message': 'You only need a bit more exercise to see a fitter you! We will have a clear plan to help with it.',
    },
    {
      'value': 'easily',
      'icon': Icons.sentiment_satisfied_alt_outlined,
      'title': 'Easily',
      'messageTitle': 'Wow, great!',
      'message': 'Your cardiorespiratory function is in very good condition. Just keep it up!',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedOption = _controller.cardioTest.value;

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
      // Save to controller before proceeding
      _controller.setCardioTest(_selectedOption!);
      print('Cardio test answer selected: $_selectedOption');
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
                  'How do you feel after climbing some stairs?',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'This will help test your cardiorespiratory function.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    height: 1.5,
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
                      final isSelected = _selectedOption == option['value'];
                      return Column(
                        children: [
                          _buildOptionCard(
                            value: option['value']!,
                            icon: option['icon'] as IconData,
                            title: option['title']!,
                            isSelected: isSelected,
                          ),
                          
                          // Info box appears below selected option with animation
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isSelected
                                ? _buildInfoBox(
                                    messageTitle: option['messageTitle']!,
                                    message: option['message']!,
                                  )
                                : const SizedBox.shrink(),
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
    required String value,
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Allow deselection by tapping the same option
          _selectedOption = _selectedOption == value ? null : value;
        });
        // Update controller immediately
        if (_selectedOption != null) {
          _controller.setCardioTest(_selectedOption!);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
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
    return Container(
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
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 20,
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