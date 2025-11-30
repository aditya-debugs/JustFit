import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogModel {
  final String activityId;
  final String userId;
  final String planId;
  final String dayId;
  
  // Activity Details
  final int dayNumber;
  final String dayTitle;
  final ActivityType activityType; // 'workout_completed', 'workout_skipped', 'rest_day'
  
  // Workout Data (if completed)
  final int? actualDuration; // Minutes (actual time spent)
  final int? estimatedCalories;
  final int? actualCalories; // If tracked with device
  
  // Sets & Exercises Completed
  final int totalSets;
  final int completedSets;
  final int totalExercises;
  final int completedExercises;
  final List<ExerciseLog> exerciseLogs; // Detailed per-exercise data
  
  // Performance
  final double completionPercentage;
  final String difficulty; // 'too_easy', 'just_right', 'too_hard'
  final int? userRating; // 1-5 stars
  final String? userNotes; // Optional feedback
  
  // Timestamps
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime loggedAt;

  ActivityLogModel({
    required this.activityId,
    required this.userId,
    required this.planId,
    required this.dayId,
    required this.dayNumber,
    required this.dayTitle,
    required this.activityType,
    this.actualDuration,
    this.estimatedCalories,
    this.actualCalories,
    required this.totalSets,
    this.completedSets = 0,
    required this.totalExercises,
    this.completedExercises = 0,
    this.exerciseLogs = const [],
    this.completionPercentage = 0.0,
    this.difficulty = 'just_right',
    this.userRating,
    this.userNotes,
    required this.startedAt,
    this.completedAt,
    required this.loggedAt,
  });

  // From Firestore
  factory ActivityLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      activityId: doc.id,
      userId: data['userId'],
      planId: data['planId'],
      dayId: data['dayId'],
      dayNumber: data['dayNumber'],
      dayTitle: data['dayTitle'],
      activityType: ActivityType.values.firstWhere(
        (e) => e.toString().split('.').last == data['activityType'],
        orElse: () => ActivityType.workoutCompleted,
      ),
      actualDuration: data['actualDuration'],
      estimatedCalories: data['estimatedCalories'],
      actualCalories: data['actualCalories'],
      totalSets: data['totalSets'],
      completedSets: data['completedSets'] ?? 0,
      totalExercises: data['totalExercises'],
      completedExercises: data['completedExercises'] ?? 0,
      exerciseLogs: (data['exerciseLogs'] as List<dynamic>?)
              ?.map((log) => ExerciseLog.fromMap(log as Map<String, dynamic>))
              .toList() ??
          [],
      completionPercentage: (data['completionPercentage'] ?? 0).toDouble(),
      difficulty: data['difficulty'] ?? 'just_right',
      userRating: data['userRating'],
      userNotes: data['userNotes'],
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      loggedAt: (data['loggedAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'planId': planId,
      'dayId': dayId,
      'dayNumber': dayNumber,
      'dayTitle': dayTitle,
      'activityType': activityType.toString().split('.').last,
      'actualDuration': actualDuration,
      'estimatedCalories': estimatedCalories,
      'actualCalories': actualCalories,
      'totalSets': totalSets,
      'completedSets': completedSets,
      'totalExercises': totalExercises,
      'completedExercises': completedExercises,
      'exerciseLogs': exerciseLogs.map((log) => log.toMap()).toList(),
      'completionPercentage': completionPercentage,
      'difficulty': difficulty,
      'userRating': userRating,
      'userNotes': userNotes,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': completedAt != null 
          ? Timestamp.fromDate(completedAt!) 
          : null,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }
}

// Exercise-level log
class ExerciseLog {
  final String exerciseId;
  final String exerciseName;
  final bool completed;
  final int? actualReps;
  final int? actualDuration; // seconds
  final int? targetReps;
  final int? targetDuration;
  final String? notes; // e.g., "Felt hard", "Easy"

  ExerciseLog({
    required this.exerciseId,
    required this.exerciseName,
    this.completed = false,
    this.actualReps,
    this.actualDuration,
    this.targetReps,
    this.targetDuration,
    this.notes,
  });

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      exerciseId: map['exerciseId'],
      exerciseName: map['exerciseName'],
      completed: map['completed'] ?? false,
      actualReps: map['actualReps'],
      actualDuration: map['actualDuration'],
      targetReps: map['targetReps'],
      targetDuration: map['targetDuration'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'completed': completed,
      'actualReps': actualReps,
      'actualDuration': actualDuration,
      'targetReps': targetReps,
      'targetDuration': targetDuration,
      'notes': notes,
    };
  }
}

enum ActivityType {
  workoutCompleted,
  workoutSkipped,
  workoutPartial, // Started but not finished
  restDay,
  activeRest,
}
