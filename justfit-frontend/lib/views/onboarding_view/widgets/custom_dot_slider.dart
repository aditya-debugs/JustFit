// lib/views/onboarding_view/widgets/custom_dot_slider.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDotSlider extends StatelessWidget {
  final int totalDots;
  final int selectedIndex;
  final Function(int) onChanged;
  final String? leftLabel;
  final String? rightLabel;
  final Color selectedColor;
  final Color unselectedColor;
  final Color trackColor;
  final bool showLabels;
  
  const CustomDotSlider({
    Key? key,
    required this.totalDots,
    required this.selectedIndex,
    required this.onChanged,
    this.leftLabel,
    this.rightLabel,
    this.selectedColor = const Color(0xFFFA2A55),
    this.unselectedColor = const Color(0xFFB0B0B0),
    this.trackColor = const Color(0xFFE8E8E8),
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          // Slider
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) => _handleInteraction(context, details.localPosition.dx),
            onHorizontalDragUpdate: (details) => _handleInteraction(context, details.localPosition.dx),
            onPanUpdate: (details) => _handleInteraction(context, details.localPosition.dx),
            child: SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background track (thick)
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 16.0,
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  
                  // Dots row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalDots, (index) {
                      bool isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () => onChanged(index),
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: isSelected ? 28 : 7,
                            height: isSelected ? 28 : 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : unselectedColor,
                              border: isSelected
                                  ? Border.all(
                                      color: selectedColor,
                                      width: 3.0,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          if (showLabels && leftLabel != null && rightLabel != null) ...[
            const SizedBox(height: 8),
            // Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leftLabel!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  Text(
                    rightLabel!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleInteraction(BuildContext context, double localX) {
    double sliderWidth = MediaQuery.of(context).size.width - 80;
    
    double percentage = localX / sliderWidth;
    int newIndex = (percentage * (totalDots - 1)).round().clamp(0, totalDots - 1);
    
    if (newIndex != selectedIndex) {
      onChanged(newIndex);
    }
  }
}