import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_view/signup_screen.dart';
import '../auth_view/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _robotController;
  late AnimationController _floatController;
  late AnimationController _firstTextController;
  late AnimationController _secondTextController;

  late Animation<double> _robotScaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _firstTextOpacity;
  late Animation<Offset> _firstTextSlide;
  late Animation<double> _secondTextOpacity;
  late Animation<Offset> _secondTextSlide;

  bool _showSecondScreen = false;

  @override
  void initState() {
    super.initState();

    // Robot zoom-in animation
    _robotController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _robotScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _robotController,
        curve: Curves.easeOutBack,
      ),
    );

    // Continuous floating animation
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    // First text animation (slide up + fade in)
    _firstTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _firstTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _firstTextController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _firstTextSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _firstTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Second text animation (slide up + fade in)
    _secondTextController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _secondTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _secondTextController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _secondTextSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _secondTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // 1. Robot zooms in
    await Future.delayed(const Duration(milliseconds: 100));
    _robotController.forward();

    // 2. First text appears after robot animation
    await Future.delayed(const Duration(milliseconds: 600));
    _firstTextController.forward();

    // 3. Wait for 2 seconds, then fade out first text
    await Future.delayed(const Duration(milliseconds: 2000));
    _firstTextController.reverse();

    // 4. Show second text after first text fades out
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _showSecondScreen = true;
      });
      _secondTextController.forward();
    }
  }

  @override
  void dispose() {
    _robotController.dispose();
    _floatController.dispose();
    _firstTextController.dispose();
    _secondTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Robot - stays in fixed position
              _buildAnimatedRobot(),
              
              const SizedBox(height: 48),
              
              // Text area - fixed height to prevent shifting
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    // First screen text
                    if (!_showSecondScreen)
                      Align(
                        alignment: Alignment.topCenter,
                        child: FadeTransition(
                          opacity: _firstTextOpacity,
                          child: SlideTransition(
                            position: _firstTextSlide,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Hi there,',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE91E63),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "I'm your personal\nfitness coach",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    // Second screen text
                    if (_showSecondScreen)
                      Align(
                        alignment: Alignment.topCenter,
                        child: FadeTransition(
                          opacity: _secondTextOpacity,
                          child: SlideTransition(
                            position: _secondTextSlide,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "I will ask you\nsome questions to design\na personalized plan",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const Spacer(flex: 3),
              
              // Buttons area - ALWAYS reserve space (even when hidden)
              SizedBox(
                height: 130, // Fixed height for button area
                child: _showSecondScreen
                    ? FadeTransition(
                        opacity: _secondTextOpacity,
                        child: SlideTransition(
                          position: _secondTextSlide,
                          child: Column(
                            children: [
                              // Get Started Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.off(() => const SignupScreen());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE91E63),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Text(
                                    'Get Started',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.off(() => const LoginScreen());
                                    },
                                    child: Text(
                                      'Log in',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFE91E63),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(), // Empty space on first screen
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedRobot() {
    return AnimatedBuilder(
      animation: Listenable.merge([_robotController, _floatController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _robotScaleAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20 + (_floatAnimation.value * 0.5),
                    offset: Offset(0, 10 + (_floatAnimation.value * 0.5)),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left eye
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4),
                          width: 2.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right eye
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4),
                          width: 2.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}