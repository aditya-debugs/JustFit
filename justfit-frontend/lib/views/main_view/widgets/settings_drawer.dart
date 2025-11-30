import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../auth_view/login_screen.dart';
import '../../welcome_view/welcome_screen.dart';
import '../../../controllers/onboarding_controller.dart';
import '../../../controllers/workout_plan_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SETTINGS',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Support Section
            _buildSectionHeader('Support'),
            _buildMenuItem(
              title: 'Help center',
              onTap: () {
                Get.snackbar(
                  'Support',
                  'Contact us at support@justfit.com',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildMenuItem(
              title: 'Submit a request',
              onTap: () {
                Get.snackbar(
                  'Support',
                  'Feature coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // General Section
            _buildSectionHeader('General'),
            _buildMenuItem(
              title: 'Language',
              trailing: 'English',
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionHeader('About'),
            _buildMenuItem(
              title: 'Privacy Policy',
              onTap: () {
                Get.snackbar(
                  'Privacy',
                  'Your privacy matters to us',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildMenuItem(
              title: 'Terms of Service',
              onTap: () {
                Get.snackbar(
                  'Terms',
                  'Terms of service',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            _buildMenuItem(
              title: 'Feedback',
              onTap: () {
                Get.snackbar(
                  'Feedback',
                  'We value your feedback',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Account Section
            _buildSectionHeader('Account'),
            _buildMenuItem(
              title: 'Log Out',
              showUnderline: true,
              onTap: () => _showLogoutDialog(context),
            ),
            _buildMenuItem(
              title: 'Delete Account',
              showUnderline: true,
              textColor: Colors.red,
              onTap: () => _showDeleteAccountDialog(context),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE31E52),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    String? trailing,
    bool showUnderline = false,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: showUnderline
              ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: textColor ?? Colors.black87,
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            if (trailing == null && onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
                    Navigator.pop(context);
                    
                    // ✅ CLEAR ALL USER DATA
                    await FirebaseAuth.instance.signOut();
                    
                    // ✅ RESET ONBOARDING CONTROLLER
                    if (Get.isRegistered<OnboardingController>()) {
                      Get.delete<OnboardingController>();
                    }
                    
                    // ✅ RESET WORKOUT PLAN CONTROLLER
                    if (Get.isRegistered<WorkoutPlanController>()) {
                      Get.delete<WorkoutPlanController>();
                    }
                    
                    Get.offAll(() => const WelcomeScreen());
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Feature Coming Soon',
                'Account deletion will be available soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}