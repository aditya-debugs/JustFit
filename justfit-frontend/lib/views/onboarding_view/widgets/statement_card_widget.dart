import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatementCardWidget extends StatelessWidget {
  final String statement;
  final String imagePath;
  final Function(bool) onAnswer;

  const StatementCardWidget({
    Key? key,
    required this.statement,
    required this.imagePath,
    required this.onAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Do you relate to the statement below?',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 40),

        // Image with statement
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Yes/No buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              // No button
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print('🔴 NO button tapped for: "$statement"');
                      onAnswer(false);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE8E8E8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            size: 40,
                            color: const Color(0xFFFA2A55),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Yes button
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print('✅ YES button tapped for: "$statement"');
                      onAnswer(true);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE8E8E8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            size: 40,
                            color: const Color(0xFF4CAF50),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Yes',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
