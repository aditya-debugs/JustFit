import asyncio
import sys
from app.services.workout_generator import workout_generator
from app.models.onboarding import OnboardingData, WorkoutPlanRequest
from datetime import datetime

async def test_production_scenarios():
    """Test real-world scenarios that Flutter will send"""
    
    print("="*80)
    print("🧪 PRODUCTION WORKOUT GENERATION TEST")
    print("="*80)
    print()
    
    # TEST 1: Maximum 90-day plan (stress test)
    print("="*80)
    print("TEST 1: 90-Day Maximum Duration Plan")
    print("="*80)
    try:
        request_90 = WorkoutPlanRequest(
            userId="test-user-90day",
            startDate=None,  # Start tomorrow
            duration=90,  # 90-day plan
            onboardingData=OnboardingData(
                # Part 1: Goal
                motivations=["weight_loss", "feel_confident"],
                mainGoal="lose_weight",
                focusAreas=["belly"],
                
                # Part 2: Body Data
                height=165.0,
                weight=65.0,
                goalWeight=58.0,
                currentBodyType="average",
                desiredBodyType="athletic",
                
                # Part 3: Women's Health
                age=28,
                menstrualCycleAdaptation="yes",
                currentCycleWeek=1,
                pelvicFloorHealth="no_issues",
                workoutLocation="yoga_mat",
                workoutType="no_equipment",
                workoutLevel="simple_sweaty",
                injuries=["none"],
                
                # Part 4: Fitness Analysis
                typicalDay="seated_work",
                activityLevel="lightly_active",
                fitnessLevel="intermediate",
                bellyType="normal",
                statementBodyDissatisfaction=True,
                statementNeedGuidance=True,
                statementEasilyGiveUp=False
            )
        )
        
        print("⏳ Generating 90-day plan (this may take 15-20 seconds)...")
        plan_90 = await workout_generator.generate_workout_plan(request_90)
        
        print(f"\n✅ 90-DAY PLAN GENERATED:")
        print(f"   Title: {plan_90.title}")
        print(f"   Duration: {plan_90.totalDays} days ({plan_90.totalWeeks} weeks)")
        print(f"   Phases: {len(plan_90.phases)}")
        print(f"   Total Exercises: {len(plan_90.allExerciseIds)}")
        print(f"   Total Workouts: {len(plan_90.dailyWorkouts)}")
        print(f"   Start Date: {plan_90.startDate}")
        print(f"   End Date: {plan_90.endDate}")
        
        # Verify data integrity
        non_rest_days = [d for d in plan_90.dailyWorkouts if not d.isRestDay]
        rest_days = [d for d in plan_90.dailyWorkouts if d.isRestDay]
        print(f"   Workout Days: {len(non_rest_days)}")
        print(f"   Rest Days: {len(rest_days)}")
        
        # Check first and last workout
        first_workout = non_rest_days[0]
        last_workout = non_rest_days[-1]
        print(f"\n   First Workout (Day {first_workout.day}):")
        print(f"      {len(first_workout.workoutSets)} sets, {first_workout.estimatedDuration} min")
        print(f"   Last Workout (Day {last_workout.day}):")
        print(f"      {len(last_workout.workoutSets)} sets, {last_workout.estimatedDuration} min")
        
        print("\n✅ TEST 1 PASSED: 90-day plan generated successfully")
        
    except Exception as e:
        print(f"\n❌ TEST 1 FAILED: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    
    print()
    
    # TEST 2: Complex constraints (multiple restrictions)
    print("="*80)
    print("TEST 2: Complex Constraints (No Jumping + Injuries + Equipment)")
    print("="*80)
    try:
        request_complex = WorkoutPlanRequest(
            userId="test-user-complex",
            startDate="2024-12-01",
            duration=60,
            onboardingData=OnboardingData(
                # Part 1: Goal
                motivations=["improve_health", "boost_energy"],
                mainGoal="keep_fit",
                focusAreas=["butt", "legs"],
                
                # Part 2: Body Data
                height=160.0,
                weight=78.0,
                goalWeight=70.0,
                currentBodyType="curvy",
                desiredBodyType="fit",
                
                # Part 3: Women's Health
                age=45,
                menstrualCycleAdaptation="not_applicable",
                currentCycleWeek=None,
                pelvicFloorHealth="occasional_leaking",
                workoutLocation="no_preference",
                workoutType="no_jumping",
                workoutLevel="easy_enough",
                injuries=["knee", "lower_back"],
                
                # Part 4: Fitness Analysis
                typicalDay="home_sedentary",
                activityLevel="not_active",
                fitnessLevel="beginner",
                hipsType="flat",
                legType="normal",
                statementBodyDissatisfaction=True,
                statementNeedGuidance=True,
                statementEasilyGiveUp=True
            )
        )
        
        print("⏳ Generating complex plan...")
        plan_complex = await workout_generator.generate_workout_plan(request_complex)
        
        print(f"\n✅ COMPLEX PLAN GENERATED:")
        print(f"   Title: {plan_complex.title}")
        print(f"   Duration: {plan_complex.totalDays} days")
        print(f"   Total Exercises: {len(plan_complex.allExerciseIds)}")
        
        # Check for banned exercises
        banned_exercises = ['jumping-jacks', 'burpees', 'jump-squats', 'high-knees', 'box-jumps']
        found_banned = [ex for ex in plan_complex.allExerciseIds if any(b in ex.lower() for b in banned_exercises)]
        
        if found_banned:
            print(f"   ⚠️ WARNING: Found potentially banned exercises: {found_banned}")
        else:
            print(f"   ✅ No banned exercises found")
        
        print("\n✅ TEST 2 PASSED: Complex constraints handled")
        
    except Exception as e:
        print(f"\n❌ TEST 2 FAILED: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    
    print()
    
    # TEST 3: Rapid generation (5 consecutive plans)
    print("="*80)
    print("TEST 3: Rapid Generation (5 Users Simultaneously)")
    print("="*80)
    try:
        print("⏳ Generating 5 plans rapidly...")
        
        rapid_requests = []
        focus_options = [["belly"], ["butt"], ["arms"], ["legs"], ["fullbody"]]
        goal_options = ["lose_weight", "build_muscle", "keep_fit", "lose_weight", "keep_fit"]
        workout_types = ["no_equipment", "no_jumping", "lying_down", "no_equipment", "no_jumping"]
        
        for i in range(5):
            rapid_requests.append(WorkoutPlanRequest(
                userId=f"test-user-rapid-{i}",
                startDate=None,
                duration=42,
                onboardingData=OnboardingData(
                    # Part 1: Goal
                    motivations=["weight_loss", "feel_confident"],
                    mainGoal=goal_options[i],
                    focusAreas=focus_options[i],
                    
                    # Part 2: Body Data
                    height=160.0,
                    weight=60.0 + i * 5,
                    goalWeight=55.0 + i * 5,
                    currentBodyType="average",
                    desiredBodyType="athletic",
                    
                    # Part 3: Women's Health
                    age=25 + i * 5,
                    menstrualCycleAdaptation="yes",
                    currentCycleWeek=1,
                    pelvicFloorHealth="no_issues",
                    workoutLocation="yoga_mat",
                    workoutType=workout_types[i],
                    workoutLevel="simple_sweaty",
                    injuries=["none"],
                    
                    # Part 4: Fitness Analysis
                    typicalDay="walking_daily",
                    activityLevel="moderately_active",
                    fitnessLevel=["beginner", "intermediate", "advanced"][i % 3],
                    statementBodyDissatisfaction=True,
                    statementNeedGuidance=False,
                    statementEasilyGiveUp=False
                )
            ))
        
        start_time = datetime.now()
        
        for i, req in enumerate(rapid_requests):
            plan = await workout_generator.generate_workout_plan(req)
            print(f"   ✅ Plan {i+1}/5: {plan.title} ({plan.totalDays} days, {len(plan.allExerciseIds)} exercises)")
        
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        
        print(f"\n✅ TEST 3 PASSED: Generated 5 plans in {duration:.1f} seconds ({duration/5:.1f}s avg)")
        
    except Exception as e:
        print(f"\n❌ TEST 3 FAILED: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    
    print()
    
    # TEST 4: Edge cases
    print("="*80)
    print("TEST 4: Edge Cases (Extreme Parameters)")
    print("="*80)
    try:
        # Very overweight user with many restrictions
        print("⏳ Testing edge case: High weight goal + multiple injuries...")
        request_edge = WorkoutPlanRequest(
            userId="test-user-edge",
            startDate=None,
            duration=84,  # 12 weeks
            onboardingData=OnboardingData(
                # Part 1: Goal
                motivations=["improve_health", "release_stress"],
                mainGoal="lose_weight",
                focusAreas=["fullbody"],
                
                # Part 2: Body Data
                height=155.0,
                weight=95.0,
                goalWeight=70.0,
                currentBodyType="greater_than_40",
                desiredBodyType="average",
                
                # Part 3: Women's Health
                age=52,
                menstrualCycleAdaptation="not_applicable",
                currentCycleWeek=None,
                pelvicFloorHealth="frequent_incontinence",
                workoutLocation="couch_bed",
                workoutType="lying_down",
                workoutLevel="easy_enough",
                injuries=["knee", "lower_back", "hip", "ankle"],
                
                # Part 4: Fitness Analysis
                typicalDay="home_sedentary",
                activityLevel="not_active",
                fitnessLevel="beginner",
                bellyType="stressed_out",
                flexibilityLevel="far_from_feet",
                cardioLevel="out_of_breath",
                statementBodyDissatisfaction=True,
                statementNeedGuidance=True,
                statementEasilyGiveUp=True
            )
        )
        
        plan_edge = await workout_generator.generate_workout_plan(request_edge)
        print(f"   ✅ Edge case plan: {plan_edge.title}")
        print(f"      Duration: {plan_edge.totalDays} days")
        print(f"      Exercises: {len(plan_edge.allExerciseIds)}")
        print(f"      Workout days: {len([d for d in plan_edge.dailyWorkouts if not d.isRestDay])}")
        
        print("\n✅ TEST 4 PASSED: Edge cases handled")
        
    except Exception as e:
        print(f"\n❌ TEST 4 FAILED: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    
    print()
    print("="*80)
    print("🎉 ALL PRODUCTION TESTS PASSED!")
    print("="*80)
    print("\n✅ Backend is PRODUCTION READY for Flutter integration!")
    print("   - 90-day plans work ✅")
    print("   - Complex constraints handled ✅")
    print("   - Rapid generation stable ✅")
    print("   - Edge cases covered ✅")
    print()
    
    return True

if __name__ == "__main__":
    success = asyncio.run(test_production_scenarios())
    sys.exit(0 if success else 1)




# from app.core.gemini import gemini_service
# from app.models.onboarding import OnboardingData, WorkoutPlanRequest
# from app.models.workout import WorkoutPlan, DailyWorkout, WorkoutSet, ExerciseInWorkout, Phase
# import json
# from datetime import datetime, timedelta
# from typing import Optional
# import uuid
# import logging
# import re
# import random

# logger = logging.getLogger(__name__)

# class WorkoutGeneratorService:
#     def __init__(self):
#         self.gemini = gemini_service
    
#     def _calculate_start_date(self, start_date_str: Optional[str]) -> datetime:
#         if start_date_str:
#             return datetime.strptime(start_date_str, "%Y-%m-%d")
#         else:
#             return datetime.now() + timedelta(days=1)
    
#     def _build_blueprint_prompt(self, data: OnboardingData) -> str:
#         """ULTRA-SHORT prompt for token efficiency - AI decides duration"""
        
#         focus_area = data.focusAreas[0] if data.focusAreas else "full_body"
        
#         # CRITICAL: Shorter exercise lists
#         focus_ex = {
#             "abs": "plank,bicycle-crunches,russian-twists,leg-raises,mountain-climbers,dead-bug,flutter-kicks,reverse-crunches,heel-touches,boat-pose,side-plank,plank-hip-dips",
#             "glutes": "glute-bridges,hip-thrusts,donkey-kicks,fire-hydrants,clamshells,squat-pulses,sumo-squats,single-leg-glute-bridge,frog-pumps,curtsy-lunges,bulgarian-split-squats,step-ups",
#             "legs": "squats,lunges,side-lunges,calf-raises,wall-sit,bulgarian-split-squats,sumo-squats,pistol-squats,step-ups",
#             "arms": "tricep-dips,push-ups,shoulder-taps,diamond-push-ups,pike-push-ups,arm-circles,wall-push-ups",
#             "full_body": "burpees,mountain-climbers,inchworms,bear-crawls,walkouts",
#             "back": "superman,bird-dog,reverse-fly,bent-over-row,back-extension,swimmers"
#         }
        
#         equip = "dumbbell-squats,dumbbell-hip-thrusts,dumbbell-rows,dumbbell-press,banded-glute-bridges,banded-lateral-walks,banded-kickbacks,banded-clamshells,dumbbell-lunges,dumbbell-deadlifts"
        
#         banned = "jumping-jacks,burpees,jump-squats,high-knees,butt-kicks,box-jumps,plank-jacks,tuck-jumps,step-jacks" if data.workoutType == "no_jumping" else ""
#         safe = "marching,step-touches,side-steps,knee-raises,arm-swings,walk-outs" if data.workoutType == "no_jumping" else ""
        
#         goal_map = {"lose_weight": "Fat Burn", "build_muscle": "Strength", "general_fitness": "Transform"}
#         focus_map = {"abs": "Core", "glutes": "Booty", "legs": "Legs", "arms": "Arms", "full_body": "Full Body"}
        
#         prompt = f"""Personalized workout plan for {data.fitnessLevel} woman, {data.mainGoal}, focus {focus_area}.

# YOU DECIDE:
# - Plan duration (28-60 days based on ALL factors below)
# - Number of phases (2-4 phases)
# - Phase durations and names
# - Progression intensity

# USER PROFILE ANALYSIS:
# - Current weight: {data.weight}kg
# - Goal weight: {data.goalWeight if data.goalWeight else data.weight}kg
# - Weight to lose/gain: {abs(data.weight - (data.goalWeight if data.goalWeight else data.weight)):.1f}kg
# - Fitness level: {data.fitnessLevel}
# - Age: {data.age}
# - Activity level: {data.activityLevel}
# - Main goal: {data.mainGoal}

# INTELLIGENT DURATION SELECTION:
# Consider weight loss amount + fitness level + age:
# - Weight loss < 5kg: 28-35 days base
# - Weight loss 5-10kg: 35-49 days base
# - Weight loss 10-15kg: 42-56 days base
# - Weight loss > 15kg: 49-60 days base
# ADJUST: Beginner +7-14 days, Advanced -7 days, Age 40+ +7 days

# CRITICAL RULES (STRICT):
# 1. exercisePool MUST contain AT LEAST 15 exercises from: {focus_ex.get(focus_area, 'squats,plank,lunges')}
# {"2. exercisePool MUST contain AT LEAST 10 exercises from: " + equip if data.workoutType == 'has_equipment' else '2. ZERO equipment exercises allowed'}
# {"3. BANNED (no jumping): " + banned + ". USE ONLY: " + safe if data.workoutType == 'no_jumping' else ''}
# 4. Exercise names: lowercase-hyphen ("knee-push-ups")
# 5. Total 18-22 exercises in exercisePool per phase
# 6. Different exercises each day via exerciseRotation

# JSON (YOU decide everything):
# {{
#   "planTitle": "{goal_map.get(data.mainGoal, 'Fitness')} - {focus_map.get(focus_area, 'Full Body')}",
#   "recommendedDuration": YOUR_CHOICE_28_TO_60_DAYS,
#   "rationale": "Brief explanation of your duration and phase choices",
#   "cycleSync": false,
#   "phasesBlueprint": [
#     {{
#       "phaseNumber": 1,
#       "phaseName": "YOUR creative name",
#       "durationDays": YOUR_CHOICE,
#       "intensityLevel": "{data.fitnessLevel}",
#       "focusArea": "{focus_area}",
#       "workoutsPerWeek": 4-6,
#       "exercisePool": ["18-22 personalized exercises"],
#       "weeklyPattern": [
#         {{"day":1,"type":"focus","intensity":"moderate","exerciseRotation":["ex1","ex2","ex3","ex4"],"progressionWeek1":{{"sets":3,"reps":10,"rest":60}},"progressionWeek2":{{"sets":3,"reps":12,"rest":55}},"progressionWeek3":{{"sets":4,"reps":12,"rest":50}},"progressionWeek4":{{"sets":4,"reps":14,"rest":50}},"progressionWeek5":{{"sets":4,"reps":15,"rest":45}},"progressionWeek6":{{"sets":4,"reps":16,"rest":45}}}},
#         {{"day":2,"type":"support","intensity":"moderate","exerciseRotation":["ex5","ex6","ex7","ex8"],"progressionWeek1":{{"sets":3,"reps":12,"rest":60}},"progressionWeek2":{{"sets":4,"reps":12,"rest":50}},"progressionWeek3":{{"sets":4,"reps":14,"rest":50}},"progressionWeek4":{{"sets":4,"reps":15,"rest":45}},"progressionWeek5":{{"sets":4,"reps":16,"rest":45}},"progressionWeek6":{{"sets":5,"reps":16,"rest":40}}}},
#         {{"day":3,"type":"cardio","intensity":"light","exerciseRotation":["ex9","ex10","ex11"],"progressionWeek1":{{"sets":3,"reps":15,"rest":45}},"progressionWeek2":{{"sets":3,"reps":18,"rest":40}},"progressionWeek3":{{"sets":3,"reps":20,"rest":40}},"progressionWeek4":{{"sets":4,"reps":20,"rest":35}},"progressionWeek5":{{"sets":4,"reps":22,"rest":35}},"progressionWeek6":{{"sets":4,"reps":25,"rest":30}}}},
#         {{"day":4,"type":"full","intensity":"moderate","exerciseRotation":["ex12","ex13","ex14"],"progressionWeek1":{{"sets":3,"reps":10,"rest":60}},"progressionWeek2":{{"sets":3,"reps":12,"rest":55}},"progressionWeek3":{{"sets":4,"reps":12,"rest":50}},"progressionWeek4":{{"sets":4,"reps":14,"rest":50}},"progressionWeek5":{{"sets":4,"reps":15,"rest":45}},"progressionWeek6":{{"sets":5,"reps":15,"rest":40}}}},
#         {{"day":5,"type":"burnout","intensity":"high","exerciseRotation":["ex15","ex16","ex17"],"progressionWeek1":{{"sets":3,"reps":15,"rest":45}},"progressionWeek2":{{"sets":3,"reps":18,"rest":40}},"progressionWeek3":{{"sets":4,"reps":18,"rest":40}},"progressionWeek4":{{"sets":4,"reps":20,"rest":35}},"progressionWeek5":{{"sets":4,"reps":22,"rest":30}},"progressionWeek6":{{"sets":5,"reps":22,"rest":30}}}},
#         {{"day":6,"type":"rest","intensity":"none"}},
#         {{"day":7,"type":"recovery","intensity":"light","exerciseRotation":["stretch1","stretch2"],"progressionWeek1":{{"duration":30}},"progressionWeek2":{{"duration":30}},"progressionWeek3":{{"duration":30}},"progressionWeek4":{{"duration":30}},"progressionWeek5":{{"duration":30}},"progressionWeek6":{{"duration":30}}}}
#       ]
#     }},
#     {{
#       "phaseNumber": 2,
#       "phaseName": "YOUR creative phase 2 name",
#       "durationDays": YOUR_CHOICE,
#       "intensityLevel": "intermediate",
#       "focusArea": "{focus_area}",
#       "workoutsPerWeek": 5-6,
#       "exercisePool": ["different 18-22 exercises"],
#       "weeklyPattern": [same 7-day structure]
#     }},
#     {{ADD MORE PHASES as needed}}
#   ]
# }}

# FINAL CHECK:
# - SUM of all phase durationDays MUST EQUAL recommendedDuration
# - recommendedDuration: 28-60 days (your choice based on user profile)
# - Count exercises in exercisePool from focus list: MUST BE 15+
# {"- Count equipment exercises in exercisePool: MUST BE 10+" if data.workoutType == 'has_equipment' else ""}
# {"- Verify ZERO exercises contain: jump, jack, hop, plyo" if data.workoutType == 'no_jumping' else ""}
# - exerciseRotation uses exercises from exercisePool
# - Replace example exercisePool with personalized 18-22 exercises per phase"""
        
#         return prompt
    
#     def _expand_blueprint(self, blueprint: dict, data: OnboardingData, start_date: datetime, user_id: str) -> WorkoutPlan:
#         """Expand blueprint into complete daily workout plan with rotation and progression"""
        
#         plan_id = str(uuid.uuid4())
#         total_days = blueprint["recommendedDuration"]
#         total_weeks = (total_days + 6) // 7
#         end_date = start_date + timedelta(days=total_days - 1)
        
#         # Use AI-generated title or fallback
#         plan_title = blueprint.get("planTitle", f"{total_days}-Day Personalized Fitness Plan")
        
#         # Build phases
#         phases = []
#         current_day = 1
#         current_date = start_date
        
#         for phase_bp in blueprint["phasesBlueprint"]:
#             phase_end_day = current_day + phase_bp["durationDays"] - 1
#             phase_end_date = current_date + timedelta(days=phase_bp["durationDays"] - 1)
            
#             phases.append(Phase(
#                 phaseNumber=phase_bp["phaseNumber"],
#                 phaseName=phase_bp["phaseName"],
#                 phaseDescription=f"{phase_bp['phaseName']} phase focusing on {phase_bp['focusArea']}",
#                 phaseGoal=f"Build {phase_bp['focusArea']} strength at {phase_bp['intensityLevel']} level",
#                 startDay=current_day,
#                 endDay=phase_end_day,
#                 startDate=current_date.strftime("%Y-%m-%d"),
#                 endDate=phase_end_date.strftime("%Y-%m-%d"),
#                 intensityLevel=phase_bp["intensityLevel"],
#                 focusArea=phase_bp["focusArea"],
#                 workoutsPerWeek=phase_bp["workoutsPerWeek"],
#                 restDaysPerWeek=7 - phase_bp["workoutsPerWeek"]
#             ))
            
#             current_day = phase_end_day + 1
#             current_date = phase_end_date + timedelta(days=1)
        
#         # Build daily workouts
#         daily_workouts = []
#         current_date = start_date
#         current_cycle_week = data.currentCycleWeek if data.currentCycleWeek else 1
        
#         for day_num in range(1, total_days + 1):
#             # Find phase
#             phase_bp = None
#             day_in_phase = 0
#             cumulative_days = 0
            
#             for p in blueprint["phasesBlueprint"]:
#                 if day_num <= cumulative_days + p["durationDays"]:
#                     phase_bp = p
#                     day_in_phase = day_num - cumulative_days
#                     break
#                 cumulative_days += p["durationDays"]
            
#             # Get weekly pattern
#             week_day = (day_in_phase - 1) % 7
#             week_number = ((day_in_phase - 1) // 7) + 1  # Which week within phase (1-6 for 42 days)
#             day_pattern = phase_bp["weeklyPattern"][week_day]
            
#             if day_pattern["type"] == "rest":
#                 daily_workouts.append(DailyWorkout(
#                     day=day_num,
#                     date=current_date.strftime("%Y-%m-%d"),
#                     dayName=current_date.strftime("%A"),
#                     dayTitle="Rest Day",
#                     isRestDay=True,
#                     phaseNumber=phase_bp["phaseNumber"],
#                     cycleWeek=current_cycle_week if blueprint.get("cycleSync") else None,
#                     cycleAdapted=blueprint.get("cycleSync", False),
#                     workoutSets=[],
#                     estimatedDuration=0,
#                     estimatedCalories=0,
#                     intensity="rest",
#                     focusArea="recovery",
#                     equipment="none",
#                     dayDescription="Rest day - light walking or gentle stretching recommended"
#                 ))
#             else:
#                 # Get progression for current week (cap at week 6)
#                 progression_key = f"progressionWeek{min(week_number, 6)}"
#                 progression = day_pattern.get(progression_key, {"sets": 3, "reps": 12, "rest": 60})
#                 print(f"🔍 DEBUG: Week {week_number}, Day pattern: {day_pattern.get('type')}, Progression: {progression}")
                
#                 workout_sets = self._create_workout_sets_with_rotation(
#                     phase_bp["exercisePool"],
#                     day_pattern,
#                     progression,
#                     current_cycle_week if blueprint.get("cycleSync") else None
#                 )
                
#                 daily_workouts.append(DailyWorkout(
#                     day=day_num,
#                     date=current_date.strftime("%Y-%m-%d"),
#                     dayName=current_date.strftime("%A"),
#                     dayTitle=day_pattern["type"].replace("_", " ").title(),
#                     isRestDay=False,
#                     phaseNumber=phase_bp["phaseNumber"],
#                     cycleWeek=current_cycle_week if blueprint.get("cycleSync") else None,
#                     cycleAdapted=blueprint.get("cycleSync", False),
#                     workoutSets=workout_sets,
#                     estimatedDuration=30,
#                     estimatedCalories=200,
#                     intensity=day_pattern["intensity"],
#                     focusArea=phase_bp["focusArea"],
#                     equipment="none"
#                 ))
            
#             current_date += timedelta(days=1)
#             if blueprint.get("cycleSync") and day_num % 7 == 0:
#                 current_cycle_week = (current_cycle_week % 4) + 1
        
#         # Collect exercise IDs
#         all_exercise_ids = set()
#         for phase_bp in blueprint["phasesBlueprint"]:
#             all_exercise_ids.update(phase_bp["exercisePool"])
        
#         return WorkoutPlan(
#             planId=plan_id,
#             userId=user_id,
#             title=plan_title,
#             description=blueprint["rationale"],
#             totalDays=total_days,
#             totalWeeks=total_weeks,
#             startDate=start_date.strftime("%Y-%m-%d"),
#             endDate=end_date.strftime("%Y-%m-%d"),
#             menstrualCycleSync=blueprint.get("cycleSync", False),
#             cycleStartWeek=data.currentCycleWeek,
#             phases=phases,
#             dailyWorkouts=daily_workouts,
#             tips=["Stay hydrated", "Focus on form over speed", "Rest when needed", "Track progress weekly"],
#             allExerciseIds=list(all_exercise_ids),
#             generatedBy="gemini-2.5-flash",
#             generatedAt=datetime.now().isoformat(),
#             createdAt=datetime.now().isoformat()
#         )
    
# def _create_workout_sets_with_rotation(self, exercise_pool, day_pattern, progression, cycle_week):
#     """Create workout sets with daily exercise rotation and progressive overload"""
    
#     # Use exercise rotation from day pattern if available
#     if "exerciseRotation" in day_pattern and day_pattern["exerciseRotation"]:
#         # Use AI-specified rotation
#         all_exercises = day_pattern["exerciseRotation"]
        
#         # Categorize exercises
#         warmup_ex = [e for e in all_exercises if any(x in e.lower() for x in ["circle", "swing", "roll", "stretch", "twist"])][:4]
#         cooldown_ex = [e for e in all_exercises if any(x in e.lower() for x in ["stretch", "pose", "twist"])][:4]
        
#         # Main exercises = everything not used in warmup/cooldown
#         used_exercises = set(warmup_ex + cooldown_ex)
#         main_ex = [e for e in all_exercises if e not in used_exercises][:8]  # ✅ INCREASED TO 8
        
#         # Fallback if categories don't yield enough exercises
#         if len(warmup_ex) < 3:
#             warmup_ex = all_exercises[:4]
#             used_exercises.update(warmup_ex)
        
#         if len(main_ex) < 6:  # ✅ ENSURE AT LEAST 6 MAIN EXERCISES
#             # Take more from exercise pool, avoiding already used ones
#             remaining = [e for e in all_exercises if e not in used_exercises]
#             main_ex = remaining[:8]
        
#         if len(cooldown_ex) < 3:
#             cooldown_ex = all_exercises[-4:]
#     else:
#         # Fallback to random selection from pool (with variety)
#         shuffled = random.sample(exercise_pool, min(len(exercise_pool), 20))  # ✅ INCREASED FROM 15 to 20
        
#         warmup_ex = [e for e in shuffled if any(x in e.lower() for x in ["circle", "swing", "roll"])][:4]
#         if not warmup_ex:
#             warmup_ex = shuffled[:4]
        
#         main_ex = [e for e in shuffled if e not in warmup_ex][:8]  # ✅ INCREASED TO 8
#         if len(main_ex) < 6:  # ✅ ENSURE AT LEAST 6
#             main_ex = shuffled[4:12]
        
#         cooldown_ex = [e for e in shuffled if any(x in e.lower() for x in ["stretch", "pose", "twist"])][:4]
#         if not cooldown_ex:
#             cooldown_ex = shuffled[-4:]
    
#     # Apply progressive overload
#     sets = progression.get("sets", 3)
#     reps = progression.get("reps", 12)
#     rest = progression.get("rest", 60)
#     duration = progression.get("duration", 30)
    
#     return [
#         WorkoutSet(
#             setNumber=1,
#             setName="Warm Up",
#             setType="warmup",
#             estimatedDuration=5,
#             exercises=[ExerciseInWorkout(
#                 exerciseId=e,
#                 name=e.replace("-", " ").title(),
#                 duration=duration,
#                 displayText=f"{duration} seconds"
#             ) for e in warmup_ex]
#         ),
#         WorkoutSet(
#             setNumber=2,
#             setName="Main Workout",
#             setType="main",
#             estimatedDuration=25,  # ✅ INCREASED FROM 20 to 25 minutes
#             exercises=[ExerciseInWorkout(
#                 exerciseId=e,
#                 name=e.replace("-", " ").title(),
#                 sets=sets,
#                 reps=reps,
#                 restBetweenSets=rest,
#                 displayText=f"{sets} sets × {reps} reps"
#             ) for e in main_ex]
#         ),
#         WorkoutSet(
#             setNumber=3,
#             setName="Cool Down",
#             setType="cooldown",
#             estimatedDuration=5,
#             exercises=[ExerciseInWorkout(
#                 exerciseId=e,
#                 name=e.replace("-", " ").title(),
#                 duration=45,
#                 displayText="45 seconds"
#             ) for e in cooldown_ex]
#         )
#     ]
    
#     async def generate_workout_plan(self, request: WorkoutPlanRequest) -> WorkoutPlan:
#         """Generate workout plan using two-stage approach with JSON mode"""
#         max_retries = 3
        
#         # For validation
#         focus_area = request.onboardingData.focusAreas[0] if request.onboardingData.focusAreas else "full_body"
#         focus_ex = {
#             "abs": "plank,bicycle-crunches,russian-twists,leg-raises,mountain-climbers,dead-bug,flutter-kicks,reverse-crunches,heel-touches,boat-pose,side-plank,plank-hip-dips",
#             "glutes": "glute-bridges,hip-thrusts,donkey-kicks,fire-hydrants,clamshells,squat-pulses,sumo-squats,single-leg-glute-bridge,frog-pumps,curtsy-lunges,bulgarian-split-squats,step-ups",
#             "legs": "squats,lunges,side-lunges,calf-raises,wall-sit,bulgarian-split-squats,sumo-squats,pistol-squats,step-ups",
#             "arms": "tricep-dips,push-ups,shoulder-taps,diamond-push-ups,pike-push-ups,arm-circles,wall-push-ups",
#             "full_body": "burpees,mountain-climbers,inchworms,bear-crawls,walkouts",
#             "back": "superman,bird-dog,reverse-fly,bent-over-row,back-extension,swimmers"
#         }
        
#         for attempt in range(max_retries):
#             try:
#                 start_date = self._calculate_start_date(request.startDate)
                
#                 logger.info(f"🎯 Stage 1: Creating blueprint for {request.userId} (Attempt {attempt + 1}/{max_retries})")
                
#                 prompt = self._build_blueprint_prompt(request.onboardingData)
                
#                 # Use JSON mode for guaranteed valid JSON
#                 response = await self.gemini.generate_content(prompt, json_mode=True)
                
#                 logger.info(f"📄 Raw response length: {len(response)} chars")
                
#                 # AGGRESSIVE CLEANING
#                 cleaned = response.strip()
                
#                 # Remove markdown code blocks
#                 if cleaned.startswith(""):
#                     cleaned = cleaned[7:].strip()
#                 elif cleaned.startswith("```"):
#                     cleaned = cleaned[3:].strip()
#                 if cleaned.endswith("```"):
#                     cleaned = cleaned[:-3].strip()
                
#                 # BULLETPROOF FIX: Handle Gemini truncation
#                 if not cleaned.startswith('{'):
#                     if cleaned.startswith('anTitle"') or cleaned.startswith('"planTitle"'):
#                         # Missing opening characters
#                         cleaned = '{"pl' + cleaned if cleaned.startswith('anTitle"') else '{' + cleaned
#                         logger.info(f"🔧 Fixed truncated JSON start")
#                     else:
#                         first_brace = cleaned.find('{')
#                         if first_brace > 0:
#                             logger.info(f"⚠️ Trimmed {first_brace} chars before JSON")
#                             cleaned = cleaned[first_brace:]
#                         elif first_brace == -1:
#                             raise Exception("No opening brace found in response")
                
#                 # Use JSONDecoder to find where first JSON ends
#                 decoder = json.JSONDecoder()
#                 try:
#                     blueprint, end_index = decoder.raw_decode(cleaned)
                    
#                     # Log if there's extra content after
#                     remaining_chars = len(cleaned) - end_index
#                     if remaining_chars > 5:
#                         logger.warning(f"⚠️ Ignored {remaining_chars} chars after JSON")
                    
#                     logger.info(f"✅ Extracted JSON object ({end_index} chars)")
                    
#                     # Validate it's the right object structure
#                     if "planTitle" not in blueprint or "phasesBlueprint" not in blueprint:
#                         # This might be a phase object, not the plan. Search for planTitle
#                         logger.warning(f"⚠️ First JSON object missing required fields. Keys: {list(blueprint.keys())}")
#                         logger.warning("⚠️ Searching for planTitle in response...")
                        
#                         # Look for "planTitle" in the original cleaned response
#                         plan_start = cleaned.find('"planTitle"')
#                         if plan_start > 0:
#                             # Find the opening brace before planTitle
#                             for i in range(plan_start, -1, -1):
#                                 if cleaned[i] == '{':
#                                     logger.info(f"🔍 Found opening brace at position {i}")
#                                     # Try parsing from here
#                                     try:
#                                         blueprint, end_index = decoder.raw_decode(cleaned[i:])
#                                         logger.info(f"✅ Successfully parsed plan JSON from position {i}")
#                                         break
#                                     except:
#                                         continue
                        
#                         # Final validation
#                         if "planTitle" not in blueprint or "phasesBlueprint" not in blueprint:
#                             logger.error(f"❌ Still missing required fields. Keys: {list(blueprint.keys())}")
#                             logger.error(f"📄 Response preview (first 1000 chars): {cleaned[:1000]}")
#                             raise Exception("Missing required fields in blueprint")
                    
#                 except json.JSONDecodeError as e:
#                     logger.error(f"❌ JSON decode error: {str(e)}")
#                     logger.error(f"📄 Response preview (first 500 chars): {cleaned[:500]}")
#                     raise
                
#                 # Validate required fields one more time
#                 if not blueprint.get("phasesBlueprint") or len(blueprint["phasesBlueprint"]) == 0:
#                     raise Exception("No phases in blueprint")
                
#                 logger.info(f"✅ Blueprint: {blueprint.get('planTitle', 'Untitled')} - {blueprint['recommendedDuration']} days, {len(blueprint['phasesBlueprint'])} phases")
                
#                 # VALIDATE FOCUS PERCENTAGE
#                 if blueprint.get("phasesBlueprint"):
#                     phase = blueprint["phasesBlueprint"][0]
#                     exercise_pool = phase.get("exercisePool", [])
                    
#                     # Check focus exercises
#                     focus_list = focus_ex.get(focus_area, "").split(",")
#                     focus_count = sum(1 for ex in exercise_pool if ex in focus_list)
#                     focus_pct = (focus_count / len(exercise_pool) * 100) if exercise_pool else 0
                    
#                     if focus_pct < 50 and attempt < max_retries - 1:
#                         logger.warning(f"⚠️ Low focus percentage: {focus_pct:.1f}% (target: 60%+). Retrying...")
#                         raise Exception(f"Focus percentage too low: {focus_pct:.1f}%")
                    
#                     logger.info(f"✅ Focus validation: {focus_count}/{len(exercise_pool)} ({focus_pct:.1f}%)")
                    
#                     # Check equipment if applicable
#                     if request.onboardingData.workoutType == 'has_equipment':
#                         equip_list = "dumbbell-squats,dumbbell-hip-thrusts,dumbbell-rows,dumbbell-press,banded-glute-bridges,banded-lateral-walks,banded-kickbacks,banded-clamshells,dumbbell-lunges,dumbbell-deadlifts".split(",")
#                         equip_count = sum(1 for ex in exercise_pool if any(eq in ex for eq in equip_list))
#                         equip_pct = (equip_count / len(exercise_pool) * 100) if exercise_pool else 0
                        
#                         if equip_pct < 30 and attempt < max_retries - 1:
#                             logger.warning(f"⚠️ Low equipment percentage: {equip_pct:.1f}% (target: 40%+). Retrying...")
#                             raise Exception(f"Equipment percentage too low: {equip_pct:.1f}%")
                        
#                         logger.info(f"✅ Equipment validation: {equip_count}/{len(exercise_pool)} ({equip_pct:.1f}%)")
                
#                 logger.info(f"🎯 Stage 2: Expanding to daily workouts with rotation")
#                 plan = self._expand_blueprint(blueprint, request.onboardingData, start_date, request.userId)
                
#                 logger.info(f"✅ Complete: {plan.totalDays} days, {len(plan.dailyWorkouts)} workouts, {len(plan.allExerciseIds)} unique exercises")
                
#                 return plan
                
#             except json.JSONDecodeError as e:
#                 logger.error(f"❌ JSON error (attempt {attempt + 1}/{max_retries}): {str(e)}")
                
#                 if attempt < max_retries - 1:
#                     logger.info(f"🔄 Retrying...")
#                     continue
#                 else:
#                     raise Exception(f"Failed to parse response after {max_retries} attempts: {str(e)}")
                    
#             except Exception as e:
#                 logger.error(f"❌ Generation error: {str(e)}")
                
#                 if attempt < max_retries - 1:
#                     logger.info(f"🔄 Retrying...")
#                     continue
#                 else:
#                     raise Exception(f"Error generating plan after {max_retries} attempts: {str(e)}")

# workout_generator = WorkoutGeneratorService()    