import 'package:get/get.dart';
import '../data/models/user/onboarding_data_model.dart';
import '../core/services/user_service.dart';
import '../core/services/workout_service.dart';
import '../controllers/workout_plan_controller.dart';

class OnboardingController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  // Loading state
  RxBool isSubmitting = false.obs;

  // ========== PART 1: GOAL (3 Questions) ==========
  
  // Q1: What motivates you most? (Multi-select)
  RxList<String> motivations = <String>[].obs;
  
  // Q2: What's your main goal? (Single select)
  Rx<String?> mainGoal = Rx<String?>(null);
  
  // Q3: Which areas do you want to focus on? (Multi-select)
  RxList<String> focusAreas = <String>[].obs;

  // ========== PART 2: BODY DATA (5 Questions) ==========
  
  // Q1: Height (in cm)
  Rx<double> height = 165.0.obs;
  
  // Q2: Weight (in kg)
  Rx<double> weight = 60.0.obs;
  
  // Q3: Goal Weight (in kg)
  Rx<double> goalWeight = 55.0.obs;
  
  // Q4: Current Body Type
  Rx<String?> currentBodyType = Rx<String?>(null);  // Made nullable
  
  // Q5: Desired Body Type
  Rx<String?> desiredBodyType = Rx<String?>(null);  // Made nullable

  // ========== PART 3: WOMEN'S HEALTH (7 Questions) ==========
  
  // Q1: Age
  Rx<int> age = 24.obs;
  
  // Q2: Menstrual Cycle Adaptation
  Rx<String?> menstrualCycleAdaptation = Rx<String?>(null);  // Made nullable
  
  // Q3: Current Cycle Phase (conditional)
  Rx<String?> currentCycleWeek = Rx<String?>(null);
  
  // Q4: Pelvic Floor Health
  Rx<String?> pelvicFloorHealth = Rx<String?>(null);  // Made nullable
  
  // Q5: Workout Location
  Rx<String?> workoutLocation = Rx<String?>(null);  // Made nullable
  
  // Q6: Workout Type
  Rx<String?> workoutType = Rx<String?>(null);  // Made nullable
  
  // Q7: Workout Level
  Rx<String?> workoutLevel = Rx<String?>(null);  // Made nullable
  
  // Q8: Injuries (Multi-select)
  RxList<String> injuries = <String>[].obs;  // Changed to empty list

  // ========== PART 4: FITNESS ANALYSIS (13 Questions) ==========
  
  // Q1: Typical Day
  Rx<String?> typicalDay = Rx<String?>(null);  // Made nullable
  
  // Q2: Activity Level
  Rx<String?> activityLevel = Rx<String?>(null);  // Made nullable
  
  // Q3: Fitness Level
  Rx<String?> fitnessLevel = Rx<String?>(null);  // Made nullable
  
  // Q4: Belly Type
  Rx<String?> bellyType = Rx<String?>(null);  // Made nullable
  
  // Q5: Hips Type
  Rx<String?> hipsType = Rx<String?>(null);  // Made nullable
  
  // Q6: Leg Type
  Rx<String?> legType = Rx<String?>(null);  // Made nullable
  
  // Q7: Flexibility Level
  Rx<String?> flexibilityLevel = Rx<String?>(null);  // Made nullable
  
  // Q8: Cardio Level
  Rx<String?> cardioLevel = Rx<String?>(null);  // Made nullable
  
  // Q9: Statement 1 - Body Dissatisfaction
  RxBool statementBodyDissatisfaction = false.obs;
  
  // Q10: Statement 2 - Need Guidance
  RxBool statementNeedGuidance = false.obs;
  
  // Q11: Statement 3 - Easily Give Up
  RxBool statementEasilyGiveUp = false.obs;

  // Additional motivation/reward questions
  RxBool motivationQuestion1 = false.obs;
  RxBool attractiveBodyDesire = false.obs;
  RxBool chronicDiseasesConcern = false.obs;
  Rx<String?> goalAchievementFeeling = Rx<String?>(null);
  Rx<String?> goalReward = Rx<String?>(null);

  // ========== SETTERS (for updating values) ==========

  // Part 1
  void toggleMotivation(String motivation) {
    if (motivations.contains(motivation)) {
      motivations.remove(motivation);
    } else {
      motivations.add(motivation);
    }
  }

  void setMainGoal(String goal) => mainGoal.value = goal;

  void toggleFocusArea(String area) {
    if (focusAreas.contains(area)) {
      focusAreas.remove(area);
    } else {
      focusAreas.add(area);
    }
  }

  // Part 2
  void setHeight(double value) => height.value = value;
  void setWeight(double value) => weight.value = value;
  void setGoalWeight(double value) => goalWeight.value = value;
  void setCurrentBodyType(String? type) => currentBodyType.value = type;  // Made nullable
  void setDesiredBodyType(String? type) => desiredBodyType.value = type;  // Made nullable

  // Part 3
  void setAge(int value) => age.value = value;
  void setMenstrualCycleAdaptation(String? value) {  // Made nullable
    menstrualCycleAdaptation.value = value;
    // Clear cycle phase if not adapting
    if (value != 'yes') {
      currentCycleWeek.value = null;
    }
  }
  void setCurrentCycleWeek(String? value) => currentCycleWeek.value = value;
  void setPelvicFloorHealth(String? value) => pelvicFloorHealth.value = value;  // Made nullable
  void setWorkoutLocation(String? value) => workoutLocation.value = value;  // Made nullable
  void setWorkoutType(String? value) => workoutType.value = value;  // Made nullable
  void setWorkoutLevel(String? value) => workoutLevel.value = value;  // Made nullable
  
  void toggleInjury(String injury) {
    // Special handling for "none"
    if (injury == 'none') {
      if (injuries.contains('none')) {
        injuries.remove('none');
      } else {
        injuries.clear();
        injuries.add('none');
      }
    } else {
      // Remove "none" if selecting a specific injury
      injuries.remove('none');
      if (injuries.contains(injury)) {
        injuries.remove(injury);
      } else {
        injuries.add(injury);
      }
      // Don't auto-add "none" if empty - let it be empty
    }
  }

  // Part 4
  void setTypicalDay(String? value) => typicalDay.value = value;  // Made nullable
  void setActivityLevel(String? value) => activityLevel.value = value;  // Made nullable
  void setFitnessLevel(String? value) => fitnessLevel.value = value;  // Made nullable
  void setBellyType(String? value) => bellyType.value = value;  // Made nullable
  void setHipsType(String? value) => hipsType.value = value;  // Made nullable
  void setLegType(String? value) => legType.value = value;  // Made nullable
  void setFlexibilityLevel(String? value) => flexibilityLevel.value = value;  // Made nullable
  void setCardioLevel(String? value) => cardioLevel.value = value;  // Made nullable
  void setStatementBodyDissatisfaction(bool value) => 
      statementBodyDissatisfaction.value = value;
  void setStatementNeedGuidance(bool value) => 
      statementNeedGuidance.value = value;
  void setStatementEasilyGiveUp(bool value) => 
      statementEasilyGiveUp.value = value;

  // Alias methods for compatibility with onboarding screens
  void setWorkoutDifficulty(String? value) => workoutLevel.value = value;  // Made nullable
  
  void setInjuries(List<String> value) {
    injuries.clear();
    injuries.addAll(value);
  }
  
  void setDailyActivity(String? value) => typicalDay.value = value;  // Made nullable
  
  void setFlexibilityTest(String? value) => flexibilityLevel.value = value;  // Made nullable
  
  void setCardioTest(String? value) => cardioLevel.value = value;  // Made nullable
  
  void setBodyDissatisfaction(bool value) => 
      statementBodyDissatisfaction.value = value;
  
  void setWorkoutSelectionDifficulty(bool value) => 
      statementNeedGuidance.value = value;
  
  void setEasilyGiveUp(bool value) => 
      statementEasilyGiveUp.value = value;
  
  // New motivation/reward setters
  void setMotivationQuestion1(bool value) => 
      motivationQuestion1.value = value;
  
  void setAttractiveBodyDesire(bool value) => 
      attractiveBodyDesire.value = value;
  
  void setChronicDiseasesConcern(bool value) => 
      chronicDiseasesConcern.value = value;
  
  void setGoalAchievementFeeling(String value) => 
      goalAchievementFeeling.value = value;
  
  void setGoalReward(String value) => 
      goalReward.value = value;
  
  // Getters for compatibility (screens access these as properties)
  Rx<String?> get workoutDifficulty => workoutLevel;  // Made nullable
  Rx<String?> get dailyActivity => typicalDay;  // Made nullable
  Rx<String?> get flexibilityTest => flexibilityLevel;  // Made nullable
  Rx<String?> get cardioTest => cardioLevel;  // Made nullable

  // ========== VALIDATION ==========

  bool validatePart1() {
    if (motivations.isEmpty) {
      Get.snackbar('⚠️ Required', 'Please select at least one motivation');
      return false;
    }
    if (mainGoal.value == null) {
      Get.snackbar('⚠️ Required', 'Please select your main goal');
      return false;
    }
    if (focusAreas.isEmpty) {
      Get.snackbar('⚠️ Required', 'Please select at least one focus area');
      return false;
    }
    return true;
  }

  bool validatePart2() {
    if (height.value <= 0 || height.value > 300) {
      Get.snackbar('⚠️ Invalid', 'Please enter a valid height');
      return false;
    }
    if (weight.value <= 0 || weight.value > 500) {
      Get.snackbar('⚠️ Invalid', 'Please enter a valid weight');
      return false;
    }
    if (goalWeight.value <= 0 || goalWeight.value > 500) {
      Get.snackbar('⚠️ Invalid', 'Please enter a valid goal weight');
      return false;
    }
    return true;
  }

  bool validatePart3() {
    if (menstrualCycleAdaptation.value == 'yes' && currentCycleWeek.value == null) {
      Get.snackbar('⚠️ Required', 'Please select your current cycle phase');
      return false;
    }
    // Removed injury validation - allow empty
    return true;
  }

  bool validatePart4() {
    // No strict validation - nullable fields are allowed
    return true;
  }

  bool validateAll() {
    return validatePart1() && 
           validatePart2() && 
           validatePart3() && 
           validatePart4();
  }

  // ========== SUBMIT ONBOARDING ==========

  Future<bool> submitOnboarding() async {
  try {
    // Validate all data
    if (!validateAll()) {
      return false;
    }

    // Get current user ID
    final userId = _userService.currentUserId;
    if (userId == null) {
      print('❌ No user logged in');
      return false;
    }

    // Collect all data
    final onboardingData = OnboardingData(
      age: age.value,
      weight: weight.value,
      height: height.value,
      goalWeight: goalWeight.value,
      mainGoal: mainGoal.value ?? 'get_fit',
      currentBodyType: currentBodyType.value ?? 'average',
      desiredBodyType: desiredBodyType.value ?? 'Fit',
      focusAreas: focusAreas.toList(),
      activityLevel: activityLevel.value ?? 'sedentary',
      fitnessLevel: fitnessLevel.value ?? 'beginner',
      workoutLevel: workoutLevel.value ?? 'beginner',
      workoutLocation: workoutLocation.value ?? 'home',
      workoutType: workoutType.value ?? 'mix',
      injuries: injuries.toList(),
      menstrualCycleAdaptation: menstrualCycleAdaptation.value ?? 'no',
      currentCycleWeek: currentCycleWeek.value,
      pelvicFloorHealth: pelvicFloorHealth.value ?? 'never',
      typicalDay: typicalDay.value ?? 'home_sedentary',
      bellyType: bellyType.value ?? 'normal',
      hipsType: hipsType.value ?? 'normal',
      legType: legType.value ?? 'normal',
      flexibilityLevel: flexibilityLevel.value ?? 'close',
      cardioLevel: cardioLevel.value ?? 'tired',
      statementBodyDissatisfaction: statementBodyDissatisfaction.value,
      statementNeedGuidance: statementNeedGuidance.value,
      statementEasilyGiveUp: statementEasilyGiveUp.value,
      motivations: motivations.toList(),
      
      completedAt: DateTime.now(),
    );

    // Save to Firestore via UserService
    final success = await _userService.saveOnboardingData(onboardingData);

    if (success) {
  print('✅ Onboarding completed successfully!');
  print('📊 User Data Summary:');
  print(onboardingData.toAIPromptString());
  
  // ✅ Generate AI workout plan
  try {
    print('🤖 Generating personalized workout plan...');
    final workoutService = WorkoutService();
    
    await workoutService.generateAndSaveWorkoutPlan(
      userId: userId,
      onboardingData: onboardingData.toMap(),
    );
    
    print('✅ Workout plan generated and saved!');
    
    // ✅ CRITICAL FIX: Reload the WorkoutPlanController to show the new plan
    try {
      print('🔄 Reloading workout plan controller...');
      final workoutPlanController = Get.find<WorkoutPlanController>();
      await workoutPlanController.loadUserWorkoutPlan();
      print('✅ Workout plan controller reloaded');
    } catch (e) {
      print('⚠️ Failed to reload workout plan controller: $e');
    }
  } catch (e) {
    print('⚠️ Failed to generate workout plan: $e');
    // Don't fail onboarding if plan generation fails
    // User can regenerate later
  }
    
  return true;
} else {
  return false;
}
  } catch (e) {
    print('❌ Error submitting onboarding: $e');
    Get.snackbar(
      '❌ Error',
      'Failed to save onboarding data',
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }
}

  // ========== HELPERS ==========

  /// Get completion percentage for progress indicator
  int getCompletionPercentage() {
    int completed = 0;
    int total = 28;

    // Part 1 (3 questions)
    if (motivations.isNotEmpty) completed++;
    if (mainGoal.value != null) completed++;
    if (focusAreas.isNotEmpty) completed++;

    // Part 2 (5 questions)
    if (height.value > 0) completed++;
    if (weight.value > 0) completed++;
    if (goalWeight.value > 0) completed++;
    if (currentBodyType.value != null) completed++;
    if (desiredBodyType.value != null) completed++;

    // Part 3 (7-8 questions, 1 conditional)
    completed++; // age has default
    if (menstrualCycleAdaptation.value != null) completed++;
    if (menstrualCycleAdaptation.value == 'yes' && currentCycleWeek.value != null) {
      completed++;
    } else if (menstrualCycleAdaptation.value != 'yes' && menstrualCycleAdaptation.value != null) {
      completed++; // Count as completed if not applicable
    }
    if (pelvicFloorHealth.value != null) completed++;
    if (workoutLocation.value != null) completed++;
    if (workoutType.value != null) completed++;
    if (workoutLevel.value != null) completed++;
    if (injuries.isNotEmpty) completed++;

    // Part 4 (13 questions)
    if (typicalDay.value != null) completed++;
    if (activityLevel.value != null) completed++;
    if (fitnessLevel.value != null) completed++;
    if (bellyType.value != null) completed++;
    if (hipsType.value != null) completed++;
    if (legType.value != null) completed++;
    if (flexibilityLevel.value != null) completed++;
    if (cardioLevel.value != null) completed++;
    completed++; // statement1
    completed++; // statement2
    completed++; // statement3
    if (goalAchievementFeeling.value != null) completed++;
    if (goalReward.value != null) completed++;

    return ((completed / total) * 100).round();
  }

  /// Reset all data (for testing or restart)
  void resetAll() {
    // Part 1
    motivations.clear();
    mainGoal.value = null;
    focusAreas.clear();

    // Part 2
    height.value = 165.0;
    weight.value = 60.0;
    goalWeight.value = 55.0;
    currentBodyType.value = null;  // Reset to null
    desiredBodyType.value = null;  // Reset to null

    // Part 3
    age.value = 24;
    menstrualCycleAdaptation.value = null;  // Reset to null
    currentCycleWeek.value = null;
    pelvicFloorHealth.value = null;  // Reset to null
    workoutLocation.value = null;  // Reset to null
    workoutType.value = null;  // Reset to null
    workoutLevel.value = null;  // Reset to null
    injuries.clear();  // Empty list

    // Part 4
    typicalDay.value = null;  // Reset to null
    activityLevel.value = null;  // Reset to null
    fitnessLevel.value = null;  // Reset to null
    bellyType.value = null;  // Reset to null
    hipsType.value = null;  // Reset to null
    legType.value = null;  // Reset to null
    flexibilityLevel.value = null;  // Reset to null
    cardioLevel.value = null;  // Reset to null
    statementBodyDissatisfaction.value = false;
    statementNeedGuidance.value = false;
    statementEasilyGiveUp.value = false;
    
    // Additional fields
    motivationQuestion1.value = false;
    attractiveBodyDesire.value = false;
    chronicDiseasesConcern.value = false;
    goalAchievementFeeling.value = null;
    goalReward.value = null;
  }

  // ========== AI BACKEND CALL (For later) ==========
  
  /// This will call your Python backend to generate workout plan
  Future<void> _callAIBackend(OnboardingData data) async {
    // TODO: Implement API call to Python backend
    // Example:
    // final response = await http.post(
    //   Uri.parse('https://your-backend.com/api/generate-plan'),
    //   body: jsonEncode(data.toMap()),
    // );
    // 
    // if (response.statusCode == 200) {
    //   final planData = jsonDecode(response.body);
    //   // Save plan using PlanService
    // }
    
    print('🤖 AI Backend call would happen here');
    print('📤 Sending data to AI...');
  }
}