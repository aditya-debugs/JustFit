class UserPreferences {
  final String measurementUnit; // 'metric' or 'imperial'
  final bool notificationsEnabled;
  final String? notificationTime; // HH:mm format
  final bool soundEnabled;
  final bool voiceGuidanceEnabled;
  final String language; // 'en', 'es', etc.
  
  UserPreferences({
    this.measurementUnit = 'metric',
    this.notificationsEnabled = true,
    this.notificationTime,
    this.soundEnabled = true,
    this.voiceGuidanceEnabled = false,
    this.language = 'en',
  });

  factory UserPreferences.defaultPreferences() {
    return UserPreferences();
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      measurementUnit: map['measurementUnit'] ?? 'metric',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      notificationTime: map['notificationTime'],
      soundEnabled: map['soundEnabled'] ?? true,
      voiceGuidanceEnabled: map['voiceGuidanceEnabled'] ?? false,
      language: map['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measurementUnit': measurementUnit,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime,
      'soundEnabled': soundEnabled,
      'voiceGuidanceEnabled': voiceGuidanceEnabled,
      'language': language,
    };
  }
}
