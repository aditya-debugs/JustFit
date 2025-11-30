// Simple models for legacy screens (Discovery, Dance, Body Part, etc.)
// These are different from WorkoutSetModel which is for the actual workout plan

class WorkoutSet {
  final String setName;
  final List<Exercise> exercises;

  WorkoutSet({
    required this.setName,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final int duration; // in seconds
  final String? thumbnailPath;
  final List<String>? actionSteps;
  final List<String>? breathingRhythm;
  final List<String>? actionFeeling;
  final List<String>? commonMistakes;

  Exercise({
    required this.name,
    required this.duration,
    this.thumbnailPath,
    this.actionSteps,
    this.breathingRhythm,
    this.actionFeeling,
    this.commonMistakes,
  });
}