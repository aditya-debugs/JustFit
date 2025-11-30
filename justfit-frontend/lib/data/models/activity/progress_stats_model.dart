import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressStatsModel {
  final String userId;
  final String planId;
  
  // Overall Progress
  final int totalDaysInPlan;
  final int completedDays;
  final int missedDays;
  final int currentDay;
  final double completionPercentage;
  
  // Current Streak
  final int currentStreak; // Consecutive days completed
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  
  // This Week Stats
  final int workoutsThisWeek;
  final int minutesThisWeek;
  final int caloriesThisWeek;
  
  // This Month Stats
  final int workoutsThisMonth;
  final int minutesThisMonth;
  final int caloriesThisMonth;
  
  // All-Time Stats
  final int totalWorkoutsCompleted;
  final int totalMinutesExercised;
  final int totalCaloriesBurned;
  final int totalDaysActive;
  
  // Weekly Breakdown (for charts)
  final Map<String, int> weeklyActivity; // {Mon: 1, Tue: 0, Wed: 1...}
  
  // Body Measurements (optional tracking)
  final List<BodyMeasurement> bodyMeasurements;
  
  // Goals & Achievements
  final int goalsAchieved;
  final List<String> badges; // Achievement badge IDs
  
  // Timestamps
  final DateTime updatedAt;

  ProgressStatsModel({
    required this.userId,
    required this.planId,
    required this.totalDaysInPlan,
    this.completedDays = 0,
    this.missedDays = 0,
    this.currentDay = 1,
    this.completionPercentage = 0.0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastWorkoutDate,
    this.workoutsThisWeek = 0,
    this.minutesThisWeek = 0,
    this.caloriesThisWeek = 0,
    this.workoutsThisMonth = 0,
    this.minutesThisMonth = 0,
    this.caloriesThisMonth = 0,
    this.totalWorkoutsCompleted = 0,
    this.totalMinutesExercised = 0,
    this.totalCaloriesBurned = 0,
    this.totalDaysActive = 0,
    this.weeklyActivity = const {},
    this.bodyMeasurements = const [],
    this.goalsAchieved = 0,
    this.badges = const [],
    required this.updatedAt,
  });

  // From Firestore
  factory ProgressStatsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgressStatsModel(
      userId: data['userId'],
      planId: data['planId'],
      totalDaysInPlan: data['totalDaysInPlan'],
      completedDays: data['completedDays'] ?? 0,
      missedDays: data['missedDays'] ?? 0,
      currentDay: data['currentDay'] ?? 1,
      completionPercentage: (data['completionPercentage'] ?? 0).toDouble(),
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      lastWorkoutDate: data['lastWorkoutDate'] != null
          ? (data['lastWorkoutDate'] as Timestamp).toDate()
          : null,
      workoutsThisWeek: data['workoutsThisWeek'] ?? 0,
      minutesThisWeek: data['minutesThisWeek'] ?? 0,
      caloriesThisWeek: data['caloriesThisWeek'] ?? 0,
      workoutsThisMonth: data['workoutsThisMonth'] ?? 0,
      minutesThisMonth: data['minutesThisMonth'] ?? 0,
      caloriesThisMonth: data['caloriesThisMonth'] ?? 0,
      totalWorkoutsCompleted: data['totalWorkoutsCompleted'] ?? 0,
      totalMinutesExercised: data['totalMinutesExercised'] ?? 0,
      totalCaloriesBurned: data['totalCaloriesBurned'] ?? 0,
      totalDaysActive: data['totalDaysActive'] ?? 0,
      weeklyActivity: Map<String, int>.from(data['weeklyActivity'] ?? {}),
      bodyMeasurements: (data['bodyMeasurements'] as List<dynamic>?)
              ?.map((m) => BodyMeasurement.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      goalsAchieved: data['goalsAchieved'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'planId': planId,
      'totalDaysInPlan': totalDaysInPlan,
      'completedDays': completedDays,
      'missedDays': missedDays,
      'currentDay': currentDay,
      'completionPercentage': completionPercentage,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastWorkoutDate': lastWorkoutDate != null
          ? Timestamp.fromDate(lastWorkoutDate!)
          : null,
      'workoutsThisWeek': workoutsThisWeek,
      'minutesThisWeek': minutesThisWeek,
      'caloriesThisWeek': caloriesThisWeek,
      'workoutsThisMonth': workoutsThisMonth,
      'minutesThisMonth': minutesThisMonth,
      'caloriesThisMonth': caloriesThisMonth,
      'totalWorkoutsCompleted': totalWorkoutsCompleted,
      'totalMinutesExercised': totalMinutesExercised,
      'totalCaloriesBurned': totalCaloriesBurned,
      'totalDaysActive': totalDaysActive,
      'weeklyActivity': weeklyActivity,
      'bodyMeasurements': bodyMeasurements.map((m) => m.toMap()).toList(),
      'goalsAchieved': goalsAchieved,
      'badges': badges,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // CopyWith for updates
  ProgressStatsModel copyWith({
    int? completedDays,
    int? missedDays,
    int? currentDay,
    double? completionPercentage,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
    int? workoutsThisWeek,
    int? minutesThisWeek,
    int? caloriesThisWeek,
    int? workoutsThisMonth,
    int? minutesThisMonth,
    int? caloriesThisMonth,
    int? totalWorkoutsCompleted,
    int? totalMinutesExercised,
    int? totalCaloriesBurned,
    int? totalDaysActive,
    Map<String, int>? weeklyActivity,
    DateTime? updatedAt,
  }) {
    return ProgressStatsModel(
      userId: userId,
      planId: planId,
      totalDaysInPlan: totalDaysInPlan,
      completedDays: completedDays ?? this.completedDays,
      missedDays: missedDays ?? this.missedDays,
      currentDay: currentDay ?? this.currentDay,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      workoutsThisWeek: workoutsThisWeek ?? this.workoutsThisWeek,
      minutesThisWeek: minutesThisWeek ?? this.minutesThisWeek,
      caloriesThisWeek: caloriesThisWeek ?? this.caloriesThisWeek,
      workoutsThisMonth: workoutsThisMonth ?? this.workoutsThisMonth,
      minutesThisMonth: minutesThisMonth ?? this.minutesThisMonth,
      caloriesThisMonth: caloriesThisMonth ?? this.caloriesThisMonth,
      totalWorkoutsCompleted: totalWorkoutsCompleted ?? this.totalWorkoutsCompleted,
      totalMinutesExercised: totalMinutesExercised ?? this.totalMinutesExercised,
      totalCaloriesBurned: totalCaloriesBurned ?? this.totalCaloriesBurned,
      totalDaysActive: totalDaysActive ?? this.totalDaysActive,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      bodyMeasurements: bodyMeasurements,
      goalsAchieved: goalsAchieved,
      badges: badges,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Body Measurement tracking
class BodyMeasurement {
  final DateTime date;
  final double weight; // kg
  final double? waist; // cm
  final double? hips; // cm
  final double? chest; // cm
  final double? arms; // cm
  final double? thighs; // cm
  final String? notes;
  final String? photoUrl; // Progress photo

  BodyMeasurement({
    required this.date,
    required this.weight,
    this.waist,
    this.hips,
    this.chest,
    this.arms,
    this.thighs,
    this.notes,
    this.photoUrl,
  });

  factory BodyMeasurement.fromMap(Map<String, dynamic> map) {
    return BodyMeasurement(
      date: DateTime.parse(map['date']),
      weight: (map['weight'] ?? 0).toDouble(),
      waist: map['waist']?.toDouble(),
      hips: map['hips']?.toDouble(),
      chest: map['chest']?.toDouble(),
      arms: map['arms']?.toDouble(),
      thighs: map['thighs']?.toDouble(),
      notes: map['notes'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'waist': waist,
      'hips': hips,
      'chest': chest,
      'arms': arms,
      'thighs': thighs,
      'notes': notes,
      'photoUrl': photoUrl,
    };
  }
}
