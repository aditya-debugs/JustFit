import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class DailyActivityScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const DailyActivityScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<DailyActivityScreen> createState() => _DailyActivityScreenState();
}

class _DailyActivityScreenState extends State<DailyActivityScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedActivity;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _options = [
    {
      'value': 'work_seated',
      'icon': Icons.desktop_windows_outlined,
      'label': 'At work, mostly seated',
    },
    {
      'value': 'home_sedentary',
      'icon': Icons.home_outlined,
      'label': 'At home, mostly sedentary',
    },
    {
      'value': 'walking_daily',
      'icon': Icons.directions_walk,
      'label': 'Walking daily',
    },
    {
      'value': 'working_on_foot',
      'icon': Icons.accessibility_new,
      'label': 'Working mostly on foot',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Load previously selected value from controller
    _selectedActivity = _controller.dailyActivity.value;

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
    if (_selectedActivity != null && widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setDailyActivity(_selectedActivity!);
      print('Daily activity selected: $_selectedActivity');
      widget.onNext!();
    }
  }

  void _handleOptionTap(String value) {
    setState(() {
      if (_selectedActivity == value) {
        // Deselect if already selected
        _selectedActivity = null;
      } else {
        _selectedActivity = value;
      }
    });
    // Update controller immediately
    if (_selectedActivity != null) {
      _controller.setDailyActivity(_selectedActivity!);
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
                  'What does your typical day look like?',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 60),

              // Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _options.map((option) {
                      final isSelected = _selectedActivity == option['value'];
                      return _buildActivityCard(
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
                    color: _selectedActivity != null
                        ? const Color(0xFF000000)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedActivity != null ? _handleNext : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _selectedActivity != null
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

  Widget _buildActivityCard({
    required String value,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _handleOptionTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFA2A55).withOpacity(0.1)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected
                    ? const Color(0xFFFA2A55)
                    : const Color(0xFF666666),
              ),
            ),

            const SizedBox(width: 20),

            // Label
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
