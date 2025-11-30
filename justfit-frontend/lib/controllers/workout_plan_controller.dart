import 'package:get/get.dart';
import '../core/services/user_service.dart';
import '../core/services/workout_service.dart';
import '../data/models/workout/workout_plan_model.dart';
import '../data/models/workout/day_plan_model.dart';
import '../data/models/workout/phase_model.dart';
import '../data/models/achievement_model.dart';
import '../core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class WorkoutPlanController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final WorkoutService _workoutService = WorkoutService();
  // Add FirestoreService instance
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  // Reactive state
  Rx<WorkoutPlanModel?> currentPlan = Rx<WorkoutPlanModel?>(null);
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Streak tracking
  RxInt userStreak = 0.obs;
  RxList<bool> weeklyProgress =
      <bool>[false, false, false, false, false, false, false].obs;
  Rx<DateTime?> lastWorkoutDate = Rx<DateTime?>(null);
  Rx<AchievementModel?> pendingAchievement = Rx<AchievementModel?>(null);

  // Computed properties
  bool get hasPlan => currentPlan.value != null;

  int get currentDayNumber => currentPlan.value?.currentDay ?? 0;

  PhaseModel? get currentPhase => currentPlan.value?.getCurrentPhase();

  DayPlanModel? get todayWorkout {
    if (currentPlan.value == null) return null;
    return currentPlan.value!.getDayByNumber(currentDayNumber);
  }

  @override
  void onInit() {
    super.onInit();
    loadUserWorkoutPlan();
  }

  /// Load the user's active workout plan
  Future<void> loadUserWorkoutPlan({bool skipCalendarUpdate = false}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('📖 Loading user\'s workout plan...');

      final user = _userService.currentUser.value;
      if (user == null) {
        print('⚠️ No user logged in');
        return;
      }

      final planId = user.currentPlanId;
      if (planId == null || planId.isEmpty) {
        print('⚠️ User has no active workout plan');
        currentPlan.value = null;
        return;
      }

      print('🔍 Fetching plan: $planId');

      final plan = await _workoutService.getWorkoutPlan(planId);

      if (plan == null) {
        print('❌ Plan not found: $planId');
        hasError.value = true;
        errorMessage.value = 'Workout plan not found';
        return;
      }

      // ✅ AUTO-UPDATE CURRENT DAY BASED ON CALENDAR (only if not skipping)
      if (!skipCalendarUpdate) {
        final calculatedCurrentDay = calculateCurrentDayByDate(plan);

        // If calculated day is ahead, update Firestore
        if (calculatedCurrentDay > plan.currentDay) {
          print(
              '📅 Current day auto-updated: ${plan.currentDay} → $calculatedCurrentDay');

          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('workout_plans')
                .doc(planId)
                .set({
              'currentDay': calculatedCurrentDay,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            print(
                '✅ Firestore updated with new currentDay: $calculatedCurrentDay');
          } catch (e) {
            print('⚠️ Failed to update currentDay in Firestore: $e');
          }

          currentPlan.value = WorkoutPlanModel(
            planId: plan.planId,
            userId: plan.userId,
            planTitle: plan.planTitle,
            planDescription: plan.planDescription,
            totalDays: plan.totalDays,
            totalWeeks: plan.totalWeeks,
            phases: plan.phases,
            currentDay: calculatedCurrentDay,
            currentPhaseId: plan.currentPhaseId,
            startDate: plan.startDate,
            estimatedEndDate: plan.estimatedEndDate,
            actualEndDate: plan.actualEndDate,
            status: plan.status,
            completedDays: plan.completedDays,
            missedDays: plan.missedDays,
            completionPercentage: plan.completionPercentage,
            generatedBy: plan.generatedBy,
            generatedAt: plan.generatedAt,
            aiModelVersion: plan.aiModelVersion,
            aiPromptMetadata: plan.aiPromptMetadata,
            createdAt: plan.createdAt,
            updatedAt: DateTime.now(),
          );
        } else {
          currentPlan.value = plan;
        }
      } else {
        // Skip calendar update - use completion-based progression
        currentPlan.value = plan;
        print('⏭️ Skipped calendar update');
      }

      print('✅ Workout plan loaded successfully!');
      print('   - Title: ${currentPlan.value!.planTitle}');
      print('   - Duration: ${currentPlan.value!.totalDays} days');
      print('   - Current Day: ${currentPlan.value!.currentDay}');

      await _prefetchTodayExercises();
      await loadUserStreak();
    } catch (e) {
      print('❌ Error loading workout plan: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load workout plan';
    } finally {
      isLoading.value = false;
    }
  }

  /// Prefetch exercise details for today's workout
  Future<void> _prefetchTodayExercises() async {
    final today = todayWorkout;
    if (today == null || today.isRestDay) {
      print('⏸️ Today is a rest day, no exercises to prefetch');
      return;
    }

    print(
        '🏋️ Prefetching ${today.workoutSets.length} exercise details for today...');
    // Implement prefetching logic if needed
  }

  /// Complete a day and move to the next
  Future<bool> completeDay(int dayNumber) async {
    try {
      if (currentPlan.value == null) return false;

      final plan = currentPlan.value!;

      final newCompletedDays = plan.completedDays + 1;
      final newCurrentDay = dayNumber + 1;
      final newPercentage = (newCompletedDays / plan.totalDays) * 100;

      String newPhaseId = plan.currentPhaseId;
      for (var phase in plan.phases) {
        if (newCurrentDay >= phase.startDay && newCurrentDay <= phase.endDay) {
          newPhaseId = phase.phaseId;
          break;
        }
      }

      currentPlan.value = plan.copyWith(
        currentDay: newCurrentDay,
        currentPhaseId: newPhaseId,
        completedDays: newCompletedDays,
        completionPercentage: newPercentage,
        updatedAt: DateTime.now(),
      );

      print('✅ Day $dayNumber completed!');
      print('   - Progress: ${newPercentage.toStringAsFixed(1)}%');
      print('   - Next Day: $newCurrentDay');

      return true;
    } catch (e) {
      print('❌ Error completing day: $e');
      return false;
    }
  }

  /// Refresh the plan
  Future<void> refreshPlan() async {
    await loadUserWorkoutPlan();
  }

  /// Calculate estimated calories
  int calculateDayCalories(DayPlanModel day) {
    final baseFactor = 5;
    return (day.estimatedDuration * baseFactor).round();
  }

  /// ========== ENHANCED STREAK MANAGEMENT WITH FIRESTORE ==========

  /// Update streak after completing a workout with smart logic + Firestore
  Future<AchievementModel?> updateStreakAfterWorkout(int? dayNumber) async {
    // dayNumber is null for discovery workouts, has value for plan workouts
    try {
      print(
          '🔥 Updating streak after workout (Day: ${dayNumber ?? 'Discovery'})');

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final user = _userService.currentUser.value;

      if (user == null) {
        print('⚠️ No user logged in');
        return null;
      }

      // Check if this is a new workout today
      if (lastWorkoutDate.value != null) {
        final lastDate = DateTime(
          lastWorkoutDate.value!.year,
          lastWorkoutDate.value!.month,
          lastWorkoutDate.value!.day,
        );

        // If already worked out today, don't increment BUT still return current data
        if (lastDate.isAtSameMomentAs(today)) {
          print('⚠️ Already worked out today, streak not incremented');
          // Still update weekly progress for today (in case it wasn't set)
          final weekday = now.weekday % 7; // Sunday = 0, Saturday = 6
          weeklyProgress[weekday] = true;
          weeklyProgress.refresh();
          return null; // No new achievement, but weekly progress is maintained
        }

        // Check if streak should be reset (missed a day)
        final daysSinceLastWorkout = today.difference(lastDate).inDays;

        if (daysSinceLastWorkout > 1) {
          print(
              '💔 Streak broken! ${daysSinceLastWorkout} days since last workout');
          userStreak.value = 1; // Reset to 1 (today's workout)
          weeklyProgress.value = [
            false,
            false,
            false,
            false,
            false,
            false,
            false
          ];
        } else {
          // Continue streak (worked out yesterday)
          userStreak.value++;
        }
      } else {
        // First workout ever
        userStreak.value = 1;
      }

      // Update last workout date
      lastWorkoutDate.value = now;

      // Update weekly progress
      final weekday = now.weekday % 7; // Sunday = 0, Saturday = 6
      weeklyProgress[weekday] = true;
      weeklyProgress.refresh(); // ✅ Force GetX update
      print(
          '✅ Weekly progress set: index=$weekday, value=${weeklyProgress[weekday]}');

      print('✅ Streak updated: ${userStreak.value} days');
      print('📅 Last workout: ${lastWorkoutDate.value}');

      // ✅ SAVE TO FIRESTORE
      try {
        await _firestoreService.updateStreak(
          userId: user.uid,
          lastWorkoutDate: now,
          currentStreak: userStreak.value,
        );
        print('💾 Streak saved to Firestore');
      } catch (e) {
        print('❌ Failed to save streak to Firestore: $e');
      }

      // Check if user earned an achievement
      final achievement = _checkForStreakAchievement();
      if (achievement != null) {
        pendingAchievement.value = achievement;
        print('🏆 Streak Achievement earned: ${achievement.title}');

        // ✅ SAVE ACHIEVEMENT TO FIRESTORE
        try {
          await _firestoreService.saveAchievement(
            userId: user.uid,
            achievementId:
                'streak_${userStreak.value}_${DateTime.now().millisecondsSinceEpoch}',
            achievementType: achievement.type.toString(),
            title: achievement.title,
            description: achievement.description,
            badgeNumber: achievement.badgeNumber,
          );
          print('💾 Achievement saved to Firestore');
        } catch (e) {
          print('❌ Failed to save achievement: $e');
        }
      }

      return achievement;
    } catch (e) {
      print('❌ Error updating streak: $e');
      return null;
    }
  }

  /// ✅ Mark a specific day as completed in Firestore (progression-based)
  Future<void> markDayAsCompleted(int dayNumber) async {
    try {
      final user = _userService.currentUser.value;
      final plan = currentPlan.value;

      if (user == null || plan == null) {
        print('⚠️ Cannot mark day complete: user or plan is null');
        return;
      }

      print('📝 Marking Day $dayNumber as completed...');

      print('🔍 DEBUG: Attempting to mark day $dayNumber');
      print('🔍 DEBUG: Plan ID = ${plan.planId}');
      print('🔍 DEBUG: Current day in plan = ${plan.currentDay}');
      print('🔍 DEBUG: Total phases = ${plan.phases.length}');

      // Create updated phases with the completed day
      final updatedPhases = plan.phases.map((phase) {
        final updatedDays = phase.days.map((day) {
          if (day.dayNumber == dayNumber) {
            // Mark this day as completed
            return day.copyWith(
              isCompleted: true,
              completedAt: DateTime.now(),
            );
          }
          return day;
        }).toList();

        return PhaseModel(
          phaseId: phase.phaseId,
          phaseNumber: phase.phaseNumber,
          phaseName: phase.phaseName,
          phaseDescription: phase.phaseDescription,
          phaseGoal: phase.phaseGoal,
          startDay: phase.startDay,
          endDay: phase.endDay,
          totalDaysInPhase: phase.totalDaysInPhase,
          days: updatedDays,
          intensityLevel: phase.intensityLevel,
          focusArea: phase.focusArea,
          workoutsPerWeek: phase.workoutsPerWeek,
          restDaysPerWeek: phase.restDaysPerWeek,
          imageUrl: phase.imageUrl,
          colorCode: phase.colorCode,
        );
      }).toList();

      // Calculate new completion stats
      final allDays = updatedPhases.expand((p) => p.days).toList();
      final completedCount = allDays.where((d) => d.isCompleted).length;
      final completionPercentage = (completedCount / plan.totalDays * 100);

      // ✅ KEEP CURRENT DAY AS-IS (calendar-based, don't change on completion)
      // Only update phases and completion stats

      // ✅ UPDATE LOCAL STATE FIRST (with updated phases!)
      currentPlan.value = WorkoutPlanModel(
        planId: plan.planId,
        userId: plan.userId,
        planTitle: plan.planTitle,
        planDescription: plan.planDescription,
        totalDays: plan.totalDays,
        totalWeeks: plan.totalWeeks,
        phases: updatedPhases, // ✅ KEY FIX - updated phases!
        currentDay: plan.currentDay, // ✅ KEEP CALENDAR-BASED CURRENT DAY
        currentPhaseId: plan.currentPhaseId,
        startDate: plan.startDate,
        estimatedEndDate: plan.estimatedEndDate,
        actualEndDate: plan.actualEndDate,
        status: plan.status,
        completedDays: completedCount,
        missedDays: plan.missedDays,
        completionPercentage: completionPercentage,
        generatedBy: plan.generatedBy,
        generatedAt: plan.generatedAt,
        aiModelVersion: plan.aiModelVersion,
        aiPromptMetadata: plan.aiPromptMetadata,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now(),
      );

      print('✅ Day $dayNumber marked complete locally');
      print('   - Completed days: $completedCount/${plan.totalDays}');
      print('   - Current day (calendar): ${plan.currentDay}');

      // ✅ UPDATE BOTH ROOT AND USER SUBCOLLECTION
      final updateData = {
        'phases': updatedPhases.map((p) => p.toMap()).toList(),
        'completedDays': completedCount,
        'completionPercentage': completionPercentage,
        'updatedAt': FieldValue.serverTimestamp(),
      };

// Update root collection
      FirebaseFirestore.instance
          .collection('workout_plans')
          .doc(plan.planId)
          .set(updateData, SetOptions(merge: true))
          .then((_) {
        print('💾 Day $dayNumber synced to root collection');
      }).catchError((e) {
        print('❌ Error syncing to root: $e');
      });

      // Update user subcollection
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workout_plans')
          .doc(plan.planId)
          .set(updateData, SetOptions(merge: true))
          .then((_) {
        print('💾 Day $dayNumber synced to user subcollection');

        // ✅ Clear cache so next load gets fresh data
        try {
          final workoutService = Get.find<WorkoutService>();
          workoutService.clearCache();
          print('🗑️ Cache cleared - fresh data will load on next fetch');
        } catch (e) {
          print('⚠️ Failed to clear cache: $e');
        }
      }).catchError((e) {
        print('❌ Error syncing to user subcollection: $e');
      });
    } catch (e) {
      print('❌ Error marking day complete: $e');
    }
  }

  /// ✅ Complete a workout and update all related data - PRODUCTION GRADE
  Future<Map<String, dynamic>> completeWorkout({
    required int dayNumber,
    required int caloriesBurned,
    required int durationMinutes,
    required String workoutType,
    required bool isFullCompletion,
  }) async {
    try {
      final userId = _userService.currentUser.value?.uid;
      if (userId == null) {
        print('❌ No user logged in');
        return {'success': false};
      }

      final plan = currentPlan.value;
      if (plan == null) {
        print('❌ No workout plan loaded');
        return {'success': false};
      }

      print(
          '🏋️ Completing workout for day $dayNumber (Full: $isFullCompletion)...');

      // 1. Save workout completion to Firestore
      final workoutId =
          'workout_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final dateStr = _formatDate(DateTime.now());

      await _firestoreService.saveWorkoutCompletion(
        userId: userId,
        workoutId: workoutId,
        planId: plan.planId,
        day: dayNumber,
        date: dateStr,
        duration: durationMinutes,
        calories: caloriesBurned,
        exercisesCompleted: [],
        isComplete: isFullCompletion,
      );

      AchievementModel? workoutAchievement;
      AchievementModel? streakAchievement;

      // ✅ ALWAYS update progress stats (counts all workouts, partial or full)
      await _updateProgressStats(
        caloriesBurned: caloriesBurned,
        durationMinutes: durationMinutes,
      );

      // ✅ ALWAYS check workout count achievement (since count always increments)
      workoutAchievement = await _checkWorkoutCountAchievement();

      // 2. Only update streak and mark day complete for FULL workouts
      if (isFullCompletion) {
        // Update streak and get streak achievement
        streakAchievement = await updateStreakAfterWorkout(dayNumber);

        // Mark day as completed in plan
        await markDayAsCompleted(dayNumber);

        print('✅ Full workout completion processed');
      } else {
        print(
            '⚠️ Partial workout - streak not updated, day not marked complete');
      }

      print('✅ Workout completion saved successfully');

      return {
        'success': true,
        'workoutAchievement': workoutAchievement,
        'streakAchievement': streakAchievement,
        'currentStreak': userStreak.value,
        'weeklyProgress': weeklyProgress.toList(),
      };
    } catch (e) {
      print('❌ Error completing workout: $e');
      return {'success': false};
    }
  }

  /// ✅ Complete a DISCOVERY workout (doesn't affect plan progression)
  /// This is SEPARATE from plan workouts - won't touch currentDay or mark days complete
  Future<Map<String, dynamic>> completeDiscoveryWorkout({
    required String workoutId,
    required String workoutTitle,
    required int caloriesBurned,
    required int durationMinutes,
    required String workoutCategory,
  }) async {
    try {
      final userId = _userService.currentUser.value?.uid;
      if (userId == null) {
        print('❌ No user logged in');
        return {'success': false};
      }

      print('🏋️ Completing discovery workout: $workoutTitle...');

      // 1. Save workout completion to Firestore (separate from plan workouts)
      final completionId =
          'discovery_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final dateStr = _formatDate(DateTime.now());

      await _firestoreService.saveWorkoutCompletion(
        userId: userId,
        workoutId: completionId,
        planId: 'discovery', // Special ID - NOT tied to any plan
        day: 0, // 0 = discovery workout, not a plan day
        date: dateStr,
        duration: durationMinutes,
        calories: caloriesBurned,
        exercisesCompleted: [],
        isComplete: true,
        workoutTitle: workoutTitle, // ✅ ADD - save the actual workout title
        workoutCategory: workoutCategory, // ✅ ADD - save the category
      );

      // 2. Update streak (shared between plan and discovery workouts)
      // This ensures streak increments once per day regardless of workout source
      final streakAchievement =
          await updateStreakAfterWorkout(null); // null = not tied to plan day

      // 3. Check workout count achievement (counts all workouts)
      final workoutAchievement = await _checkWorkoutCountAchievement();

      // 4. Update progress stats in Firestore
      await _updateProgressStats(
        caloriesBurned: caloriesBurned,
        durationMinutes: durationMinutes,
      );

      print('✅ Discovery workout saved - Plan NOT affected');

      return {
        'success': true,
        'workoutAchievement': workoutAchievement,
        'streakAchievement': streakAchievement,
        'currentStreak': userStreak.value,
        'weeklyProgress': weeklyProgress.toList(),
      };
    } catch (e) {
      print('❌ Error completing discovery workout: $e');
      return {'success': false};
    }
  }

  /// ✅ Update progress stats (for both plan and discovery workouts)
  Future<void> _updateProgressStats({
    required int caloriesBurned,
    required int durationMinutes,
  }) async {
    try {
      final userId = _userService.currentUser.value?.uid;
      if (userId == null) {
        print('❌ _updateProgressStats: No user ID');
        return;
      }

      print('🔥 _updateProgressStats called:');
      print('   Duration: $durationMinutes min');
      print('   Calories: $caloriesBurned cal');
      print('   User: $userId');

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('stats');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          final data = snapshot.data() ?? {};
          final currentWorkouts = data['totalWorkoutsCompleted'] ?? 0;
          final currentMinutes = data['totalMinutesExercised'] ?? 0;
          final currentCalories = data['totalCaloriesBurned'] ?? 0;

          print('📊 Current stats in Firestore:');
          print('   Workouts: $currentWorkouts → ${currentWorkouts + 1}');
          print(
              '   Minutes: $currentMinutes → ${currentMinutes + durationMinutes}');
          print(
              '   Calories: $currentCalories → ${currentCalories + caloriesBurned}');

          transaction.update(docRef, {
            'totalWorkoutsCompleted': currentWorkouts + 1,
            'totalMinutesExercised': currentMinutes + durationMinutes,
            'totalCaloriesBurned': currentCalories + caloriesBurned,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          print('📊 Creating new stats document');
          transaction.set(docRef, {
            'totalWorkoutsCompleted': 1,
            'totalMinutesExercised': durationMinutes,
            'totalCaloriesBurned': caloriesBurned,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });

      print('✅ Progress stats updated successfully!');
    } catch (e) {
      print('❌ Error updating progress stats: $e');
      print('   Stack trace: ${StackTrace.current}');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Calculate which day the user should be on based on plan start date
  int calculateCurrentDayByDate(WorkoutPlanModel plan) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(
      plan.startDate.year,
      plan.startDate.month,
      plan.startDate.day,
    );

    final daysSinceStart = today.difference(startDay).inDays;

    // Day 1 = start date, Day 2 = next day, etc.
    final calculatedDay = daysSinceStart + 1;

    // Clamp to plan limits
    return calculatedDay.clamp(1, plan.totalDays);
  }

  /// Update user streak based on workout completion
  Future<void> updateStreak() async {
    try {
      final userId = _userService.currentUser.value?.uid;
      if (userId == null) return;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check if workout was already done today
      if (lastWorkoutDate.value != null) {
        final lastDate = DateTime(
          lastWorkoutDate.value!.year,
          lastWorkoutDate.value!.month,
          lastWorkoutDate.value!.day,
        );

        if (lastDate == today) {
          print('⚠️ Workout already completed today');
          return;
        }
      }

      // Update last workout date
      lastWorkoutDate.value = now;

      // Update weekly progress (0 = Monday, 6 = Sunday)
      int dayOfWeek = now.weekday - 1; // Convert to 0-6
      weeklyProgress[dayOfWeek] = true;
      weeklyProgress.refresh();

      // Calculate streak
      if (lastWorkoutDate.value != null) {
        final daysSinceLastWorkout = today
            .difference(
              DateTime(
                lastWorkoutDate.value!.year,
                lastWorkoutDate.value!.month,
                lastWorkoutDate.value!.day,
              ),
            )
            .inDays;

        if (daysSinceLastWorkout == 1) {
          // Consecutive day
          userStreak.value++;
        } else if (daysSinceLastWorkout > 1) {
          // Streak broken
          userStreak.value = 1;
        }
      } else {
        userStreak.value = 1;
      }

      // Save streak to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'streak': userStreak.value,
        'lastWorkoutDate': Timestamp.fromDate(now),
        'weeklyProgress': weeklyProgress.toList(),
      });

      print('✅ Streak updated: ${userStreak.value} days');
    } catch (e) {
      print('❌ Error updating streak: $e');
    }
  }

  /// Get total workouts completed by user (from progress/stats)
  Future<int> getTotalWorkoutsCompleted() async {
    try {
      final userId = _userService.currentUser.value?.uid;
      if (userId == null) return 0;

      // ✅ Use progress/stats document for consistency
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('stats');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() ?? {};
        return data['totalWorkoutsCompleted'] ?? 0;
      }

      return 0;
    } catch (e) {
      print('❌ Error getting total workouts: $e');
      return 0;
    }
  }

  /// ✅ Check for workout count achievements
  Future<AchievementModel?> _checkWorkoutCountAchievement() async {
    try {
      // Get total BEFORE current save
      final total = await getTotalWorkoutsCompleted();

      // Check if THIS workout triggers an achievement
      final nextTotal = total + 1; // The count AFTER this workout
      print('🏋️ Total workouts completed: $total → $nextTotal (after this)');

      final achievement = AchievementModel.getByWorkoutCount(nextTotal);

      if (achievement != null) {
        print('🏆 Workout count achievement earned: ${achievement.title}');

        // Save to Firestore (check if already exists first)
        final userId = _userService.currentUser.value?.uid;
        if (userId != null) {
          final achievementId = 'workout_$nextTotal';

          // Check if already earned
          final alreadyExists = await _firestoreService.hasAchievement(
            userId: userId,
            achievementId: achievementId,
          );

          if (!alreadyExists) {
            await _firestoreService.saveAchievement(
              userId: userId,
              achievementId: achievementId,
              achievementType: achievement.type.toString(),
              title: achievement.title,
              description: achievement.description,
              badgeNumber: achievement.badgeNumber,
            );
            print('✅ Achievement saved: ${achievement.title}');
          } else {
            print('ℹ️ Achievement already exists, skipping save');
          }
        }
      }

      return achievement;
    } catch (e) {
      print('❌ Error checking workout achievement: $e');
      return null;
    }
  }

  /// Check if user earned a new streak achievement based on current streak
  AchievementModel? _checkForStreakAchievement() {
    final streak = userStreak.value;

    // Check milestone achievements
    if (streak == 2) return AchievementModel.twoDayStreak;
    if (streak == 3) return AchievementModel.threeDayStreak;
    if (streak == 5) return AchievementModel.fiveDayStreak;
    if (streak == 7) return AchievementModel.sevenDayStreak;
    if (streak == 10) return AchievementModel.tenDayStreak;
    if (streak == 30) return AchievementModel.thirtyDayStreak;

    return null;
  }

  /// Load user streak from Firestore (ENHANCED VERSION)
  Future<void> loadUserStreak() async {
    try {
      final user = _userService.currentUser.value;
      if (user == null) {
        print('⚠️ No user - streak reset to 0');
        userStreak.value = 0;
        lastWorkoutDate.value = null;
        return;
      }

      print('📡 Loading streak from Firestore for user: ${user.uid}');

      // ✅ LOAD FROM FIRESTORE
      final streakData = await _firestoreService.getStreak(userId: user.uid);

      if (streakData != null) {
        userStreak.value = streakData['currentStreak'] ?? 0;

        final lastDateStr = streakData['lastWorkoutDate'];
        if (lastDateStr != null) {
          lastWorkoutDate.value = DateTime.parse(lastDateStr);

          // Check if streak should be reset (more than 1 day gap)
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final lastDate = DateTime(
            lastWorkoutDate.value!.year,
            lastWorkoutDate.value!.month,
            lastWorkoutDate.value!.day,
          );

          final daysSince = today.difference(lastDate).inDays;

          if (daysSince > 1) {
            print(
                '💔 Streak expired! Resetting from ${userStreak.value} to 0 (${daysSince} days gap)');
            userStreak.value = 0;
            lastWorkoutDate.value = null;
            weeklyProgress.value = [
              false,
              false,
              false,
              false,
              false,
              false,
              false
            ];

            // Update Firestore with reset
            await _firestoreService.updateStreak(
              userId: user.uid,
              lastWorkoutDate: now,
              currentStreak: 0,
            );
          } else {
            print('✅ Streak loaded: ${userStreak.value} days');
            print('📅 Last workout: ${lastWorkoutDate.value}');
          }
        }
      } else {
        print('ℹ️ No streak data found - starting fresh');
        userStreak.value = 0;
        lastWorkoutDate.value = null;
        weeklyProgress.value = [
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ];
      }
    } catch (e) {
      print('❌ Error loading streak: $e');
      userStreak.value = 0;
      lastWorkoutDate.value = null;
    }
  }

  /// Reset weekly progress (call at start of new week)
  void resetWeeklyProgress() {
    weeklyProgress.value = [false, false, false, false, false, false, false];
    print('🔄 Weekly progress reset');
  }

  /// Get pending achievement and clear it
  AchievementModel? claimPendingAchievement() {
    final achievement = pendingAchievement.value;
    pendingAchievement.value = null;
    return achievement;
  }

  /// Check if a day is locked based on HYBRID logic:
  /// - Calendar must have reached that day, AND
  /// - Previous day must be completed
  bool isDayLocked(int dayNumber) {
    if (currentPlan.value == null) return true;
    if (dayNumber == 1) return false; // Day 1 never locked

    final plan = currentPlan.value!;

    // Check if calendar has reached this day
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayStartDate = plan.startDate.add(Duration(days: dayNumber - 1));
    final dayStart =
        DateTime(dayStartDate.year, dayStartDate.month, dayStartDate.day);

    final calendarReached = !today.isBefore(dayStart);

    // Check if previous day is completed
    final previousDay = plan.phases
        .expand((phase) => phase.days)
        .firstWhereOrNull((day) => day.dayNumber == dayNumber - 1);

    final previousCompleted = previousDay?.isCompleted ?? false;

    // Locked if calendar hasn't reached OR previous day not completed
    return !calendarReached || !previousCompleted;
  }

  /// Get appropriate lock message based on why the day is locked
  String getLockMessage(int dayNumber) {
    if (currentPlan.value == null) return "Locked";
    if (dayNumber == 1) return ""; // Day 1 never locked

    final plan = currentPlan.value!;

    // Check calendar status
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayStartDate = plan.startDate.add(Duration(days: dayNumber - 1));
    final dayStart =
        DateTime(dayStartDate.year, dayStartDate.month, dayStartDate.day);

    final calendarReached = !today.isBefore(dayStart);

    // Check previous day completion
    final previousDay = plan.phases
        .expand((phase) => phase.days)
        .firstWhereOrNull((day) => day.dayNumber == dayNumber - 1);

    final previousCompleted = previousDay?.isCompleted ?? false;

    // Determine message based on lock reason
    if (!calendarReached) {
      final daysUntil = dayStart.difference(today).inDays;
      if (daysUntil == 1) {
        return "This workout unlocks tomorrow!";
      } else {
        return "This workout unlocks in $daysUntil days";
      }
    } else if (!previousCompleted) {
      final isCurrent = plan.currentDay == dayNumber;
      if (isCurrent) {
        return "Today's workout! Complete Day ${dayNumber - 1} first to start.";
      } else {
        return "Complete Day ${dayNumber - 1} first to unlock this workout.";
      }
    }

    return "Locked"; // Fallback
  }
}
