from pydantic import BaseModel
from typing import List, Optional
from datetime import date

class OnboardingData(BaseModel):
    # PART 1: GOAL (3 questions)
    motivations: List[str]  # ["get_shaped", "look_better", "improve_health", "release_stress", "feel_confident", "boost_energy"]
    mainGoal: str  # "lose_weight", "build_muscle", "keep_fit"
    focusAreas: List[str]  # ["arms", "belly", "butt", "legs", "fullbody"]
    
    # PART 2: BODY DATA (5 questions)
    height: float  # cm
    weight: float  # kg
    goalWeight: Optional[float] = None  # kg
    currentBodyType: str  # "athletic", "lean", "fit", "average", "curvy", "greater_than_40"
    desiredBodyType: str  # Same options as currentBodyType
    
    # PART 3: WOMEN'S HEALTH (7 questions)
    age: int  # 18-80
    menstrualCycleAdaptation: Optional[str] = None  # "yes", "no", "not_applicable"
    currentCycleWeek: Optional[int | str] = None  # 1, 2, 3, 4, or None if irregular
    pelvicFloorHealth: Optional[str] = None  # "no_issues", "occasional_leaking", "frequent_incontinence", "prefer_not_say"
    workoutLocation: str  # "yoga_mat", "couch_bed", "no_preference"
    workoutType: str  # "no_equipment", "no_jumping", "lying_down", "none_of_all"
    workoutLevel: str  # "easy_enough", "simple_sweaty", "somewhat_challenging"
    injuries: List[str]  # ["none", "knee", "lower_back", "ankle", "wrist", "hip"]
    
    # PART 4: FITNESS ANALYSIS (13 questions)
    typicalDay: str  # "seated_work", "home_sedentary", "walking_daily", "working_on_foot"
    activityLevel: str  # "not_active", "lightly_active", "moderately_active", "highly_active"
    fitnessLevel: str  # "beginner", "intermediate", "advanced"
    bellyType: Optional[str] = None  # "normal", "alcohol", "mommy", "stressed_out", "hormonal"
    hipsType: Optional[str] = None  # "normal", "flat", "saggy", "double", "bubble"
    legType: Optional[str] = None  # "normal", "x_shaped", "o_shaped", "xo_shaped"
    flexibilityLevel: Optional[str] = None  # "far_from_feet", "close_to_feet", "easily_touch"
    cardioLevel: Optional[str] = None  # "out_of_breath", "somewhat_tired", "easily"
    statementBodyDissatisfaction: bool  # True/False
    statementNeedGuidance: bool  # True/False
    statementEasilyGiveUp: bool  # True/False

class WorkoutPlanRequest(BaseModel):
    userId: str
    onboardingData: OnboardingData
    startDate: Optional[str] = None  # "YYYY-MM-DD" format, defaults to tomorrow
    duration: Optional[int] = None  # Optional: LLM will decide if not provided