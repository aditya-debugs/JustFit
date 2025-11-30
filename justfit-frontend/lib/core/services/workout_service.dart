import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/datasources/workout_api.dart';
import '../../data/models/workout/workout_plan_model.dart';
import '../../data/models/workout/exercise_model.dart';
import './user_service.dart';


class WorkoutService {
  final WorkoutApiService _apiService;
  final FirebaseFirestore _firestore;
  
  // In-memory cache
  final Map<String, WorkoutPlanModel> _planCache = {};
  final Map<String, ExerciseModel> _exerciseCache = {};
  
  WorkoutService({
    WorkoutApiService? apiService,
    FirebaseFirestore? firestore,
  })  : _apiService = apiService ?? WorkoutApiService(),
        _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Generate and save a workout plan
Future<WorkoutPlanModel> generateAndSaveWorkoutPlan({
  required Map<String, dynamic> onboardingData,
  required String userId,
  String? startDate,
}) async {
  try {
    print('=' * 60);
    print('🚀 GENERATING WORKOUT PLAN');
    print('=' * 60);
    print('👤 User ID: $userId');
    print('📅 Start Date: ${startDate ?? "Today"}');
    print('=' * 60);
    
    // Generate plan from backend
    final plan = await _apiService.generateWorkoutPlan(
      onboardingData: onboardingData,
      userId: userId,
      startDate: startDate,
    );
    
    print('✅ Workout plan generated successfully!');
    print('📊 Plan Details:');
    print('   - Title: ${plan.planTitle}');
    print('   - Duration: ${plan.totalDays} days');
    print('   - Phases: ${plan.phases.length}');
    print('   - Plan ID: ${plan.planId}');
    print('=' * 60);
    
    // Cache it
    _planCache[plan.planId] = plan;
    
    // Save to Firestore (root collection)
print('💾 Saving plan to root Firestore collection...');
await _firestore
    .collection('workout_plans')
    .doc(plan.planId)
    .set(plan.toFirestore());

print('✅ Plan saved to root collection');

// ✅ ALSO save complete plan to user's subcollection
print('💾 Saving plan to user subcollection...');
await _firestore
    .collection('users')
    .doc(userId)
    .collection('workout_plans')
    .doc(plan.planId)
    .set(plan.toFirestore());

print('✅ Plan saved to user subcollection');

// Update user's current plan
print('👤 Updating user profile in Firestore...');
await _firestore
    .collection('users')
    .doc(userId)
    .set({
      'currentPlanId': plan.planId,
      'planStartDate': startDate ?? DateTime.now().toIso8601String().split('T')[0],
    }, SetOptions(merge: true));
    
    print('✅ User profile updated in Firestore');
    
    // ✅ CRITICAL FIX: Reload user profile in memory so UI shows the new plan
    try {
      print('🔄 Reloading user profile in memory...');
      final userService = Get.find<UserService>();
      await userService.loadUserProfile(userId);
      print('✅ User profile reloaded - currentPlanId is now available');
    } catch (e) {
      print('⚠️ Failed to reload user profile: $e');
      // Non-critical, but plan may not show immediately
    }
    
    print('=' * 60);
    
    return plan;
  } catch (e) {
    print('=' * 60);
    print('❌ ERROR GENERATING WORKOUT PLAN');
    print('Error: $e');
    print('=' * 60);
    rethrow;
  }
}

  
  /// Get workout plan (from cache or Firestore)
Future<WorkoutPlanModel?> getWorkoutPlan(String planId) async {
  try {
    print('📖 Fetching plan: $planId');
    
    // Check cache first
    if (_planCache.containsKey(planId)) {
      print('✅ Plan found in cache');
      return _planCache[planId];
    }
    
    // ✅ FIX: Get current user to fetch from their subcollection
    final userService = Get.find<UserService>();
    final userId = userService.currentUser.value?.uid;
    
    if (userId == null) {
      print('❌ No user logged in');
      return null;
    }
    
    // ✅ FIX: Try user subcollection first, but validate it has complete data
print('🔍 Fetching from user subcollection: users/$userId/workout_plans/$planId');
var doc = await _firestore
    .collection('users')
    .doc(userId)
    .collection('workout_plans')
    .doc(planId)
    .get();

// Check if document exists AND has required fields (planTitle is a good indicator)
final hasCompleteData = doc.exists && doc.data()?['planTitle'] != null;

if (!hasCompleteData) {
  if (doc.exists) {
    print('⚠️ User subcollection has incomplete data, deleting and fetching from root...');
    // Delete incomplete document
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('workout_plans')
        .doc(planId)
        .delete();
  } else {
    print('⚠️ Not found in user subcollection, trying root collection...');
  }
  
  // Fetch from root collection
  doc = await _firestore
      .collection('workout_plans')
      .doc(planId)
      .get();
  
  // If found in root, copy to user subcollection for future
  if (doc.exists) {
    print('✅ Found in root collection, copying to user subcollection...');
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('workout_plans')
        .doc(planId)
        .set(doc.data()!);
    print('✅ Plan migrated to user subcollection');
  }
}
    
    if (!doc.exists) {
      print('⚠️ Plan not found in Firestore');
      return null;
    }
    
    final plan = WorkoutPlanModel.fromFirestore(doc);
    _planCache[planId] = plan;
    
    print('✅ Plan loaded from Firestore');
    print('   - Completed days in plan: ${plan.completedDays}');
    print('   - Phases count: ${plan.phases.length}');
    return plan;
  } catch (e) {
    print('❌ Error fetching workout plan: $e');
    rethrow;
  }
}
  
