import firebase_admin
from firebase_admin import credentials, firestore
import sys
import asyncio
import traceback

# Initialize Firebase (if not already initialized)
try:
    firebase_admin.get_app()
except ValueError:
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)

# Import after Firebase init
from app.services.workout_generator import workout_generator
from app.models.onboarding import WorkoutPlanRequest, OnboardingData

async def test_workout_generation():
    """Test workout plan generation with menstrual cycle sync"""
    
    # ========================================================================
    # TEST CASE 1: No Cycle Sync (Control)
    # ========================================================================
    print("\n" + "=" * 80)
    print("TEST CASE 1: Flat Belly Focus + No Cycle Sync (Control)")
    print("=" * 80)
    
    request1 = WorkoutPlanRequest(
        userId="test-user-no-sync",
        startDate="2025-11-27",
        onboardingData=OnboardingData(
            motivations=["feel_confident", "lose_weight"],
            mainGoal="lose_weight",
            focusAreas=["belly"],
            height=165,
            weight=65,
            goalWeight=58,
            currentBodyType="average",
            desiredBodyType="toned",
            age=28,
            menstrualCycleAdaptation="no",
            currentCycleWeek=None,
            pelvicFloorHealth="no_issues",
            workoutLocation="yoga_mat",
            workoutType="no_equipment",
            workoutLevel="simple_sweaty",
            injuries=["none"],
            typicalDay="seated_work",
            activityLevel="lightly_active",
            fitnessLevel="beginner",
            bellyType="normal",
            hipsType="normal",
            legType="normal",
            flexibilityLevel="close_to_feet",
            cardioLevel="somewhat_tired",
            statementBodyDissatisfaction=True,
            statementNeedGuidance=True,
            statementEasilyGiveUp=False,
        )
    )
    
    try:
        print("\n🚀 Generating workout plan (NO cycle sync)...")
        plan1 = await workout_generator.generate_workout_plan(request1)
        
        print(f"\n✅ PLAN GENERATED!")
        print(f"   Title: {plan1.title}")
        print(f"   Duration: {plan1.totalDays} days")
        
        print(f"\n📊 INTENSITY CHECK (First 7 days):")
        for day in plan1.dailyWorkouts[:7]:
            if day.isRestDay:
                print(f"   Day {day.day}: REST DAY")
            else:
                print(f"   Day {day.day}: {day.intensity} | {day.estimatedDuration} min, {day.estimatedCalories} cal")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        traceback.print_exc()
    
    # ========================================================================
    # TEST CASE 2: Cycle Sync - Week 1 (Menstruation)
    # ========================================================================
    print("\n\n" + "=" * 80)
    print("TEST CASE 2: Cycle Sync - Starting on WEEK 1 (Menstruation)")
    print("=" * 80)
    
    request2 = WorkoutPlanRequest(
        userId="test-user-week1",
        startDate="2025-11-27",
        onboardingData=OnboardingData(
            motivations=["feel_confident", "lose_weight"],
            mainGoal="lose_weight",
            focusAreas=["belly"],
            height=165,
            weight=65,
            goalWeight=58,
            currentBodyType="average",
            desiredBodyType="toned",
            age=28,
            menstrualCycleAdaptation="yes",  # ✅ CYCLE SYNC ON
            currentCycleWeek=1,  # ✅ MENSTRUATION
            pelvicFloorHealth="no_issues",
            workoutLocation="yoga_mat",
            workoutType="no_equipment",
            workoutLevel="simple_sweaty",
            injuries=["none"],
            typicalDay="seated_work",
            activityLevel="lightly_active",
            fitnessLevel="beginner",
            bellyType="normal",
            hipsType="normal",
            legType="normal",
            flexibilityLevel="close_to_feet",
            cardioLevel="somewhat_tired",
            statementBodyDissatisfaction=True,
            statementNeedGuidance=True,
            statementEasilyGiveUp=False,
        )
    )
    
    try:
        print("\n🚀 Generating workout plan (WEEK 1 - Menstruation)...")
        plan2 = await workout_generator.generate_workout_plan(request2)
        
        print(f"\n✅ PLAN GENERATED!")
        print(f"   Title: {plan2.title}")
        
        print(f"\n📊 CYCLE-AWARE INTENSITY (4 weeks = 28 days):")
        print("   Expected: Week 1 (Gentle) → Week 2 (Moderate) → Week 3 (High) → Week 4 (Moderate)")
        print()
        
        for week in range(1, 5):
            start_day = (week - 1) * 7
            end_day = start_day + 7
            week_days = [d for d in plan2.dailyWorkouts[start_day:end_day] if not d.isRestDay]
            
            if week_days:
                print(f"\n   📅 WEEK {week}:")
                for day in week_days[:3]:  # Show first 3 days
                    reps_info = ""
                    main_set = next((ws for ws in day.workoutSets if ws.setType == "main"), None)
                    if main_set and main_set.exercises:
                        reps_info = f" | Reps: {main_set.exercises[0].reps}"
                    
                    print(f"      Day {day.day}: {day.intensity} | {day.estimatedDuration} min{reps_info}")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        traceback.print_exc()
    
    # ========================================================================
    # TEST CASE 3: Cycle Sync + Pelvic Floor Issues
    # ========================================================================
    print("\n\n" + "=" * 80)
    print("TEST CASE 3: Cycle Sync - Week 1 + Pelvic Floor Issues")
    print("=" * 80)
    
    request3 = WorkoutPlanRequest(
        userId="test-user-pelvic",
        startDate="2025-11-27",
        onboardingData=OnboardingData(
            motivations=["feel_confident", "lose_weight"],
            mainGoal="lose_weight",
            focusAreas=["belly"],
            height=165,
            weight=65,
            goalWeight=58,
            currentBodyType="average",
            desiredBodyType="toned",
            age=28,
            menstrualCycleAdaptation="yes",  # ✅ CYCLE SYNC ON
            currentCycleWeek=1,  # ✅ MENSTRUATION
            pelvicFloorHealth="occasional_leaking",  # ✅ PELVIC FLOOR ISSUE
            workoutLocation="yoga_mat",
            workoutType="no_equipment",
            workoutLevel="simple_sweaty",
            injuries=["none"],
            typicalDay="seated_work",
            activityLevel="lightly_active",
            fitnessLevel="beginner",
            bellyType="normal",
            hipsType="normal",
            legType="normal",
            flexibilityLevel="close_to_feet",
            cardioLevel="somewhat_tired",
            statementBodyDissatisfaction=True,
            statementNeedGuidance=True,
            statementEasilyGiveUp=False,
        )
    )
    
    try:
        print("\n🚀 Generating workout plan (Week 1 + Pelvic Floor Issues)...")
        plan3 = await workout_generator.generate_workout_plan(request3)
        
        print(f"\n✅ PLAN GENERATED!")
        
        print(f"\n📊 EXTRA GENTLE INTENSITY (First 7 days):")
        print("   Expected: 'Very Gentle (Menstruation + Pelvic Care)' during week 1")
        print()
        
        for day in plan3.dailyWorkouts[:7]:
            if day.isRestDay:
                print(f"   Day {day.day}: REST DAY")
            else:
                main_set = next((ws for ws in day.workoutSets if ws.setType == "main"), None)
                reps_info = f" | Reps: {main_set.exercises[0].reps}" if main_set and main_set.exercises else ""
                print(f"   Day {day.day}: {day.intensity} | {day.estimatedDuration} min{reps_info}")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        traceback.print_exc()
    
    # ========================================================================
    # SUMMARY
    # ========================================================================
    print("\n\n" + "=" * 80)
    print("📊 TEST SUMMARY:")
    print("=" * 80)
    print("\n✅ TEST 1 (No Sync): Should show standard intensity labels")
    print("✅ TEST 2 (Cycle Sync): Should show cycle-aware intensity (Gentle → Moderate → High → Moderate)")
    print("✅ TEST 3 (Cycle + Pelvic): Should show 'Very Gentle' with reduced reps during menstruation")
    print("\n" + "=" * 80)

if __name__ == "__main__":
    asyncio.run(test_workout_generation())