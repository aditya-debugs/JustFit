import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../controllers/onboarding_controller.dart';

class MotivationScreen2 extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(bool)? onNext;

  const MotivationScreen2({
    Key? key,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  State<MotivationScreen2> createState() => _MotivationScreen2State();
}

class _MotivationScreen2State extends State<MotivationScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Get controller instance
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize controller
    _controller = Get.find<OnboardingController>();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnswer(bool answer) {
    // Save to controller
    _controller.setAttractiveBodyDesire(answer);
    
    // Call parent callback
    widget.onNext?.call(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding/image_2.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient background if image not found
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFE8D5D5),
                        Color(0xFFD8C8C8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Content overlay with animation
          SafeArea(
            child: Column(
              children: [
                // Header with back button (no animation)
                _buildHeader(),

                // Animated content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Spacer to push content down
                          const Spacer(),

                          // Question text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'Do you wanna\nget an attractive\nbody?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Yes/No buttons
                          _buildButtons(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // No button
          Expanded(
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleAnswer(false),
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Text(
                      'No',
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

          const SizedBox(width: 16),

          // Yes button
          Expanded(
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleAnswer(true),
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Text(
                      'Yes',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}