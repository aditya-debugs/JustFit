class WorkoutExercise {
  final String name;
  final int duration;
  final int? sets;
  final int? reps;
  final int? rest;
  final String setType;  // ✅ ADD THIS

  WorkoutExercise({
    required this.name,
    required this.duration,
    this.sets,
    this.reps,
    this.rest,
    required this.setType,  // ✅ ADD THIS
  });
}