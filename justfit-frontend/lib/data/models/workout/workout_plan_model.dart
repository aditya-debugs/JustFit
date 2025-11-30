import 'package:cloud_firestore/cloud_firestore.dart';
import 'phase_model.dart';
import 'day_plan_model.dart';

class WorkoutPlanModel {
  final String planId;
  final String userId;
  
  // Plan Details
  final String planTitle; // e.g., "12-Week Full Body Transformation"
  final String planDescription;
  final int totalDays; // DYNAMIC - could be 42, 56, 84, 120...
  final int totalWeeks; // Calculated from totalDays
  
  // Phases (DYNAMIC - 1 to 6+ phases)
  final List<PhaseModel> phases;
  
  // Progress Tracking
  final int currentDay; // Which day user is on (1-based)
  final String currentPhaseId;
  final DateTime startDate;
  final DateTime? estimatedEndDate;
  final DateTime? actualEndDate; // When plan was completed
  
  // Status
  final PlanStatus status; // 'active', 'paused', 'completed', 'archived'
  final int completedDays;
  final int missedDays;
  final double completionPercentage;
  
  // AI Generation Metadata
  final String generatedBy; // 'ai_gpt4', 'ai_claude', etc.
  final DateTime generatedAt;
  final String aiModelVersion;
  final Map<String, dynamic>? aiPromptMetadata; // Optional: store prompt info
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutPlanModel({
    required this.planId,
    required this.userId,
    required this.planTitle,
    required this.planDescription,
    required this.totalDays,
    required this.totalWeeks,
    required this.phases,
    this.currentDay = 1,
    required this.currentPhaseId,
    required this.startDate,
    this.estimatedEndDate,
    this.actualEndDate,
    this.status = PlanStatus.active,
    this.completedDays = 0,
    this.missedDays = 0,
    this.completionPercentage = 0.0,
    required this.generatedBy,
    required this.generatedAt,
    required this.aiModelVersion,
    this.aiPromptMetadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // From Firestore
  factory WorkoutPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutPlanModel(
      planId: doc.id,
      userId: data['userId'],
      planTitle: data['planTitle'],
      planDescription: data['planDescription'],
      totalDays: data['totalDays'],
      totalWeeks: data['totalWeeks'],
      phases: (data['phases'] as List<dynamic>)
          .map((phase) => PhaseModel.fromMap(phase as Map<String, dynamic>))
          .toList(),
      currentDay: data['currentDay'] ?? 1,
      currentPhaseId: data['currentPhaseId'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      estimatedEndDate: data['estimatedEndDate'] != null
          ? (data['estimatedEndDate'] as Timestamp).toDate()
          : null,
      actualEndDate: data['actualEndDate'] != null
          ? (data['actualEndDate'] as Timestamp).toDate()
          : null,
      status: PlanStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => PlanStatus.active,
      ),
      completedDays: data['completedDays'] ?? 0,
      missedDays: data['missedDays'] ?? 0,
      completionPercentage: (data['completionPercentage'] ?? 0).toDouble(),
      generatedBy: data['generatedBy'],
      generatedAt: (data['generatedAt'] as Timestamp).toDate(),
      aiModelVersion: data['aiModelVersion'],
      aiPromptMetadata: data['aiPromptMetadata'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // From API JSON (Backend response)
  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    // Parse dates
    final startDate = DateTime.parse(json['startDate']);
    final endDate = DateTime.parse(json['endDate']);
    
    // Convert backend phases to frontend PhaseModel
    final phases = (json['phases'] as List)
        .map((phaseJson) => PhaseModel.fromBackendJson(
              phaseJson as Map<String, dynamic>,
              json['dailyWorkouts'] as List,
            ))
        .toList();
    
    return WorkoutPlanModel(
      planId: json['planId'],
      userId: json['userId'],
      planTitle: json['title'],
      planDescription: json['description'],
      totalDays: json['totalDays'],
      totalWeeks: json['totalWeeks'],
      phases: phases,
      currentDay: 1, // Start at day 1
      currentPhaseId: phases.isNotEmpty ? phases[0].phaseId : '',
      startDate: startDate,
      estimatedEndDate: endDate,
      actualEndDate: null,
      status: PlanStatus.active,
      completedDays: 0,
      missedDays: 0,
      completionPercentage: 0.0,
      generatedBy: json['generatedBy'] ?? 'gemini-2.5-flash',
      generatedAt: DateTime.parse(json['generatedAt']),
      aiModelVersion: json['generatedBy'] ?? 'gemini-2.5-flash',
      aiPromptMetadata: {
        'menstrualCycleSync': json['menstrualCycleSync'] ?? false,
        'cycleStartWeek': json['cycleStartWeek'],
        'allExerciseIds': json['allExerciseIds'],
      },
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.now(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'planTitle': planTitle,
      'planDescription': planDescription,
      'totalDays': totalDays,
      'totalWeeks': totalWeeks,
      'phases': phases.map((phase) => phase.toMap()).toList(),
      'currentDay': currentDay,
      'currentPhaseId': currentPhaseId,
      'startDate': Timestamp.fromDate(startDate),
      'estimatedEndDate': estimatedEndDate != null
          ? Timestamp.fromDate(estimatedEndDate!)
          : null,
      'actualEndDate': actualEndDate != null
          ? Timestamp.fromDate(actualEndDate!)
          : null,
      'status': status.toString().split('.').last,
      'completedDays': completedDays,
      'missedDays': missedDays,
      'completionPercentage': completionPercentage,
      'generatedBy': generatedBy,
      'generatedAt': Timestamp.fromDate(generatedAt),
      'aiModelVersion': aiModelVersion,
      'aiPromptMetadata': aiPromptMetadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper: Get phase by ID
  PhaseModel? getPhaseById(String phaseId) {
    try {
      return phases.firstWhere((phase) => phase.phaseId == phaseId);
    } catch (e) {
      return null;
    }
  }

  // Helper: Get current phase
  PhaseModel? getCurrentPhase() {
    return getPhaseById(currentPhaseId);
  }

  // Helper: Get day by number
  DayPlanModel? getDayByNumber(int dayNumber) {
    for (var phase in phases) {
      final day = phase.days.firstWhere(
        (d) => d.dayNumber == dayNumber,
        orElse: () => null as DayPlanModel,
      );
      if (day != null) return day;
    }
    return null;
  }

  // CopyWith
  WorkoutPlanModel copyWith({
    String? planTitle,
    String? planDescription,
    int? currentDay,
    String? currentPhaseId,
    DateTime? startDate,
    DateTime? estimatedEndDate,
    DateTime? actualEndDate,
    PlanStatus? status,
    int? completedDays,
    int? missedDays,
    double? completionPercentage,
    DateTime? updatedAt,
  }) {
    return WorkoutPlanModel(
      planId: planId,
      userId: userId,
      planTitle: planTitle ?? this.planTitle,
      planDescription: planDescription ?? this.planDescription,
      totalDays: totalDays,
      totalWeeks: totalWeeks,
      phases: phases,
      currentDay: currentDay ?? this.currentDay,
      currentPhaseId: currentPhaseId ?? this.currentPhaseId,
      startDate: startDate ?? this.startDate,
      estimatedEndDate: estimatedEndDate ?? this.estimatedEndDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      status: status ?? this.status,
      completedDays: completedDays ?? this.completedDays,
      missedDays: missedDays ?? this.missedDays,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      generatedBy: generatedBy,
      generatedAt: generatedAt,
      aiModelVersion: aiModelVersion,
      aiPromptMetadata: aiPromptMetadata,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Enums
enum PlanStatus {
  active,
  paused,
  completed,
  archived,
}
