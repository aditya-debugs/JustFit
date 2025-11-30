import firebase_admin
from firebase_admin import credentials, firestore
import json
import sys

# Initialize Firebase (if not already initialized)
try:
    firebase_admin.get_app()
except ValueError:
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()

def check_user_plan(user_email=None):
    """Check workout plan for a specific user"""
    
    print("=" * 80)
    print("🔍 CHECKING STORED WORKOUT PLAN IN FIRESTORE")
    print("=" * 80)
    
    # Get user by email or latest user
    if user_email:
        users = db.collection('users').where('email', '==', user_email).limit(1).get()
    else:
        # Get most recent user
        users = db.collection('users').order_by('createdAt', direction=firestore.Query.DESCENDING).limit(1).get()
    
    if not users:
        print("❌ No users found!")
        return
    
    user = users[0]
    user_id = user.id
    user_data = user.to_dict()
    
    print(f"\n👤 USER:")
    print(f"   ID: {user_id}")
    print(f"   Email: {user_data.get('email', 'N/A')}")
    print(f"   Name: {user_data.get('displayName', 'N/A')}")
    
    # Get user's workout plan
    plans = db.collection('workout_plans').where('userId', '==', user_id).limit(1).get()
    
    if not plans:
        print(f"\n❌ No workout plan found for this user!")
        return
    
    plan = plans[0]
    plan_data = plan.to_dict()
    
    print(f"\n📋 WORKOUT PLAN:")
    print(f"   Plan ID: {plan.id}")
    print(f"   Title: {plan_data.get('planTitle', plan_data.get('title', 'N/A'))}")
    print(f"   Total Days: {plan_data.get('totalDays', 'N/A')}")
    print(f"   Total Phases: {len(plan_data.get('phases', []))}")
    print(f"   Status: {plan_data.get('status', 'N/A')}")
    
    # Check if plan has dailyWorkouts or phases structure
    daily_workouts = plan_data.get('dailyWorkouts', [])
    phases = plan_data.get('phases', [])
    
    print(f"\n📊 PLAN STRUCTURE:")
    print(f"   Has 'dailyWorkouts' field: {'Yes' if daily_workouts else 'No'}")
    print(f"   Has 'phases' field: {'Yes' if phases else 'No'}")
    
    # Extract days from phases if dailyWorkouts is empty
    if not daily_workouts and phases:
        print(f"\n   ℹ️  Plan uses 'phases' structure. Extracting days from phases...")
        daily_workouts = []
        for phase in phases:
            phase_days = phase.get('days', [])
            daily_workouts.extend(phase_days)
        print(f"   ✅ Extracted {len(daily_workouts)} days from {len(phases)} phases")
    
    print(f"\n📅 CHECKING SETS/ROUNDS IN DAILY WORKOUTS:")
    
    if not daily_workouts:
        print("   ❌ No daily workouts found in either structure!")
        print("\n🔍 DEBUG: Available top-level fields in plan document:")
        for key in sorted(plan_data.keys()):
            print(f"      - {key}: {type(plan_data[key]).__name__}")
        return
    
    print(f"   Total days in plan: {len(daily_workouts)}")
    
    # Check first 20 workout days
    workout_days_checked = 0
    sets_found = {}
    
    for i, day in enumerate(daily_workouts[:20]):  # Check first 20 days
        if day.get('isRestDay'):
            continue
        
        workout_days_checked += 1
        day_num = day.get('dayNumber', day.get('day', i+1))
        
        print(f"\n   📆 Day {day_num} - {day.get('dayTitle', 'N/A')}:")
        print(f"      Phase: {day.get('phaseNumber', day.get('phaseNumber', 'N/A'))}")
        print(f"      Estimated Duration: {day.get('estimatedDuration', 'N/A')} min")
        print(f"      Estimated Calories: {day.get('estimatedCalories', 'N/A')} cal")
        
        workout_sets = day.get('workoutSets', [])
        print(f"      Workout Sets: {len(workout_sets)}")
        
        for ws in workout_sets:
            if ws.get('setType') == 'main':
                exercises = ws.get('exercises', [])
                print(f"\n      🏋️ Main Set ({len(exercises)} exercises):")
                
                if exercises:
                    # Check first exercise for sets info
                    first_ex = exercises[0]
                    sets_value = first_ex.get('sets')
                    reps_value = first_ex.get('reps')
                    duration_value = first_ex.get('duration')
                    
                    print(f"         First Exercise: {first_ex.get('name', 'N/A')}")
                    print(f"         Exercise ID: {first_ex.get('exerciseId', 'N/A')}")
                    
                    if sets_value is not None:
                        print(f"         ✅ Sets/Rounds: {sets_value}")
                        sets_found[day_num] = sets_value
                    else:
                        print(f"         ⚠️  Sets/Rounds: NOT SET (will default to 3)")
                    
                    if reps_value is not None:
                        print(f"         Reps: {reps_value}")
                    
                    if duration_value is not None:
                        print(f"         Duration: {duration_value}s")
                    
                    print(f"         Display Text: {first_ex.get('displayText', 'N/A')}")
                    
                    # Show all exercises in this set
                    if len(exercises) > 1:
                        print(f"\n         All {len(exercises)} exercises in this set:")
                        for idx, ex in enumerate(exercises, 1):
                            ex_sets = ex.get('sets', 'N/A')
                            ex_name = ex.get('name', ex.get('exerciseId', 'Unknown'))
                            print(f"            {idx}. {ex_name} - Sets: {ex_sets}")
        
        if workout_days_checked >= 10:
            break
    
    # Summary
    print(f"\n" + "=" * 80)
    print(f"📊 SUMMARY:")
    print(f"=" * 80)
    print(f"   Workout days checked: {workout_days_checked}")
    print(f"   Days with sets info: {len(sets_found)}")
    
    if sets_found:
        unique_sets = set(sets_found.values())
        print(f"   Unique sets values found: {sorted(unique_sets)}")
        
        # Calculate average
        avg_sets = sum(sets_found.values()) / len(sets_found)
        print(f"   Average sets across checked days: {avg_sets:.1f}")
        
        # Show progression
        print(f"\n   📈 Sets Progression (first {min(10, len(sets_found))} workout days):")
        for day_num in sorted(list(sets_found.keys())[:10]):
            print(f"      Day {day_num}: {sets_found[day_num]} sets")
        
        # Verdict
        if len(unique_sets) == 1 and 3 in unique_sets:
            print(f"\n   ⚠️  VERDICT: All days have 3 sets (likely hardcoded or default)")
        elif len(unique_sets) > 1:
            print(f"\n   ✅ VERDICT: Progressive sets detected! ({min(unique_sets)} → {max(unique_sets)} sets)")
        else:
            print(f"\n   ℹ️  VERDICT: All days have {list(unique_sets)[0]} sets")
    else:
        print(f"\n   ❌ VERDICT: NO SETS DATA FOUND - Frontend will default to 3 rounds!")
    
    print("=" * 80)

if __name__ == "__main__":
    email = sys.argv[1] if len(sys.argv) > 1 else None
    check_user_plan(email)