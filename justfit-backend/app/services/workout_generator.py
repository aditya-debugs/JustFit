from datetime import datetime, timedelta
from typing import Optional, List
import uuid
import logging
import json
import random
from app.models.onboarding import WorkoutPlanRequest, OnboardingData
from app.models.workout import WorkoutPlan, Phase, DailyWorkout, WorkoutSet, ExerciseInWorkout
from app.core.gemini import gemini_service

logger = logging.getLogger(__name__)

# ===== WORKOUT GENERATOR =====

class WorkoutGeneratorService:
    def __init__(self):
        self.gemini = gemini_service
    
    def _calculate_start_date(self, start_date_str: Optional[str]) -> datetime:
        if start_date_str:
            return datetime.strptime(start_date_str, "%Y-%m-%d")
        else:
            return datetime.now() + timedelta(days=1)
    
    def _build_blueprint_prompt(self, data: OnboardingData) -> str:
        """ULTRA-SHORT prompt for token efficiency - AI decides duration"""
        
        focus_area = data.focusAreas[0] if data.focusAreas else "full_body"
        
        # CRITICAL: Shorter exercise lists
        focus_ex = {
            "abs": "plank,bicycle-crunches,russian-twists,leg-raises,mountain-climbers,dead-bug,flutter-kicks,reverse-crunches,heel-touches,boat-pose,side-plank,plank-hip-dips",
            "glutes": "glute-bridges,hip-thrusts,donkey-kicks,fire-hydrants,clamshells,squat-pulses,sumo-squats,single-leg-glute-bridge,frog-pumps,curtsy-lunges,bulgarian-split-squats,step-ups",
            "legs": "squats,lunges,side-lunges,calf-raises,wall-sit,bulgarian-split-squats,sumo-squats,pistol-squats,step-ups",
            "arms": "tricep-dips,push-ups,shoulder-taps,diamond-push-ups,pike-push-ups,arm-circles,wall-push-ups",
            "full_body": "burpees,mountain-climbers,inchworms,bear-crawls,walkouts",
            "back": "superman,bird-dog,reverse-fly,bent-over-row,back-extension,swimmers"
        }
        
        equip = "dumbbell-squats,dumbbell-hip-thrusts,dumbbell-rows,dumbbell-press,banded-glute-bridges,banded-lateral-walks,banded-kickbacks,banded-clamshells,dumbbell-lunges,dumbbell-deadlifts"
        
        banned = "jumping-jacks,burpees,jump-squats,high-knees,butt-kicks,box-jumps,plank-jacks,tuck-jumps,step-jacks" if data.workoutType == "no_jumping" else ""
        safe = "marching,step-touches,side-steps,knee-raises,arm-swings,walk-outs" if data.workoutType == "no_jumping" else ""
        
        goal_map = {"lose_weight": "Fat Burn", "build_muscle": "Muscle Build", "keep_fit": "Fitness"}
        focus_map = {"abs": "Core Sculpt", "belly": "Flat Belly", "glutes": "Booty Builder", "butt": "Booty Builder", 
                     "legs": "Leg Toning", "arms": "Arm Sculpt", "fullbody": "Full Body", "back": "Back Strength"}
        
        prompt = f"""USER: {data.age}yo, {data.weight}kg → {data.goalWeight or data.weight-5}kg, {data.fitnessLevel}, goal: {data.mainGoal}, focus: {focus_area}

CRITICAL RULES:
1. exercisePool MUST contain AT LEAST 15 exercises from: {focus_ex.get(focus_area, 'squats,plank,lunges')}
{"2. exercisePool MUST contain AT LEAST 10 exercises from: " + equip if data.workoutType == 'has_equipment' else '2. ZERO equipment exercises allowed'}
{"3. BANNED (no jumping): " + banned + ". USE ONLY: " + safe if data.workoutType == 'no_jumping' else ''}
4. Exercise names: lowercase-hyphen ("knee-push-ups")
5. Total 18-22 exercises in exercisePool per phase
6. Different exercises each day via exerciseRotation

JSON (YOU decide everything):
{{
  "planTitle": "{goal_map.get(data.mainGoal, 'Fitness')} - {focus_map.get(focus_area, 'Full Body')}",
  "recommendedDuration": YOUR_CHOICE_28_TO_60_DAYS,
  "rationale": "Brief explanation of your duration and phase choices",
  "cycleSync": false,
  "phasesBlueprint": [
    {{
      "phaseNumber": 1,
      "phaseName": "YOUR creative name",
      "durationDays": YOUR_CHOICE,
      "intensityLevel": "{data.fitnessLevel}",
      "focusArea": "{focus_area}",
      "workoutsPerWeek": 4-6,
      "exercisePool": ["18-22 personalized exercises"],
      "weeklyPattern": [
        {{"day":1,"type":"focus","intensity":"moderate","exerciseRotation":["ex1","ex2","ex3","ex4"],"progressionWeek1":{{"sets":3,"reps":10,"rest":60}},"progressionWeek2":{{"sets":3,"reps":12,"rest":55}},"progressionWeek3":{{"sets":4,"reps":12,"rest":50}},"progressionWeek4":{{"sets":4,"reps":14,"rest":50}},"progressionWeek5":{{"sets":4,"reps":15,"rest":45}},"progressionWeek6":{{"sets":4,"reps":16,"rest":45}}}},
        {{"day":2,"type":"support","intensity":"moderate","exerciseRotation":["ex5","ex6","ex7","ex8"],"progressionWeek1":{{"sets":3,"reps":12,"rest":60}},"progressionWeek2":{{"sets":4,"reps":12,"rest":50}},"progressionWeek3":{{"sets":4,"reps":14,"rest":50}},"progressionWeek4":{{"sets":4,"reps":15,"rest":45}},"progressionWeek5":{{"sets":4,"reps":16,"rest":45}},"progressionWeek6":{{"sets":5,"reps":16,"rest":40}}}},
        {{"day":3,"type":"cardio","intensity":"light","exerciseRotation":["ex9","ex10","ex11"],"progressionWeek1":{{"sets":3,"reps":15,"rest":45}},"progressionWeek2":{{"sets":3,"reps":18,"rest":40}},"progressionWeek3":{{"sets":3,"reps":20,"rest":40}},"progressionWeek4":{{"sets":4,"reps":20,"rest":35}},"progressionWeek5":{{"sets":4,"reps":22,"rest":35}},"progressionWeek6":{{"sets":4,"reps":25,"rest":30}}}},
        {{"day":4,"type":"full","intensity":"moderate","exerciseRotation":["ex12","ex13","ex14"],"progressionWeek1":{{"sets":3,"reps":10,"rest":60}},"progressionWeek2":{{"sets":3,"reps":12,"rest":55}},"progressionWeek3":{{"sets":4,"reps":12,"rest":50}},"progressionWeek4":{{"sets":4,"reps":14,"rest":50}},"progressionWeek5":{{"sets":4,"reps":15,"rest":45}},"progressionWeek6":{{"sets":5,"reps":15,"rest":40}}}},
        {{"day":5,"type":"burnout","intensity":"high","exerciseRotation":["ex15","ex16","ex17"],"progressionWeek1":{{"sets":3,"reps":15,"rest":45}},"progressionWeek2":{{"sets":3,"reps":18,"rest":40}},"progressionWeek3":{{"sets":4,"reps":18,"rest":40}},"progressionWeek4":{{"sets":4,"reps":20,"rest":35}},"progressionWeek5":{{"sets":4,"reps":22,"rest":30}},"progressionWeek6":{{"sets":5,"reps":22,"rest":30}}}},
        {{"day":6,"type":"rest","intensity":"none"}},
        {{"day":7,"type":"recovery","intensity":"light","exerciseRotation":["stretch1","stretch2"],"progressionWeek1":{{"duration":30}},"progressionWeek2":{{"duration":30}},"progressionWeek3":{{"duration":30}},"progressionWeek4":{{"duration":30}},"progressionWeek5":{{"duration":30}},"progressionWeek6":{{"duration":30}}}}
      ]
    }},
    {{
      "phaseNumber": 2,
      "phaseName": "YOUR creative phase 2 name",
      "durationDays": YOUR_CHOICE,
      "intensityLevel": "intermediate",
      "focusArea": "{focus_area}",
      "workoutsPerWeek": 5-6,
      "exercisePool": ["different 18-22 exercises"],
      "weeklyPattern": [same 7-day structure]
    }},
    {{ADD MORE PHASES as needed}}
  ]
}}

REQUIREMENTS:
- SUM of all phase durationDays MUST EQUAL recommendedDuration
- recommendedDuration: 28-60 days (your choice based on user profile)
- Count exercises in exercisePool from focus list: MUST BE 15+
{"- Count equipment exercises in exercisePool: MUST BE 10+" if data.workoutType == 'has_equipment' else ""}
{"- Verify ZERO exercises contain: jump, jack, hop, plyo" if data.workoutType == 'no_jumping' else ""}
- exerciseRotation uses exercises from exercisePool
- Replace example exercisePool with personalized 18-22 exercises per phase"""
        
        return prompt
    
    def _expand_blueprint(self, blueprint: dict, data: OnboardingData, start_date: datetime, user_id: str) -> WorkoutPlan:
        """Expand blueprint into complete daily workout plan with rotation and progression"""
        
        plan_id = str(uuid.uuid4())
        total_days = blueprint["recommendedDuration"]
        total_weeks = (total_days + 6) // 7
        end_date = start_date + timedelta(days=total_days - 1)

        # ✅ CONVERT string phase to integer week ONCE (frontend sends "week1", "week2", etc.)
        cycle_week_int = None
        if data.currentCycleWeek:
            if isinstance(data.currentCycleWeek, str):
                if data.currentCycleWeek == "week1":
                    cycle_week_int = 1
                elif data.currentCycleWeek == "week2":
                    cycle_week_int = 2
                elif data.currentCycleWeek == "week3":
                    cycle_week_int = 3
                elif data.currentCycleWeek == "week4":
                    cycle_week_int = 4
                # "irregular" or anything else = None
            else:
                # Already an integer
                cycle_week_int = data.currentCycleWeek
        
        # Use AI-generated title or fallback
        plan_title = blueprint.get("planTitle", f"{total_days}-Day Personalized Fitness Plan")
        
        phases = []
        daily_workouts = []
        current_day = 1
        current_date = start_date
        
        for phase_bp in blueprint["phasesBlueprint"]:
            phase_id = str(uuid.uuid4())
            phase_start_day = current_day
            phase_duration = phase_bp["durationDays"]
            phase_end_day = phase_start_day + phase_duration - 1
            phase_start_date = current_date
            phase_end_date = current_date + timedelta(days=phase_duration - 1)
            
            # Create phase
            phases.append(Phase(
                phaseNumber=phase_bp["phaseNumber"],
                phaseName=phase_bp["phaseName"],
                phaseDescription=f"Phase {phase_bp['phaseNumber']}: {phase_bp['phaseName']}",
                phaseGoal=f"Build {phase_bp['focusArea']} strength and endurance",
                startDay=phase_start_day,
                endDay=phase_end_day,
                startDate=phase_start_date.strftime("%Y-%m-%d"),
                endDate=phase_end_date.strftime("%Y-%m-%d"),
                intensityLevel=phase_bp["intensityLevel"],
                focusArea=phase_bp["focusArea"],
                workoutsPerWeek=phase_bp["workoutsPerWeek"],
                restDaysPerWeek=7 - phase_bp["workoutsPerWeek"]
            ))
            
            # Generate daily workouts for this phase
            exercise_pool = phase_bp["exercisePool"]
            weekly_pattern = phase_bp["weeklyPattern"]
            
            for day_offset in range(phase_duration):
                day_date = current_date + timedelta(days=day_offset)
                day_of_week = day_offset % 7
                day_pattern = weekly_pattern[day_of_week]
                
                # Calculate week number for progressive overload
                week_number = (current_day - 1) // 7 + 1
                
                if day_pattern.get("type") == "rest":
                    # Rest day
                    daily_workouts.append(DailyWorkout(
                        day=current_day,
                        date=day_date.strftime("%Y-%m-%d"),
                        dayName=day_date.strftime("%A"),
                        dayTitle="Rest",
                        isRestDay=True,
                        phaseNumber=phase_bp["phaseNumber"],
                        estimatedDuration=0,
                        estimatedCalories=0,
                        intensity="none",
                        focusArea="rest",
                        equipment="none"
                    ))
                else:
                    # Get progression for current week (cap at week 6)
                    progression_key = f"progressionWeek{min(week_number, 6)}"
                    base_progression = day_pattern.get(progression_key, {"sets": 3, "reps": 12, "rest": 60, "duration": 30})
                    
                    # 🩸 MENSTRUAL CYCLE SYNC: Adjust intensity based on cycle week
                    cycle_intensity_label = "Standard"
                    
                    # ✅ CHECK 1: User must OPT-IN for menstrual cycle adaptation
                    if data.menstrualCycleAdaptation == "yes" and cycle_week_int:
                        # Calculate cycle week (1-4) based on start week
                        days_since_start = current_day - 1
                        cycle_week = ((cycle_week_int - 1 + (days_since_start // 7)) % 4) + 1
                        
                        # Adjust workout based on cycle phase
                        if cycle_week == 1:  # 🩸 MENSTRUATION - LOWEST intensity
                            intensity_multiplier = 0.65
                            cycle_intensity_label = "Gentle (Menstruation)"
                            # Force recovery/light workouts during period
                            if day_pattern.get("type") in ["burnout", "hiit", "full"]:
                                day_pattern = dict(day_pattern)
                                day_pattern["type"] = "recovery"
                            
                            # ✅ CHECK 2: Extra caution for pelvic floor health
                            if data.pelvicFloorHealth in ["occasional_leaking", "frequent_incontinence"]:
                                intensity_multiplier = 0.55
                                cycle_intensity_label = "Very Gentle (Menstruation + Pelvic Care)"
                                print(f"🩸🛡️ CYCLE WEEK 1 + Pelvic Floor: Extra gentle, 55% intensity")
                            else:
                                print(f"🩸 CYCLE WEEK 1 (Menstruation): Light intensity (65%)")
                        
                        elif cycle_week == 2:  # ⚡ FOLLICULAR - BUILDING energy
                            intensity_multiplier = 1.0
                            cycle_intensity_label = "Moderate (Follicular - Building Energy)"
                            print(f"⚡ CYCLE WEEK 2 (Follicular): Normal intensity, energy building")
                        
                        elif cycle_week == 3:  # 🌟 OVULATION - PEAK performance
                            intensity_multiplier = 1.15
                            cycle_intensity_label = "High (Ovulation - Peak Power)"
                            
                            # ✅ CHECK 3: Reduce impact if pelvic floor issues
                            if data.pelvicFloorHealth in ["occasional_leaking", "frequent_incontinence"]:
                                intensity_multiplier = 0.95
                                cycle_intensity_label = "Moderate (Ovulation + Pelvic Care)"
                                # No high-intensity workouts with pelvic issues
                                if day_pattern.get("type") in ["burnout", "hiit"]:
                                    day_pattern = dict(day_pattern)
                                    day_pattern["type"] = "cardio"
                                print(f"🌟🛡️ CYCLE WEEK 3 + Pelvic Floor: Moderate intensity (no high-impact)")
                            else:
                                print(f"🌟 CYCLE WEEK 3 (Ovulation): PEAK performance, 115% intensity!")
                        
                        else:  # 🌙 LUTEAL (Week 4) - PMS, moderate intensity
                            intensity_multiplier = 0.85
                            cycle_intensity_label = "Moderate (Luteal - PMS Phase)"
                            # Slightly reduce intensity during PMS
                            if day_pattern.get("type") in ["burnout", "hiit"]:
                                day_pattern = dict(day_pattern)
                                day_pattern["type"] = "cardio"
                            print(f"🌙 CYCLE WEEK 4 (Luteal/PMS): 85% intensity, gentler approach")
                        
                        # Apply multiplier to progression
                        progression = {
                            "sets": max(2, int(base_progression.get("sets", 3) * intensity_multiplier)) if cycle_week != 1 else base_progression.get("sets", 3),
                            "reps": max(8, int(base_progression.get("reps", 12) * intensity_multiplier)),
                            "rest": min(90, int(base_progression.get("rest", 60) / intensity_multiplier)) if intensity_multiplier > 0 else base_progression.get("rest", 60),
                            "duration": max(20, int(base_progression.get("duration", 30) * intensity_multiplier))
                        }
                    
                    # ✅ NO CYCLE SYNC, but still check pelvic floor health
                    elif data.pelvicFloorHealth in ["occasional_leaking", "frequent_incontinence"]:
                        # Apply pelvic floor modifications even without cycle sync
                        intensity_multiplier = 0.85
                        progression = {
                            "sets": base_progression.get("sets", 3),
                            "reps": max(8, int(base_progression.get("reps", 12) * intensity_multiplier)),
                            "rest": int(base_progression.get("rest", 60) / intensity_multiplier),
                            "duration": max(20, int(base_progression.get("duration", 30) * intensity_multiplier))
                        }
                        cycle_intensity_label = "Moderate (Pelvic Floor Safe)"
                        
                        # Avoid high-intensity workouts
                        if day_pattern.get("type") in ["burnout", "hiit"]:
                            day_pattern = dict(day_pattern)
                            day_pattern["type"] = "cardio"
                        
                        print(f"🛡️ Pelvic Floor Care: 85% intensity, avoiding high-impact")
                    
                    else:
                        # ✅ NO SYNC + NO PELVIC ISSUES: Standard progression
                        progression = base_progression
                        # Determine intensity label from workout type
                        workout_type = day_pattern.get("type", "full").lower()
                        if workout_type in ["burnout", "hiit"]:
                            cycle_intensity_label = "High Intensity"
                        elif workout_type == "recovery":
                            cycle_intensity_label = "Light Recovery"
                        elif workout_type == "cardio":
                            cycle_intensity_label = "Moderate Cardio"
                        else:
                            cycle_intensity_label = "Moderate"
                    
                    print(f"🔍 DEBUG: Week {week_number}, Day pattern: {day_pattern.get('type')}, Progression: {progression}, Intensity: {cycle_intensity_label}")
                    
                    workout_sets = self._create_workout_sets_with_rotation(
                        exercise_pool,
                        day_pattern,
                        progression,
                        cycle_week_int
                    )
                    
                    # ✅ CALCULATE ACCURATE TIME & CALORIES
                    total_time_seconds = 0
                    
                    # Warmup time (base - 5s per exercise)
                    for ex in workout_sets[0].exercises:
                        total_time_seconds += max(20, ex.duration - 5)
                    
                    # Main workout time (3 rounds with progressive time)
                    sets = progression.get("sets", 3)  # Number of rounds
                    for ex in workout_sets[1].exercises:
                        round1_time = ex.duration  # Base time
                        round2_time = ex.duration + 10  # +10s
                        round3_time = ex.duration + 15  # +5s
                        
                        if sets == 3:
                            total_time_seconds += round1_time + round2_time + round3_time
                        elif sets == 4:
                            round4_time = ex.duration + 15  # +15s for round 4
                            total_time_seconds += round1_time + round2_time + round3_time + round4_time
                        elif sets == 5:
                            round4_time = ex.duration + 15
                            round5_time = ex.duration + 20  # +20s for round 5
                            total_time_seconds += round1_time + round2_time + round3_time + round4_time + round5_time
                        else:
                            # Fallback for other set counts
                            total_time_seconds += ex.duration * sets
                    
                    # Cooldown time (base - 5s per exercise)
                    for ex in workout_sets[2].exercises:
                        total_time_seconds += max(20, ex.duration - 5)
                    
                    # Convert to minutes (round up)
                    estimated_duration = (total_time_seconds + 59) // 60
                    
                    # Calculate calories (5 cal/min for moderate intensity)
                    estimated_calories = estimated_duration * 5
                    
                    print(f"   💡 Calculated: {estimated_duration} min, {estimated_calories} cal (from {total_time_seconds}s workout)")
                    
                    daily_workouts.append(DailyWorkout(
                        day=current_day,
                        date=day_date.strftime("%Y-%m-%d"),
                        dayName=day_date.strftime("%A"),
                        dayTitle=day_pattern.get("type", "Workout").capitalize(),
                        isRestDay=False,
                        phaseNumber=phase_bp["phaseNumber"],
                        workoutSets=workout_sets,
                        estimatedDuration=estimated_duration,  # ✅ ACCURATE!
                        estimatedCalories=estimated_calories,  # ✅ ACCURATE!
                        intensity=cycle_intensity_label,  # ✅ Shows cycle-aware intensity
                        focusArea=phase_bp["focusArea"],
                        equipment="none" if data.workoutType == "no_equipment" else "minimal"
                    ))
                
                current_day += 1
            
            current_date = phase_end_date + timedelta(days=1)
        
        # Collect exercise IDs
        all_exercise_ids = set()
        for phase_bp in blueprint["phasesBlueprint"]:
            all_exercise_ids.update(phase_bp["exercisePool"])
        
        return WorkoutPlan(
            planId=plan_id,
            userId=user_id,
            title=plan_title,
            description=blueprint["rationale"],
            totalDays=total_days,
            totalWeeks=total_weeks,
            startDate=start_date.strftime("%Y-%m-%d"),
            endDate=end_date.strftime("%Y-%m-%d"),
            menstrualCycleSync=blueprint.get("cycleSync", False),
            cycleStartWeek=cycle_week_int,
            phases=phases,
            dailyWorkouts=daily_workouts,
            tips=["Stay hydrated", "Focus on form over speed", "Rest when needed", "Track progress weekly"],
            allExerciseIds=list(all_exercise_ids),
            generatedBy="gemini-2.5-flash",
            generatedAt=datetime.now().isoformat(),
            createdAt=datetime.now().isoformat()
        )

    
    def _create_workout_sets_with_rotation(self, exercise_pool: List[str], day_pattern: dict, progression: dict, cycle_week: Optional[int] = None) -> List[WorkoutSet]:
        """Create workout sets with proper phase-based structure - guarantees minimum exercises"""
        
        # Get exercises from AI's daily rotation (DIFFERENT exercises each day!)
        if "exerciseRotation" in day_pattern and day_pattern["exerciseRotation"]:
            all_exercises = day_pattern["exerciseRotation"]
        else:
            # Fallback: random selection from pool (ensures daily variety)
            all_exercises = random.sample(exercise_pool, min(len(exercise_pool), 14))
        
        # ✅ ENSURE MINIMUM 14 EXERCISES for proper workout structure
        if len(all_exercises) < 14:
            remaining_pool = [e for e in exercise_pool if e not in all_exercises]
            needed = 14 - len(all_exercises)
            if len(remaining_pool) >= needed:
                all_exercises = list(all_exercises) + random.sample(remaining_pool, needed)
            else:
                # If still not enough, repeat some exercises
                all_exercises = list(all_exercises) + remaining_pool
                if len(all_exercises) < 14:
                    all_exercises = all_exercises + random.sample(exercise_pool, 14 - len(all_exercises))
        
        # ✅ PHASE-BASED EXERCISE COUNTS (no 0-exercise main workouts!)
        workout_type = day_pattern.get("type", "full").lower()
        sets = progression.get("sets", 3)
        
        if workout_type == "recovery":
            # Recovery: lighter but still has main workout (2-4-2 structure)
            warmup_count, main_count, cooldown_count = 2, 4, 2
        elif workout_type in ["cardio", "burnout"]:
            # Cardio/Burnout: focused intensity (3-6-3 structure)
            warmup_count, main_count, cooldown_count = 3, 6, 3
        elif workout_type == "hiit":
            # HIIT: short bursts (2-5-2 structure)
            warmup_count, main_count, cooldown_count = 2, 5, 2
        elif sets >= 4:
            # High intensity weeks: more exercises (3-10-3 structure)
            warmup_count, main_count, cooldown_count = 3, 10, 3
        else:
            # Standard: balanced workout (3-8-3 structure)
            warmup_count, main_count, cooldown_count = 3, 8, 3
        
        # Extract exercise sets
        warmup_ex = all_exercises[0:warmup_count]
        main_ex = all_exercises[warmup_count:warmup_count + main_count]
        cooldown_ex = all_exercises[warmup_count + main_count:warmup_count + main_count + cooldown_count]
        
        # Get progression data
        reps = progression.get("reps", 12)
        rest = progression.get("rest", 60)
        duration = progression.get("duration", 30)
        
        return [
            WorkoutSet(
                setNumber=1,
                setName="Warm Up",
                setType="warmup",
                estimatedDuration=5,
                exercises=[ExerciseInWorkout(
                    exerciseId=e,
                    name=e.replace("-", " ").title(),
                    duration=25 + (i % 3) * 5,  # Vary: 25s, 30s, 35s
                    displayText=f"{25 + (i % 3) * 5} seconds"
                ) for i, e in enumerate(warmup_ex)]
            ),
            WorkoutSet(
                setNumber=2,
                setName="Main Workout",
                setType="main",
                estimatedDuration=25,
                exercises=[ExerciseInWorkout(
                    exerciseId=e,
                    name=e.replace("-", " ").title(),
                    duration=30 + (i % 4) * 5,  # Vary: 30s, 35s, 40s, 45s
                    sets=sets,
                    reps=reps,
                    restBetweenSets=rest,
                    displayText=f"{30 + (i % 4) * 5}s × {sets} rounds"
                ) for i, e in enumerate(main_ex)]
            ),
            WorkoutSet(
                setNumber=3,
                setName="Cool Down",
                setType="cooldown",
                estimatedDuration=5,
                exercises=[ExerciseInWorkout(
                    exerciseId=e,
                    name=e.replace("-", " ").title(),
                    duration=40 + (i % 2) * 5,  # Vary: 40s, 45s
                    displayText=f"{40 + (i % 2) * 5} seconds"
                ) for i, e in enumerate(cooldown_ex)]
            )
        ]

    
    async def generate_workout_plan(self, request: WorkoutPlanRequest) -> WorkoutPlan:
        """Generate workout plan using two-stage approach with JSON mode"""
        max_retries = 3
        
        # For validation
        focus_area = request.onboardingData.focusAreas[0] if request.onboardingData.focusAreas else "full_body"
        focus_ex = {
            "abs": "plank,bicycle-crunches,russian-twists,leg-raises,mountain-climbers,dead-bug,flutter-kicks,reverse-crunches,heel-touches,boat-pose,side-plank,plank-hip-dips",
            "glutes": "glute-bridges,hip-thrusts,donkey-kicks,fire-hydrants,clamshells,squat-pulses,sumo-squats,single-leg-glute-bridge,frog-pumps,curtsy-lunges,bulgarian-split-squats,step-ups",
            "legs": "squats,lunges,side-lunges,calf-raises,wall-sit,bulgarian-split-squats,sumo-squats,pistol-squats,step-ups",
            "arms": "tricep-dips,push-ups,shoulder-taps,diamond-push-ups,pike-push-ups,arm-circles,wall-push-ups",
            "full_body": "burpees,mountain-climbers,inchworms,bear-crawls,walkouts",
            "back": "superman,bird-dog,reverse-fly,bent-over-row,back-extension,swimmers"
        }
        
        for attempt in range(max_retries):
            try:
                start_date = self._calculate_start_date(request.startDate)
                
                logger.info(f"🎯 Stage 1: Creating blueprint for {request.userId} (Attempt {attempt + 1}/{max_retries})")
                
                prompt = self._build_blueprint_prompt(request.onboardingData)
                
                # Use JSON mode for guaranteed valid JSON
                response = await self.gemini.generate_content(prompt, json_mode=True)
                
                logger.info(f"📄 Raw response length: {len(response)} chars")
                
                # AGGRESSIVE CLEANING
                cleaned = response.strip()
                
                # Remove markdown code blocks
                if cleaned.startswith(""):
                    cleaned = cleaned[7:].strip()
                elif cleaned.startswith("```"):
                    cleaned = cleaned[3:].strip()
                if cleaned.endswith("```"):
                    cleaned = cleaned[:-3].strip()
                
                # BULLETPROOF FIX: Handle Gemini truncation
                if not cleaned.startswith('{'):
                    if cleaned.startswith('anTitle"') or cleaned.startswith('"planTitle"'):
                        # Missing opening characters
                        cleaned = '{"pl' + cleaned if cleaned.startswith('anTitle"') else '{' + cleaned
                        logger.info(f"🔧 Fixed truncated JSON start")
                    else:
                        first_brace = cleaned.find('{')
                        if first_brace > 0:
                            logger.info(f"⚠️ Trimmed {first_brace} chars before JSON")
                            cleaned = cleaned[first_brace:]
                        elif first_brace == -1:
                            raise Exception("No opening brace found in response")
                
                # Use JSONDecoder to find where first JSON ends
                decoder = json.JSONDecoder()
                try:
                    blueprint, end_index = decoder.raw_decode(cleaned)
                    
                    # Log if there's extra content after
                    remaining_chars = len(cleaned) - end_index
                    if remaining_chars > 5:
                        logger.warning(f"⚠️ Ignored {remaining_chars} chars after JSON")
                    
                    logger.info(f"✅ Extracted JSON object ({end_index} chars)")
                    
                    # Validate it's the right object structure
                    if "planTitle" not in blueprint or "phasesBlueprint" not in blueprint:
                        # This might be a phase object, not the plan. Search for planTitle
                        logger.warning(f"⚠️ First JSON object missing required fields. Keys: {list(blueprint.keys())}")
                        logger.warning("⚠️ Searching for planTitle in response...")
                        
                        # Look for "planTitle" in the original cleaned response
                        plan_title_pos = cleaned.find('"planTitle"')
                        if plan_title_pos > 0:
                            # Try parsing from that position
                            before_plan_title = cleaned[:plan_title_pos].rfind('{')
                            if before_plan_title >= 0:
                                logger.info(f"🔧 Found planTitle at position {plan_title_pos}, retrying parse from {before_plan_title}")
                                cleaned = cleaned[before_plan_title:]
                                blueprint, end_index = decoder.raw_decode(cleaned)
                        
                        # Final validation
                        if "planTitle" not in blueprint or "phasesBlueprint" not in blueprint:
                            raise Exception(f"Missing required fields in blueprint. Got keys: {list(blueprint.keys())}")
                    
                except json.JSONDecodeError as e:
                    logger.error(f"❌ JSON parsing failed: {e}")
                    logger.error(f"First 500 chars: {cleaned[:500]}")
                    raise Exception(f"Invalid JSON structure: {e}")
                
                # Validate blueprint
                if not blueprint.get("phasesBlueprint"):
                    raise Exception("Blueprint missing phasesBlueprint")
                
                if len(blueprint["phasesBlueprint"]) < 1:
                    raise Exception(f"Blueprint has {len(blueprint['phasesBlueprint'])} phases (need 1+)")
                
                logger.info(f"✅ Blueprint valid: {len(blueprint['phasesBlueprint'])} phases, {blueprint['recommendedDuration']} days")
                
                # VALIDATION: Check focus area percentage
                for i, phase_bp in enumerate(blueprint["phasesBlueprint"], 1):
                    exercise_pool = phase_bp.get("exercisePool", [])
                    logger.info(f"📋 Phase {i}: {len(exercise_pool)} exercises in pool")
                    
                    # Count focus exercises
                    focus_list = focus_ex.get(focus_area, "").lower().split(",")
                    focus_count = sum(1 for ex in exercise_pool if any(f in ex.lower() for f in focus_list))
                    focus_pct = (focus_count / len(exercise_pool) * 100) if exercise_pool else 0
                    
                    logger.info(f"🎯 Phase {i} focus area '{focus_area}': {focus_count}/{len(exercise_pool)} exercises ({focus_pct:.1f}%)")
                    
                    if focus_pct < 50:
                        logger.warning(f"⚠️ Phase {i} has LOW focus area coverage ({focus_pct:.1f}%). Continuing anyway...")
                    
                    # Count equipment exercises if applicable
                    if request.onboardingData.workoutType == "has_equipment":
                        equip_list = ["dumbbell", "banded", "kettlebell", "resistance"]
                        equip_count = sum(1 for ex in exercise_pool if any(eq in ex.lower() for eq in equip_list))
                        equip_pct = (equip_count / len(exercise_pool) * 100) if exercise_pool else 0
                        logger.info(f"🏋️ Phase {i} equipment exercises: {equip_count}/{len(exercise_pool)} ({equip_pct:.1f}%)")
                        
                        if equip_pct < 40:
                            logger.warning(f"⚠️ Phase {i} has LOW equipment usage ({equip_pct:.1f}%). Expected 40%+")
                    
                    # Validate no jumping if required
                    if request.onboardingData.workoutType == "no_jumping":
                        banned = ["jump", "jack", "hop", "plyo", "burpee"]
                        jumping_ex = [ex for ex in exercise_pool if any(b in ex.lower() for b in banned)]
                        if jumping_ex:
                            logger.error(f"❌ Phase {i} contains BANNED jumping exercises: {jumping_ex}")
                            raise Exception(f"Phase {i} violates NO JUMPING constraint: {jumping_ex}")
                        else:
                            logger.info(f"✅ Phase {i} equipment validation: {equip_count}/{len(exercise_pool)} ({equip_pct:.1f}%)")
                
                logger.info(f"🎯 Stage 2: Expanding to daily workouts with rotation")
                plan = self._expand_blueprint(blueprint, request.onboardingData, start_date, request.userId)
                
                logger.info(f"✅ Complete: {plan.totalDays} days, {len(plan.dailyWorkouts)} workouts, {len(plan.allExerciseIds)} unique exercises")
                
                return plan
                
            except Exception as e:
                logger.error(f"❌ Attempt {attempt + 1}/{max_retries} failed: {e}")
                if attempt == max_retries - 1:
                    raise Exception(f"Error generating plan after {max_retries} attempts: {e}")
                logger.info(f"🔄 Retrying... ({attempt + 2}/{max_retries})")
                continue

# Create singleton instance
workout_generator = WorkoutGeneratorService()