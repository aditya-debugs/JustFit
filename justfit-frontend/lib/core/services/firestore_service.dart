import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    String? workoutTitle, // ✅ NEW - for discovery workouts
    String? workoutCategory, // ✅ NEW - for discovery workouts
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId);

      final data = {
        'workoutId': workoutId,
        'planId': planId,
        'day': day,
        'date': date,
        'duration': duration,
        'calories': calories,
        'exercisesCompleted': exercisesCompleted,
        'isComplete': isComplete,
        'completedAt': FieldValue.serverTimestamp(),
      };

      // Add optional fields for discovery workouts
      if (workoutTitle != null) {
        data['workoutTitle'] = workoutTitle;
      }
      if (workoutCategory != null) {
        data['workoutCategory'] = workoutCategory;
      }

      await docRef.set(data);

      print(
          '✅ Workout saved to Firestore: Day $day, $duration min, $calories cal');
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
      print('⚖️ Querying weight history for $year-$month');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_history')
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          // ✅ Removed .orderBy('day') - we'll sort in code instead
          .get();

      print('⚖️ Found ${snapshot.docs.length} weight entries in Firestore');

      final List<Map<String, dynamic>> history = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp;
        history.add({
          'date': timestamp.toDate(),
          'weight': data['weight'],
        });
      }

      return history;
    } catch (e) {
      print('❌ Error getting weight history: $e');
      return [];
    }
  }

  /// Get ALL weight history entries (for timeline continuity)
  Future<List<Map<String, dynamic>>> getAllWeightHistory(String userId) async {
    try {
      print('⚖️ Fetching ALL weight history for timeline');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_history')
          .get();

      print('⚖️ Found ${snapshot.docs.length} total weight entries');

      final List<Map<String, dynamic>> history = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp;
        history.add({
          'date': timestamp.toDate(),
          'weight': data['weight'],
        });
      }

      // Sort by date
      history.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

      return history;
    } catch (e) {
      print('❌ Error getting all weight history: $e');
      return [];
    }
  }

  /// Get user's weight goal
  Future<double?> getWeightGoal(String userId) async {
    try {
      print('🎯 Fetching goal weight...');

      // First check top-level goalWeight field
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data();

        // Check top-level goalWeight
        if (data?['goalWeight'] != null) {
          final goal = (data!['goalWeight'] as num).toDouble();
          print('🎯 Found goal in profile: $goal kg');
          return goal;
        }

        // Check nested onboardingData
        if (data?['onboardingData'] != null) {
          final onboardingData =
              data!['onboardingData'] as Map<String, dynamic>;
          if (onboardingData['goalWeight'] != null) {
            final goal = (onboardingData['goalWeight'] as num).toDouble();
            print('🎯 Found goal in onboardingData: $goal kg');
            return goal;
          }
        }
      }

      // Fallback: check goals collection
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc('weight_goal')
          .get();

      if (doc.exists && doc.data()?['targetWeight'] != null) {
        final goal = (doc.data()!['targetWeight'] as num).toDouble();
        print('🎯 Found goal in goals collection: $goal kg');
        return goal;
      }

      print('⚠️ No goal weight found');
      return null;
    } catch (e) {
      print('❌ Error getting goal weight: $e');
      return null;
    }
  }

  /// Save weight entry
  Future<void> saveWeightEntry({
    required String userId,
    required double weight,
    DateTime? date,
  }) async {
    try {
      final entryDate = date ?? DateTime.now();
      final docId = '${entryDate.year}_${entryDate.month}_${entryDate.day}';

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_history')
          .doc(docId)
          .set({
        'weight': weight,
        'date': Timestamp.fromDate(entryDate),
        'year': entryDate.year,
        'month': entryDate.month,
        'day': entryDate.day,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print(
          '✅ Weight entry saved: $weight kg on ${entryDate.year}-${entryDate.month}-${entryDate.day}');
    } catch (e) {
      print('❌ Error saving weight entry: $e');
      rethrow;
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
      // ✅ FIX: Ensure precise week boundaries (Monday 00:00:00 to next Monday 00:00:00)
      final normalizedStart =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final weekEnd = DateTime(weekStart.year, weekStart.month, weekStart.day)
          .add(const Duration(days: 7));

      print(
          '⏱️ Querying duration from ${normalizedStart.toIso8601String()} to ${weekEnd.toIso8601String()}');
      print(
          '   Week range: ${DateFormat('MMM d').format(normalizedStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd.subtract(const Duration(days: 1)))}');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('completedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(normalizedStart))
          .where('completedAt', isLessThan: Timestamp.fromDate(weekEnd))
          .get();

      print(
          '⏱️ Found ${snapshot.docs.length} workouts for duration calculation');

      final Map<int, int> durations = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['completedAt'] as Timestamp).toDate();
        final weekday = date.weekday - 1; // 0 = Monday, 6 = Sunday
        final duration = data['duration'] ??
            0; // ✅ FIXED: Changed from 'totalMinutes' to 'duration'

        durations[weekday] = (durations[weekday] ?? 0) + (duration as int);
        print(
            '  📅 Day ${weekday} (${date.toString().split(' ')[0]}): +${duration} min');
      }

      print('⏱️ Final durations (in minutes): $durations');
      return durations;
    } catch (e) {
      print('❌ Error getting weekly duration: $e');
      return {};
    }
  }

  /// Get weekly calories burned
  Future<Map<int, int>> getWeeklyCalories({
    required String userId,
    required DateTime weekStart,
  }) async {
    try {
      // ✅ FIX: Ensure precise week boundaries (Monday 00:00:00 to next Monday 00:00:00)
      final normalizedStart =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final weekEnd = DateTime(weekStart.year, weekStart.month, weekStart.day)
          .add(const Duration(days: 7));

      print(
          '🔥 Querying calories from ${normalizedStart.toIso8601String()} to ${weekEnd.toIso8601String()}');
      print(
          '   Week range: ${DateFormat('MMM d').format(normalizedStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd.subtract(const Duration(days: 1)))}');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('completedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(normalizedStart))
          .where('completedAt', isLessThan: Timestamp.fromDate(weekEnd))
          .get();

      print(
          '🔥 Found ${snapshot.docs.length} workouts for calories calculation');

      final Map<int, int> calories = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['completedAt'] as Timestamp).toDate();
        final weekday = date.weekday - 1; // 0 = Monday, 6 = Sunday
        final cal = data['calories'] ??
            0; // ✅ FIXED: Changed from 'totalCalories' to 'calories'

        calories[weekday] = (calories[weekday] ?? 0) + (cal as int);
        print(
            '  📅 Day ${weekday} (${date.toString().split(' ')[0]}): +${cal} kcal');
      }

      print('🔥 Final calories: $calories');
      return calories;
    } catch (e) {
      print('❌ Error getting weekly calories: $e');
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
      final endDate =
          DateTime(year, month + 1, 0, 23, 59, 59); // ✅ Include end of last day

      print('📅 ========== MONTHLY WORKOUT QUERY ==========');
      print('   User: $userId');
      print('   Month: $year-$month');
      print('   Start: $startDate');
      print('   End: $endDate');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('completedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('completedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      print('📅 Found ${snapshot.docs.length} workout documents');

      final Set<int> workoutDays = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('   📄 Document ID: ${doc.id}');
        print('      Data keys: ${data.keys.toList()}');

        final completedAt = data['completedAt'];
        if (completedAt != null) {
          final date = (completedAt as Timestamp).toDate();
          workoutDays.add(date.day);
          print('      ✅ Workout on day ${date.day} (${date})');
        } else {
          print('      ⚠️ No completedAt field!');
        }
      }

      print('📅 Final workout days set: $workoutDays');
      print('📅 ==========================================');

      return workoutDays;
    } catch (e) {
      print('❌ Error getting monthly workout days: $e');
      print('   Stack trace: ${StackTrace.current}');
      return {};
    }
  }

  /// Get user's total progress stats
  Future<Map<String, dynamic>?> getUserProgressStats(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('stats')
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('❌ Error fetching user progress stats: $e');
      return null;
    }
  }

  /// Get user's profile weight (from onboarding or latest entry)
  Future<double?> getUserCurrentWeight(String userId) async {
    try {
      print('⚖️ Fetching user weight from profile...');

      // First try to get from user profile document
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data();

        // Check top-level weight field
        if (data?['weight'] != null) {
          final weight = (data!['weight'] as num).toDouble();
          print('⚖️ Found weight in profile: $weight kg');
          return weight;
        }

        // Check nested onboardingData
        if (data?['onboardingData'] != null) {
          final onboardingData =
              data!['onboardingData'] as Map<String, dynamic>;
          if (onboardingData['weight'] != null) {
            final weight = (onboardingData['weight'] as num).toDouble();
            print('⚖️ Found weight in onboardingData: $weight kg');
            return weight;
          }
        }
      }

      // Fallback: get latest weight entry from history
      print('⚖️ No weight in profile, checking weight_history...');
      final latestSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight_history')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (latestSnapshot.docs.isNotEmpty) {
        final weight =
            (latestSnapshot.docs.first.data()['weight'] as num).toDouble();
        print('⚖️ Found weight in history: $weight kg');
        return weight;
      }

      print('⚠️ No weight found anywhere');
      return null;
    } catch (e) {
      print('❌ Error getting user current weight: $e');
      return null;
    }
  }
}
