import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart';
import '../../core/routes/app_routes.dart';
import '../../views/onboarding_view/screens/part_transition_screen.dart';
import '../../views/onboarding_view/screens/onboarding_question_screen.dart';
import '../../data/datasources/onboarding_data.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final bool isGoogleSignIn;

  const ProfilePhotoScreen({
    Key? key,
    required this.email,
    required this.password,
    required this.name,
    this.isGoogleSignIn = false,
  }) : super(key: key);

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final _authService = Get.find<AuthService>();
  final _userService = Get.find<UserService>();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Change Avatar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Take Photo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color(0xFF007AFF),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(
                  'Choose from Album',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color(0xFF007AFF),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF007AFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _handleFinish() async {
  setState(() => _isLoading = true);

  try {
    // Create account if not Google sign-in
    if (!widget.isGoogleSignIn) {
      final user = await _authService.signUp(
        email: widget.email,
        password: widget.password,
        name: widget.name,
      );

      if (user == null) {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Error',
          'Failed to create account. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      print('✅ Firebase Auth user created: ${user.uid}');
      
      // ✅ IMPORTANT: Create user document in Firestore
      try {
        await _userService.createUser(
          uid: user.uid,
          email: user.email ?? widget.email,
          displayName: user.displayName ?? widget.name,
          photoUrl: user.photoURL,
          isAnonymous: false,
        );
        
        print('✅ User document created in Firestore');
      } catch (firestoreError) {
        print('❌ Firestore error: $firestoreError');
        // Continue anyway - user is authenticated, document creation can be retried
      }
    } else {
      // Google sign-in case
      final user = _authService.firebaseUser.value;
      if (user != null) {
        try {
          await _userService.createUser(
            uid: user.uid,
            email: user.email ?? widget.email,
            displayName: user.displayName ?? widget.name,
            photoUrl: user.photoURL,
            isAnonymous: false,
          );
        } catch (e) {
          print('❌ Error creating user document for Google sign-in: $e');
        }
      }
    }

    // TODO: Upload profile photo if selected

    setState(() => _isLoading = false);

    // ✅ UPDATED: Navigate to Part 1 Transition which starts the onboarding flow
    print('🚀 Starting onboarding from Part 1...');
    
    Get.offAll(
      () => PartTransitionScreen(
        partNumber: 1,
        partTitle: 'Goal',
        onComplete: () {
          // Call the public method from AppRoutes to start the flow
          AppRoutes.startOnboardingFlow();
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    
  } catch (e) {
    print('❌ Error finishing signup: $e');
    setState(() => _isLoading = false);
    
    // Check if it's an "email already in use" error
    if (e.toString().contains('email-already-in-use')) {
      Get.snackbar(
        'Account Exists',
        'This email is already registered. Please log in instead.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error', 
        'Failed to complete signup. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'JUSTFIT!',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE91E63),
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Title
              Text(
                'Change your Profile photo',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Profile Image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey[400],
                      ),
              ),
              
              const SizedBox(height: 24),
              
              // Name
              Text(
                widget.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Change Photo Button
              OutlinedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.camera_alt, color: Color(0xFFE91E63)),
                label: Text(
                  'Change Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE91E63),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  side: const BorderSide(color: Color(0xFFE91E63), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Finish Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
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
                          'Finish',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
