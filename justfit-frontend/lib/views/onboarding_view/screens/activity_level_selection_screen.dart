import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';
import '../widgets/custom_dot_slider.dart';

class ActivityLevelSelectionScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const ActivityLevelSelectionScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 2,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<ActivityLevelSelectionScreen> createState() =>
      _ActivityLevelSelectionScreenState();
}

class _ActivityLevelSelectionScreenState
    extends State<ActivityLevelSelectionScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Get OnboardingController instance
  final OnboardingController _controller = Get.find<OnboardingController>();

  final List<Map<String, dynamic>> _activityLevels = [
    {
      'title': 'Not active',
      'description': 'I easily get out of breath while walking up the stairs',
      'icon': Icons.hotel,
      'value': 'not_active',
    },
    {
      'title': 'Lightly active',
      'description': 'Sometimes I do quick workouts to get my body moving',
      'icon': Icons.self_improvement,
      'value': 'lightly_active',
    },
    {
      'title': 'Moderately active',
      'description': 'I exercise regularly, at least 1-2 times a week',
      'icon': Icons.directions_walk,
      'value': 'moderately_active',
    },
    {
      'title': 'Highly active',
      'description': 'Fitness is an essential part of my life',
      'icon': Icons.directions_run,
      'value': 'highly_active',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Load previously selected value from controller
    final savedValue = _controller.activityLevel.value;
    if (savedValue != null) {
      _currentIndex = _activityLevels.indexWhere(
        (level) => level['value'] == savedValue
      );
      if (_currentIndex == -1) _currentIndex = 0;
    }
    
    _pageController = PageController(
      viewportFraction: 0.6,
      initialPage: _currentIndex,
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
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Update controller immediately
    _controller.setActivityLevel(_activityLevels[index]['value']);
  }

  void _onSliderChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Update controller immediately
    _controller.setActivityLevel(_activityLevels[index]['value']);
  }

  void _handleNext() {
    if (widget.onNext != null) {
      // Save to controller before proceeding
      _controller.setActivityLevel(_activityLevels[_currentIndex]['value']);
      print('Activity level selected: ${_activityLevels[_currentIndex]['value']}');
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Choose your activity level',
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

                        // Carousel
                        SizedBox(
                          height: 320,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemCount: _activityLevels.length,
                            itemBuilder: (context, index) {
                              return _buildCarouselItem(index);
                            },
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Slider
                        _buildCustomSlider(),

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

              const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
        }

        final isCenter = _currentIndex == index;

        return Center(
          child: SizedBox(
            height: 320,
            width: 300 * value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular character animation
          _buildActivityCircle(index),

          const SizedBox(height: 24),

          // Title
          Text(
            _activityLevels[index]['title'],
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _activityLevels[index]['description'],
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCircle(int index) {
    final isCenter = _currentIndex == index;
    final size = isCenter ? 180.0 : 140.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCenter
            ? const Color(0xFFFA2A55).withOpacity(0.1)
            : const Color(0xFFFFE5EC).withOpacity(0.3),
        border: Border.all(
          color: isCenter
              ? const Color(0xFFFA2A55)
              : const Color(0xFFFFB3C6).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: _buildAnimatedIcon(index, isCenter),
      ),
    );
  }

  Widget _buildAnimatedIcon(int index, bool isCenter) {
    final iconData = _activityLevels[index]['icon'] as IconData;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        double rotation = 0.0;
        double scale = 1.0;

        if (index == 0) {
          // Sleeping animation - gentle breathing
          scale = 1.0 + (0.05 * (value < 0.5 ? value * 2 : (1 - value) * 2));
        } else if (index == 1) {
          // Stretching animation - side to side
          rotation = 0.2 * (value < 0.5 ? value * 2 : (1 - value) * 2 - 1);
        } else if (index == 2) {
          // Walking animation - slight up and down
          scale = 1.0 + (0.1 * (value < 0.5 ? value * 2 : (1 - value) * 2));
        } else if (index == 3) {
          // Running animation - more pronounced up and down
          scale = 1.0 + (0.15 * (value < 0.5 ? value * 2 : (1 - value) * 2));
        }

        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotation,
            child: Icon(
              iconData,
              size: isCenter ? 80 : 60,
              color: isCenter ? const Color(0xFFFA2A55) : const Color(0xFFFFB3C6),
            ),
          ),
        );
      },
      onEnd: () {
        // Restart animation
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildCustomSlider() {
  return CustomDotSlider(
    totalDots: 4,
    selectedIndex: _currentIndex,
    onChanged: _onSliderChanged,
    leftLabel: 'Not active',
    rightLabel: 'Highly active',
  );
}
}
