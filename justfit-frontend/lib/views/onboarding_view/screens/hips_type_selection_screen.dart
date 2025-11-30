import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class HipsTypeSelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const HipsTypeSelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 5,
    this.totalQuestionsInPart = 5,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<HipsTypeSelectionScreen> createState() =>
      _HipsTypeSelectionScreenState();
}

class _HipsTypeSelectionScreenState extends State<HipsTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedHipsType;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _hipsTypes = [
    {
      'value': 'normal',
      'label': 'Normal',
      'image': 'assets/images/onboarding/hips_normal.png',
    },
    {
      'value': 'flat',
      'label': 'Flat',
      'image': 'assets/images/onboarding/hips_flat.png',
    },
    {
      'value': 'saggy',
      'label': 'Saggy',
      'image': 'assets/images/onboarding/hips_saggy.png',
    },
    {
      'value': 'double',
      'label': 'Double',
      'image': 'assets/images/onboarding/hips_double.png',
    },
    {
      'value': 'bubble',
      'label': 'Bubble',
      'image': 'assets/images/onboarding/hips_bubble.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedHipsType = _controller.hipsType.value;

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
    if (_selectedHipsType != null && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setHipsType(_selectedHipsType!);
      print('Hips type selected: $_selectedHipsType');
      widget.onNext!();
    }
  }

  void _handleOptionTap(String value) {
    setState(() {
      if (_selectedHipsType == value) {
        _selectedHipsType = null;
      } else {
        _selectedHipsType = value;
      }
    });
    // Update controller immediately
    if (_selectedHipsType != null) {
      _controller.setHipsType(_selectedHipsType!);
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Select the option that best matches your hips type',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _hipsTypes.map((option) {
                      final isSelected = _selectedHipsType == option['value'];
                      return _buildHipsTypeCard(
                        value: option['value']!,
                        label: option['label']!,
                        imagePath: option['image']!,
                        isSelected: isSelected,
                      );
                    }).toList(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _selectedHipsType != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedHipsType != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedHipsType != null
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

  Widget _buildHipsTypeCard({
    required String value,
    required String label,
    required String imagePath,
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
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFFFA2A55) : const Color(0xFF000000),
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
