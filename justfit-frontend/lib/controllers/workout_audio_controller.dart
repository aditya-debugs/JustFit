import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class WorkoutAudioController extends GetxController {
  // Background music player
  late AudioPlayer _backgroundMusicPlayer;

  // TTS for voice guidance
  late FlutterTts _tts;

  // Settings
  RxBool isBackgroundMusicEnabled = true.obs;
  RxBool isAudioGuidanceEnabled = true.obs;
  RxBool useExternalMusic = false.obs;

  // State
  RxBool isPlayingMusic = false.obs;
  RxBool isWorkoutPaused = false.obs;
  bool _isSpeaking = false;
  bool _isCountingDown = false;

  // Track messages to avoid repetition
  final List<String> _usedMotivationalMessages = [];
  String? _currentCyclePhase;

// Motivational messages - General (high energy, short)
  final List<String> _generalMotivation = [
    "You're halfway there, keep going!",
    "You're doing great, keep it up!",
    "Don't lose hope, you've got this!",
    "Amazing work, stay strong!",
    "Keep that fire burning!",
    "You're crushing it!",
    "Stay focused, almost there!",
    "Feel that power, yes!",
  ];

// Cycle-aware motivational messages (gentle, caring)
  final Map<String, List<String>> _cycleMotivation = {
    'menstruation': [
      "Don't exert too much, take care of your body!",
      "Listen to your body, gentle is strong!",
      "You're doing amazing, be kind to yourself!",
      "Honor your body today, you're doing great!",
    ],
    'follicular': [
      "Your energy is building, but pace yourself!",
      "You're getting stronger every day!",
      "Feel that momentum, you're unstoppable!",
      "Keep building that strength!",
    ],
    'ovulation': [
      "Peak power time, but don't overdo it!",
      "You're at your strongest, enjoy it!",
      "This is your moment, stay balanced!",
      "Unleash that energy wisely!",
    ],
    'luteal': [
      "Steady pace, take care of yourself!",
      "Quality over intensity, you're perfect!",
      "Listen and adjust, that's smart!",
      "Be gentle, you're doing wonderful!",
    ],
  };

  // Rest messages for different rounds
  final List<String> _restMessages = [
    "Great work! Take a breather, you earned it!",
    "Rest up! Prepare for the next round!",
    "Excellent! Use this time to recover!",
    "Nice job! Catch your breath, next round coming up!",
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeAudio();
    _loadSettings();
  }

  Future<void> _initializeAudio() async {
    // Background music setup
    _backgroundMusicPlayer = AudioPlayer();
    _backgroundMusicPlayer.setLoopMode(LoopMode.one);
    _backgroundMusicPlayer.setVolume(0.25);

    try {
      await _backgroundMusicPlayer.setAsset('assets/audio/workout_music.mp3');
    } catch (e) {
      print('⚠️ Background music file not found (app will work without it)');
    }

    // TTS setup
    _tts = FlutterTts();
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      if (!_isCountingDown) {
        _restoreMusicVolume();
      }
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isBackgroundMusicEnabled.value = prefs.getBool('backgroundMusic') ?? true;
    isAudioGuidanceEnabled.value = prefs.getBool('audioGuidance') ?? true;
    useExternalMusic.value = prefs.getBool('useExternalMusic') ?? false;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backgroundMusic', isBackgroundMusicEnabled.value);
    await prefs.setBool('audioGuidance', isAudioGuidanceEnabled.value);
    await prefs.setBool('useExternalMusic', useExternalMusic.value);
  }

  /// Set user's cycle phase for personalized messages
  void setCyclePhase(String? intensity) {
    if (intensity == null) {
      _currentCyclePhase = null;
      return;
    }

    if (intensity.toLowerCase().contains('menstruation')) {
      _currentCyclePhase = 'menstruation';
    } else if (intensity.toLowerCase().contains('follicular')) {
      _currentCyclePhase = 'follicular';
    } else if (intensity.toLowerCase().contains('ovulation') ||
        intensity.toLowerCase().contains('peak')) {
      _currentCyclePhase = 'ovulation';
    } else if (intensity.toLowerCase().contains('luteal') ||
        intensity.toLowerCase().contains('pms')) {
      _currentCyclePhase = 'luteal';
    } else {
      _currentCyclePhase = null;
    }
  }

  // ========== BACKGROUND MUSIC CONTROLS ==========

  Future<void> startBackgroundMusic() async {
    if (!isBackgroundMusicEnabled.value) return;
    if (useExternalMusic.value) return;
    if (isWorkoutPaused.value) return;

    try {
      await _backgroundMusicPlayer.play();
      isPlayingMusic.value = true;
      print('✅ Background music started');
    } catch (e) {
      print('⚠️ Background music error: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.pause();
      isPlayingMusic.value = false;
      print('⏸️ Background music paused');
    } catch (e) {
      print('⚠️ Pause error: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (useExternalMusic.value) return;
    if (!isBackgroundMusicEnabled.value) return;
    if (isWorkoutPaused.value) return;

    try {
      await _backgroundMusicPlayer.play();
      isPlayingMusic.value = true;
      print('▶️ Background music resumed');
    } catch (e) {
      print('⚠️ Resume error: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      // ✅ CRITICAL FIX: Ensure complete stop by pausing first, then stopping
      await _backgroundMusicPlayer.pause();
      await _backgroundMusicPlayer.stop();
      await _backgroundMusicPlayer.seek(Duration.zero); // Reset position
      isPlayingMusic.value = false;
      print('⏹️ Background music stopped and reset');
    } catch (e) {
      print('⚠️ Stop error: $e');
      // Force state update even if stop fails
      isPlayingMusic.value = false;
    }
  }

  Future<void> toggleBackgroundMusic() async {
    isBackgroundMusicEnabled.value = !isBackgroundMusicEnabled.value;

    if (isBackgroundMusicEnabled.value && useExternalMusic.value) {
      useExternalMusic.value = false;
    }

    await _saveSettings();

    if (isBackgroundMusicEnabled.value &&
        !useExternalMusic.value &&
        !isWorkoutPaused.value) {
      await startBackgroundMusic();
    } else {
      await pauseBackgroundMusic();
    }
  }

  void setWorkoutPaused(bool isPaused) {
    isWorkoutPaused.value = isPaused;

    if (isPaused) {
      pauseBackgroundMusic();
      // Stop any ongoing TTS
      _tts.stop();
      _isSpeaking = false;
      _isCountingDown = false;
    } else {
      if (isBackgroundMusicEnabled.value && !useExternalMusic.value) {
        resumeBackgroundMusic();
      }
    }
  }

  void _duckMusicVolume() {
    if (isPlayingMusic.value) {
      _backgroundMusicPlayer.setVolume(0.08);
    }
  }

  void _restoreMusicVolume() {
    if (isPlayingMusic.value) {
      _backgroundMusicPlayer.setVolume(0.25);
    }
  }

  // ========== TTS VOICE GUIDANCE ==========

  Future<void> _speakInternal(String text) async {
    if (!isAudioGuidanceEnabled.value) return;

    _duckMusicVolume();

    try {
      await _tts.speak(text);
      // ✅ Add a small delay to ensure TTS completes
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      print('⚠️ TTS error: $e');
    } finally {
      // ✅ Always restore volume in finally block
      _isSpeaking = false;
      _restoreMusicVolume();
    }
  }

  /// Stop any ongoing speech (used when exercise is skipped)
  Future<void> stopCurrentSpeech() async {
    await _tts.stop();
    _isSpeaking = false;
    _isCountingDown = false;
    _restoreMusicVolume();
  }

  Future<void> toggleAudioGuidance() async {
    isAudioGuidanceEnabled.value = !isAudioGuidanceEnabled.value;
    await _saveSettings();

    if (!isAudioGuidanceEnabled.value) {
      await stopCurrentSpeech();
    }
  }

  Future<void> toggleExternalMusic() async {
    useExternalMusic.value = !useExternalMusic.value;
    await _saveSettings();

    if (useExternalMusic.value) {
      isBackgroundMusicEnabled.value = false;
      await stopBackgroundMusic();
    }
  }

  // ========== WORKOUT-SPECIFIC AUDIO CUES ==========

  /// Called at the start of "Get Ready" phase
  Future<void> playGetReadyForExercise(String exerciseName,
      {bool isFirstExercise = false}) async {
    if (!isAudioGuidanceEnabled.value) return;
    if (_isSpeaking || _isCountingDown) return;

    _isSpeaking = true;

    // ✅ Special message for first exercise
    if (isFirstExercise) {
      await _speakInternal(
          "Let's get started! Get ready for your first exercise!");
    } else {
      await _speakInternal("Get ready for $exerciseName");
    }

    _isSpeaking = false;
  }

  /// Called when "Get Ready" timer reaches 3.5 seconds
  Future<void> playCountdown321Go() async {
    if (!isAudioGuidanceEnabled.value) return;
    if (_isCountingDown) return;

    _isCountingDown = true;
    _duckMusicVolume();

    try {
      await _tts.speak("3");
      await Future.delayed(const Duration(milliseconds: 900));

      await _tts.speak("2");
      await Future.delayed(const Duration(milliseconds: 900));

      await _tts.speak("1");
      await Future.delayed(const Duration(milliseconds: 900));

      await _tts.speak("GO!");
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('⚠️ Countdown error: $e');
    }

    _isCountingDown = false;
    _restoreMusicVolume();
  }

  /// Random mid-workout motivation (called during exercise)
  Future<void> playRandomMotivation() async {
    if (!isAudioGuidanceEnabled.value) return;
    if (_isSpeaking || _isCountingDown) return;

    // Choose message based on cycle phase if available
    List<String> messagePool;
    if (_currentCyclePhase != null &&
        _cycleMotivation.containsKey(_currentCyclePhase)) {
      messagePool = _cycleMotivation[_currentCyclePhase]!;
    } else {
      messagePool = _generalMotivation;
    }

    // Filter out recently used messages
    final availableMessages = messagePool
        .where((msg) => !_usedMotivationalMessages.contains(msg))
        .toList();

    if (availableMessages.isEmpty) {
      _usedMotivationalMessages.clear();
      return playRandomMotivation(); // Retry with reset pool
    }

    final random = Random();
    final message = availableMessages[random.nextInt(availableMessages.length)];

    _usedMotivationalMessages.add(message);
    if (_usedMotivationalMessages.length > messagePool.length ~/ 2) {
      _usedMotivationalMessages.removeAt(0); // Keep only recent half
    }

    _isSpeaking = true;
    await _speakInternal(message);
    _isSpeaking = false;
  }

  /// Called when rest period starts (between rounds)
  Future<void> playRestTime(int roundJustCompleted) async {
    if (!isAudioGuidanceEnabled.value) return;
    if (_isSpeaking || _isCountingDown) return;

    final random = Random();
    final baseMessage = _restMessages[random.nextInt(_restMessages.length)];

    _isSpeaking = true;
    await _speakInternal(baseMessage);
    _isSpeaking = false;
  }

  /// Called when workout is complete (on WorkoutCompleteScreen)
  Future<void> playWorkoutComplete() async {
    if (!isAudioGuidanceEnabled.value) return;

    // ✅ Ensure we're not speaking or counting down
    if (_isSpeaking || _isCountingDown) {
      await stopCurrentSpeech();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // ✅ Always use the energetic "Woo-hoo" message
    const message =
        "Woo-hoo! Congratulations! You just crushed that workout! You're one step closer to your goals. Keep up the amazing work!";

    _isSpeaking = true;
    await _speakInternal(message);
    _isSpeaking = false;
  }

  // ========== EXTERNAL MUSIC CONTROLS ==========

  Future<void> enableExternalMusic() async {
    useExternalMusic.value = true;
    isBackgroundMusicEnabled.value = false;
    await _saveSettings();
    await stopBackgroundMusic();
  }

  Future<void> disableExternalMusic() async {
    useExternalMusic.value = false;
    await _saveSettings();

    if (isBackgroundMusicEnabled.value && !isWorkoutPaused.value) {
      await startBackgroundMusic();
    }
  }

  @override
  void onClose() {
    _backgroundMusicPlayer.dispose();
    _tts.stop();
    super.onClose();
  }
}
