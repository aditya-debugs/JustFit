import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== WORKOUT COMPLETION ====================
  
  /// Save a completed workout to Firestore
  Future<void> saveWorkoutCompletion({
    required String userId,
    required String workoutId,
    required String planId,
    required int day,
    required String date,
    required int duration, // in minutes
    required int calories,
    required List<String> exercisesCompleted,
    required bool isComplete,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId);

      await docRef.set({
        'workoutId': workoutId,
        'planId': planId,
        'day': day,
        'date': date,
        'duration': duration,
        'calories': calories,
        'exercisesCompleted': exercisesCompleted,
        'isComplete': isComplete,
        'completedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Workout saved to Firestore: Day $day, $duration min, $calories cal');
    } catch (e) {
      print('❌ Error saving workout: $e');
      rethrow;
    }
  }

  /// Get workout history for a user
  Future<List<Map<String, dynamic>>> getWorkoutHistory({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .orderBy('completedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('❌ Error fetching workout history: $e');
      return [];
    }
  }

  /// Get today's workouts
  Future<List<Map<String, dynamic>>> getTodayWorkouts({
    required String userId,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('date', isEqualTo: today)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('❌ Error fetching today\'s workouts: $e');
      return [];
    }
  }

  // ==================== STREAK MANAGEMENT ====================
  
  /// Update user's streak after workout completion
  Future<void> updateStreak({
    required String userId,
    required DateTime lastWorkoutDate,
    required int currentStreak,
    int? longestStreak,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('streak');

      await docRef.set({
        'currentStreak': currentStreak,
        'lastWorkoutDate': lastWorkoutDate.toIso8601String().split('T')[0],
        'longestStreak': longestStreak ?? currentStreak,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Streak updated: $currentStreak days');
    } catch (e) {
      print('❌ Error updating streak: $e');
      rethrow;
    }
  }

  /// Get user's streak data
  Future<Map<String, dynamic>?> getStreak({
    required String userId,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('streak')
          .get();

      if (!doc.exists) {
        return {
          'currentStreak': 0,
          'lastWorkoutDate': null,
          'longestStreak': 0,
        };
      }

      return doc.data();
    } catch (e) {
      print('❌ Error fetching streak: $e');
      return null;
    }
  }

  // ==================== ACHIEVEMENTS ====================
  
  /// Save an earned achievement
  Future<void> saveAchievement({
    required String userId,
    required String achievementId,
    required String achievementType,
    required String title,
    required String description,
    required int badgeNumber,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId);

      await docRef.set({
        'achievementId': achievementId,
        'achievementType': achievementType,
        'title': title,
        'description': description,
        'badgeNumber': badgeNumber,
        'earnedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Achievement saved: $title');
    } catch (e) {
      print('❌ Error saving achievement: $e');
      rethrow;
    }
  }

  /// Get all earned achievements for a user
  Future<List<Map<String, dynamic>>> getAchievements({
    required String userId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .orderBy('earnedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('❌ Error fetching achievements: $e');
      return [];
    }
  }

  /// Check if a specific achievement exists
  Future<bool> hasAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .get();

      return doc.exists;
    } catch (e) {
      print('❌ Error checking achievement: $e');
      return false;
    }
  }

  // ==================== USER STATS ====================
  
  /// Get aggregated user statistics
  Future<Map<String, dynamic>> getUserStats({
    required String userId,
  }) async {
    try {
      // Get total workouts
      final workoutsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('isComplete', isEqualTo: true)
          .get();

      int totalWorkouts = workoutsSnapshot.docs.length;
      int totalCalories = 0;
      int totalMinutes = 0;

      for (var doc in workoutsSnapshot.docs) {
        final data = doc.data();
        totalCalories += (data['calories'] as int?) ?? 0;
        totalMinutes += (data['duration'] as int?) ?? 0;
      }

      // Get streak
      final streakData = await getStreak(userId: userId);

      return {
        'totalWorkouts': totalWorkouts,
        'totalCalories': totalCalories,
        'totalMinutes': totalMinutes,
        'currentStreak': streakData?['currentStreak'] ?? 0,
        'longestStreak': streakData?['longestStreak'] ?? 0,
      };
    } catch (e) {
      print('❌ Error fetching user stats: $e');
      return {
        'totalWorkouts': 0,
        'totalCalories': 0,
        'totalMinutes': 0,
        'currentStreak': 0,
        'longestStreak': 0,
      };
    }
  }

    // ========== WEIGHT TRACKING ==========
  
  /// Log a weight entry
  Future<void> logWeight({
    required String userId,
    required double weight,
    DateTime? date,
  }) async {
    try {
      final logDate = date ?? DateTime.now();
      final docId = '${logDate.year}_${logDate.month}_${logDate.day}';
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_logs')
          .doc(docId)
          .set({
        'weight': weight,
        'date': Timestamp.fromDate(logDate),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging weight: $e');
      rethrow;
    }
  }
  
  /// Get weight history for a specific month
  Future<List<Map<String, dynamic>>> getWeightHistory({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_logs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'weight': data['weight'],
          'date': (data['date'] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      print('Error getting weight history: $e');
      return [];
    }
  }
  
  /// Get user's weight goal
  Future<double?> getWeightGoal(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc('weight')
          .get();
      
      if (doc.exists) {
        return doc.data()?['targetWeight'];
      }
      return null;
    } catch (e) {
      print('Error getting weight goal: $e');
      return null;
    }
  }
  
  /// Set user's weight goal
  Future<void> setWeightGoal({
    required String userId,
    required double targetWeight,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc('weight')
          .set({
        'targetWeight': targetWeight,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error setting weight goal: $e');
      rethrow;
    }
  }
  
  // ========== PROGRESS STATS ==========
  
  /// Get weekly workout duration
  Future<Map<int, int>> getWeeklyDuration({
    required String userId,
    required DateTime weekStart,
  }) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 7));
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
          .where('completedAt', isLessThan: Timestamp.fromDate(weekEnd))
          .get();
      
      final Map<int, int> durations = {};
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['completedAt'] as Timestamp).toDate();
        final weekday = date.weekday % 7; // 0 = Sunday
        final duration = data['totalMinutes'] ?? 0;
        
        durations[weekday] = (durations[weekday] ?? 0) + (duration as int);
      }
      
      return durations;
    } catch (e) {
      print('Error getting weekly duration: $e');
      return {};
    }
  }
  
  /// Get weekly calories burned
  Future<Map<int, int>> getWeeklyCalories({
    required String userId,
    required DateTime weekStart,
  }) async {
    try {
      final weekEnd = weekStart.add(const Duration(days: 7));
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
          .where('completedAt', isLessThan: Timestamp.fromDate(weekEnd))
          .get();
      
      final Map<int, int> calories = {};
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['completedAt'] as Timestamp).toDate();
        final weekday = date.weekday % 7; // 0 = Sunday
        final cal = data['totalCalories'] ?? 0;
        
        calories[weekday] = (calories[weekday] ?? 0) + (cal as int);
      }
      
      return calories;
    } catch (e) {
      print('Error getting weekly calories: $e');
      return {};
    }
  }
  
  /// Get monthly workout days (for calendar)
Future<Set<int>> getMonthlyWorkoutDays({
  required String userId,
  required int year,
  required int month,
}) async {
  try {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('completedAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    
    final Set<int> workoutDays = {};
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = (data['completedAt'] as Timestamp).toDate();
      workoutDays.add(date.day);
    }
    
    return workoutDays;
  } catch (e) {
    print('Error getting monthly workout days: $e');
    return {};
  }
}
}