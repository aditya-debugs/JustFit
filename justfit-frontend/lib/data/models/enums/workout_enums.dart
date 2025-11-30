// All enums in one place for easy access

// ========== USER ENUMS ==========

enum MeasurementUnit {
  metric,
  imperial,
}

enum BodyType {
  athletic,
  lean,
  fit,
  average,
  curvy,
  plusSize,
}

// ========== WORKOUT PLAN ENUMS ==========

enum PlanStatus {
  active,
  paused,
  completed,
  archived,
}

enum DayType {
  workout,
  rest,
  activeRest,
  testDay,
}

enum SetType {
  warmup,
  main,
  cooldown,
  stretch,
}

enum ExerciseMeasurement {
  reps,
  duration,
  distance,
  repsDuration,
}

enum ExerciseCategory {
  strength,
  cardio,
  flexibility,
  balance,
  plyometric,
  core,
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

enum Intensity {
  low,
  medium,
  high,
  peak,
}

// ========== ACTIVITY ENUMS ==========

enum ActivityType {
  workoutCompleted,
  workoutSkipped,
  workoutPartial,
  restDay,
  activeRest,
}

enum WorkoutDifficulty {
  tooEasy,
  justRight,
  tooHard,
}

// ========== ONBOARDING ENUMS ==========

enum MainGoal {
  loseWeight,
  buildMuscle,
  keepFit,
}

enum FocusArea {
  arms,
  belly,
  butt,
  legs,
  fullBody,
}

enum ActivityLevel {
  notActive,
  lightlyActive,
  moderatelyActive,
  highlyActive,
}

enum FitnessLevel {
  beginner,
  intermediate,
  advanced,
}

enum WorkoutLocation {
  yogaMat,
  couchBed,
  noPreference,
}

enum WorkoutType {
  noEquipment,
  noJumping,
  lyingDown,
  none,
}

enum InjuryType {
  none,
  knee,
  lowerBack,
  ankle,
  wrist,
  hip,
}

// ========== HELPER EXTENSIONS ==========

extension ExerciseMeasurementExtension on ExerciseMeasurement {
  String get displayName {
    switch (this) {
      case ExerciseMeasurement.reps:
        return 'Reps';
      case ExerciseMeasurement.duration:
        return 'Duration';
      case ExerciseMeasurement.distance:
        return 'Distance';
      case ExerciseMeasurement.repsDuration:
        return 'Reps × Duration';
    }
  }
}

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }
  
  String get emoji {
    switch (this) {
      case Difficulty.beginner:
        return '🟢';
      case Difficulty.intermediate:
        return '🟡';
      case Difficulty.advanced:
        return '🔴';
    }
  }
}

extension IntensityExtension on Intensity {
  String get displayName {
    switch (this) {
      case Intensity.low:
        return 'Low';
      case Intensity.medium:
        return 'Medium';
      case Intensity.high:
        return 'High';
      case Intensity.peak:
        return 'Peak';
    }
  }
  
  String get emoji {
    switch (this) {
      case Intensity.low:
        return '😌';
      case Intensity.medium:
        return '💪';
      case Intensity.high:
        return '🔥';
      case Intensity.peak:
        return '⚡';
    }
  }
}