/// Global app configuration
/// Toggle testing mode for quick workout testing
class AppConfig {
  // ✅ SET TO TRUE FOR TESTING, FALSE FOR PRODUCTION
  // static const bool isTestingMode = true; // ← COMMENTED OUT FOR PRODUCTION
  static const bool isTestingMode = false; // ← PRODUCTION MODE

  // Backend URL Configuration
  static const String backendUrl =
      'https://justfit.onrender.com'; // Production Render URL
  static const String apiBaseUrl = '$backendUrl/api';

  // Testing configuration
  static const int testExerciseDuration = 5; // seconds per exercise
  static const int testMinimumDuration = 1; // minutes (70% = 0.7 min)
  static const double testQualityThreshold = 0.5; // 50% instead of 70%

  // Production configuration
  static const double productionQualityThreshold = 0.7; // 70%

  // Computed values based on mode
  static int get exerciseDurationOverride =>
      isTestingMode ? testExerciseDuration : 0;
  static int get minimumWorkoutDuration =>
      isTestingMode ? testMinimumDuration : 0;
  static double get qualityThreshold =>
      isTestingMode ? testQualityThreshold : productionQualityThreshold;

  static String get modeLabel =>
      isTestingMode ? "🧪 TEST MODE" : "🚀 PRODUCTION";
}
