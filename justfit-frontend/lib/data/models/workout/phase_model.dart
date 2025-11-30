import 'day_plan_model.dart';

class PhaseModel {
  final String phaseId;
  final int phaseNumber; // 1, 2, 3...
  final String phaseName; // "Foundation Phase", "Build Phase"
  final String phaseDescription;
  final String phaseGoal; // "Build base strength and endurance"
  
  // Duration
  final int startDay; // Day 1, Day 29, etc.
  final int endDay; // Day 28, Day 56, etc.
  final int totalDaysInPhase; // endDay - startDay + 1
  
  // Days (DYNAMIC array)
  final List<DayPlanModel> days;
  
  // Phase Characteristics
  final String intensityLevel; // 'low', 'medium', 'high', 'peak'
  final String focusArea; // 'strength', 'cardio', 'flexibility', 'mixed'
  final int workoutsPerWeek; // 3, 4, 5, 6, 7
  final int restDaysPerWeek;
  
  // Visual
  final String? imageUrl; // Optional phase image
  final String colorCode; // Hex color for UI: "#FF5722"

  PhaseModel({
    required this.phaseId,
    required this.phaseNumber,
    required this.phaseName,
    required this.phaseDescription,
    required this.phaseGoal,
    required this.startDay,
    required this.endDay,
    required this.totalDaysInPhase,
    required this.days,
    required this.intensityLevel,
    required this.focusArea,
    required this.workoutsPerWeek,
    required this.restDaysPerWeek,
    this.imageUrl,
    this.colorCode = '#FF5722',
  });

  // From Map (Firestore)
  factory PhaseModel.fromMap(Map<String, dynamic> map) {
    return PhaseModel(
      phaseId: map['phaseId'],
      phaseNumber: map['phaseNumber'],
      phaseName: map['phaseName'],
      phaseDescription: map['phaseDescription'],
      phaseGoal: map['phaseGoal'],
      startDay: map['startDay'],
      endDay: map['endDay'],
      totalDaysInPhase: map['totalDaysInPhase'],
      days: (map['days'] as List<dynamic>)
          .map((day) => DayPlanModel.fromMap(day as Map<String, dynamic>))
          .toList(),
      intensityLevel: map['intensityLevel'],
      focusArea: map['focusArea'],
      workoutsPerWeek: map['workoutsPerWeek'],
      restDaysPerWeek: map['restDaysPerWeek'],
      imageUrl: map['imageUrl'],
      colorCode: map['colorCode'] ?? '#FF5722',
    );
  }

  // From Backend JSON (API response)
  factory PhaseModel.fromBackendJson(
    Map<String, dynamic> phaseJson,
    List<dynamic> allDailyWorkouts,
  ) {
    final phaseNumber = phaseJson['phaseNumber'] as int;
    final startDay = phaseJson['startDay'] as int;
    final endDay = phaseJson['endDay'] as int;
    
    // Filter daily workouts that belong to this phase
    final phaseDays = allDailyWorkouts
        .where((dayJson) => dayJson['phaseNumber'] == phaseNumber)
        .map((dayJson) => DayPlanModel.fromBackendJson(dayJson as Map<String, dynamic>))
        .toList();
    
    // Generate phaseId
    final phaseId = 'phase_$phaseNumber';
    
    return PhaseModel(
      phaseId: phaseId,
      phaseNumber: phaseNumber,
      phaseName: phaseJson['phaseName'] ?? 'Phase $phaseNumber',
      phaseDescription: phaseJson['phaseDescription'] ?? '',
      phaseGoal: phaseJson['phaseGoal'] ?? '',
      startDay: startDay,
      endDay: endDay,
      totalDaysInPhase: endDay - startDay + 1,
      days: phaseDays,
      intensityLevel: phaseJson['intensityLevel'] ?? 'medium',
      focusArea: phaseJson['focusArea'] ?? 'full_body',
      workoutsPerWeek: phaseJson['workoutsPerWeek'] ?? 5,
      restDaysPerWeek: phaseJson['restDaysPerWeek'] ?? 2,
      imageUrl: null,
      colorCode: _getColorForPhase(phaseNumber),
    );
  }

  // Helper: Get color based on phase number
  static String _getColorForPhase(int phaseNumber) {
    final colors = [
      '#FF5722', // Deep Orange (Phase 1)
      '#FF9800', // Orange (Phase 2)
      '#FFC107', // Amber (Phase 3)
      '#4CAF50', // Green (Phase 4)
      '#2196F3', // Blue (Phase 5)
      '#9C27B0', // Purple (Phase 6)
    ];
    return colors[(phaseNumber - 1) % colors.length];
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'phaseId': phaseId,
      'phaseNumber': phaseNumber,
      'phaseName': phaseName,
      'phaseDescription': phaseDescription,
      'phaseGoal': phaseGoal,
      'startDay': startDay,
      'endDay': endDay,
      'totalDaysInPhase': totalDaysInPhase,
      'days': days.map((day) => day.toMap()).toList(),
      'intensityLevel': intensityLevel,
      'focusArea': focusArea,
      'workoutsPerWeek': workoutsPerWeek,
      'restDaysPerWeek': restDaysPerWeek,
      'imageUrl': imageUrl,
      'colorCode': colorCode,
    };
  }
}
