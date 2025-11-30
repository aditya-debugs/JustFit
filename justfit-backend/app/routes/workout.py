from fastapi import APIRouter, HTTPException
from app.models.onboarding import WorkoutPlanRequest
from app.models.workout import WorkoutPlan, ExerciseDetailRequest, ExerciseDetailResponse
from app.services.workout_generator import workout_generator
from app.services.exercise_details_generator import exercise_details_generator

router = APIRouter(tags=["Workout"])

@router.post("/generate", response_model=WorkoutPlan)
async def generate_workout_plan(request: WorkoutPlanRequest):
    """
    Generate a personalized workout plan based on onboarding data.
    This returns the plan structure with exercise IDs but NOT detailed instructions.
    Use /exercise-details endpoint to fetch exercise instructions.
    """
    try:
        plan = await workout_generator.generate_workout_plan(request)
        return plan
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/exercise-details", response_model=ExerciseDetailResponse)
async def fetch_exercise_details(request: ExerciseDetailRequest):
    """
    Fetch detailed instructions for multiple exercises at once.
    This should be called after generating a plan to get all exercise details in one batch.
    
    Example:
    {
        "exerciseIds": ["knee-pushups", "arm-circles", "bodyweight-squats"]
    }
    """
    try:
        details = await exercise_details_generator.generate_exercise_details(request)
        return details
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/test")
async def test_workout_endpoint():
    """
    Test endpoint to verify workout routes are working
    """
    return {
        "message": "Workout endpoint is working!",
        "available_endpoints": [
            "POST /api/workout/generate - Generate workout plan structure",
            "POST /api/workout/exercise-details - Fetch exercise instructions (batch)"
        ]
    }