  /// Fetch exercise details from backend and cache them (with batching)
  Future<List<ExerciseModel>> fetchAndCacheExerciseDetails(
    List<String> exerciseIds,
  ) async {
    try {
      print('=' * 60);
      print('🏋️  FETCHING EXERCISE DETAILS');
      print('=' * 60);
      print('📋 Total requested: ${exerciseIds.length} exercises');
      
      // Filter out already cached exercises
      final uncachedIds = exerciseIds
          .where((id) => !_exerciseCache.containsKey(id))
          .toList();
      
      if (uncachedIds.isEmpty) {
        print('✅ All ${exerciseIds.length} exercises already cached');
        print('=' * 60);
        return exerciseIds.map((id) => _exerciseCache[id]!).toList();
      }
      
      print('📦 Cached: ${exerciseIds.length - uncachedIds.length}');
      print('🆕 Need to fetch: ${uncachedIds.length}');
      print('=' * 60);
      
      // BATCH SIZE: 15 exercises per request (safe limit for Gemini)
      const batchSize = 15;
      final List<ExerciseModel> allExercises = [];
      int successCount = 0;
      int failCount = 0;
      
      for (int i = 0; i < uncachedIds.length; i += batchSize) {
        final end = (i + batchSize < uncachedIds.length) 
            ? i + batchSize 
            : uncachedIds.length;
        final batch = uncachedIds.sublist(i, end);
        
        final batchNum = (i ~/ batchSize) + 1;
        final totalBatches = (uncachedIds.length / batchSize).ceil();
        
        print('');
        print('📦 BATCH $batchNum/$totalBatches');
        print('   Exercises: ${batch.length}');
        print('   IDs: ${batch.join(", ")}');
        print('   Status: Fetching...');
        
        try {
          // Fetch this batch
          final exercises = await _apiService.fetchExerciseDetails(
            exerciseIds: batch,
          );
          
          print('   ✅ Backend returned ${exercises.length} exercises');
          
          // Validate exercises
          if (exercises.isEmpty) {
            print('   ⚠️  WARNING: Backend returned 0 exercises!');
            failCount++;
          } else {
            // Cache them
            for (var exercise in exercises) {
              _exerciseCache[exercise.exerciseId] = exercise;
              print('      ✓ ${exercise.exerciseId}: ${exercise.exerciseName}');
            }
            
            allExercises.addAll(exercises);
            successCount++;
            print('   ✅ Batch $batchNum COMPLETE');
          }
          
          // Small delay between batches
          if (end < uncachedIds.length) {
            await Future.delayed(Duration(milliseconds: 500));
          }
        } catch (e) {
          print('   ❌ Batch $batchNum FAILED: $e');
          failCount++;
          // Continue with other batches instead of failing completely
        }
      }
      
      print('');
      print('=' * 60);
      print('📊 FETCH SUMMARY');
      print('=' * 60);
      print('✅ Successful batches: $successCount');
      print('❌ Failed batches: $failCount');
      print('💾 Total exercises cached: ${allExercises.length}');
      print('=' * 60);
      
      // Save to Firestore
      if (allExercises.isNotEmpty) {
        try {
          print('💾 Saving to Firestore...');
          final batch = _firestore.batch();
          for (var exercise in allExercises) {
            final docRef = _firestore
                .collection('exercise_details')
                .doc(exercise.exerciseId);
            batch.set(docRef, exercise.toMap());
          }
          await batch.commit();
          print('✅ Saved to Firestore');
        } catch (e) {
          print('⚠️  Firestore save failed: $e');
        }
      }
      
      print('=' * 60);
      
      // Return all requested exercises (from cache)
      final result = exerciseIds
          .where((id) => _exerciseCache.containsKey(id))
          .map((id) => _exerciseCache[id]!)
          .toList();
      
      print('🎯 Returning ${result.length}/${exerciseIds.length} requested exercises');
      print('=' * 60);
      
      return result;
      
    } catch (e) {
      print('=' * 60);
      print('❌ CRITICAL ERROR FETCHING EXERCISE DETAILS');
      print('Error: $e');
      print('=' * 60);
      rethrow;
    }
  }
  
  /// Get exercise details (from cache or Firestore)
  Future<ExerciseModel?> getExerciseDetails(String exerciseId) async {
    try {
      // Check cache
      if (_exerciseCache.containsKey(exerciseId)) {
        return _exerciseCache[exerciseId];
      }
      
      // Fetch from Firestore
      final doc = await _firestore
          .collection('exercise_details')
          .doc(exerciseId)
          .get();
      
      if (!doc.exists) {
        return null;
      }
      
      final exercise = ExerciseModel.fromMap(doc.data()!);
      _exerciseCache[exerciseId] = exercise;
      
      return exercise;
    } catch (e) {
      print('❌ Error fetching exercise details: $e');
      rethrow;
    }
  }
  
  /// Clear all caches
  void clearCache() {
    _planCache.clear();
    _exerciseCache.clear();
    print('🗑️  Cache cleared');
  }
}
