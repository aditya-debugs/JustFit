import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/models/workout/discovery_workout_model.dart';

class DiscoveryWorkoutService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // In-memory cache
  final Map<String, DiscoveryWorkoutModel> _workoutCache = {};
  final Map<String, List<DiscoveryWorkoutModel>> _categoryCache = {};

  // Get single workout by ID
  Future<DiscoveryWorkoutModel?> getWorkoutById(String workoutId) async {
    try {
      // Check cache first
      if (_workoutCache.containsKey(workoutId)) {
        print('✅ Workout $workoutId fetched from cache');
        return _workoutCache[workoutId];
      }

      // Fetch from Firestore
      final doc = await _firestore
          .collection('discovery_workouts')
          .doc(workoutId)
          .get();

      if (!doc.exists) {
        print('❌ Workout $workoutId not found');
        return null;
      }

      final workout = DiscoveryWorkoutModel.fromFirestore(doc);
      _workoutCache[workoutId] = workout;
      
      print('✅ Workout $workoutId fetched from Firestore');
      return workout;
    } catch (e) {
      print('❌ Error fetching workout $workoutId: $e');
      return null;
    }
  }

  // Get all workouts for a category
  Future<List<DiscoveryWorkoutModel>> getWorkoutsByCategory(String category) async {
    try {
      // Check cache first
      if (_categoryCache.containsKey(category)) {
        print('✅ Category $category fetched from cache (${_categoryCache[category]!.length} workouts)');
        return _categoryCache[category]!;
      }

      // Fetch from Firestore
      final querySnapshot = await _firestore
          .collection('discovery_workouts')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: false)
          .get();

      final workouts = querySnapshot.docs
          .map((doc) => DiscoveryWorkoutModel.fromFirestore(doc))
          .toList();

      // Update cache
      _categoryCache[category] = workouts;
      for (var workout in workouts) {
        _workoutCache[workout.id] = workout;
      }

      print('✅ Category $category fetched from Firestore (${workouts.length} workouts)');
      return workouts;
    } catch (e) {
      print('❌ Error fetching category $category: $e');
      return [];
    }
  }

  // Preload all workouts (call on app start)
  Future<void> preloadAllWorkouts() async {
    try {
      print('🔄 Preloading all discovery workouts...');
      
      final querySnapshot = await _firestore
          .collection('discovery_workouts')
          .get();

      for (var doc in querySnapshot.docs) {
        final workout = DiscoveryWorkoutModel.fromFirestore(doc);
        _workoutCache[workout.id] = workout;
        
        // Group by category
        if (!_categoryCache.containsKey(workout.category)) {
          _categoryCache[workout.category] = [];
        }
        _categoryCache[workout.category]!.add(workout);
      }

      print('✅ Preloaded ${_workoutCache.length} discovery workouts');
    } catch (e) {
      print('❌ Error preloading workouts: $e');
    }
  }

  // Clear cache
  void clearCache() {
    _workoutCache.clear();
    _categoryCache.clear();
    print('🗑️ Discovery workout cache cleared');
  }
}
