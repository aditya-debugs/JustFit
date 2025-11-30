import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_photo_screen.dart';

class NameScreen extends StatefulWidget {
  final String email;
  final String password;
  final bool isGoogleSignIn;

  const NameScreen({
    Key? key,
    required this.email,
    required this.password,
    this.isGoogleSignIn = false,
  }) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _nameController = TextEditingController();
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
    });
  }

  void _handleNext() {
    if (!_isNameValid) return;

    Get.to(() => ProfilePhotoScreen(
      email: widget.email,
      password: widget.password,
      name: _nameController.text.trim(),
      isGoogleSignIn: widget.isGoogleSignIn,
    ));
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
          'NAME',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
              const SizedBox(height: 60),
              
              // Question
              Text(
                "What's your name?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Name Input
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Colors.grey[300],
                  ),
                ),
                autofocus: true,
              ),
              
              // Underline
              Container(
                height: 2,
                width: 200,
                color: const Color(0xFFE91E63),
              ),
              
              const Spacer(),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isNameValid ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNameValid 
                        ? Colors.black 
                        : Colors.grey[300],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Next',
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