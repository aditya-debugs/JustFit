class AppKeys {
  // Singleton instances for each key category
  static SPKeys spKeys = const SPKeys();
  static APIKeys apiKeys = const APIKeys();
  static AnalyticsKeys analyticsKeys = const AnalyticsKeys();
}

// SharedPreferences Keys
class SPKeys {
  const SPKeys();

  String get isFirstLaunch => 'is_first_launch';
  String get userId => 'user_id';
  String get userName => 'user_name';
  String get languageCode => 'language_code';
  String get themeMode => 'theme_mode';
  String get notificationsEnabled => 'notifications_enabled';
  String get lastSyncTime => 'last_sync_time';
  String get hasPremium => 'has_premium';
}

// API Keys (placeholder for now)
class APIKeys {
  const APIKeys();

  String get baseUrl => 'https://api.justfit.com';
  String get apiVersion => 'v1';
  String get timeoutSeconds => '30';
}

// Analytics Event Keys
class AnalyticsKeys {
  const AnalyticsKeys();

  // Screen names
  String get homeScreen => 'home_screen';
  String get workoutScreen => 'workout_screen';
  String get profileScreen => 'profile_screen';
  String get settingsScreen => 'settings_screen';

  // Events
  String get appOpened => 'app_opened';
  String get workoutStarted => 'workout_started';
  String get workoutCompleted => 'workout_completed';
  String get exerciseViewed => 'exercise_viewed';
}