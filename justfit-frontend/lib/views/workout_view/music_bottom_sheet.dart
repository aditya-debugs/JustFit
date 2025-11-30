import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/workout_audio_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicBottomSheet extends StatelessWidget {
  const MusicBottomSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const MusicBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<WorkoutAudioController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Row(
              children: [
                Text(
                  'Music',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Audio Guidance Section
            _buildSectionTitle('Audio Guidance'),
            const SizedBox(height: 16),
            Obx(() => _buildToggleRow(
                  'Default Audio',
                  audioController.isAudioGuidanceEnabled.value,
                  () => audioController.toggleAudioGuidance(),
                  enabled: true,
                )),
            const SizedBox(height: 32),

            // Background Music Section
            _buildSectionTitle('Background Music'),
            const SizedBox(height: 16),
            Obx(() => _buildToggleRow(
                  'Default Music',
                  audioController.isBackgroundMusicEnabled.value,
                  () => audioController.toggleBackgroundMusic(),
                  enabled: !audioController.useExternalMusic.value,
                )),
            const SizedBox(height: 24),

            // External Music Integration
            _buildSectionTitle('Other App'),
            const SizedBox(height: 16),
            _buildExternalMusicRow(context, audioController),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, VoidCallback onToggle, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: enabled ? Colors.black : Colors.grey[500],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: enabled ? onToggle : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: (value && enabled) ? const Color(0xFFE91E63) : Colors.grey[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: enabled ? Colors.white : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExternalMusicRow(BuildContext context, WorkoutAudioController controller) {
    return Obx(() => GestureDetector(
      onTap: controller.useExternalMusic.value 
          ? () {
              // ✅ If already in external mode, disable it and return to internal
              controller.disableExternalMusic();
              Navigator.pop(context);
              Get.snackbar(
                'Internal Music Enabled',
                'Switched back to app music',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black87,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
              );
            }
          : () async {
              // ✅ Try to launch external music app
              const spotifyUri = 'spotify://';
              const spotifyUrl = 'https://open.spotify.com';
              
              try {
                final spotifyUriParsed = Uri.parse(spotifyUri);
                final spotifyUrlParsed = Uri.parse(spotifyUrl);
                
                if (await canLaunchUrl(spotifyUriParsed)) {
                  await launchUrl(spotifyUriParsed);
                  await controller.enableExternalMusic();
                  Navigator.pop(context);
                } else if (await canLaunchUrl(spotifyUrlParsed)) {
                  await launchUrl(spotifyUrlParsed, mode: LaunchMode.externalApplication);
                  await controller.enableExternalMusic();
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Get.snackbar(
                    'External Music',
                    'Play music from any app (Spotify, Apple Music, YouTube Music, etc.) then start your workout',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 4),
                    margin: const EdgeInsets.all(16),
                  );
                  await controller.enableExternalMusic();
                }
              } catch (e) {
                Navigator.pop(context);
                Get.snackbar(
                  'External Music',
                  'Open your music app, play a playlist, then return to continue your workout',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                  margin: const EdgeInsets.all(16),
                );
                await controller.enableExternalMusic();
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          // ✅ Visual feedback when external music is active
          color: controller.useExternalMusic.value 
              ? const Color(0xFF1DB954).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: controller.useExternalMusic.value
              ? Border.all(color: const Color(0xFF1DB954), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                controller.useExternalMusic.value 
                    ? Icons.check_circle
                    : Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.useExternalMusic.value 
                        ? 'External Music Active'
                        : 'Spotify',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    controller.useExternalMusic.value
                        ? 'Tap to disable'
                        : 'Or any music app',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              controller.useExternalMusic.value
                  ? Icons.close
                  : Icons.chevron_right,
              color: Colors.grey[600],
              size: 24,
            ),
          ],
        ),
      ),
    ));
  }
}
