class ExerciseModel {
  final String exerciseId;
  final String exerciseName; // "Push-ups", "Squats"
  final String? exerciseDescription;
  
  // Exercise Details
  final String category; // 'strength', 'cardio', 'flexibility', 'balance'
  final String targetMuscle; // 'chest', 'legs', 'core', 'full_body'
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  
  // Repetition Info (flexible for different exercise types)
  final ExerciseMeasurement measurement;
  final int? reps; // For rep-based exercises
  final int? duration; // For time-based exercises (seconds)
  final double? distance; // For distance-based exercises (meters)
  final int? restAfter; // Seconds of rest after this exercise
  final int? sets; // ✅ ADD THIS - Number of sets/rounds for this exercise
  
  // Media
  final String? thumbnailUrl;
  final String? videoUrl; // Cloudinary URL
  final String? gifUrl; // Animated demo
  
  // Instructions (different sources)
  final List<String> instructions; // Step-by-step (actionSteps from backend)
  final List<String>? breathingRhythm; // Breathing instructions
  final List<String>? actionFeeling; // What it should feel like
  final List<String>? commonMistakes; // Common mistakes
  final List<String>? tips; // Pro tips (optional)
  
  // Equipment
  final String equipment; // 'none', 'yoga_mat', 'dumbbells', 'resistance_band'
  
  // Modifications
  final String? easierVariation; // Exercise ID for easier version
  final String? harderVariation; // Exercise ID for harder version

  ExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseDescription,
    required this.category,
    required this.targetMuscle,
    required this.difficulty,
    required this.measurement,
    this.reps,
    this.duration,
    this.distance,
    this.restAfter,
    this.sets, // ✅ ADD THIS
    this.thumbnailUrl,
    this.videoUrl,
    this.gifUrl,
    this.instructions = const [],
    this.breathingRhythm,
    this.actionFeeling,
    this.commonMistakes,
    this.tips,
    this.equipment = 'none',
    this.easierVariation,
    this.harderVariation,
  });

  // From Map (Firestore)
  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      exerciseId: map['exerciseId'] ?? '',                    // ✅ Default to empty string
      exerciseName: map['exerciseName'] ?? 'Unknown',         // ✅ Default to 'Unknown'
      exerciseDescription: map['exerciseDescription'],
      category: map['category'] ?? 'strength',                // ✅ Default to 'strength'
      targetMuscle: map['targetMuscle'] ?? 'full_body',       // ✅ Default to 'full_body'
      difficulty: map['difficulty'] ?? 'beginner',            // ✅ Default to 'beginner'
      measurement: ExerciseMeasurement.values.firstWhere(
        (e) => e.toString().split('.').last == map['measurement'],
        orElse: () => ExerciseMeasurement.reps,
      ),
      reps: map['reps'],
      duration: map['duration'],
      distance: map['distance']?.toDouble(),
      restAfter: map['restAfter'],
      sets: map['sets'],
      thumbnailUrl: map['thumbnailUrl'],
      videoUrl: map['videoUrl'],
      gifUrl: map['gifUrl'],
      instructions: map['instructions'] != null 
          ? List<String>.from(map['instructions']) 
          : [],                                               // ✅ Default to empty list
      breathingRhythm: map['breathingRhythm'] != null 
          ? (map['breathingRhythm'] is String 
              ? [map['breathingRhythm'] as String]  // Convert string to list
              : List<String>.from(map['breathingRhythm']))
          : null,
      actionFeeling: map['actionFeeling'] != null 
          ? (map['actionFeeling'] is String 
              ? [map['actionFeeling'] as String]  // Convert string to list
              : List<String>.from(map['actionFeeling']))
          : null,
      commonMistakes: map['commonMistakes'] != null 
          ? List<String>.from(map['commonMistakes']) 
          : null,
      tips: map['tips'] != null 
          ? List<String>.from(map['tips']) 
          : null,
      equipment: map['equipment'] ?? 'none',                  // ✅ Default to 'none'
      easierVariation: map['easierVariation'],
      harderVariation: map['harderVariation'],
    );
  }

  // From Backend JSON (API response for exercise in workout)
  factory ExerciseModel.fromBackendJson(Map<String, dynamic> json) {
    // Parse displayText (e.g., "30 seconds", "12 reps", "12-15 reps")
    final displayText = json['displayText'] as String?;
    final parsedData = _parseDisplayText(displayText);
    
    return ExerciseModel(
      exerciseId: json['exerciseId'],
      exerciseName: json['name'],
      exerciseDescription: null,
      category: 'strength', // Will be updated when fetching exercise details
      targetMuscle: 'full_body',
      difficulty: 'beginner',
      measurement: parsedData['measurement'],
      reps: parsedData['reps'],
      duration: parsedData['duration'],
      distance: null,
      restAfter: json['restBetweenSets'],
      sets: json['sets'], // ✅ ADD THIS - Parse from backend
      thumbnailUrl: null,
      videoUrl: null,
      gifUrl: null,
      instructions: [],
      breathingRhythm: null,
      actionFeeling: null,
      commonMistakes: null,
      tips: null,
      equipment: 'none',
      easierVariation: null,
      harderVariation: null,
    );
  }

  // From Backend JSON (API response for exercise details)
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json['exerciseId'],
      exerciseName: json['name'],
      exerciseDescription: null,
      category: json['category'],
      targetMuscle: json['targetMuscle'],
      difficulty: json['difficulty'],
      measurement: ExerciseMeasurement.duration, // Default
      reps: null,
      duration: null,
      distance: null,
      restAfter: null,
      sets: null, // ✅ ADD THIS
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
      gifUrl: json['gifUrl'],
      instructions: List<String>.from(json['actionSteps'] ?? []),
      breathingRhythm: List<String>.from(json['breathingRhythm'] ?? []),
      actionFeeling: List<String>.from(json['actionFeeling'] ?? []),
      commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
      tips: null,
      equipment: json['equipment'] ?? 'none',
      easierVariation: json['modifications']?['easier'],
      harderVariation: json['modifications']?['harder'],
    );
  }

  // Helper: Parse displayText to extract reps/duration
  static Map<String, dynamic> _parseDisplayText(String? displayText) {
    if (displayText == null || displayText.isEmpty) {
      return {
        'measurement': ExerciseMeasurement.reps,
        'reps': null,
        'duration': null,
      };
    }

    final text = displayText.toLowerCase();
    
    // Check for seconds/time-based
    if (text.contains('second') || text.contains('sec')) {
      final match = RegExp(r'(\d+)').firstMatch(text);
      return {
        'measurement': ExerciseMeasurement.duration,
        'reps': null,
        'duration': match != null ? int.parse(match.group(1)!) : null,
      };
    }
    
    // Check for reps
    if (text.contains('rep') || text.contains('x')) {
      final match = RegExp(r'(\d+)').firstMatch(text);
      return {
        'measurement': ExerciseMeasurement.reps,
        'reps': match != null ? int.parse(match.group(1)!) : null,
        'duration': null,
      };
    }
    
    // Default: assume reps
    return {
      'measurement': ExerciseMeasurement.reps,
      'reps': null,
      'duration': null,
    };
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'exerciseDescription': exerciseDescription,
      'category': category,
      'targetMuscle': targetMuscle,
      'difficulty': difficulty,
      'measurement': measurement.toString().split('.').last,
      'reps': reps,
      'duration': duration,
      'distance': distance,
      'restAfter': restAfter,
      'sets': sets, // ✅ ADD THIS
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'gifUrl': gifUrl,
      'instructions': instructions,
      'breathingRhythm': breathingRhythm,
      'actionFeeling': actionFeeling,
      'commonMistakes': commonMistakes,
      'tips': tips,
      'equipment': equipment,
      'easierVariation': easierVariation,
      'harderVariation': harderVariation,
    };
  }

  // Helper: Display format
  String getDisplayFormat() {
    switch (measurement) {
      case ExerciseMeasurement.reps:
        return '$reps reps';
      case ExerciseMeasurement.duration:
        return '$duration sec';
      case ExerciseMeasurement.distance:
        return '${distance}m';
      case ExerciseMeasurement.repsDuration:
        return '$reps reps × $duration sec';
      default:
        return '';
    }
  }

  // Helper: Merge with detailed exercise data
  ExerciseModel mergeWithDetails(ExerciseModel details) {
    return ExerciseModel(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      exerciseDescription: details.exerciseDescription,
      category: details.category,
      targetMuscle: details.targetMuscle,
      difficulty: details.difficulty,
      measurement: measurement,
      reps: reps,
      duration: duration,
      distance: distance,
      restAfter: restAfter,
      sets: sets, // ✅ ADD THIS
      thumbnailUrl: details.thumbnailUrl ?? thumbnailUrl,
      videoUrl: details.videoUrl ?? videoUrl,
      gifUrl: details.gifUrl ?? gifUrl,
      instructions: details.instructions.isNotEmpty ? details.instructions : instructions,
      breathingRhythm: details.breathingRhythm,
      actionFeeling: details.actionFeeling,
      commonMistakes: details.commonMistakes,
      tips: details.tips,
      equipment: details.equipment,
      easierVariation: details.easierVariation,
      harderVariation: details.harderVariation,
    );
  }
}

enum ExerciseMeasurement {
  reps, // e.g., 15 push-ups
  duration, // e.g., 30 sec plank
  distance, // e.g., 100m run
  repsDuration, // e.g., 10 reps with 3 sec hold each
}
