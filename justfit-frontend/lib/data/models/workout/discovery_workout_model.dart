import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_set_model.dart';

class DiscoveryWorkoutModel {
  final String id;
  final String title;
  final String category; // knee_friendly, belly, plus_size, etc.
  final int duration; // minutes
  final int calories;
  final String intensity; // low, medium, high
  final String equipment;
  final String focusZones;
  final String imageUrl;
  final bool isVip;
  final List<WorkoutSetModel> workoutSets;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiscoveryWorkoutModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.calories,
    required this.intensity,
    required this.equipment,
    required this.focusZones,
    required this.imageUrl,
    this.isVip = false,
    required this.workoutSets,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiscoveryWorkoutModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return DiscoveryWorkoutModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      duration: data['duration'] ?? 0,
      calories: data['calories'] ?? 0,
      intensity: data['intensity'] ?? 'medium',
      equipment: data['equipment'] ?? 'None',
      focusZones: data['focusZones'] ?? 'FullBody',
      imageUrl: data['imageUrl'] ?? '',
      isVip: data['isVip'] ?? false,
      workoutSets: (data['workoutSets'] as List<dynamic>?)
              ?.map((set) => WorkoutSetModel.fromMap(set as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'duration': duration,
      'calories': calories,
      'intensity': intensity,
      'equipment': equipment,
      'focusZones': focusZones,
      'imageUrl': imageUrl,
      'isVip': isVip,
      'workoutSets': workoutSets.map((set) => set.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
