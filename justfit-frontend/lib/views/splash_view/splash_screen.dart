import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../welcome_view/welcome_screen.dart';
import '../main_view/main_screen.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart';
import '../../controllers/onboarding_controller.dart';
import '../../data/datasources/onboarding_data.dart';
import '../../views/onboarding_view/screens/onboarding_question_screen.dart';
import '../../views/onboarding_view/screens/part_transition_screen.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Wait 2 seconds, then check auth status and navigate
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final authService = Get.find<AuthService>();
      final userService = Get.find<UserService>();
      
      print('🔍 Checking authentication status...');
      
      // Check if user is authenticated
      if (authService.isAuthenticated && !authService.isAnonymous) {
        print('✅ User is authenticated, loading profile...');
        
        // ✅ FIXED: Wait for user profile to actually load (max 5 seconds)
        int attempts = 0;
        const maxAttempts = 25; // 25 attempts × 200ms = 5 seconds max
        
        while (attempts < maxAttempts) {
          final user = userService.currentUser.value;
          
          if (user != null) {
            // Profile loaded successfully!
            print('✅ User profile loaded: ${user.email}');
            
            // Check onboarding status
            if (!user.hasCompletedOnboarding) {
              // Resume onboarding
              print('📋 Onboarding incomplete, resuming...');
              _navigateToOnboarding();
            } else {
              // Go to home screen
              print('🏠 Onboarding complete, navigating to home...');
              _navigateToHome();
            }
            return;
          }
          
          // Wait 200ms before trying again
          await Future.delayed(const Duration(milliseconds: 200));
          attempts++;
        }
        
        // If we reach here, profile didn't load within 5 seconds
        print('⚠️ No user profile found after 5 seconds, signing out...');
        await authService.signOut();
        _navigateToWelcome();
        return;
      } else {
        // Not authenticated - show welcome screen
        print('👋 User not authenticated, showing welcome...');
        _navigateToWelcome();
      }
    } catch (e) {
      print('❌ Error during auth check: $e');
      // On error, show welcome screen
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    Get.off(
      () => const WelcomeScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _navigateToHome() {
    Get.offAll(
      () => const MainScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _navigateToOnboarding() {
    // Start from Part 1 - same flow as in app_routes.dart
    Get.off(
      () => PartTransitionScreen(
        partNumber: 1,
        partTitle: 'Goal',
        onComplete: () {
          // ✅ Call the public method from AppRoutes
          AppRoutes.startOnboardingFlow();
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFFE91E63),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'JUSTFIT',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}