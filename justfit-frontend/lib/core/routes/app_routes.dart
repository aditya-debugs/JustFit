// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/onboarding_data.dart';
import '../../controllers/onboarding_controller.dart';
import '../../views/onboarding_view/screens/part_transition_screen.dart';
import '../../views/onboarding_view/screens/onboarding_question_screen.dart';
import '../../views/onboarding_view/screens/onboarding_image_question_screen.dart';
import '../../views/onboarding_view/screens/body_focus_question_screen.dart';
import '../../views/onboarding_view/screens/height_selection_screen.dart';
import '../../views/onboarding_view/screens/weight_selection_screen.dart';
import '../../views/onboarding_view/screens/goal_weight_selection_screen.dart';
import '../../views/onboarding_view/screens/body_type_selection_screen.dart';
import '../../views/onboarding_view/screens/desired_body_type_selection_screen.dart';
import '../../views/onboarding_view/screens/age_selection_screen.dart';
import '../../views/onboarding_view/screens/menstrual_cycle_awareness_screen.dart';
import '../../views/onboarding_view/screens/cycle_phase_selection_screen.dart';
import '../../views/onboarding_view/screens/pelvic_floor_health_screen.dart';
import '../../views/onboarding_view/screens/workout_location_screen.dart';
import '../../views/onboarding_view/screens/workout_type_preference_screen.dart';
import '../../views/onboarding_view/screens/workout_level_preference_screen.dart';
import '../../views/onboarding_view/screens/injury_selection_screen.dart';
import '../../views/onboarding_view/screens/daily_activity_screen.dart';
import '../../views/onboarding_view/screens/activity_level_selection_screen.dart';
import '../../views/onboarding_view/screens/fitness_level_selection_screen.dart';
import '../../views/onboarding_view/screens/belly_type_selection_screen.dart';
import '../../views/onboarding_view/screens/hips_type_selection_screen.dart';
import '../../views/onboarding_view/screens/leg_type_selection_screen.dart';
import '../../views/onboarding_view/screens/flexibility_test_screen.dart';
import '../../views/onboarding_view/screens/cardio_test_screen.dart';
import '../../views/onboarding_view/screens/statement_1_screen.dart';
import '../../views/onboarding_view/screens/statement_2_screen.dart';
import '../../views/onboarding_view/screens/statement_3_screen.dart';
import '../../views/onboarding_view/screens/goal_achievement_feelings_screen.dart';
import '../../views/onboarding_view/screens/goal_reward_screen.dart';
import '../../views/onboarding_view/screens/onboarding_success_screen.dart';
import '../../views/onboarding_view/screens/motivation_screen_1.dart';
import '../../views/onboarding_view/screens/motivation_screen_2.dart';
import '../../views/onboarding_view/screens/motivation_screen_3.dart';
import '../../views/onboarding_view/screens/plan_creation_loading_screen.dart';
import '../../views/main_view/main_screen.dart';
import '../../views/auth_view/login_screen.dart';
import '../../views/splash_view/splash_screen.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart';

class AppRoutes {
  static const String splash = '/';

  // 🔧 DEVELOPMENT FLAG - Toggle onboarding
  // Set to true to skip onboarding and go directly to MainScreen
  // Set to false for production or to test onboarding flow
  // static const bool skipOnboarding = true; // ← COMMENTED OUT FOR PRODUCTION
  static const bool skipOnboarding = false; // ← PRODUCTION MODE

  static List<GetPage> routes = [
    // ✅ UPDATED: Simplified splash route
    GetPage(
      name: splash,
      page: () {
        // Initialize controllers at app start
        if (!Get.isRegistered<OnboardingController>()) {
          Get.put(OnboardingController(), permanent: true);
          print('✅ OnboardingController initialized at app start');
        }

        // 🔧 Development flag check
        if (skipOnboarding) {
          print('🚀 Development Mode: Skipping to MainScreen');
          return const MainScreen();
        }

        // Return splash screen - it will handle all navigation logic
        return const SplashScreen();
      },
    ),
  ];

