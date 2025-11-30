from pydantic import BaseModel
from typing import List, Optional

# ============================================
# EXERCISE MODELS
# ============================================

class ExerciseInWorkout(BaseModel):
    """Exercise as it appears in a workout (minimal info)"""
    exerciseId: str
    name: str
    duration: Optional[int] = None
    sets: Optional[int] = None
    reps: Optional[int] = None
    restBetweenSets: Optional[int] = None
    displayText: str

class ExerciseDetail(BaseModel):
    """Full exercise details (for detail sheet)"""
    exerciseId: str
    name: str
    category: str
    targetMuscle: str
    difficulty: str
    equipment: str
    thumbnailUrl: Optional[str] = None
    videoUrl: Optional[str] = None
    gifUrl: Optional[str] = None
    actionSteps: List[str]
    breathingRhythm: List[str]
    actionFeeling: List[str]
    commonMistakes: List[str]
    modifications: Optional[dict] = None

# ============================================
# WORKOUT SET MODEL
# ============================================

class WorkoutSet(BaseModel):
    """A set of exercises (Warm Up, Main, Cool Down)"""
    setNumber: int
    setName: str
    setType: str
    estimatedDuration: int
    exercises: List[ExerciseInWorkout]

# ============================================
# DAILY WORKOUT MODEL (WITH DATE & CYCLE INFO)
# ============================================

class DailyWorkout(BaseModel):
    """A single day's workout with date and cycle context"""
    day: int
    date: str  # "YYYY-MM-DD"
    dayName: str  # "Monday", "Tuesday", etc.
    dayTitle: str
    isRestDay: bool = False
    phaseNumber: int
    
    # Menstrual cycle context (if applicable)
    cycleWeek: Optional[int] = None  # 1, 2, 3, or 4
    cycleAdapted: bool = False  # True if workout was modified for cycle
    
    # Workout details
    workoutSets: List[WorkoutSet] = []
    
    # Metadata
    estimatedDuration: int
    estimatedCalories: int
    intensity: str
    focusArea: str
    equipment: str = "none"
    dayDescription: Optional[str] = None
    thumbnailUrl: Optional[str] = None

# ============================================
# PHASE MODEL
# ============================================

class Phase(BaseModel):
    """A phase in the workout plan"""
    phaseNumber: int
    phaseName: str
    phaseDescription: str
    phaseGoal: str
    startDay: int
    endDay: int
    startDate: str  # "YYYY-MM-DD"
    endDate: str  # "YYYY-MM-DD"
    intensityLevel: str
    focusArea: str
    workoutsPerWeek: int
    restDaysPerWeek: int

# ============================================
# COMPLETE WORKOUT PLAN MODEL
# ============================================

class WorkoutPlan(BaseModel):
    """Complete workout plan structure"""
    planId: str
    userId: str
    title: str
    description: str
    
    # Duration with dates
    totalDays: int
    totalWeeks: int
    startDate: str  # "YYYY-MM-DD"
    endDate: str  # "YYYY-MM-DD"
    
    # Menstrual cycle info (if applicable)
    menstrualCycleSync: bool = False
    cycleStartWeek: Optional[int] = None
    
    # Structure
    phases: List[Phase]
    dailyWorkouts: List[DailyWorkout]
    
    # Tips
    tips: List[str]
    
    # All exercise IDs used in the plan (for batch fetching)
    allExerciseIds: List[str]
    
    # Metadata
    generatedBy: str
    generatedAt: str
    createdAt: str

# ============================================
# REQUEST/RESPONSE MODELS
# ============================================

class ExerciseDetailRequest(BaseModel):
    """Request to fetch exercise details"""
    exerciseIds: List[str]

class ExerciseDetailResponse(BaseModel):
    """Response with exercise details"""
    exercises: List[ExerciseDetail]

class ChatMessage(BaseModel):
    """Chat message model"""
    message: str
    userId: Optional[str] = None
    conversationHistory: Optional[List[dict]] = None
    userContext: Optional[dict] = None