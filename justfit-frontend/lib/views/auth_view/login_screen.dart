import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart'; // ← ADDED
import '../main_view/main_screen.dart'; // ← ADDED
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = Get.find<AuthService>();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _showOtherOptions = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = GetUtils.isEmail(_emailController.text.trim());
    });
  }

  void _validatePassword() {
    setState(() {
      _isPasswordValid = _passwordController.text.length >= 8;
    });
  }

  bool get _isFormValid => _isEmailValid && _isPasswordValid && _agreedToTerms;

  // ✅ UPDATED METHOD WITH NAVIGATION
  Future<void> _handleLogin() async {
  if (!_isFormValid) return;

  setState(() => _isLoading = true);

  try {
    // 1. Sign in with Firebase
    final user = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    // 2. Wait for UserService to load profile (triggered by auth state listener)
    final userService = Get.find<UserService>();
    
    // Poll for user profile to be loaded (max 5 seconds)
    int attempts = 0;
    while (userService.currentUser.value == null && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    
    final userProfile = userService.currentUser.value;
    
    if (userProfile == null) {
      print('❌ User profile failed to load after sign-in');
      Get.snackbar(
        'Error',
        'Failed to load user profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() => _isLoading = false);
      return;
    }

    print('✅ User profile loaded: ${userProfile.email}');
    print('✅ Onboarding status: ${userProfile.hasCompletedOnboarding}');

    // 3. Navigate based on onboarding status
    if (!mounted) return;
    
    if (userProfile.hasCompletedOnboarding) {
      print('🏠 Navigating to MainScreen...');
      Get.offAll(() => const MainScreen());
    } else {
      print('📋 User needs onboarding - navigating to MainScreen anyway');
      // TODO: Navigate to onboarding flow when implemented
      Get.offAll(() => const MainScreen());
    }
    
  } catch (e) {
    print('❌ Login error: $e');
    Get.snackbar(
      'Error',
      'Failed to sign in. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() => _isLoading = false);
  }
}

  // ✅ UPDATED METHOD WITH NAVIGATION
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    final user = await _authService.signInWithGoogle();
    
    setState(() => _isLoading = false);
    
    if (user != null) {
      // ✅ Check onboarding status and navigate
      final userService = Get.find<UserService>();
      
      // Wait for user profile to load
      await Future.delayed(const Duration(milliseconds: 800));
      
      final userProfile = userService.currentUser.value;
      
      if (userProfile == null) {
        print('⚠️ No user profile found after Google sign-in');
        return;
      }
      
      // Navigate based on onboarding status
      if (userProfile.hasCompletedOnboarding) {
        print('🏠 Navigating to home screen...');
        Get.offAll(() => const MainScreen());
      } else {
        print('📋 User needs to complete onboarding');
        // For now, still go to home (you can add onboarding navigation later)
        Get.offAll(() => const MainScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // JUSTFIT! Logo
                Text(
                  'JUSTFIT!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE91E63),
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Title
                Text(
                  'Log in to access your\npersonal fitness plan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  showValidIcon: _isEmailValid,
                ),
                
                const SizedBox(height: 16),
                
                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  hint: 'Password ( 8+ characters.)',
                  obscureText: !_isPasswordVisible,
                  showVisibilityToggle: true,
                  onVisibilityToggle: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Forgot Password
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                      Get.snackbar(
                        'Coming Soon',
                        'Password reset feature will be available soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text(
                      'Forgot password',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Terms & Conditions Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() => _agreedToTerms = value ?? false);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          children: [
                            const TextSpan(text: 'I confirm that i have read and agreed to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isFormValid && !_isLoading) ? _handleLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid 
                          ? const Color(0xFFE91E63) 
                          : Colors.grey[300],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Log in',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't have an account?  ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const SignupScreen());
                      },
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE91E63),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 80),
                
                // Or login with others
                GestureDetector(
                  onTap: () {
                    setState(() => _showOtherOptions = !_showOtherOptions);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Or login with others',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _showOtherOptions 
                            ? Icons.keyboard_arrow_up 
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ],
                  ),
                ),
                
                if (_showOtherOptions) ...[
                  const SizedBox(height: 24),
                  
                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Facebook Button (placeholder)
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        onTap: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Facebook login will be available soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      
                      const SizedBox(width: 32),
                      
                      // Google Button
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        color: const Color(0xFFDB4437),
                        onTap: _isLoading ? null : _handleGoogleSignIn,
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool showValidIcon = false,
    bool showVisibilityToggle = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          border: InputBorder.none,
          suffixIcon: showValidIcon
              ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
              : showVisibilityToggle
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[400],
                        size: 22,
                      ),
                      onPressed: onVisibilityToggle,
                    )
                  : null,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}