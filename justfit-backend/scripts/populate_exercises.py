"""
Script to populate Firestore with exercise library
Run once to seed the database with exercise details

Usage:
  python scripts/populate_exercises.py
"""

import firebase_admin
from firebase_admin import credentials, firestore
import os

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    # Path to your service account key
    # Download from: Firebase Console → Project Settings → Service Accounts → Generate new private key
    cred_path = os.path.join(os.path.dirname(__file__), '..', 'serviceAccountKey.json')
    
    if not os.path.exists(cred_path):
        print("❌ ERROR: serviceAccountKey.json not found!")
        print(f"   Expected location: {os.path.abspath(cred_path)}")
        print("\n📝 To get your service account key:")
        print("   1. Go to: https://console.firebase.google.com")
        print("   2. Select your project")
        print("   3. Click gear icon → Project Settings")
        print("   4. Go to 'Service Accounts' tab")
        print("   5. Click 'Generate new private key'")
        print("   6. Save as: justfit-backend/serviceAccountKey.json")
        return None
    
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)
    return firestore.client()

# Exercise Library - Women's Fitness Exercises
# Exercise Library - Women's Fitness Exercises (50 exercises)
EXERCISES = [
    {
        "exerciseId": "jumping-jacks",
        "exerciseName": "Jumping Jacks",
        "category": "cardio",
        "targetMuscle": "full_body",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Stand with feet together and arms at your sides",
            "Jump while spreading legs shoulder-width apart",
            "Simultaneously raise arms overhead",
            "Jump back to starting position",
            "Repeat in a continuous rhythm"
        ],
        "breathingRhythm": [
            "Inhale: As you jump and open",
            "Exhale: As you return to center",
            "Keep breathing steady and rhythmic"
        ],
        "actionFeeling": [
            "You should feel your heart rate increase",
            "Light burning in legs and shoulders",
            "Energized and warmed up"
        ],
        "commonMistakes": [
            "Landing too heavily on feet",
            "Not fully extending arms overhead",
            "Holding breath",
            "Moving too fast without control"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "squats",
        "exerciseName": "Squats",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet shoulder-width apart",
            "Keep chest up and core engaged",
            "Lower hips back and down as if sitting",
            "Go down until thighs are parallel to floor",
            "Push through heels to return to standing"
        ],
        "breathingRhythm": [
            "Inhale: As you lower down",
            "Exhale: As you push back up",
            "Hold breath briefly at the bottom"
        ],
        "actionFeeling": [
            "Tension in quadriceps and glutes",
            "Weight centered in heels",
            "Burning sensation in thighs"
        ],
        "commonMistakes": [
            "Knees extending past toes",
            "Rounding the back",
            "Not going low enough",
            "Lifting heels off ground"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "push-ups",
        "exerciseName": "Push-ups",
        "category": "strength",
        "targetMuscle": "chest",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in plank position with hands shoulder-width",
            "Keep body in straight line from head to heels",
            "Lower chest toward ground by bending elbows",
            "Keep elbows at 45-degree angle from body",
            "Push back up to starting position"
        ],
        "breathingRhythm": [
            "Inhale: As you lower down",
            "Exhale: As you push up",
            "Don't hold your breath"
        ],
        "actionFeeling": [
            "Tension in chest, shoulders, and triceps",
            "Core engaged throughout",
            "Stable and controlled movement"
        ],
        "commonMistakes": [
            "Sagging hips",
            "Flaring elbows out too wide",
            "Not lowering fully",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "lunges",
        "exerciseName": "Lunges",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Step forward with one leg",
            "Lower hips until both knees are bent at 90 degrees",
            "Front knee should be directly above ankle",
            "Push back to starting position and repeat on other side"
        ],
        "breathingRhythm": [
            "Inhale: As you step forward and lower",
            "Exhale: As you push back up",
            "Maintain steady breathing rhythm"
        ],
        "actionFeeling": [
            "Burning in front leg quadriceps and glutes",
            "Balance and stability throughout",
            "Controlled movement in both directions"
        ],
        "commonMistakes": [
            "Front knee extending past toes",
            "Leaning torso too far forward",
            "Not lowering deep enough",
            "Losing balance"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "plank",
        "exerciseName": "Plank",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Start in forearm plank position",
            "Elbows directly under shoulders",
            "Body forms straight line from head to heels",
            "Engage core and squeeze glutes",
            "Hold position without sagging or raising hips"
        ],
        "breathingRhythm": [
            "Breathe normally and steadily",
            "Don't hold your breath",
            "Focus on keeping core engaged"
        ],
        "actionFeeling": [
            "Intense core engagement",
            "Tension in shoulders and arms",
            "Burning sensation in abs",
            "Whole body working together"
        ],
        "commonMistakes": [
            "Hips sagging toward ground",
            "Raising hips too high",
            "Holding breath",
            "Letting shoulders collapse"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "burpees",
        "exerciseName": "Burpees",
        "category": "cardio",
        "targetMuscle": "full_body",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start standing, then drop into a squat",
            "Place hands on floor and jump feet back to plank",
            "Perform a push-up",
            "Jump feet back to squat position",
            "Explosively jump up with arms overhead"
        ],
        "breathingRhythm": [
            "Exhale: During the push-up",
            "Inhale: As you jump up",
            "Quick, rhythmic breathing"
        ],
        "actionFeeling": [
            "Full body workout intensity",
            "Heart rate significantly elevated",
            "Challenging but energizing"
        ],
        "commonMistakes": [
            "Skipping the push-up",
            "Not jumping high enough",
            "Poor form due to fatigue",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "high-knees",
        "exerciseName": "High Knees",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Stand with feet hip-width apart",
            "Drive one knee up toward chest",
            "Quickly switch to other knee",
            "Pump arms in running motion",
            "Keep core tight and maintain quick pace"
        ],
        "breathingRhythm": [
            "Quick, rhythmic breaths",
            "Match breathing to movement pace",
            "Don't hold breath"
        ],
        "actionFeeling": [
            "Heart rate elevation",
            "Burning in hip flexors and quads",
            "Cardiovascular challenge"
        ],
        "commonMistakes": [
            "Not lifting knees high enough",
            "Leaning too far back",
            "Moving too slowly",
            "Tensing shoulders"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "mountain-climbers",
        "exerciseName": "Mountain Climbers",
        "category": "cardio",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in plank position",
            "Drive one knee toward chest",
            "Quickly switch legs in running motion",
            "Keep hips level and core engaged",
            "Maintain quick, controlled pace"
        ],
        "breathingRhythm": [
            "Quick, shallow breaths",
            "Rhythmic with movement",
            "Stay relaxed in shoulders"
        ],
        "actionFeeling": [
            "Core working intensely",
            "Shoulders stabilizing",
            "Heart rate climbing"
        ],
        "commonMistakes": [
            "Hips rising too high",
            "Not bringing knee far enough forward",
            "Moving too slowly",
            "Letting shoulders collapse"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "glute-bridges",
        "exerciseName": "Glute Bridges",
        "category": "strength",
        "targetMuscle": "glutes",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie on back with knees bent, feet flat",
            "Feet hip-width apart, arms at sides",
            "Push through heels to lift hips up",
            "Squeeze glutes at top",
            "Lower back down with control"
        ],
        "breathingRhythm": [
            "Exhale: As you lift hips",
            "Inhale: As you lower down",
            "Pause at top for extra squeeze"
        ],
        "actionFeeling": [
            "Strong glute activation",
            "Hamstring engagement",
            "Lower back supported"
        ],
        "commonMistakes": [
            "Pushing through toes instead of heels",
            "Arching lower back excessively",
            "Not squeezing glutes at top",
            "Moving too quickly"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "bicycle-crunches",
        "exerciseName": "Bicycle Crunches",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie on back with hands behind head",
            "Lift shoulders off ground",
            "Bring one knee toward chest while rotating opposite elbow to knee",
            "Switch sides in cycling motion",
            "Keep lower back pressed to floor"
        ],
        "breathingRhythm": [
            "Exhale: As you crunch and rotate",
            "Inhale: As you switch sides",
            "Keep steady rhythm"
        ],
        "actionFeeling": [
            "Intense oblique activation",
            "Core fully engaged",
            "Controlled rotation"
        ],
        "commonMistakes": [
            "Pulling on neck",
            "Moving too fast",
            "Not fully extending legs",
            "Lower back lifting off floor"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
        {
        "exerciseId": "side-plank",
        "exerciseName": "Side Plank",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Lie on side with forearm on ground",
            "Stack feet and lift hips off ground",
            "Body forms straight line from head to feet",
            "Hold position with core engaged",
            "Repeat on other side"
        ],
        "breathingRhythm": [
            "Breathe steadily and evenly",
            "Don't hold breath",
            "Focus on oblique engagement"
        ],
        "actionFeeling": [
            "Intense oblique activation",
            "Shoulder stabilization",
            "Balance challenge"
        ],
        "commonMistakes": [
            "Hips sagging toward floor",
            "Not stacking feet properly",
            "Rotating torso forward or back",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "tricep-dips",
        "exerciseName": "Tricep Dips",
        "category": "strength",
        "targetMuscle": "arms",
        "difficulty": "intermediate",
        "equipment": "chair",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Sit on edge of chair, hands next to hips",
            "Slide hips off chair, supporting with arms",
            "Lower body by bending elbows to 90 degrees",
            "Keep elbows pointing back, not out",
            "Push back up to starting position"
        ],
        "breathingRhythm": [
            "Inhale: As you lower down",
            "Exhale: As you push up",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Triceps burning",
            "Shoulders engaged",
            "Chest slightly involved"
        ],
        "commonMistakes": [
            "Elbows flaring out to sides",
            "Lowering too far",
            "Shrugging shoulders",
            "Using momentum"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "donkey-kicks",
        "exerciseName": "Donkey Kicks",
        "category": "strength",
        "targetMuscle": "glutes",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start on all fours, hands under shoulders",
            "Keep knee bent at 90 degrees",
            "Lift one leg up toward ceiling",
            "Squeeze glutes at top",
            "Lower back down and repeat"
        ],
        "breathingRhythm": [
            "Exhale: As you lift leg up",
            "Inhale: As you lower down",
            "Pause at top for squeeze"
        ],
        "actionFeeling": [
            "Glutes firing intensely",
            "Hamstring engagement",
            "Core stabilization"
        ],
        "commonMistakes": [
            "Arching lower back",
            "Not squeezing glutes",
            "Moving too quickly",
            "Straightening the knee"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "russian-twists",
        "exerciseName": "Russian Twists",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Sit with knees bent, feet off ground",
            "Lean back slightly, keeping back straight",
            "Clasp hands together in front",
            "Rotate torso side to side",
            "Touch hands to ground on each side"
        ],
        "breathingRhythm": [
            "Exhale: As you twist",
            "Inhale: As you return to center",
            "Quick rhythmic breaths"
        ],
        "actionFeeling": [
            "Obliques working hard",
            "Core fully engaged",
            "Balance challenge"
        ],
        "commonMistakes": [
            "Moving too fast",
            "Rounding the back",
            "Not rotating fully",
            "Letting feet touch ground"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "wall-sit",
        "exerciseName": "Wall Sit",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "wall",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 45,
        "instructions": [
            "Stand with back against wall",
            "Slide down until knees at 90 degrees",
            "Feet shoulder-width apart",
            "Keep back flat against wall",
            "Hold position without sliding"
        ],
        "breathingRhythm": [
            "Breathe steadily and deeply",
            "Don't hold breath",
            "Focus on endurance"
        ],
        "actionFeeling": [
            "Intense quad burn",
            "Glutes engaged",
            "Endurance challenge"
        ],
        "commonMistakes": [
            "Not going low enough",
            "Feet too close to wall",
            "Holding breath",
            "Arching back off wall"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "calf-raises",
        "exerciseName": "Calf Raises",
        "category": "strength",
        "targetMuscle": "calves",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Rise up onto balls of feet",
            "Lift heels as high as possible",
            "Squeeze calves at top",
            "Lower back down with control"
        ],
        "breathingRhythm": [
            "Exhale: As you rise up",
            "Inhale: As you lower down",
            "Steady rhythm"
        ],
        "actionFeeling": [
            "Calf muscles tightening",
            "Balance engagement",
            "Burn in lower legs"
        ],
        "commonMistakes": [
            "Not rising high enough",
            "Moving too quickly",
            "Not controlling descent",
            "Bending knees"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "flutter-kicks",
        "exerciseName": "Flutter Kicks",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Lie flat on back, legs extended",
            "Place hands under glutes for support",
            "Lift legs slightly off ground",
            "Alternate kicking legs up and down",
            "Keep lower back pressed to floor"
        ],
        "breathingRhythm": [
            "Breathe steadily throughout",
            "Quick shallow breaths",
            "Don't hold breath"
        ],
        "actionFeeling": [
            "Lower abs burning",
            "Hip flexors working",
            "Core tension"
        ],
        "commonMistakes": [
            "Lower back arching",
            "Kicking too high",
            "Moving too fast",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "fire-hydrants",
        "exerciseName": "Fire Hydrants",
        "category": "strength",
        "targetMuscle": "glutes",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start on all fours",
            "Keep knee bent at 90 degrees",
            "Lift one leg out to side",
            "Keep hips level",
            "Lower and repeat on other side"
        ],
        "breathingRhythm": [
            "Exhale: As you lift leg",
            "Inhale: As you lower",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Outer glutes burning",
            "Hip abductors working",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Rotating hips",
            "Moving too fast",
            "Not lifting high enough",
            "Arching back"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "butt-kicks",
        "exerciseName": "Butt Kicks",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Stand with feet hip-width apart",
            "Jog in place",
            "Kick heels up toward glutes",
            "Pump arms in running motion",
            "Maintain quick pace"
        ],
        "breathingRhythm": [
            "Quick rhythmic breaths",
            "Match breathing to pace",
            "Stay relaxed"
        ],
        "actionFeeling": [
            "Hamstrings working",
            "Heart rate elevation",
            "Light cardio burn"
        ],
        "commonMistakes": [
            "Not kicking high enough",
            "Moving too slowly",
            "Leaning forward",
            "Tensing shoulders"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "pike-push-ups",
        "exerciseName": "Pike Push-ups",
        "category": "strength",
        "targetMuscle": "shoulders",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in downward dog position",
            "Hands and feet on ground, hips high",
            "Bend elbows to lower head toward ground",
            "Keep legs relatively straight",
            "Push back up to starting position"
        ],
        "breathingRhythm": [
            "Inhale: As you lower down",
            "Exhale: As you push up",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Shoulders burning",
            "Triceps engaged",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Bending knees too much",
            "Not lowering deep enough",
            "Flaring elbows",
            "Arching back"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "superman",
        "exerciseName": "Superman",
        "category": "strength",
        "targetMuscle": "back",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie face down with arms extended forward",
            "Simultaneously lift arms, chest, and legs off ground",
            "Squeeze glutes and lower back",
            "Hold for 2 seconds",
            "Lower back down with control"
        ],
        "breathingRhythm": [
            "Exhale: As you lift up",
            "Hold breath briefly at top",
            "Inhale: As you lower down"
        ],
        "actionFeeling": [
            "Lower back engaged",
            "Glutes squeezing",
            "Full posterior chain working"
        ],
        "commonMistakes": [
            "Lifting too high and straining neck",
            "Not engaging glutes",
            "Holding breath too long",
            "Moving too fast"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "leg-raises",
        "exerciseName": "Leg Raises",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie flat on back with legs extended",
            "Place hands under glutes",
            "Keep legs straight and lift toward ceiling",
            "Stop at 90 degrees",
            "Lower back down without touching floor"
        ],
        "breathingRhythm": [
            "Exhale: As you lift legs",
            "Inhale: As you lower legs",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Lower abs intensely engaged",
            "Hip flexors working",
            "Core tension throughout"
        ],
        "commonMistakes": [
            "Lower back arching",
            "Bending knees",
            "Lowering too fast",
            "Using momentum"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "skater-jumps",
        "exerciseName": "Skater Jumps",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start standing on one leg",
            "Jump laterally to other leg",
            "Land softly with slight knee bend",
            "Swing arms for balance and momentum",
            "Immediately jump back to other side"
        ],
        "breathingRhythm": [
            "Quick rhythmic breathing",
            "Exhale with each jump",
            "Stay loose"
        ],
        "actionFeeling": [
            "Heart rate elevated",
            "Legs burning",
            "Power and agility"
        ],
        "commonMistakes": [
            "Landing too hard",
            "Not jumping far enough laterally",
            "Poor balance",
            "Moving too slowly"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "reverse-lunges",
        "exerciseName": "Reverse Lunges",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Step backward with one leg",
            "Lower hips until both knees at 90 degrees",
            "Push through front heel to return",
            "Alternate legs"
        ],
        "breathingRhythm": [
            "Inhale: As you step back and lower",
            "Exhale: As you push back up",
            "Steady rhythm"
        ],
        "actionFeeling": [
            "Quads and glutes working",
            "Balance challenge",
            "Controlled movement"
        ],
        "commonMistakes": [
            "Front knee passing toes",
            "Not lowering deep enough",
            "Losing balance",
            "Leaning forward"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "diamond-push-ups",
        "exerciseName": "Diamond Push-ups",
        "category": "strength",
        "targetMuscle": "triceps",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 8,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in plank with hands together",
            "Form diamond shape with thumbs and index fingers",
            "Keep elbows close to body",
            "Lower chest toward hands",
            "Push back up explosively"
        ],
        "breathingRhythm": [
            "Inhale: As you lower",
            "Exhale: As you push up",
            "Don't hold breath"
        ],
        "actionFeeling": [
            "Triceps burning intensely",
            "Chest engaged",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Elbows flaring out",
            "Not lowering fully",
            "Sagging hips",
            "Hands too far apart"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "inchworms",
        "exerciseName": "Inchworms",
        "category": "strength",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Bend at waist and place hands on floor",
            "Walk hands forward to plank position",
            "Optionally perform a push-up",
            "Walk feet back to hands and stand"
        ],
        "breathingRhythm": [
            "Exhale: As you walk hands out",
            "Inhale: As you walk feet in",
            "Steady breathing"
        ],
        "actionFeeling": [
            "Core engaged throughout",
            "Hamstring stretch",
            "Full body coordination"
        ],
        "commonMistakes": [
            "Bending knees",
            "Not walking far enough",
            "Rushing the movement",
            "Sagging in plank"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "side-lunges",
        "exerciseName": "Side Lunges",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet together",
            "Step out wide to one side",
            "Bend stepping leg while keeping other straight",
            "Push through heel to return to center",
            "Alternate sides"
        ],
        "breathingRhythm": [
            "Inhale: As you step out and lower",
            "Exhale: As you push back",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Inner thighs stretching",
            "Quads and glutes working",
            "Balance and stability"
        ],
        "commonMistakes": [
            "Knee passing toes",
            "Not sitting back far enough",
            "Keeping both knees bent",
            "Losing balance"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "sumo-squats",
        "exerciseName": "Sumo Squats",
        "category": "strength",
        "targetMuscle": "legs",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet wider than shoulder-width",
            "Turn toes out at 45 degrees",
            "Lower hips straight down",
            "Keep knees tracking over toes",
            "Push through heels to stand"
        ],
        "breathingRhythm": [
            "Inhale: As you lower down",
            "Exhale: As you push up",
            "Steady rhythm"
        ],
        "actionFeeling": [
            "Inner thighs working",
            "Glutes engaged",
            "Quad activation"
        ],
        "commonMistakes": [
            "Knees collapsing inward",
            "Not going low enough",
            "Leaning forward",
            "Lifting heels"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "standing-oblique-crunches",
        "exerciseName": "Standing Oblique Crunches",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Place hands behind head",
            "Lift one knee toward same-side elbow",
            "Crunch sideways bringing elbow and knee together",
            "Alternate sides"
        ],
        "breathingRhythm": [
            "Exhale: As you crunch",
            "Inhale: As you return to standing",
            "Rhythmic breathing"
        ],
        "actionFeeling": [
            "Obliques contracting",
            "Balance challenge",
            "Core engagement"
        ],
        "commonMistakes": [
            "Pulling on neck",
            "Not crunching sideways enough",
            "Moving too fast",
            "Losing balance"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "curtsy-lunges",
        "exerciseName": "Curtsy Lunges",
        "category": "strength",
        "targetMuscle": "glutes",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand with feet hip-width apart",
            "Step one leg back and across behind other leg",
            "Lower hips until front thigh is parallel to floor",
            "Push through front heel to return",
            "Alternate sides"
        ],
        "breathingRhythm": [
            "Inhale: As you step back and lower",
            "Exhale: As you push back up",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Glutes working hard",
            "Balance challenge",
            "Hip stability"
        ],
        "commonMistakes": [
            "Front knee caving inward",
            "Not crossing far enough back",
            "Leaning forward",
            "Losing balance"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "bear-crawl",
        "exerciseName": "Bear Crawl",
        "category": "strength",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Start on all fours with knees hovering",
            "Keep back flat and core tight",
            "Move forward by stepping opposite hand and foot",
            "Stay low to ground",
            "Maintain steady pace"
        ],
        "breathingRhythm": [
            "Breathe steadily throughout",
            "Don't hold breath",
            "Stay relaxed"
        ],
        "actionFeeling": [
            "Full body engagement",
            "Core working hard",
            "Shoulders stabilizing"
        ],
        "commonMistakes": [
            "Hips too high",
            "Moving too fast",
            "Not moving opposite limbs",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "plank-jacks",
        "exerciseName": "Plank Jacks",
        "category": "cardio",
        "targetMuscle": "core",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in high plank position",
            "Jump feet out wide",
            "Jump feet back together",
            "Keep core tight and hips level",
            "Maintain quick pace"
        ],
        "breathingRhythm": [
            "Quick rhythmic breathing",
            "Exhale with each jump",
            "Stay loose"
        ],
        "actionFeeling": [
            "Core engaged",
            "Heart rate elevated",
            "Cardio challenge"
        ],
        "commonMistakes": [
            "Hips bouncing up and down",
            "Sagging in middle",
            "Moving too slowly",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "single-leg-deadlift",
        "exerciseName": "Single Leg Deadlift",
        "category": "strength",
        "targetMuscle": "hamstrings",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand on one leg with slight knee bend",
            "Hinge at hip and reach toward ground",
            "Extend free leg behind for balance",
            "Keep back straight",
            "Return to standing and squeeze glutes"
        ],
        "breathingRhythm": [
            "Inhale: As you hinge forward",
            "Exhale: As you stand back up",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Hamstrings stretching and working",
            "Glutes engaged",
            "Balance challenge"
        ],
        "commonMistakes": [
            "Rounding the back",
            "Not hinging at hip",
            "Losing balance",
            "Not extending leg fully behind"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "star-jumps",
        "exerciseName": "Star Jumps",
        "category": "cardio",
        "targetMuscle": "full_body",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in slight squat position",
            "Jump explosively upward",
            "Spread arms and legs out into star shape",
            "Land softly back in squat",
            "Immediately repeat"
        ],
        "breathingRhythm": [
            "Inhale: Before jump",
            "Exhale: During jump",
            "Quick recovery breaths"
        ],
        "actionFeeling": [
            "Full body explosion",
            "Heart rate spike",
            "Power and coordination"
        ],
        "commonMistakes": [
            "Landing too hard",
            "Not extending fully",
            "Poor landing mechanics",
            "Moving too slowly"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "toe-touches",
        "exerciseName": "Toe Touches",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 15,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie on back with legs raised straight up",
            "Reach arms toward ceiling",
            "Crunch up and reach for toes",
            "Lower back down with control",
            "Keep legs as straight as possible"
        ],
        "breathingRhythm": [
            "Exhale: As you reach up",
            "Inhale: As you lower down",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Upper abs working",
            "Hamstring stretch",
            "Core tension"
        ],
        "commonMistakes": [
            "Using momentum",
            "Bending knees too much",
            "Not crunching high enough",
            "Pulling on neck"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "bird-dog",
        "exerciseName": "Bird Dog",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start on all fours",
            "Extend opposite arm and leg simultaneously",
            "Keep back flat and core engaged",
            "Hold for 2 seconds",
            "Return and switch sides"
        ],
        "breathingRhythm": [
            "Exhale: As you extend",
            "Hold breath briefly",
            "Inhale: As you return"
        ],
        "actionFeeling": [
            "Core stabilizing",
            "Balance challenge",
            "Lower back engaged"
        ],
        "commonMistakes": [
            "Rotating hips or shoulders",
            "Arching back",
            "Moving too fast",
            "Not extending fully"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "crab-walk",
        "exerciseName": "Crab Walk",
        "category": "strength",
        "targetMuscle": "triceps",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Sit with knees bent, hands behind hips",
            "Lift hips off ground",
            "Walk forward or backward on hands and feet",
            "Keep hips elevated",
            "Move with opposite hand and foot"
        ],
        "breathingRhythm": [
            "Breathe steadily throughout",
            "Don't hold breath",
            "Stay relaxed"
        ],
        "actionFeeling": [
            "Triceps working",
            "Shoulders engaged",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Hips sagging",
            "Moving too fast",
            "Looking down instead of forward",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "squat-jumps",
        "exerciseName": "Squat Jumps",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in squat position",
            "Explode upward jumping as high as possible",
            "Land softly back in squat",
            "Immediately go into next rep",
            "Use arms for momentum"
        ],
        "breathingRhythm": [
            "Inhale: In squat position",
            "Exhale: During jump",
            "Quick recovery"
        ],
        "actionFeeling": [
            "Explosive power",
            "Legs burning",
            "Heart rate elevated"
        ],
        "commonMistakes": [
            "Landing too hard",
            "Not squatting deep enough",
            "Poor landing mechanics",
            "Not jumping high enough"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "hollow-body-hold",
        "exerciseName": "Hollow Body Hold",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Lie flat on back",
            "Lift shoulders and legs off ground",
            "Press lower back into floor",
            "Extend arms overhead",
            "Hold hollow position"
        ],
        "breathingRhythm": [
            "Shallow steady breaths",
            "Don't hold breath",
            "Focus on core tension"
        ],
        "actionFeeling": [
            "Intense core engagement",
            "Full ab tension",
            "Whole body tightness"
        ],
        "commonMistakes": [
            "Lower back arching",
            "Legs too high",
            "Shoulders not lifted",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "wide-push-ups",
        "exerciseName": "Wide Push-ups",
        "category": "strength",
        "targetMuscle": "chest",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in plank with hands wider than shoulders",
            "Keep body in straight line",
            "Lower chest toward ground",
            "Elbows flare out at 45 degrees",
            "Push back up explosively"
        ],
        "breathingRhythm": [
            "Inhale: As you lower",
            "Exhale: As you push up",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Chest stretching and working",
            "Shoulders engaged",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Hands too wide",
            "Sagging hips",
            "Not lowering fully",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "windshield-wipers",
        "exerciseName": "Windshield Wipers",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie on back with arms out to sides",
            "Lift legs straight up to 90 degrees",
            "Lower legs to one side keeping them together",
            "Bring legs back to center",
            "Lower to other side"
        ],
        "breathingRhythm": [
            "Exhale: As you lower legs",
            "Inhale: As you bring back to center",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Obliques working intensely",
            "Core fully engaged",
            "Control and stability"
        ],
        "commonMistakes": [
            "Moving too fast",
            "Shoulders lifting off ground",
            "Bending knees",
            "Losing control"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "frog-pumps",
        "exerciseName": "Frog Pumps",
        "category": "strength",
        "targetMuscle": "glutes",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": 20,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie on back with knees bent",
            "Place soles of feet together, knees out",
            "Lift hips off ground",
            "Squeeze glutes at top",
            "Lower with control"
        ],
        "breathingRhythm": [
            "Exhale: As you lift hips",
            "Inhale: As you lower",
            "Quick tempo"
        ],
        "actionFeeling": [
            "Glutes burning",
            "Inner thighs stretching",
            "Hip activation"
        ],
        "commonMistakes": [
            "Not squeezing glutes",
            "Moving too fast",
            "Arching back too much",
            "Feet too far from body"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "reverse-plank",
        "exerciseName": "Reverse Plank",
        "category": "strength",
        "targetMuscle": "back",
        "difficulty": "intermediate",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Sit with legs extended, hands behind hips",
            "Lift hips to form straight line",
            "Point toes and engage glutes",
            "Keep shoulders back",
            "Hold position"
        ],
        "breathingRhythm": [
            "Breathe steadily",
            "Don't hold breath",
            "Focus on form"
        ],
        "actionFeeling": [
            "Posterior chain engaged",
            "Shoulders working",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Hips sagging",
            "Head dropping back",
            "Shoulders hunching",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "box-jumps",
        "exerciseName": "Box Jumps",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "advanced",
        "equipment": "box",
        "defaultReps": 10,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Stand facing a sturdy box or platform",
            "Bend knees and swing arms back",
            "Jump explosively onto box",
            "Land softly with knees bent",
            "Step down and repeat"
        ],
        "breathingRhythm": [
            "Inhale: Before jump",
            "Exhale: During jump",
            "Recovery breath on box"
        ],
        "actionFeeling": [
            "Explosive power",
            "Full leg engagement",
            "Cardiovascular challenge"
        ],
        "commonMistakes": [
            "Box too high for skill level",
            "Landing too hard",
            "Jumping down instead of stepping",
            "Not landing fully on box"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "arm-circles",
        "exerciseName": "Arm Circles",
        "category": "warmup",
        "targetMuscle": "shoulders",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 2,
        "defaultDuration": 30,
        "instructions": [
            "Stand with arms extended to sides",
            "Make small circles forward",
            "Gradually increase circle size",
            "Reverse direction halfway through",
            "Keep arms straight throughout"
        ],
        "breathingRhythm": [
            "Breathe naturally",
            "Don't hold breath",
            "Stay relaxed"
        ],
        "actionFeeling": [
            "Shoulders warming up",
            "Light burn building",
            "Increased mobility"
        ],
        "commonMistakes": [
            "Moving too fast",
            "Bending arms",
            "Hunching shoulders",
            "Circles too small"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "bodyweight-rows",
        "exerciseName": "Bodyweight Rows",
        "category": "strength",
        "targetMuscle": "back",
        "difficulty": "intermediate",
        "equipment": "bar",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Hang from low bar with body straight",
            "Feet on ground, body at angle",
            "Pull chest to bar",
            "Keep body in straight line",
            "Lower back down with control"
        ],
        "breathingRhythm": [
            "Exhale: As you pull up",
            "Inhale: As you lower down",
            "Controlled breathing"
        ],
        "actionFeeling": [
            "Back muscles engaging",
            "Biceps working",
            "Core stabilizing"
        ],
        "commonMistakes": [
            "Sagging hips",
            "Not pulling high enough",
            "Using momentum",
            "Shrugging shoulders"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "seal-jacks",
        "exerciseName": "Seal Jacks",
        "category": "cardio",
        "targetMuscle": "full_body",
        "difficulty": "beginner",
        "equipment": "none",
        "defaultReps": None,
        "defaultSets": 3,
        "defaultDuration": 30,
        "instructions": [
            "Stand with feet together, arms extended forward",
            "Jump feet apart",
            "Simultaneously open arms wide to sides",
            "Jump back to starting position",
            "Clap hands in front"
        ],
        "breathingRhythm": [
            "Rhythmic breathing",
            "Exhale with each clap",
            "Stay loose"
        ],
        "actionFeeling": [
            "Heart rate increasing",
            "Shoulders working",
            "Cardio burn"
        ],
        "commonMistakes": [
            "Arms not fully extended",
            "Moving too slowly",
            "Not coordinating arms and legs",
            "Holding breath"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "v-ups",
        "exerciseName": "V-Ups",
        "category": "core",
        "targetMuscle": "core",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 12,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Lie flat on back with arms overhead",
            "Simultaneously lift legs and torso",
            "Reach hands toward toes forming V shape",
            "Lower back down with control",
            "Keep legs and arms straight"
        ],
        "breathingRhythm": [
            "Exhale: As you crunch up",
            "Inhale: As you lower down",
            "Explosive breathing"
        ],
        "actionFeeling": [
            "Full core engagement",
            "Intense abdominal work",
            "Hip flexor involvement"
        ],
        "commonMistakes": [
            "Bending knees or arms",
            "Using momentum",
            "Not reaching full V",
            "Neck strain"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    },
    {
        "exerciseId": "jump-lunges",
        "exerciseName": "Jump Lunges",
        "category": "cardio",
        "targetMuscle": "legs",
        "difficulty": "advanced",
        "equipment": "none",
        "defaultReps": 16,
        "defaultSets": 3,
        "defaultDuration": None,
        "instructions": [
            "Start in lunge position",
            "Jump explosively switching legs mid-air",
            "Land softly in lunge on opposite leg",
            "Immediately repeat",
            "Keep core engaged throughout"
        ],
        "breathingRhythm": [
            "Quick explosive breaths",
            "Exhale with each jump",
            "Rapid recovery"
        ],
        "actionFeeling": [
            "Explosive leg power",
            "Heart rate spiking",
            "High intensity burn"
        ],
        "commonMistakes": [
            "Landing too hard",
            "Not switching fully",
            "Knees caving inward",
            "Poor balance"
        ],
        "videoUrl": None,
        "lottieUrl": None,
        "thumbnailUrl": None
    }
    # Continue with 40 more exercises...
    # I'll provide these in the next message to keep it manageable
]

def populate_exercises(db):
    """Upload exercises to Firestore"""
    print("\n" + "=" * 60)
    print("📚 Populating Firestore with exercise library...")
    print("=" * 60)
    print(f"\n📊 Total exercises to upload: {len(EXERCISES)}\n")
    print("Uploading to Firestore...\n")
    
    success_count = 0
    failed_count = 0
    
    for idx, exercise in enumerate(EXERCISES, 1):
        try:
            exercise_id = exercise['exerciseId']
            
            # Fix field names to match backend model
            fixed_exercise = {
                'exerciseId': exercise['exerciseId'],
                'name': exercise['exerciseName'],  # Change exerciseName → name
                'category': exercise['category'],
                'targetMuscle': exercise['targetMuscle'],
                'difficulty': exercise['difficulty'],
                'equipment': exercise['equipment'],
                'thumbnailUrl': exercise.get('thumbnailUrl'),
                'videoUrl': exercise.get('videoUrl'),
                'gifUrl': exercise.get('lottieUrl'),  # Map lottieUrl → gifUrl for now
                'actionSteps': exercise['instructions'],  # Change instructions → actionSteps
                'breathingRhythm': exercise['breathingRhythm'],
                'actionFeeling': exercise['actionFeeling'],
                'commonMistakes': exercise['commonMistakes'],
                'modifications': None  # Not in populate script, will be added later
            }
            
            db.collection('exercises').document(exercise_id).set(fixed_exercise)
            print(f"  {idx:2d}. ✅ {exercise['exerciseName']:30s} ({exercise_id})")
            success_count += 1
        except Exception as e:
            print(f"  {idx:2d}. ❌ {exercise.get('exerciseName', 'Unknown'):30s} - Error: {e}")
            failed_count += 1
    
    print("\n" + "=" * 60)
    print(f"✅ Successfully uploaded: {success_count}")
    print(f"❌ Failed: {failed_count}")
    print("=" * 60)
    print("\n✨ Exercise library is now ready!")
    print("   Your app will load exercises from Firestore instantly.\n")


if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("🚀 EXERCISE LIBRARY POPULATION SCRIPT")
    print("=" * 60)
    
    # Initialize Firebase
    db = initialize_firebase()
    if db is None:
        print("\n❌ Failed to initialize Firebase. Exiting...")
        exit(1)
    
    # Populate exercises
    populate_exercises(db)