import 'package:flutter/material.dart';

class OnboardingData {
  // Part 1: Goal Questions
  static const Map<String, dynamic> goalQ1 = {
    'partTitle': 'Goal',
    'question': 'What motivates you most?',
    'options': [
      {'icon': Icons.fitness_center, 'label': 'Get Shaped'},
      {'icon': Icons.auto_awesome, 'label': 'Look Better'},
      {'icon': Icons.medical_services_outlined, 'label': 'Improve Health'},
      {'icon': Icons.self_improvement, 'label': 'Release Stress'},
      {'icon': Icons.thumb_up_outlined, 'label': 'Feel Confident'},
      {'icon': Icons.bolt, 'label': 'Boost Energy'},
    ],
    'isMultiSelect': true,
    'currentPart': 1,
    'currentQuestionInPart': 1,
    'totalQuestionsInPart': 3,
    'totalParts': 4,
  };

  static const Map<String, dynamic> goalQ2 = {
    'partTitle': 'Goal',
    'question': "What's your main goal?",
    'options': [
      {
        'label': 'Lose weight',
        'image': 'assets/images/onboarding/lose_weight.png',
      },
      {
        'label': 'Build muscle',
        'image': 'assets/images/onboarding/build_muscle.png',
      },
      {
        'label': 'Keep fit',
        'image': 'assets/images/onboarding/keep_fit.png',
      },
    ],
    'currentPart': 1,
    'currentQuestionInPart': 2,
    'totalQuestionsInPart': 3,
    'totalParts': 4,
  };

  static const Map<String, dynamic> goalQ3 = {
  'partTitle': 'Goal',
  'question': 'Which areas do you want\nto focus on?',
  'options': [
    {'bodyPart': 'arms', 'label': 'Toned Arms'},
    {'bodyPart': 'belly', 'label': 'Flat Belly'},
    {'bodyPart': 'butt', 'label': 'Round Butt'},
    {'bodyPart': 'legs', 'label': 'Slim Legs'},
    {'bodyPart': 'fullbody', 'label': 'Full Body Slimming'},
  ],
  'currentPart': 1,
  'currentQuestionInPart': 3,
  'totalQuestionsInPart': 3,
  'totalParts': 4,
};

  static const Map<String, dynamic> bodyDataQ1 = {
    'partTitle': 'Body Data',
    'question': "What's your height?",
    'currentPart': 2,
    'currentQuestionInPart': 1,
    'totalQuestionsInPart': 5,  // ← ONLY CHANGE: 3 to 5
    'totalParts': 4,
  };

  static const Map<String, dynamic> bodyDataQ2 = {
    'partTitle': 'Body Data',
    'question': "What's your weight?",
    'currentPart': 2,
    'currentQuestionInPart': 2,
    'totalQuestionsInPart': 5,  // ← ONLY CHANGE: 3 to 5
    'totalParts': 4,
  };

  static final Map<String, dynamic> bodyDataQ3 = {
    'partTitle': 'Body Data',
    'question': 'What\'s your goal weight?',
    'currentPart': 2,
    'currentQuestionInPart': 3,
    'totalQuestionsInPart': 5,  // ← ONLY CHANGE: 3 to 5
    'totalParts': 4,
  };

  static final Map<String, dynamic> bodyDataQ4 = {
    'partTitle': 'Body Data',
    'question': 'Choose your body type',
    'currentPart': 2,
    'currentQuestionInPart': 4,
    'totalQuestionsInPart': 5,  // ← ONLY CHANGE: 4 to 5
    'totalParts': 4,
  };

  static final Map<String, dynamic> bodyDataQ5 = {
    'partTitle': 'Body Data',
    'question': 'What\'s your desired body type?',
    'currentPart': 2,
    'currentQuestionInPart': 5,
    'totalQuestionsInPart': 5,  // ← NEW ENTRY
    'totalParts': 4,
  };
}