  // Extract onboarding flow to reduce nesting
  // ✅ Made public so it can be called from profile_photo_screen
  static void startOnboardingFlow() {
    // Controller is already initialized, just start the flow
    Get.off(
      () => OnboardingQuestionScreen(
        partTitle: OnboardingData.goalQ1['partTitle'],
        question: OnboardingData.goalQ1['question'],
        options: OnboardingData.goalQ1['options'],
        isMultiSelect:
            OnboardingData.goalQ1['isMultiSelect'] ?? false, // ✅ ADD THIS LINE
        currentPart: OnboardingData.goalQ1['currentPart'],
        currentQuestionInPart: OnboardingData.goalQ1['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.goalQ1['totalQuestionsInPart'],
        totalParts: OnboardingData.goalQ1['totalParts'],
        onNext: () => _navigateToGoalQ2(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToGoalQ2() {
    Get.to(
      () => OnboardingImageQuestionScreen(
        partTitle: OnboardingData.goalQ2['partTitle'],
        question: OnboardingData.goalQ2['question'],
        options: OnboardingData.goalQ2['options'],
        currentPart: OnboardingData.goalQ2['currentPart'],
        currentQuestionInPart: OnboardingData.goalQ2['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.goalQ2['totalQuestionsInPart'],
        totalParts: OnboardingData.goalQ2['totalParts'],
        onNext: () => _navigateToGoalQ3(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToGoalQ3() {
    Get.to(
      () => BodyFocusQuestionScreen(
        partTitle: OnboardingData.goalQ3['partTitle'],
        question: OnboardingData.goalQ3['question'],
        options: OnboardingData.goalQ3['options'],
        currentPart: OnboardingData.goalQ3['currentPart'],
        currentQuestionInPart: OnboardingData.goalQ3['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.goalQ3['totalQuestionsInPart'],
        totalParts: OnboardingData.goalQ3['totalParts'],
        onBack: () => Get.back(),
        onNext: () => _navigateToPart2Transition(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToPart2Transition() {
    Get.to(
      () => PartTransitionScreen(
        partNumber: 2,
        partTitle: 'Body Data',
        onComplete: () => _navigateToHeight(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToHeight() {
    Get.off(
      () => HeightSelectionScreen(
        partTitle: OnboardingData.bodyDataQ1['partTitle'],
        question: OnboardingData.bodyDataQ1['question'],
        currentPart: OnboardingData.bodyDataQ1['currentPart'],
        currentQuestionInPart:
            OnboardingData.bodyDataQ1['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.bodyDataQ1['totalQuestionsInPart'],
        totalParts: OnboardingData.bodyDataQ1['totalParts'],
        onBack: () => Get.back(),
        onNext: () => _navigateToWeight(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToWeight() {
    // ✅ Get height from controller
    final controller = Get.find<OnboardingController>();

    Get.to(
      () => WeightSelectionScreen(
        partTitle: OnboardingData.bodyDataQ2['partTitle'],
        question: OnboardingData.bodyDataQ2['question'],
        currentPart: OnboardingData.bodyDataQ2['currentPart'],
        currentQuestionInPart:
            OnboardingData.bodyDataQ2['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.bodyDataQ2['totalQuestionsInPart'],
        totalParts: OnboardingData.bodyDataQ2['totalParts'],
        userHeightCm: controller.height.value,
        onBack: () => Get.back(),
        onNext: () => _navigateToGoalWeight(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToGoalWeight() {
    // ✅ Get weight from controller
    final controller = Get.find<OnboardingController>();

    Get.to(
      () => GoalWeightSelectionScreen(
        partTitle: OnboardingData.bodyDataQ3['partTitle'],
        question: OnboardingData.bodyDataQ3['question'],
        currentPart: OnboardingData.bodyDataQ3['currentPart'],
        currentQuestionInPart:
            OnboardingData.bodyDataQ3['currentQuestionInPart'],
        totalQuestionsInPart: OnboardingData.bodyDataQ3['totalQuestionsInPart'],
        totalParts: OnboardingData.bodyDataQ3['totalParts'],
        userCurrentWeightKg: controller.weight.value,
        userCurrentWeightLbs: controller.weight.value * 2.20462,
        onBack: () => Get.back(),
        onNext: () => _navigateToBodyType(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToBodyType() {
    Get.to(
      () => BodyTypeSelectionScreen(
        partTitle: 'Body Data',
        question: 'Choose your body type',
        currentPart: 2,
        currentQuestionInPart: 4,
        totalQuestionsInPart: 5,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: (selectedBodyFatIndex) =>
            _navigateToDesiredBodyType(selectedBodyFatIndex),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToDesiredBodyType(int selectedBodyFatIndex) {
    Get.to(
      () => DesiredBodyTypeSelectionScreen(
        partTitle: 'Body Data',
        question: "What's your desired body type?",
        currentBodyFatIndex: selectedBodyFatIndex,
        currentPart: 2,
        currentQuestionInPart: 5,
        totalQuestionsInPart: 5,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToPart3Transition(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToPart3Transition() {
    print('Part 2 complete! Moving to Part 3...');
    Get.to(
      () => PartTransitionScreen(
        partNumber: 3,
        partTitle: 'About You',
        onComplete: () => _navigateToAge(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToAge() {
    Get.off(
      () => AgeSelectionScreen(
        partTitle: 'About You',
        question: "What's your age?",
        currentPart: 3,
        currentQuestionInPart: 1,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToMenstrualCycle(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToMenstrualCycle() {
    print('Age selected, moving to menstrual cycle awareness...');
    Get.to(
      () => MenstrualCycleAwarenessScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 2,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: (selection) => _handleMenstrualCycleSelection(selection),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _handleMenstrualCycleSelection(String selection) {
    print('Menstrual cycle selection: $selection');
    if (selection == 'yes') {
      _navigateToCyclePhase();
    } else {
      _navigateToPelvicFloor();
    }
  }

  static void _navigateToCyclePhase() {
    Get.to(
      () => CyclePhaseSelectionScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 3,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToPelvicFloor(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToPelvicFloor() {
    print('Moving to pelvic floor screen...');
    Get.to(
      () => PelvicFloorHealthScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 3,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToWorkoutLocation(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToWorkoutLocation() {
    print('Pelvic floor answered, moving to workout location...');
    Get.to(
      () => WorkoutLocationScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 4,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToWorkoutType(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToWorkoutType() {
    print('Workout location selected, moving to workout type preference...');
    Get.to(
      () => WorkoutTypePreferenceScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 5,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToWorkoutLevel(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToWorkoutLevel() {
    print('Workout type selected, moving to workout level preference...');
    Get.to(
      () => WorkoutLevelPreferenceScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 6,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToInjury(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToInjury() {
    print('Workout level selected, moving to injury selection...');
    Get.to(
      () => InjurySelectionScreen(
        partTitle: 'About You',
        currentPart: 3,
        currentQuestionInPart: 7,
        totalQuestionsInPart: 7,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToPart4Transition(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToPart4Transition() {
    print('Part 3 complete! Moving to Part 4: Fitness Analysis...');
    Get.to(
      () => PartTransitionScreen(
        partNumber: 4,
        partTitle: 'Fitness Analysis',
        showPartLabel: true,
        onComplete: () => _navigateToDailyActivity(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToDailyActivity() {
    Get.off(
      () => DailyActivityScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 1,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToActivityLevel(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToActivityLevel() {
    print('Daily activity selected, moving to activity level selection...');
    Get.to(
      () => ActivityLevelSelectionScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 2,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToFitnessLevel(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToFitnessLevel() {
    print('Activity level selected, moving to fitness level selection...');
    Get.to(
      () => FitnessLevelSelectionScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 3,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToBellyType(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToBellyType() {
    print('Fitness level selected, moving to belly type selection...');
    Get.to(
      () => BellyTypeSelectionScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 4,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToHipsType(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToHipsType() {
    print('Belly type selected, moving to hips type selection...');
    Get.to(
      () => HipsTypeSelectionScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 5,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToLegType(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToLegType() {
    print('Hips type selected, moving to leg type selection...');
    Get.to(
      () => LegTypeSelectionScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 6,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToFlexibility(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToFlexibility() {
    print('Leg type selected, moving to flexibility test...');
    Get.to(
      () => FlexibilityTestScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 7,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToCardio(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToCardio() {
    print('Flexibility test complete, moving to cardio test...');
    Get.to(
      () => CardioTestScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 8,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToStatement1(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToStatement1() {
    print('Cardio test complete, moving to statement 1...');
    Get.to(
      () => Statement1Screen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 9,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToStatement2(answer),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToStatement2(bool answer) {
    print('Statement 1 answered: ${answer ? "Yes" : "No"}');
    Get.to(
      () => Statement2Screen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 10,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToStatement3(answer),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToStatement3(bool answer) {
    print('Statement 2 answered: ${answer ? "Yes" : "No"}');
    Get.to(
      () => Statement3Screen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 11,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToGoalFeelings(answer),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToGoalFeelings(bool answer) {
    print('Statement 3 answered: ${answer ? "Yes" : "No"}');
    Get.to(
      () => GoalAchievementFeelingsScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 12,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToGoalReward(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToGoalReward() {
    print('Goal achievement feelings selected, moving to goal reward...');
    Get.to(
      () => GoalRewardScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 13,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToSuccessScreen(),
      ),
      transition: Transition.noTransition,
    );
  }

  static void _navigateToSuccessScreen() {
    print('🎉 Part 4 Complete! Moving to success screen...');
    Get.to(
      () => OnboardingSuccessScreen(
        partTitle: 'Fitness Analysis',
        currentPart: 4,
        currentQuestionInPart: 13,
        totalQuestionsInPart: 13,
        totalParts: 4,
        onBack: () => Get.back(),
        onNext: () => _navigateToMotivation1(),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToMotivation1() {
    print('✅ Success screen complete! Moving to motivation screens...');
    Get.to(
      () => MotivationScreen1(
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToMotivation2(answer),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToMotivation2(bool answer) {
    print('Motivation 1 answered: ${answer ? "Yes" : "No"}');
    Get.to(
      () => MotivationScreen2(
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToMotivation3(answer),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToMotivation3(bool answer) {
    print('Motivation 2 answered: ${answer ? "Yes" : "No"}');
    Get.to(
      () => MotivationScreen3(
        onBack: () => Get.back(),
        onNext: (answer) => _navigateToLoadingScreen(answer),
      ),
      transition: Transition.fade,
    );
  }

  static void _navigateToLoadingScreen(bool answer) async {
    print('Motivation 3 answered: ${answer ? "Yes" : "No"}');
    print('🚀 Starting plan generation BEFORE loading screen...');

    // ✅ CRITICAL: Start plan generation immediately
    final controller = Get.find<OnboardingController>();

    // Navigate to loading screen
    Get.to(
      () => PlanCreationLoadingScreen(
        onComplete: () => _navigateToMainApp(),
      ),
      transition: Transition.fade,
    );

    // ✅ IMMEDIATELY trigger plan generation in background
    controller.submitOnboarding().then((success) {
      if (success) {
        print('✅ Plan generation completed successfully!');
      } else {
        print('❌ Plan generation failed');
        // The loading screen will handle timeout
      }
    });
  }

  static void _navigateToMainApp() {
    print('✅ Plan creation complete! Moving to main app...');

    // Plan is already generated and saved, just navigate
    Get.offAll(
      () => const MainScreen(),
      transition: Transition.fade,
    );
  }
}
