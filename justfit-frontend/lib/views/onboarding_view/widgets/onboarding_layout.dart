import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingLayout extends StatelessWidget {
  final String partTitle;
  final int currentPart;
  final int currentQuestionInPart;
  final int totalQuestionsInPart;
  final int totalParts;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget child;
 

  const OnboardingLayout({
    Key? key,
    required this.partTitle,
    this.currentPart = 1,
    this.currentQuestionInPart = 1,
    this.totalQuestionsInPart = 3,
    this.totalParts = 4,
    this.showBackButton = false,
    this.onBack,
    required this.child,
   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // FIXED HEADER (doesn't animate)
            _buildFixedHeader(),
            
            // ANIMATED CONTENT (slides in/out)
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        
        // Back button (if needed) + Part title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF666666),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                const SizedBox(width: 48), // Placeholder to keep title centered
              
              Expanded(
                child: Center(
                  child: Text(
                    partTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFA2A55),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 48), // Right spacer
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Progress bar
        _buildProgressBar(),
        
        const SizedBox(height: 8),
      ],
    );
  }

  // lib/views/onboarding_view/widgets/onboarding_layout.dart
// Add these parameters to the class (around line 10):


  Widget _buildProgressBar() {
  return Center(
    child: SizedBox(
      width: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalParts * 2 - 1,
          (index) {
            if (index.isOdd) {
              // Dot separator between parts
              final dotPartIndex = index ~/ 2; // Which part does this dot represent completion for?
              
              // Show checkmark on dot if the part before it is complete
              bool showCheckmark = dotPartIndex < currentPart - 1 || 
                                   (dotPartIndex == currentPart - 1 && 
                                    currentQuestionInPart == totalQuestionsInPart);
              
              return Container(
                width: 18, // Larger to accommodate checkmark
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showCheckmark 
                      ? const Color(0xFFFA2A55) // Red if complete
                      : const Color(0xFFD0D0D0), // Gray if not complete
                ),
                child: showCheckmark
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              );
            } else {
              // Progress bar segment for each part
              final partIndex = index ~/ 2;
              double partProgress = 0.0;

              // Calculate progress
              if (partIndex < currentPart - 1) {
                partProgress = 1.0;
              } else if (partIndex == currentPart - 1) {
                partProgress = currentQuestionInPart / totalQuestionsInPart;
              }

              return Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: partProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA2A55),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}
}
