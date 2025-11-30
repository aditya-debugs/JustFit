import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/workout_plan_controller.dart';
import '../../core/constants/app_colors.dart';

class RestDayScreen extends StatelessWidget {
  final int dayNumber;
  final String? description;
  final bool isLocked;

  const RestDayScreen({
    Key? key,
    required this.dayNumber,
    this.description,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutPlanController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.close, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rest Day Icon with elegant design
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '🌿',
                          style: const TextStyle(fontSize: 70),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Rest Day',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Suggested Activities Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Suggested Light Activities',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildActivity('🚶‍♀️', 'Light walking (15-20 min)'),
                          const SizedBox(height: 4),
                          _buildActivity('🧘‍♀️', 'Gentle stretching'),
                          const SizedBox(height: 4),
                          _buildActivity('💆‍♀️', 'Foam rolling or massage'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: _buildMarkCompleteButton(controller, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkCompleteButton(
      WorkoutPlanController controller, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLocked) {
            _showLockedDialog(context);
          } else {
            _markAsComplete(controller, context);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 56,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  'Mark as Completed',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFF3E5F5),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Title
                Text(
                  'Take it easy!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  'Don\'t rush! Please complete previous days workout first!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Icon with day number
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Day ${dayNumber - 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // OK Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        child: Text(
                          'OK',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _markAsComplete(
      WorkoutPlanController controller, BuildContext context) async {
    try {
      // Mark the rest day as completed
      await controller.markDayAsCompleted(dayNumber);

      // Update streak (rest days count for streak maintenance)
      await controller.updateStreakAfterWorkout(dayNumber);

      // Close the screen
      Get.back();

      // Show success message with app theme colors
      Get.snackbar(
        '',
        '',
        titleText: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              'Rest Day Completed',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        messageText: Text(
          'Great job taking care of your recovery!',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Error marking rest day complete: $e');
      Get.snackbar(
        'Error',
        'Failed to mark rest day as complete. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
