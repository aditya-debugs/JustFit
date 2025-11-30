import 'workout_set_model.dart';

class DayPlanModel {
  final String dayId;
  final int dayNumber; // 1, 2, 3... up to totalDays in plan
  final String dayTitle; // "Upper Body Strength", "Cardio Blast"
  final String? daySubtitle; // Optional subtitle
  
  // Type
  final bool isRestDay;
  final DayType dayType; // 'workout', 'rest', 'active_rest', 'test_day'
  
  // Workout Content (empty if rest day)
  final List<WorkoutSetModel> workoutSets;
  
  // Metadata
  final int estimatedDuration; // Total minutes
  final int estimatedCalories;
  final String intensity; // 'low', 'medium', 'high'
  final String focusArea; // 'upper_body', 'lower_body', 'core', 'cardio', 'full_body'
  final String? equipment; // 'yoga_mat', 'dumbbells', 'resistance_band', 'none'
  
  // Progress
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isLocked; // For sequential unlocking
  
  // Visual
  final String? thumbnailUrl; // Day thumbnail image
  final String? heroImageUrl; // Large hero image for detail screen

  DayPlanModel({
    required this.dayId,
    required this.dayNumber,
    required this.dayTitle,
    this.daySubtitle,
    this.isRestDay = false,
    required this.dayType,
    this.workoutSets = const [],
    required this.estimatedDuration,
    required this.estimatedCalories,
    required this.intensity,
    required this.focusArea,
    this.equipment,
    this.isCompleted = false,
    this.completedAt,
    this.isLocked = false,
    this.thumbnailUrl,
    this.heroImageUrl,
  });

  // From Map (Firestore)
  factory DayPlanModel.fromMap(Map<String, dynamic> map) {
    return DayPlanModel(
      dayId: map['dayId'],
      dayNumber: map['dayNumber'],
      dayTitle: map['dayTitle'],
      daySubtitle: map['daySubtitle'],
      isRestDay: map['isRestDay'] ?? false,
      dayType: DayType.values.firstWhere(
        (e) => e.toString().split('.').last == map['dayType'],
        orElse: () => DayType.workout,
      ),
      workoutSets: (map['workoutSets'] as List<dynamic>?)
              ?.map((set) => WorkoutSetModel.fromMap(set as Map<String, dynamic>))
              .toList() ??
          [],
      estimatedDuration: map['estimatedDuration'],
      estimatedCalories: map['estimatedCalories'],
      intensity: map['intensity'],
      focusArea: map['focusArea'],
      equipment: map['equipment'],
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      isLocked: map['isLocked'] ?? false,
      thumbnailUrl: map['thumbnailUrl'],
      heroImageUrl: map['heroImageUrl'],
    );
  }

  // From Backend JSON (API response)
  factory DayPlanModel.fromBackendJson(Map<String, dynamic> json) {
    final dayNumber = json['day'] as int;
    final isRestDay = json['isRestDay'] ?? false;
    
    // Convert backend workout sets to frontend WorkoutSetModel
    final workoutSets = isRestDay
        ? <WorkoutSetModel>[]
        : (json['workoutSets'] as List?)
                ?.map((setJson) => WorkoutSetModel.fromBackendJson(setJson as Map<String, dynamic>))
                .toList() ??
            [];
    
    return DayPlanModel(
      dayId: 'day_$dayNumber',
      dayNumber: dayNumber,
      dayTitle: json['dayTitle'] ?? 'Day $dayNumber',
      daySubtitle: json['dayName'], // "Monday", "Tuesday", etc.
      isRestDay: isRestDay,
      dayType: isRestDay ? DayType.rest : DayType.workout,
      workoutSets: workoutSets,
      estimatedDuration: json['estimatedDuration'] ?? 0,
      estimatedCalories: json['estimatedCalories'] ?? 0,
      intensity: json['intensity'] ?? 'medium',
      focusArea: json['focusArea'] ?? 'full_body',
      equipment: json['equipment'] ?? 'none',
      isCompleted: false,
      completedAt: null,
      isLocked: false,
      thumbnailUrl: json['thumbnailUrl'],
      heroImageUrl: json['thumbnailUrl'],
    );
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'dayId': dayId,
      'dayNumber': dayNumber,
      'dayTitle': dayTitle,
      'daySubtitle': daySubtitle,
      'isRestDay': isRestDay,
      'dayType': dayType.toString().split('.').last,
      'workoutSets': workoutSets.map((set) => set.toMap()).toList(),
      'estimatedDuration': estimatedDuration,
      'estimatedCalories': estimatedCalories,
      'intensity': intensity,
      'focusArea': focusArea,
      'equipment': equipment,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'isLocked': isLocked,
      'thumbnailUrl': thumbnailUrl,
      'heroImageUrl': heroImageUrl,
    };
  }

  // CopyWith for updating completion status
  DayPlanModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    bool? isLocked,
  }) {
    return DayPlanModel(
      dayId: dayId,
      dayNumber: dayNumber,
      dayTitle: dayTitle,
      daySubtitle: daySubtitle,
      isRestDay: isRestDay,
      dayType: dayType,
      workoutSets: workoutSets,
      estimatedDuration: estimatedDuration,
      estimatedCalories: estimatedCalories,
      intensity: intensity,
      focusArea: focusArea,
      equipment: equipment,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isLocked: isLocked ?? this.isLocked,
      thumbnailUrl: thumbnailUrl,
      heroImageUrl: heroImageUrl,
    );
  }
}

enum DayType {
  workout,
  rest,
  activeRest, // Light stretching, walking
  testDay, // Fitness assessment day
}