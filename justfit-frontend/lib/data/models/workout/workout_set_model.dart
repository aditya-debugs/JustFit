import 'exercise_model.dart';

class WorkoutSetModel {
  final String setId;
  final int setNumber; // 1, 2, 3...
  final String setTitle; // "Warm Up", "Main Set", "Cool Down"
  final String? setDescription;
  
  // Exercises in this set
  final List<ExerciseModel> exercises;
  
  // Set Metadata
  final int estimatedDuration; // Minutes
  final int rounds; // Number of rounds to repeat (1 = do once)
  final int? restBetweenRounds; // Seconds rest between rounds
  
  // Type
  final SetType setType; // 'warmup', 'main', 'cooldown', 'stretch'

  WorkoutSetModel({
    required this.setId,
    required this.setNumber,
    required this.setTitle,
    this.setDescription,
    required this.exercises,
    required this.estimatedDuration,
    this.rounds = 1,
    this.restBetweenRounds,
    required this.setType,
  });

  // From Map (Firestore)
  factory WorkoutSetModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSetModel(
      setId: map['setId'] ?? '',                              // ✅ Default to empty string
      setNumber: map['setNumber'] ?? 1,                       // ✅ Default to 1
      setTitle: map['setTitle'] ?? 'Set',                     // ✅ Default to 'Set'
      setDescription: map['setDescription'],
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((ex) => ExerciseModel.fromMap(ex as Map<String, dynamic>))
              .toList() ??
          [],                                                 // ✅ Default to empty list
      estimatedDuration: map['estimatedDuration'] ?? 0,       // ✅ Default to 0
      rounds: map['rounds'] ?? 1,
      restBetweenRounds: map['restBetweenRounds'],
      setType: SetType.values.firstWhere(
        (e) => e.toString().split('.').last == map['setType'],
        orElse: () => SetType.main,
      ),
    );
  }

  // From Backend JSON (API response)
  factory WorkoutSetModel.fromBackendJson(Map<String, dynamic> json) {
    final setNumber = json['setNumber'] as int;
    final setName = json['setName'] ?? 'Set $setNumber';
    final setType = json['setType'] ?? 'main';
    
    // Convert backend exercises to frontend ExerciseModel
    final exercises = (json['exercises'] as List)
        .map((exJson) => ExerciseModel.fromBackendJson(exJson as Map<String, dynamic>))
        .toList();
    
    return WorkoutSetModel(
      setId: 'set_$setNumber',
      setNumber: setNumber,
      setTitle: setName,
      setDescription: null,
      exercises: exercises,
      estimatedDuration: json['estimatedDuration'] ?? 5,
      rounds: 1,
      restBetweenRounds: null,
      setType: _parseSetType(setType),
    );
  }

  // Helper: Parse set type string to enum
  static SetType _parseSetType(String type) {
    switch (type.toLowerCase()) {
      case 'warmup':
      case 'warm-up':
      case 'warm_up':
        return SetType.warmup;
      case 'cooldown':
      case 'cool-down':
      case 'cool_down':
        return SetType.cooldown;
      case 'stretch':
      case 'stretching':
        return SetType.stretch;
      default:
        return SetType.main;
    }
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'setId': setId,
      'setNumber': setNumber,
      'setTitle': setTitle,
      'setDescription': setDescription,
      'exercises': exercises.map((ex) => ex.toMap()).toList(),
      'estimatedDuration': estimatedDuration,
      'rounds': rounds,
      'restBetweenRounds': restBetweenRounds,
      'setType': setType.toString().split('.').last,
    };
  }
}

enum SetType {
  warmup,
  main,
  cooldown,
  stretch,
}