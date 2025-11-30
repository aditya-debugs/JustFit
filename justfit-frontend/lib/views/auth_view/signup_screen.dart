import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';
import 'login_screen.dart';
import 'name_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  Future<void> _handleSignup() async {
    if (!_isFormValid) return;

    // Navigate to name screen instead of creating account immediately
    Get.to(() => NameScreen(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    ));
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);
    
    if (user != null) {
      // If Google sign-in successful, still go to name screen to complete profile
      Get.to(() => NameScreen(
        email: user.email ?? '',
        password: '',
        isGoogleSignIn: true,
      ));
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
                  'Create an account to track\nyour progress',
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
                
                const SizedBox(height: 40),
                
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
                
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isFormValid && !_isLoading) ? _handleSignup : null,
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
                            'Sign up',
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
                      "Already have an account?  ",
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
                
                const SizedBox(height: 80),
                
                // Or sign up with others
                GestureDetector(
                  onTap: () {
                    setState(() => _showOtherOptions = !_showOtherOptions);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Or sign up with others',
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