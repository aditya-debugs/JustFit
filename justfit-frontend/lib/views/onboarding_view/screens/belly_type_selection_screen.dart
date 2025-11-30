import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class BellyTypeSelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const BellyTypeSelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 4,
    this.totalQuestionsInPart = 4,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<BellyTypeSelectionScreen> createState() =>
      _BellyTypeSelectionScreenState();
}

class _BellyTypeSelectionScreenState extends State<BellyTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedBellyType;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _bellyTypes = [
    {
      'value': 'normal',
      'label': 'Normal',
      'image': 'assets/images/onboarding/belly_normal.png', // Placeholder path
    },
    {
      'value': 'alcohol_belly',
      'label': 'Alcohol Belly',
      'image': 'assets/images/onboarding/belly_alcohol.png', // Placeholder path
    },
    {
      'value': 'mommy_belly',
      'label': 'Mommy Belly',
      'image': 'assets/images/onboarding/belly_mommy.png', // Placeholder path
    },
    {
      'value': 'stressed_out_belly',
      'label': 'Stressed-out Belly',
      'image': 'assets/images/onboarding/belly_stressed.png', // Placeholder path
    },
    {
      'value': 'hormonal_belly',
      'label': 'Hormonal Belly',
      'image': 'assets/images/onboarding/belly_hormonal.png', // Placeholder path
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedBellyType = _controller.bellyType.value;

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
    if (_selectedBellyType != null && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setBellyType(_selectedBellyType!);
      print('Belly type selected: $_selectedBellyType');
      widget.onNext!();
    }
  }

  void _handleOptionTap(String value) {
    setState(() {
      if (_selectedBellyType == value) {
        // Deselect if already selected
        _selectedBellyType = null;
      } else {
        _selectedBellyType = value;
      }
    });
    // Update controller immediately
    if (_selectedBellyType != null) {
      _controller.setBellyType(_selectedBellyType!);
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
                  'Select the option that best matches your belly type',
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

              // Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _bellyTypes.map((option) {
                      final isSelected = _selectedBellyType == option['value'];
                      return _buildBellyTypeCard(
                        value: option['value']!,
                        label: option['label']!,
                        imagePath: option['image']!,
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
                    color: _selectedBellyType != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedBellyType != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedBellyType != null
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

  Widget _buildBellyTypeCard({
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

            const SizedBox(width: 16),

            // Image placeholder
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
                    // Placeholder when image is not found
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