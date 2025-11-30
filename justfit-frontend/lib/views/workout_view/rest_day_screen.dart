import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RestDayScreen extends StatelessWidget {
  final int dayNumber;
  final String? description;

  const RestDayScreen({
    Key? key,
    required this.dayNumber,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Rest Day Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.spa,
                            size: 60,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        // Title
                        Text(
                          'Rest Day',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Description
                        Text(
                          description ?? 'Take it easy today! Recovery is just as important as training.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: 48),
                        
                        // Light Activities
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Suggested Light Activities',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildActivity('🚶‍♀️', 'Light walking (15-20 min)'),
                              _buildActivity('🧘‍♀️', 'Gentle stretching'),
                              _buildActivity('💆‍♀️', 'Foam rolling or massage'),
                              _buildActivity('💤', 'Extra sleep if needed'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Mark as Complete Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Mark rest day as complete
                    Get.back();
                    Get.snackbar(
                      '✅ Rest Day Logged',
                      'Great job taking care of your recovery!',
                      backgroundColor: Colors.green.withOpacity(0.9),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(16),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Mark as Complete',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActivity(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}