import 'package:flutter/material.dart';  // ← ADD THIS LINE

enum AchievementType {
  firstWorkout,
  twoWorkouts,
  threeWorkouts,
  fiveWorkouts,
  tenWorkouts,
  twoDayStreak,
  threeDayStreak,
  fiveDayStreak,
  sevenDayStreak,
  tenDayStreak,
  thirtyDayStreak,
}

class AchievementModel {
  final AchievementType type;
  final String title;
  final String description;
  final int badgeNumber;
  final BadgeStyle badgeStyle;

  AchievementModel({
    required this.type,
    required this.title,
    required this.description,
    required this.badgeNumber,
    required this.badgeStyle,
  });

  // Workout count achievements
  static AchievementModel get firstWorkout => AchievementModel(
        type: AchievementType.firstWorkout,
        title: '1st Workout Complete!',
        description: 'You earned this badge by completing your first workout with JustFit.',
        badgeNumber: 1,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFB388FF), // Purple
          accentColor: const Color(0xFF8E24AA),
        ),
      );

  static AchievementModel get twoWorkouts => AchievementModel(
        type: AchievementType.twoWorkouts,
        title: '2 Workouts Done!',
        description: 'You\'re building momentum! Keep pushing forward.',
        badgeNumber: 2,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFF4FC3F7), // Light Blue
          accentColor: const Color(0xFF0288D1),
        ),
      );

  static AchievementModel get threeWorkouts => AchievementModel(
        type: AchievementType.threeWorkouts,
        title: '3 Workouts Achieved!',
        description: 'Three down! You\'re making this a habit.',
        badgeNumber: 3,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFF81C784), // Green
          accentColor: const Color(0xFF388E3C),
        ),
      );

  static AchievementModel get fiveWorkouts => AchievementModel(
        type: AchievementType.fiveWorkouts,
        title: '5 Workouts Complete!',
        description: 'Five workouts down! You\'re on fire!',
        badgeNumber: 5,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFFFB74D), // Orange
          accentColor: const Color(0xFFF57C00),
        ),
      );

  static AchievementModel get tenWorkouts => AchievementModel(
        type: AchievementType.tenWorkouts,
        title: '10 Workouts Milestone!',
        description: 'Double digits! You\'re a fitness champion!',
        badgeNumber: 10,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFFFD700), // Gold
          accentColor: const Color(0xFFFFA000),
        ),
      );

  // Streak achievements (UPDATED with 2-day and 3-day)
  static AchievementModel get twoDayStreak => AchievementModel(
        type: AchievementType.twoDayStreak,
        title: '2-Day Streak!',
        description: 'Two days in a row! You\'re building consistency!',
        badgeNumber: 2,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFFF6B9D), // Pink
          accentColor: const Color(0xFFE91E63),
        ),
      );

  static AchievementModel get threeDayStreak => AchievementModel(
        type: AchievementType.threeDayStreak,
        title: '3-Day Streak!',
        description: 'Three days strong! Keep the momentum going!',
        badgeNumber: 3,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFF64B5F6), // Blue
          accentColor: const Color(0xFF1976D2),
        ),
      );

  // Update existing streak achievements
  static AchievementModel get fiveDayStreak => AchievementModel(
        type: AchievementType.fiveDayStreak,
        title: '5-Day Streak!',
        description: 'Amazing! Five consecutive days of training!',
        badgeNumber: 5,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFF64B5F6), // Blue
          accentColor: const Color(0xFF1976D2),
        ),
      );

  static AchievementModel get sevenDayStreak => AchievementModel(
        type: AchievementType.sevenDayStreak,
        title: '7-Day Streak!',
        description: 'A full week of workouts! You\'re unstoppable!',
        badgeNumber: 7,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFFFD54F), // Gold
          accentColor: const Color(0xFFFFA000),
        ),
      );

  static AchievementModel get tenDayStreak => AchievementModel(
        type: AchievementType.tenDayStreak,
        title: '10-Day Streak!',
        description: 'Ten days straight! You\'re a fitness champion!',
        badgeNumber: 10,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFF4CAF50), // Green
          accentColor: const Color(0xFF2E7D32),
        ),
      );

  static AchievementModel get thirtyDayStreak => AchievementModel(
        type: AchievementType.thirtyDayStreak,
        title: '30-Day Streak!',
        description: 'A full month! You\'ve built an unbreakable habit!',
        badgeNumber: 30,
        badgeStyle: BadgeStyle(
          primaryColor: const Color(0xFFFF5722), // Deep Orange
          accentColor: const Color(0xFFD84315),
        ),
      );

  // Get achievement by workout count
  static AchievementModel? getByWorkoutCount(int count) {
    if (count == 1) return firstWorkout;
    if (count == 2) return twoWorkouts;
    if (count == 3) return threeWorkouts;
    if (count == 5) return fiveWorkouts;
    if (count == 10) return tenWorkouts;
    return null;
  }

  // Get achievement by streak count
  static AchievementModel? getByStreak(int streak) {
    if (streak == 2) return twoDayStreak;
    if (streak == 3) return threeDayStreak;
    if (streak == 5) return fiveDayStreak;
    if (streak == 7) return sevenDayStreak;
    if (streak == 10) return tenDayStreak;
    if (streak == 30) return thirtyDayStreak;
    return null;
  }
}

class BadgeStyle {
  final Color primaryColor;
  final Color accentColor;

  BadgeStyle({
    required this.primaryColor,
    required this.accentColor,
  });
}


