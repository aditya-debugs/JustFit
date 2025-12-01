import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../widgets/onboarding_layout.dart';
import '../../../controllers/onboarding_controller.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const OnboardingSuccessScreen({
    Key? key,
    required this.partTitle,
    this.currentPart = 4,
    this.currentQuestionInPart = 13,
    this.totalQuestionsInPart = 13,
    this.totalParts = 4,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<OnboardingSuccessScreen> createState() =>
      _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late PageController _pageController;
  Timer? _autoScrollTimer;

  // Get controller instance
  late final OnboardingController _controller;

  // Sample profile images - you can replace with actual asset paths
  final List<String> _profileImages = [
    'assets/images/onboarding/profile_1.png',
    'assets/images/onboarding/profile_2.png',
    'assets/images/onboarding/profile_3.png',
    'assets/images/onboarding/profile_4.png',
    'assets/images/onboarding/profile_5.png',
    'assets/images/onboarding/profile_6.png',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize controller
    _controller = Get.find<OnboardingController>();

    // Fade and slide animations for content
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();

    // Page controller for carousel - viewportFraction controls spacing and overlap
    _pageController = PageController(
      viewportFraction: 0.28, // This creates the overlap effect
      initialPage: 1000,
    );

    // Start auto-scroll immediately after a tiny delay to ensure page controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    // Start immediately, then repeat every 2 seconds
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_pageController.hasClients) {
        final nextPage = _pageController.page!.round() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        final nextPage = _pageController.page!.round() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
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
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
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
                        const SizedBox(height: 20),
                        _buildContent(),
                        const Spacer(),
                        _buildNextButton(),
                        const SizedBox(height: 24),
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

  Widget _buildContent() {
    return Column(
      children: [
        // Main title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'JustFit was made for people\njust like you!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 50),

        // Rotating profile carousel - Full width
        SizedBox(
          width: double.infinity,
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              final imageIndex = index % _profileImages.length;
              return _buildProfileCircle(_profileImages[imageIndex], index);
            },
          ),
        ),

        const SizedBox(height: 16),

        // User count text
        Text(
          '1,000,000+ JustFit users',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 60),

        // Statistics section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '83%',
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE31E52),
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: ' Of JustFit Users',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Description text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'claim that the workout plan we offer is easy to follow and makes it simple to stay on track.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCircle(String imagePath, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double scale = 0.6; // Default to small size

        if (_pageController.position.haveDimensions) {
          final page =
              _pageController.page ?? _pageController.initialPage.toDouble();
          // Calculate distance from center
          final diff = (page - index).abs();

          // Scale based on position - center is largest, sides are smaller
          if (diff < 1) {
            // This is the center or very close to center
            scale = 1.0 - (diff * 0.4); // Scale from 1.0 to 0.6
          } else {
            // Far from center
            scale = 0.6;
          }

          // Smooth the scale transition
          scale = scale.clamp(0.6, 1.0);
        } else {
          // Before position has dimensions, calculate based on initialPage
          final diff = (_pageController.initialPage - index).abs();
          if (diff < 1) {
            scale = 1.0 - (diff * 0.4);
          } else {
            scale = 0.6;
          }
          scale = scale.clamp(0.6, 1.0);
        }

        return Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image doesn't exist
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 60 * scale,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return Padding(
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
            onTap: widget.onNext,
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
    );
  }
}
