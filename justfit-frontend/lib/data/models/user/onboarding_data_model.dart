class OnboardingData {
  // PART 1: GOAL
  final List<String> motivations;
  final String mainGoal;
  final List<String> focusAreas;

  // PART 2: BODY DATA
  final double height; // in cm
  final double weight; // in kg
  final double goalWeight; // in kg
  final String currentBodyType;
  final String desiredBodyType;

  // PART 3: WOMEN'S HEALTH
  final int age;
  final String menstrualCycleAdaptation;
  final String? currentCycleWeek;
  final String pelvicFloorHealth;
  final String workoutLocation;
  final String workoutType;
  final String workoutLevel;
  final List<String> injuries;

  // PART 4: FITNESS ANALYSIS
  final String typicalDay;
  final String activityLevel;
  final String fitnessLevel;
  final String bellyType;
  final String hipsType;
  final String legType;
  final String flexibilityLevel;
  final String cardioLevel;
  
  // Statements (Yes/No)
  final bool statementBodyDissatisfaction;
  final bool statementNeedGuidance;
  final bool statementEasilyGiveUp;

  // Metadata
  final DateTime completedAt;

  OnboardingData({
    required this.motivations,
    required this.mainGoal,
    required this.focusAreas,
    required this.height,
    required this.weight,
    required this.goalWeight,
    required this.currentBodyType,
    required this.desiredBodyType,
    required this.age,
    required this.menstrualCycleAdaptation,
    this.currentCycleWeek,
    required this.pelvicFloorHealth,
    required this.workoutLocation,
    required this.workoutType,
    required this.workoutLevel,
    required this.injuries,
    required this.typicalDay,
    required this.activityLevel,
    required this.fitnessLevel,
    required this.bellyType,
    required this.hipsType,
    required this.legType,
    required this.flexibilityLevel,
    required this.cardioLevel,
    required this.statementBodyDissatisfaction,
    required this.statementNeedGuidance,
    required this.statementEasilyGiveUp,
    required this.completedAt,
  });

  // From Firestore map
  factory OnboardingData.fromMap(Map<String, dynamic> map) {
    return OnboardingData(
      motivations: List<String>.from(map['motivations'] ?? []),
      mainGoal: map['mainGoal'] ?? '',
      focusAreas: List<String>.from(map['focusAreas'] ?? []),
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      goalWeight: (map['goalWeight'] ?? 0).toDouble(),
      currentBodyType: map['currentBodyType'] ?? '',
      desiredBodyType: map['desiredBodyType'] ?? '',
      age: map['age'] ?? 0,
      menstrualCycleAdaptation: map['menstrualCycleAdaptation'] ?? '',
      currentCycleWeek: map['currentCycleWeek'],
      pelvicFloorHealth: map['pelvicFloorHealth'] ?? '',
      workoutLocation: map['workoutLocation'] ?? '',
      workoutType: map['workoutType'] ?? '',
      workoutLevel: map['workoutLevel'] ?? '',
      injuries: List<String>.from(map['injuries'] ?? []),
      typicalDay: map['typicalDay'] ?? '',
      activityLevel: map['activityLevel'] ?? '',
      fitnessLevel: map['fitnessLevel'] ?? '',
      bellyType: map['bellyType'] ?? '',
      hipsType: map['hipsType'] ?? '',
      legType: map['legType'] ?? '',
      flexibilityLevel: map['flexibilityLevel'] ?? '',
      cardioLevel: map['cardioLevel'] ?? '',
      statementBodyDissatisfaction: map['statementBodyDissatisfaction'] ?? false,
      statementNeedGuidance: map['statementNeedGuidance'] ?? false,
      statementEasilyGiveUp: map['statementEasilyGiveUp'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : DateTime.now(),
    );
  }

  // To Firestore map
  Map<String, dynamic> toMap() {
    return {
      'motivations': motivations,
      'mainGoal': mainGoal,
      'focusAreas': focusAreas,
      'height': height,
      'weight': weight,
      'goalWeight': goalWeight,
      'currentBodyType': currentBodyType,
      'desiredBodyType': desiredBodyType,
      'age': age,
      'menstrualCycleAdaptation': menstrualCycleAdaptation,
      'currentCycleWeek': currentCycleWeek,
      'pelvicFloorHealth': pelvicFloorHealth,
      'workoutLocation': workoutLocation,
      'workoutType': workoutType,
      'workoutLevel': workoutLevel,
      'injuries': injuries,
      'typicalDay': typicalDay,
      'activityLevel': activityLevel,
      'fitnessLevel': fitnessLevel,
      'bellyType': bellyType,
      'hipsType': hipsType,
      'legType': legType,
      'flexibilityLevel': flexibilityLevel,
      'cardioLevel': cardioLevel,
      'statementBodyDissatisfaction': statementBodyDissatisfaction,
      'statementNeedGuidance': statementNeedGuidance,
      'statementEasilyGiveUp': statementEasilyGiveUp,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  // ========== HELPER: Convert codes to full descriptions ==========
  
  static String _getBodyTypeDescription(String code) {
    const map = {
      'athletic': 'Athletic (< 15% body fat)',
      'lean': 'Lean (15-20% body fat)',
      'fit': 'Fit (21-25% body fat)',
      'average': 'Average (26-30% body fat)',
      'curvy': 'Curvy (31-40% body fat)',
      'plus_size': 'Plus Size (> 40% body fat)',
    };
    return map[code] ?? code;
  }

  static String _getTypicalDayDescription(String code) {
    const map = {
      'work_seated': 'Working mostly seated (office work, remote work)',
      'home_sedentary': 'At home, mostly sedentary activities',
      'walking_daily': 'Walking daily, moderate movement',
      'working_on_foot': 'Working on feet most of the day (retail, hospitality)',
    };
    return map[code] ?? code;
  }

  static String _getActivityLevelDescription(String code) {
    const map = {
      'not_active': 'Not Active (no regular exercise)',
      'lightly_active': 'Lightly Active (1-2 days/week light activity)',
      'moderately_active': 'Moderately Active (3-4 days/week)',
      'highly_active': 'Highly Active (5+ days/week, intense workouts)',
    };
    return map[code] ?? code;
  }

  static String _getFitnessLevelDescription(String code) {
    const map = {
      'beginner': 'Beginner (new to fitness)',
      'intermediate': 'Intermediate (regular exercise for 6+ months)',
      'advanced': 'Advanced (consistent training for 1+ years)',
    };
    return map[code] ?? code;
  }

  static String _getFlexibilityDescription(String code) {
    const map = {
      'far': 'Low flexibility (far from touching toes)',
      'close': 'Moderate flexibility (close to touching toes)',
      'touch': 'Good flexibility (can touch toes easily)',
    };
    return map[code] ?? code;
  }

  static String _getCardioDescription(String code) {
    const map = {
      'breath': 'Low endurance (out of breath quickly after 1 min)',
      'tired': 'Moderate endurance (tired after 2-3 mins)',
      'easily': 'Good endurance (can maintain activity 5+ mins)',
    };
    return map[code] ?? code;
  }

  static String _getBellyTypeDescription(String code) {
    const map = {
      'normal': 'Normal belly shape',
      'alcohol_belly': 'Alcohol belly (round, firm)',
      'mommy_belly': 'Mommy belly (post-pregnancy)',
      'stressed_out_belly': 'Stressed-out belly (cortisol-related)',
      'hormonal_belly': 'Hormonal belly (hormone imbalance)',
    };
    return map[code] ?? code;
  }

  static String _getHipsTypeDescription(String code) {
    const map = {
      'normal': 'Normal hip shape',
      'flat': 'Flat hips',
      'saggy': 'Saggy hips',
      'double': 'Double hips (hip dips)',
      'bubble': 'Bubble hips (rounded)',
    };
    return map[code] ?? code;
  }

  static String _getLegTypeDescription(String code) {
    const map = {
      'normal': 'Normal leg alignment',
      'x_shaped': 'X-shaped legs (knock knees)',
      'o_shaped': 'O-shaped legs (bow legs)',
      'xo_shaped': 'XO-shaped legs (combination)',
    };
    return map[code] ?? code;
  }

  static String _getWorkoutLocationDescription(String code) {
    const map = {
      'yoga_mat': 'Has a yoga mat or exercise space',
      'couch_bed': 'Prefers couch or bed exercises',
      'no_preference': 'No specific location preference',
    };
    return map[code] ?? code;
  }

  static String _getWorkoutTypeDescription(String code) {
    const map = {
      'no_equipment': 'No equipment needed',
      'no_jumping': 'No jumping (low impact)',
      'lying_down': 'Prefers lying down exercises',
      'none': 'No specific workout type preference',
    };
    return map[code] ?? code;
  }

  static String _getWorkoutLevelDescription(String code) {
    const map = {
      'easy': 'Easy intensity',
      'moderate': 'Moderate intensity',
      'challenging': 'Challenging intensity',
    };
    return map[code] ?? code;
  }

  static String _getPelvicFloorDescription(String code) {
    const map = {
      'no_issues': 'No pelvic floor issues',
      'occasional': 'Occasional pelvic floor concerns',
      'frequent': 'Frequent pelvic floor issues',
      'prefer_not_say': 'Prefers not to say',
    };
    return map[code] ?? code;
  }

  static String _getCyclePhaseDescription(String? code) {
    if (code == null) return 'Not applicable';
    const map = {
      'week1': 'Week 1 (Menstruation)',
      'week2': 'Week 2 (Follicular phase)',
      'week3': 'Week 3 (Ovulation)',
      'week4': 'Week 4 (Luteal phase)',
      'irregular': 'Irregular cycle',
    };
    return map[code] ?? code;
  }

  // Helper: Convert to AI prompt-friendly format with FULL DESCRIPTIONS
  String toAIPromptString() {
    return '''
USER PROFILE:
- Age: $age years old
- Primary Goal: ${mainGoal.replaceAll('_', ' ').toUpperCase()}
- Motivations: ${motivations.map((m) => m.replaceAll('_', ' ')).join(', ')}
- Target Focus Areas: ${focusAreas.map((a) => a.replaceAll('_', ' ')).join(', ')}

BODY DATA & MEASUREMENTS:
- Current Weight: ${weight}kg (${(weight * 2.20462).toStringAsFixed(1)}lbs)
- Height: ${height}cm (${(height / 2.54 / 12).floor()}' ${((height / 2.54) % 12).round()}")
- Goal Weight: ${goalWeight}kg (${(goalWeight * 2.20462).toStringAsFixed(1)}lbs)
- Weight to Lose/Gain: ${(weight - goalWeight).abs().toStringAsFixed(1)}kg
- Current Body Type: ${_getBodyTypeDescription(currentBodyType)}
- Desired Body Type: ${_getBodyTypeDescription(desiredBodyType)}

FITNESS LEVEL & EXPERIENCE:
- Experience Level: ${_getFitnessLevelDescription(fitnessLevel)}
- Activity Level: ${_getActivityLevelDescription(activityLevel)}
- Typical Day: ${_getTypicalDayDescription(typicalDay)}
- Flexibility: ${_getFlexibilityDescription(flexibilityLevel)}
- Cardio Endurance: ${_getCardioDescription(cardioLevel)}

WORKOUT PREFERENCES & CONSTRAINTS:
- Injuries/Limitations: ${injuries.map((i) => i.replaceAll('_', ' ')).join(', ')}
- Workout Location: ${_getWorkoutLocationDescription(workoutLocation)}
- Equipment Preference: ${_getWorkoutTypeDescription(workoutType)}
- Preferred Intensity: ${_getWorkoutLevelDescription(workoutLevel)}

BODY-SPECIFIC DETAILS:
- Belly Type: ${_getBellyTypeDescription(bellyType)}
- Hips Type: ${_getHipsTypeDescription(hipsType)}
- Leg Type: ${_getLegTypeDescription(legType)}

WOMEN'S HEALTH:
- Menstrual Cycle Adaptation: ${menstrualCycleAdaptation == 'yes' ? 'Yes, adapt plan to cycle' : 'No adaptation needed'}
${currentCycleWeek != null ? '- Current Cycle Phase: ${_getCyclePhaseDescription(currentCycleWeek)}' : ''}
- Pelvic Floor Health: ${_getPelvicFloorDescription(pelvicFloorHealth)}

PSYCHOLOGICAL PROFILE:
- Body Image Concerns: ${statementBodyDissatisfaction ? 'Has body dissatisfaction when looking in mirror' : 'Generally satisfied with body image'}
- Need for Guidance: ${statementNeedGuidance ? 'Needs help selecting suitable workouts' : 'Confident in workout selection'}
- Motivation Risk: ${statementEasilyGiveUp ? 'May give up if exercises are too hard or boring' : 'Good perseverance'}

PLAN GENERATION NOTES:
- Create a personalized, progressive workout plan
- Consider all constraints, injuries, and preferences
- Adapt intensity based on fitness level and motivation risk
- Include exercises targeting focus areas: ${focusAreas.join(', ')}
- Plan should be realistic and sustainable for long-term success
''';
  }
}
