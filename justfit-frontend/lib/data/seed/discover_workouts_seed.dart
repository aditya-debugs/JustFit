// This file contains complete workout data for seeding Firestore
// Each workout has full exercise details with instructions, breathing, etc.

class DiscoveryWorkoutsSeed {
  static final List<Map<String, dynamic>> allWorkouts = [
    

    // ==================== BREAST CANCER AWARENESS MONTH WORKOUTS ====================

    {
      'id': 'breast_cancer_1',
      'title': 'Cardio Dance Fusion',
      'category': 'breast_cancer',
      'duration': 5,
      'calories': 33,
      'intensity': 'medium',
      'equipment': 'None',
      'focusZones': 'Cardio, Arms, Mobility',
      'imageUrl': 'assets/images/healthy_1.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Pulse Raiser)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Side Step and Arm Swings (Low Impact)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Step right foot out, tap left foot in. Step left foot out, tap right foot in.',
                'Swing arms forward and back loosely, keeping movement below shoulder level initially.',
                'Keep your steps light and rhythmic.'
              ],
              'breathingRhythm': 'Steady, active breaths',
              'actionFeeling': 'Heart rate gently increasing, shoulders mobilizing',
              'commonMistakes': [
                'Lifting arms too high too fast',
                'Heavy foot landings'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Dance Block',
          'setType': 'main',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Forward and Back Step with Bicep Curls',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Step right foot forward, step left foot back, keeping a small range of motion.',
                'Coordinate with alternating bicep curls (no weights needed).',
                'Focus on rhythm and arm squeeze.'
              ],
              'breathingRhythm': 'Exhale on the curl/step, inhale on the return',
              'actionFeeling': 'Cardio and arm muscles engaging',
              'commonMistakes': [
                'Using momentum instead of controlled arm contraction'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Torso Twist (Slow and Controlled)',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand tall, gently twist your torso side to side.',
                'Keep feet mostly planted or allow back heel to pivot lightly.',
                'Extend arms straight out to the sides for a rotational stretch/strength.',
                'Maintain a slow, deliberate pace.'
              ],
              'breathingRhythm': 'Exhale on the twist, inhale on the center',
              'actionFeeling': 'Core rotation, spinal flexibility',
              'commonMistakes': [
                'Twisting too quickly and jerking the movement'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Overhead Reach and Breathing',
              'duration': 30,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Stand still. Inhale, reach both arms slowly overhead (only as high as comfortable).',
                'Exhale, lower arms slowly to sides.',
                'Repeat twice, focusing on slowing the heart rate.'
              ],
              'breathingRhythm': 'Slow, long exhales',
              'actionFeeling': 'Calm, recovered, upper body lengthening',
              'commonMistakes': [
                'Shrugging shoulders on the reach'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },


    {
      'id': 'breast_cancer_2',
      'title': 'Full Body Tone: 15-Min Sculpt',
      'category': 'breast_cancer',
      'duration': 22,
      'calories': 208,
      'intensity': 'medium',
      'equipment': 'Chair, Mat',
      'focusZones': 'Total Body Strength, Upper Body',
      'imageUrl': 'assets/images/healthy_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Shoulder Focus)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Shoulder Blade Squeezes (Seated)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Sit tall. Squeeze shoulder blades together for 3 seconds.',
                'Release and repeat.',
                'Focus on squeezing the muscles in your upper back (rhomboids).',
                'Keep shoulders relaxed away from ears.'
              ],
              'breathingRhythm': 'Exhale on the squeeze, inhale on the release',
              'actionFeeling': 'Upper back engaging, improving posture',
              'commonMistakes': [
                'Shrugging the shoulders up'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Circuit',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Chair-Assisted Squats (Sit-to-Stand)',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand in front of a sturdy chair. Slowly sit down until you tap the seat.',
                'Immediately stand back up, squeezing glutes.',
                'Control the descent to protect knees and joints.'
              ],
              'breathingRhythm': 'Inhale sit, exhale stand (power up)',
              'actionFeeling': 'Glutes and quads strengthening, low-impact leg work',
              'commonMistakes': [
                'Bouncing off the chair'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Wall Push-Ups (Arm Strengthening)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand arms-length from a wall, hands at shoulder width.',
                'Bend elbows to lower chest toward the wall.',
                'Push back to start. Keep the body straight.',
                'Adjust distance from the wall for intensity (closer = easier).'
              ],
              'breathingRhythm': 'Inhale down, exhale up',
              'actionFeeling': 'Chest, shoulders, and arms engaging in a controlled manner',
              'commonMistakes': [
                'Arching the lower back'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Hip Abduction (Outer Thigh)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Hold onto a chair. Lift right leg out to the side (a few inches).',
                'Keep toes pointing forward, torso upright (avoid leaning).',
                'Lower slowly. Switch legs halfway through.'
              ],
              'breathingRhythm': 'Exhale on the lift, inhale on the lower',
              'actionFeeling': 'Outer hip and thigh strengthening for stability',
              'commonMistakes': [
                'Leaning significantly to the side'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Assisted Standing Triceps/Side Stretch',
              'duration': 60,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Reach right arm overhead, bend elbow.',
                'Use left hand to gently pull right elbow back (triceps stretch).',
                'Add a gentle side bend to the left.',
                'Hold 30 seconds, then switch sides.'
              ],
              'breathingRhythm': 'Deep, purposeful breathing into the stretch',
              'actionFeeling': 'Upper body release, shoulder mobility gently improving',
              'commonMistakes': [
                'Forcing the stretch or pulling the elbow too hard'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },



    {
      'id': 'breast_cancer_3',
      'title': 'Strength & Grace: Empowering Workout',
      'category': 'breast_cancer',
      'duration': 18,
      'calories': 156,
      'intensity': 'medium',
      'equipment': 'Light Weights (optional), Mat',
      'focusZones': 'Shoulder Strength, Core, Legs',
      'imageUrl': 'assets/images/healthy_1.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Mobility Flow)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Arm Flutters (Small and Controlled)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand tall, extend arms out to the sides at shoulder height.',
                'Make small, rapid circles (flutters) forward for 30 seconds.',
                'Reverse to backward flutters for 30 seconds.',
                'Keep movements small and fast, generating heat in the shoulders.'
              ],
              'breathingRhythm': 'Breathe quickly and consistently',
              'actionFeeling': 'Shoulder muscles activating, ready for strength work',
              'commonMistakes': [
                'Letting arms drop below shoulder height'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Circuit',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Bent-Over Row (Imaginary/Light Weights)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand, hinge forward slightly from hips (back flat, soft knees).',
                'Pretend to hold light weights. Pull elbows up and back, squeezing shoulder blades together.',
                'Lower arms slowly with control.',
                'Focus on strengthening the upper back.'
              ],
              'breathingRhythm': 'Exhale on the pull (squeeze), inhale on the lower',
              'actionFeeling': 'Upper back (rhomboids, lats) strengthening for posture',
              'commonMistakes': [
                'Rounding the back',
                'Shrugging shoulders up to the ears'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Lunges (Modified)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand tall. Step right foot wide to the side.',
                'Bend the right knee, keeping the left leg straight (shallow lunge).',
                'Push off the right foot to return to center.',
                'Alternate sides, focusing on controlled movement.'
              ],
              'breathingRhythm': 'Inhale on the lunge, exhale on the push back to center',
              'actionFeeling': 'Inner and outer thighs and glutes working',
              'commonMistakes': [
                'Letting the bending knee go past the toes',
                'Leaning forward excessively'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Plank (Knees) with Taps',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Start in plank on your knees (on hands or forearms).',
                'Keep a straight line from head to knees, core tight.',
                'Gently tap the right hand to the left shoulder, then the left hand to the right shoulder.',
                'Alternate taps slowly, maintaining core stillness.'
              ],
              'breathingRhythm': 'Steady, controlled breaths',
              'actionFeeling': 'Core stability challenged by the shoulder movement',
              'commonMistakes': [
                'Letting the hips sway side to side'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Chest Opener (Door Frame or Wall)',
              'duration': 60,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Stand near a doorway. Place forearm on the frame (goalpost position).',
                'Gently step forward, feeling a stretch across the chest and front of the shoulder.',
                'Hold for 30 seconds (adjust to pain-free range, especially post-surgery).',
                'Switch sides.'
              ],
              'breathingRhythm': 'Deep, expansive breaths into the chest',
              'actionFeeling': 'Opening and lengthening of chest muscles',
              'commonMistakes': [
                'Forcing the stretch if range of motion is limited'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },



    {
      'id': 'breast_cancer_4',
      'title': 'Pink Power: Energizing Flow',
      'category': 'breast_cancer',
      'duration': 12,
      'calories': 98,
      'intensity': 'medium',
      'equipment': 'None',
      'focusZones': 'Cardio, Full Body Mobility',
      'imageUrl': 'assets/images/healthy_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Cardio Prep)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Heel Digs and Overhead Reaches (Modified)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Tap right heel forward, then left heel.',
                'Coordinate with alternating overhead reaches (only as high as comfortable).',
                'Keep the pace brisk to raise the heart rate.'
              ],
              'breathingRhythm': 'Active, steady breathing',
              'actionFeeling': 'Hamstrings stretching, shoulders preparing for full range',
              'commonMistakes': [
                'Reaching into a painful range of motion'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Circuit',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Standing Side Crunches (Fast)',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Hands behind head. Bring right elbow to right knee (side crunch).',
                'Alternate sides quickly, keeping balance.',
                'Focus on squeezing the obliques, not leaning forward.'
              ],
              'breathingRhythm': 'Exhale sharply with each crunch',
              'actionFeeling': 'Core and cardio working hard',
              'commonMistakes': [
                'Pulling on the neck'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Step with Arm Circles',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Step touch side to side (quickly).',
                'Add large forward arm circles (30 seconds).',
                'Reverse to large backward arm circles (30 seconds).',
                'Keep arms flowing and coordinated with the steps.'
              ],
              'breathingRhythm': 'Active and consistent breaths',
              'actionFeeling': 'Full body cardio, continuous shoulder movement',
              'commonMistakes': [
                'Stiffening the torso'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Boxer Shuffle with Punches (Low Impact)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Shift weight quickly side-to-side (shuffling bounce).',
                'Throw alternating straight punches (jabs) forward.',
                'Keep punches powerful and rhythmic, engaging the core slightly.'
              ],
              'breathingRhythm': 'Exhale with each punch',
              'actionFeeling': 'Total body endurance, upper body toning',
              'commonMistakes': [
                'Punching too far or locking elbows'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Seated Deep Breathing and Shoulder Drops',
              'duration': 60,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Sit down on the floor or chair. Close eyes.',
                'Inhale, shrug shoulders up. Exhale, let them drop completely.',
                'Take 5 deep recovery breaths, focusing on relaxing the upper body.'
              ],
              'breathingRhythm': 'Slow, cleansing breaths',
              'actionFeeling': 'Calm, rapid relaxation, stress relief',
              'commonMistakes': [
                'Holding tension in the jaw'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },



    {
      'id': 'breast_cancer_5',
      'title': 'Hope & Health: Wellness Session',
      'category': 'breast_cancer',
      'duration': 25,
      'calories': 220,
      'intensity': 'medium',
      'equipment': 'Mat, Light Weights/Cans (optional)',
      'focusZones': 'Lymphatic Flow, Core, Back',
      'imageUrl': 'assets/images/healthy_1.jpeg',
      'isVip': true,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Lymphatic Flow)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Pumping and Marching',
              'duration': 90,
              'rest': 15,
              'reps': null,
              'instructions': [
                'March in place slowly.',
                'Bend elbows at sides. Gently clench and release fists rhythmically.',
                'Add small shoulder shrugs up and down (pumping motion).',
                'This encourages lymphatic movement in the armpits and groin.'
              ],
              'breathingRhythm': 'Slow, natural breaths, coordinating with the gentle pump',
              'actionFeeling': 'Circulation boosting, joints preparing for work',
              'commonMistakes': [
                'Moving too fast or aggressively'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Circuit',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Rear Delt Fly (Light Weight)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand, hinge forward slightly from the hips (flat back).',
                'Arms hanging. Lift arms out and back to the sides, squeezing shoulder blades.',
                'Keep elbows slightly bent. Focus on controlled movement.',
                'Strengthens the often-neglected upper back muscles.'
              ],
              'breathingRhythm': 'Exhale on the lift (squeeze), inhale on the lower',
              'actionFeeling': 'Shoulder stability and upper back working',
              'commonMistakes': [
                'Swinging the weights or rounding the back'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Low Lunge Hip Stretch to Stand',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Step right foot forward into a low lunge (back knee can stay up or tap down).',
                'Hold the lunge for 5 seconds for a hip flexor stretch.',
                'Step back to stand.',
                'Alternate legs slowly, prioritizing the stretch and stability.'
              ],
              'breathingRhythm': 'Inhale on the lunge/stretch, exhale on the stand',
              'actionFeeling': 'Hips opening, lower body strengthening',
              'commonMistakes': [
                'Knee collapsing inward in the lunge'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Plank (Knees or Full)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Lie on your right side, prop up on your right forearm (elbow under shoulder).',
                'Lift hips off the mat (knees bent or legs straight).',
                'Keep core engaged and body in a straight line.',
                'Hold for 20 seconds, then switch sides and repeat.'
              ],
              'breathingRhythm': 'Steady, active breaths',
              'actionFeeling': 'Obliques and outer hip stabilizing strongly',
              'commonMistakes': [
                'Letting hips drop or arching the back'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Supported Spinal Twist (Supine)',
              'duration': 90,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Lie on your back, bring knees to chest, then drop knees to the right.',
                'Rest arms comfortably (T-shape or cactus shape).',
                'Hold the twist for 45 seconds, focusing on deep breathing.',
                'Switch sides and repeat.'
              ],
              'breathingRhythm': 'Deep, tension-releasing breaths into the abdomen',
              'actionFeeling': 'Spinal decompression and profound rest',
              'commonMistakes': [
                'Trying to force the twist deeper'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },



    {
      'id': 'breast_cancer_6',
      'title': 'Survivor Strong: Full Body Blast',
      'category': 'breast_cancer',
      'duration': 30,
      'calories': 267,
      'intensity': 'high',
      'equipment': 'Mat, Chair (optional)',
      'focusZones': 'Endurance, Total Body Strength',
      'imageUrl': 'assets/images/healthy_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up (Dynamic Circuit)',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Modified Jumping Jacks (Fast Taps)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Perform fast No-Jump Jacks (stepping out side-to-side).',
                'Move arms with full range (as comfortable) for 30 seconds.',
                'Switch to high knee marching with arm pumps for 30 seconds.'
              ],
              'breathingRhythm': 'Fast, active breaths',
              'actionFeeling': 'Cardio boost, full body warming up quickly',
              'commonMistakes': [
                'Letting arm movement drop off'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Circuit',
          'setType': 'main',
          'sets': 4,
          'exercises': [
            {
              'exerciseName': 'Squat to Overhead Press (Imaginary/Light)',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Perform one squat. As you stand up, drive arms straight overhead (press).',
                'Lower arms back to the start and repeat the squat.',
                'Focus on linking the leg power to the arm press.'
              ],
              'breathingRhythm': 'Exhale forcefully on the stand and press',
              'actionFeeling': 'Compound movement, full body high-calorie burn',
              'commonMistakes': [
                'Arching the back on the overhead press'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Triceps Kickbacks (Standing, Light Weights)',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Hinge at hips, back flat. Hold light weights (or use resistance).',
                'Keep elbows tucked by your sides. Extend forearms straight back, squeezing triceps.',
                'Return slowly. Control the negative (lowering) phase.'
              ],
              'breathingRhythm': 'Exhale on the extension (squeeze), inhale on the return',
              'actionFeeling': 'Back of arms strengthening intensely',
              'commonMistakes': [
                'Swinging the arms or lifting elbows'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Bicycle Crunch (Fast Tempo)',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Hands behind head. Bring right elbow to left knee, alternating sides rapidly.',
                'Focus on the core twist and speed to keep heart rate high.',
                'Maintain good balance.'
              ],
              'breathingRhythm': 'Exhale sharply with each twist/crunch',
              'actionFeeling': 'Obliques, core, and hip flexors driving the cardio',
              'commonMistakes': [
                'Not twisting the torso enough'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Walk and Deep Breathing',
              'duration': 90,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Walk slowly in place, gradually decreasing knee height.',
                'Perform 1 minute of easy walking, followed by 30 seconds of slow, deep recovery breathing.',
                'Let heart rate return to normal gradually.'
              ],
              'breathingRhythm': 'Slow, measured breaths to calm the nervous system',
              'actionFeeling': 'Complete recovery, sense of strength and calm',
              'commonMistakes': [
                'Stopping movement too abruptly'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },
    // ==================== KNEE FRIENDLY WORKOUTS ====================
    
    {
      'id': 'knee_friendly_1',
      'title': 'Gentle Cardio: Burn Calories, No Jumping',
      'category': 'knee_friendly',
      'duration': 28,
      'calories': 126,
      'intensity': 'low',
      'equipment': 'None',
      'focusZones': 'FullBody',
      'imageUrl': 'assets/images/knee_friendly_1.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Marching in Place',
              'duration': 60,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand tall with feet hip-width apart',
                'Lift your right knee up to hip level',
                'Lower it back down and lift your left knee',
                'Swing your arms naturally as you march',
                'Keep your core engaged and back straight'
              ],
              'breathingRhythm': 'Breathe naturally, inhale through nose, exhale through mouth',
              'actionFeeling': 'You should feel your heart rate gently increasing and muscles warming up',
              'commonMistakes': [
                'Hunching shoulders - keep them relaxed',
                'Lifting knees too high - hip level is sufficient',
                'Holding breath - maintain steady breathing'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Arm Circles',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand with feet shoulder-width apart',
                'Extend arms out to sides at shoulder height',
                'Make small circles forward for 15 seconds',
                'Reverse direction for 15 seconds',
                'Increase circle size gradually'
              ],
              'breathingRhythm': 'Breathe steadily, don\'t hold your breath',
              'actionFeeling': 'Light warming sensation in shoulders and arms',
              'commonMistakes': [
                'Making circles too large too quickly',
                'Tensing shoulders up to ears',
                'Moving too fast'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Side Leg Lifts',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand tall, hold onto a chair for balance',
                'Lift your right leg out to the side, keep it straight',
                'Hold for 1 second at the top',
                'Lower slowly with control',
                'Switch legs halfway through'
              ],
              'breathingRhythm': 'Exhale as you lift, inhale as you lower',
              'actionFeeling': 'Burn in outer thigh and hip muscles',
              'commonMistakes': [
                'Leaning too far to the side',
                'Lifting leg too high - 30-45 degrees is enough',
                'Swinging leg instead of controlled movement'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Modified Wall Push-Ups',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand arm\'s length from a wall',
                'Place palms flat on wall at shoulder height',
                'Bend elbows to lean toward wall',
                'Push back to starting position',
                'Keep core engaged throughout'
              ],
              'breathingRhythm': 'Inhale as you bend elbows, exhale as you push away',
              'actionFeeling': 'Chest, shoulders, and triceps working',
              'commonMistakes': [
                'Arching lower back',
                'Moving too fast',
                'Locking elbows at top'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Step-Touch Side to Side',
              'duration': 50,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand with feet together',
                'Step right foot to side, tap left foot next to it',
                'Step left foot to side, tap right foot next to it',
                'Add arm swings for more cardio',
                'Keep movements smooth and controlled'
              ],
              'breathingRhythm': 'Breathe naturally, steady rhythm',
              'actionFeeling': 'Heart rate elevated, legs and glutes working',
              'commonMistakes': [
                'Steps too wide',
                'Landing heavily on feet',
                'Upper body too stiff'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Seated Knee Extensions',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Sit on edge of chair, back straight',
                'Extend right leg straight out in front',
                'Hold for 2 seconds, flex foot',
                'Lower slowly and switch legs',
                'Alternate legs for duration'
              ],
              'breathingRhythm': 'Exhale as you extend, inhale as you lower',
              'actionFeeling': 'Front of thigh (quadriceps) engaging',
              'commonMistakes': [
                'Slumping in chair',
                'Locking knee joint',
                'Moving too quickly'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Quad Stretch',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand on left leg, hold onto wall for balance',
                'Bend right knee, bring heel toward glutes',
                'Hold right ankle with right hand',
                'Keep knees together, hips square',
                'Hold for 20 seconds each side'
              ],
              'breathingRhythm': 'Deep, slow breaths',
              'actionFeeling': 'Gentle stretch in front of thigh',
              'commonMistakes': [
                'Pulling foot too hard',
                'Arching lower back',
                'Letting knees separate'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Shoulder Rolls and Deep Breaths',
              'duration': 45,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Stand comfortably, arms by sides',
                'Roll shoulders backward in large circles',
                'Take deep breaths in through nose',
                'Exhale slowly through mouth',
                'Let your heart rate gradually return to normal'
              ],
              'breathingRhythm': '4 counts in, 6 counts out',
              'actionFeeling': 'Relaxation, tension release',
              'commonMistakes': [
                'Rushing the breathing',
                'Tensing up instead of relaxing'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'knee_friendly_2',
      'title': 'Leg Sculpt: Tone & Burn Standing',
      'category': 'knee_friendly',
      'duration': 32,
      'calories': 136,
      'intensity': 'low',
      'equipment': 'None',
      'focusZones': 'Lower Body',
      'imageUrl': 'assets/images/knee_friendly_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Ankle Circles',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand on one leg, hold wall for balance',
                'Lift other foot slightly off ground',
                'Rotate ankle in circles - 10 one way',
                'Reverse direction for 10 circles',
                'Switch feet and repeat'
              ],
              'breathingRhythm': 'Breathe naturally and evenly',
              'actionFeeling': 'Ankles loosening up',
              'commonMistakes': [
                'Making circles too small',
                'Not balancing properly'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Hip Circles',
              'duration': 50,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand with hands on hips',
                'Make circular motions with hips',
                'Go clockwise for 15 seconds',
                'Then counterclockwise for 15 seconds',
                'Keep movements smooth and controlled'
              ],
              'breathingRhythm': 'Breathe steadily throughout',
              'actionFeeling': 'Hips warming up and loosening',
              'commonMistakes': [
                'Moving too fast',
                'Making circles too small'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Calf Raises',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand tall, feet hip-width apart',
                'Hold onto chair for balance',
                'Rise up onto toes slowly',
                'Hold at top for 2 seconds',
                'Lower down with control'
              ],
              'breathingRhythm': 'Exhale as you rise, inhale as you lower',
              'actionFeeling': 'Calves burning and working hard',
              'commonMistakes': [
                'Bouncing up and down',
                'Not going high enough on toes',
                'Leaning forward'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Static Squats (Wall Sit)',
              'duration': 30,
              'rest': 25,
              'reps': null,
              'instructions': [
                'Stand with back against wall',
                'Slide down until knees at 90 degrees',
                'Keep back flat against wall',
                'Hold this position',
                'Breathe steadily throughout'
              ],
              'breathingRhythm': 'Steady, controlled breaths',
              'actionFeeling': 'Deep burn in thighs, glutes engaged',
              'commonMistakes': [
                'Knees going past toes',
                'Coming up on toes',
                'Holding breath'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Hip Abduction',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand tall, hold chair with left hand',
                'Lift right leg out to side',
                'Keep toes pointing forward',
                'Lower with control',
                'Switch sides halfway through'
              ],
              'breathingRhythm': 'Exhale on lift, inhale on lower',
              'actionFeeling': 'Outer thigh and hip working',
              'commonMistakes': [
                'Rotating hips',
                'Lifting leg too high',
                'Leaning to side'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Hamstring Stretch',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand with right leg extended forward',
                'Flex right foot, heel on ground',
                'Hinge at hips, reach toward toes',
                'Hold for 20 seconds',
                'Switch legs and repeat'
              ],
              'breathingRhythm': 'Deep breaths, relax into stretch',
              'actionFeeling': 'Gentle stretch back of thigh',
              'commonMistakes': [
                'Rounding back',
                'Bouncing in stretch',
                'Pushing too hard'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Gentle Walking in Place',
              'duration': 60,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Walk slowly in place',
                'Let arms swing naturally',
                'Breathe deeply',
                'Gradually slow down your pace',
                'Let heart rate return to normal'
              ],
              'breathingRhythm': 'Deep, calming breaths',
              'actionFeeling': 'Calm, relaxed, accomplished',
              'commonMistakes': [
                'Stopping too abruptly'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'knee_friendly_3',
      'title': 'Low Impact Power: Joint-Safe Strength',
      'category': 'knee_friendly',
      'duration': 20,
      'calories': 145,
      'intensity': 'medium',
      'equipment': 'Yoga Mat',
      'focusZones': 'FullBody',
      'imageUrl': 'assets/images/knee_friendly_3.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Neck Rolls',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand or sit comfortably',
                'Slowly roll head in circles',
                'Go clockwise for 3 circles',
                'Reverse for 3 circles',
                'Move slowly and gently'
              ],
              'breathingRhythm': 'Breathe naturally throughout',
              'actionFeeling': 'Tension releasing from neck',
              'commonMistakes': [
                'Moving too fast',
                'Forcing the stretch'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Oblique Crunches',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand with hands behind head',
                'Lift right knee toward right elbow',
                'Crunch side to side',
                'Alternate sides',
                'Keep core engaged'
              ],
              'breathingRhythm': 'Exhale on each crunch',
              'actionFeeling': 'Obliques working, core engaged',
              'commonMistakes': [
                'Pulling on neck',
                'Using momentum',
                'Not lifting knee high enough'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Counter Push-Ups',
              'duration': 35,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Place hands on sturdy counter or table',
                'Walk feet back to create angle',
                'Lower chest toward counter',
                'Push back up',
                'Keep body straight'
              ],
              'breathingRhythm': 'Inhale down, exhale up',
              'actionFeeling': 'Chest, arms, and core working',
              'commonMistakes': [
                'Hips sagging',
                'Elbows flaring out too wide',
                'Not going low enough'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Bicycle',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand tall',
                'Bring right elbow to left knee',
                'Alternate sides in pedaling motion',
                'Engage core with each twist',
                'Keep movements controlled'
              ],
              'breathingRhythm': 'Exhale on each twist',
              'actionFeeling': 'Abs and obliques burning',
              'commonMistakes': [
                'Moving too fast',
                'Not rotating fully',
                'Losing balance'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Side Stretch',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand with feet hip-width apart',
                'Reach right arm overhead',
                'Lean to the left',
                'Hold for 20 seconds',
                'Switch sides'
              ],
              'breathingRhythm': 'Deep breaths into stretched side',
              'actionFeeling': 'Gentle stretch along side body',
              'commonMistakes': [
                'Bending forward',
                'Forcing the stretch'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Deep Breathing Exercise',
              'duration': 40,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Stand or sit comfortably',
                'Place hands on belly',
                'Breathe deeply into belly',
                'Feel belly expand',
                'Exhale slowly and fully'
              ],
              'breathingRhythm': '6 counts in, 8 counts out',
              'actionFeeling': 'Calm, centered, recovered',
              'commonMistakes': [
                'Shallow breathing',
                'Rushing'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'knee_friendly_4',
      'title': 'Seated Sculpt: Chair Workout',
      'category': 'knee_friendly',
      'duration': 15,
      'calories': 89,
      'intensity': 'low',
      'equipment': 'Chair',
      'focusZones': 'FullBody',
      'imageUrl': 'assets/images/knee_friendly_1.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Seated Marching',
              'duration': 50,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Sit tall in chair',
                'Lift right knee up',
                'Lower and lift left knee',
                'March in place',
                'Swing arms naturally'
              ],
              'breathingRhythm': 'Breathe naturally',
              'actionFeeling': 'Heart rate gently increasing',
              'commonMistakes': [
                'Slumping in chair',
                'Moving too fast'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Seated Arm Raises',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Sit tall, feet flat on floor',
                'Raise both arms overhead',
                'Lower arms to sides',
                'Repeat with control',
                'Keep core engaged'
              ],
              'breathingRhythm': 'Exhale up, inhale down',
              'actionFeeling': 'Shoulders and arms working',
              'commonMistakes': [
                'Arching back',
                'Rushing movements',
                'Slouching'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Seated Knee Extensions',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Sit on edge of chair',
                'Extend right leg straight',
                'Hold for 2 seconds',
                'Lower and switch',
                'Alternate legs'
              ],
              'breathingRhythm': 'Exhale on extend, inhale on lower',
              'actionFeeling': 'Quadriceps engaging',
              'commonMistakes': [
                'Locking knee',
                'Moving too fast',
                'Slumping'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Seated Torso Twists',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Sit tall, hands behind head',
                'Twist torso to right',
                'Return to center',
                'Twist to left',
                'Keep hips facing forward'
              ],
              'breathingRhythm': 'Exhale on each twist',
              'actionFeeling': 'Obliques and core working',
              'commonMistakes': [
                'Moving hips',
                'Twisting too fast',
                'Not sitting tall'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Seated Shoulder Rolls',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Sit comfortably',
                'Roll shoulders back in circles',
                'Do 5 backward rolls',
                'Then 5 forward rolls',
                'Breathe deeply'
              ],
              'breathingRhythm': 'Deep, steady breaths',
              'actionFeeling': 'Tension releasing',
              'commonMistakes': [
                'Moving too fast',
                'Shallow breathing'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Seated Breathing',
              'duration': 35,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Sit tall, eyes closed',
                'Breathe deeply',
                'Inhale through nose',
                'Exhale through mouth',
                'Feel completely relaxed'
              ],
              'breathingRhythm': '5 counts in, 7 counts out',
              'actionFeeling': 'Calm and recovered',
              'commonMistakes': [
                'Rushing',
                'Not breathing deeply'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'knee_friendly_5',
      'title': 'Safe & Strong: Beginner Friendly',
      'category': 'knee_friendly',
      'duration': 18,
      'calories': 112,
      'intensity': 'low',
      'equipment': 'None',
      'focusZones': 'FullBody',
      'imageUrl': 'assets/images/knee_friendly_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Shoulder Shrugs',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Stand comfortably',
                'Lift shoulders toward ears',
                'Hold for 2 seconds',
                'Release and lower',
                'Repeat smoothly'
              ],
              'breathingRhythm': 'Inhale up, exhale down',
              'actionFeeling': 'Shoulders loosening',
              'commonMistakes': [
                'Tensing neck',
                'Moving too fast'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Standing Alternating Knee Lifts',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand tall',
                'Lift right knee to hip height',
                'Lower with control',
                'Lift left knee',
                'Alternate smoothly'
              ],
              'breathingRhythm': 'Breathe naturally',
              'actionFeeling': 'Core engaged, legs working',
              'commonMistakes': [
                'Lifting knee too high',
                'Losing balance',
                'Slouching'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Arm Punches',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand with feet shoulder-width',
                'Punch right arm forward',
                'Pull back, punch left',
                'Alternate arms quickly',
                'Add slight twist for power'
              ],
              'breathingRhythm': 'Exhale on each punch',
              'actionFeeling': 'Shoulders, arms, and core working',
              'commonMistakes': [
                'Locking elbows',
                'Not engaging core',
                'Punching too high'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Back Extensions',
              'duration': 35,
              'rest': 20,
              'reps': null,
              'instructions': [
                'Stand with hands on lower back',
                'Gently arch backwards',
                'Hold for 2 seconds',
                'Return to neutral',
                'Keep movement controlled'
              ],
              'breathingRhythm': 'Inhale on arch, exhale on return',
              'actionFeeling': 'Lower back gently working',
              'commonMistakes': [
                'Arching too far',
                'Moving too fast',
                'Not supporting lower back'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Full Body Stretch',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Stand tall, reach arms overhead',
                'Stretch up as high as you can',
                'Hold for 5 seconds',
                'Lower arms and relax',
                'Repeat 3 times'
              ],
              'breathingRhythm': 'Deep breath in on reach',
              'actionFeeling': 'Full body lengthening',
              'commonMistakes': [
                'Holding breath',
                'Arching back too much'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Relaxation Standing',
              'duration': 40,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Stand with feet hip-width',
                'Let arms hang loosely',
                'Close eyes',
                'Breathe deeply',
                'Let tension melt away'
              ],
              'breathingRhythm': '6 counts in, 8 counts out',
              'actionFeeling': 'Complete relaxation',
              'commonMistakes': [
                'Rushing',
                'Shallow breathing'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'knee_friendly_6',
      'title': 'Knee Relief: Gentle Movement',
      'category': 'knee_friendly',
      'duration': 12,
      'calories': 67,
      'intensity': 'low',
      'equipment': 'Yoga Mat',
      'focusZones': 'Lower Body',
      'imageUrl': 'assets/images/knee_friendly_3.jpeg',
      'isVip': true,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Leg Swings',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Hold onto wall for support',
                'Gently swing right leg forward and back',
                'Keep movements small and controlled',
                'Do 10 swings',
                'Switch legs'
              ],
              'breathingRhythm': 'Breathe naturally',
              'actionFeeling': 'Hips and legs warming gently',
              'commonMistakes': [
                'Swinging too high',
                'Moving too fast'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Supine Knee Bends',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Lie on back on mat',
                'Slowly bend right knee, slide foot up',
                'Straighten leg back out',
                'Alternate legs',
                'Move gently and controlled'
              ],
              'breathingRhythm': 'Breathe naturally',
              'actionFeeling': 'Knees moving gently, no pain',
              'commonMistakes': [
                'Bending too far',
                'Moving too fast',
                'Forcing the movement'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Ankle Pumps',
              'duration': 35,
              'rest': 15,
              'reps': null,
              'instructions': [
                'Lie on back, legs extended',
                'Point toes away from you',
                'Flex toes back toward you',
                'Alternate smoothly',
                'Feel calves working gently'
              ],
              'breathingRhythm': 'Breathe steadily',
              'actionFeeling': 'Circulation improving in legs',
              'commonMistakes': [
                'Moving too fast',
                'Not fully flexing/pointing'
              ],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Gentle Knee to Chest',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': [
                'Lie on back',
                'Gently bring right knee to chest',
                'Hold for 15 seconds',
                'Lower and switch',
                'Move very gently'
              ],
              'breathingRhythm': 'Deep, relaxing breaths',
              'actionFeeling': 'Gentle stretch in hips and lower back',
              'commonMistakes': [
                'Pulling too hard',
                'Forcing the stretch'
              ],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Supine Relaxation',
              'duration': 40,
              'rest': 0,
              'reps': null,
              'instructions': [
                'Lie flat on back',
                'Let legs and arms relax completely',
                'Close eyes',
                'Breathe deeply',
                'Feel completely at ease'
              ],
              'breathingRhythm': '7 counts in, 9 counts out',
              'actionFeeling': 'Complete relaxation and relief',
              'commonMistakes': [
                'Tensing up',
                'Not breathing deeply'
              ],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    // ==================== BELLY WORKOUTS ====================
    
    {
      'id': 'belly_1',
      'title': 'Core Awakening: Prep for Progress',
      'category': 'belly',
      'duration': 21,
      'calories': 184,
      'intensity': 'medium',
      'equipment': 'Yoga Mat',
      'focusZones': 'Core',
      'imageUrl': 'assets/images/belly_1.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Cat-Cow Stretches',
              'duration': 50,
              'rest': 10,
              'reps': null,
              'instructions': ['Start on hands and knees', 'Arch back and look up (cow pose)', 'Round back and tuck chin (cat pose)', 'Flow between positions smoothly', 'Focus on spinal movement'],
              'breathingRhythm': 'Inhale on cow, exhale on cat',
              'actionFeeling': 'Spine warming up and loosening',
              'commonMistakes': ['Moving too fast', 'Not engaging core', 'Forgetting to breathe'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Torso Twists Standing',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand with feet shoulder-width apart', 'Place hands behind head', 'Rotate torso left and right', 'Keep hips facing forward', 'Move with control, not momentum'],
              'breathingRhythm': 'Exhale on each twist',
              'actionFeeling': 'Obliques and core warming',
              'commonMistakes': ['Twisting hips instead of torso', 'Moving too fast', 'Hunching shoulders'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Dead Bug',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': ['Lie on back, arms extended toward ceiling', 'Lift knees to 90 degrees', 'Lower right arm and left leg simultaneously', 'Return to start, switch sides', 'Keep lower back pressed to mat'],
              'breathingRhythm': 'Exhale as you extend, inhale as you return',
              'actionFeeling': 'Deep core engagement throughout',
              'commonMistakes': ['Lower back arching off mat', 'Moving too quickly', 'Not fully extending limbs'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Bird Dog',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': ['Start on hands and knees', 'Extend right arm forward and left leg back', 'Hold for 3 seconds, keeping balance', 'Return to start, switch sides', 'Keep hips level throughout'],
              'breathingRhythm': 'Breathe steadily, don\'t hold breath',
              'actionFeeling': 'Core stabilizing, back and glutes working',
              'commonMistakes': ['Hips rotating', 'Arching or rounding back', 'Lifting limbs too high'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Modified Plank Hold',
              'duration': 30,
              'rest': 25,
              'reps': null,
              'instructions': ['Start on forearms and knees', 'Keep body in straight line from head to knees', 'Engage core, don\'t let hips sag', 'Hold this position', 'Breathe steadily throughout'],
              'breathingRhythm': 'Steady breathing, don\'t hold breath',
              'actionFeeling': 'Entire core engaged and burning',
              'commonMistakes': ['Hips sagging', 'Hips too high', 'Not breathing', 'Looking up instead of down'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Bicycle Crunches',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Lie on back, hands behind head', 'Lift shoulders off mat', 'Bring right elbow to left knee', 'Switch sides in pedaling motion', 'Keep lower back on mat'],
              'breathingRhythm': 'Exhale on each crunch',
              'actionFeeling': 'Abs burning, obliques working',
              'commonMistakes': ['Pulling on neck', 'Moving too fast', 'Not fully rotating'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Child\'s Pose',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': ['Kneel on mat, sit back on heels', 'Extend arms forward on mat', 'Lower forehead toward mat', 'Breathe deeply', 'Feel stretch in lower back'],
              'breathingRhythm': 'Deep, slow breaths',
              'actionFeeling': 'Lower back and core releasing',
              'commonMistakes': ['Rushing through the stretch', 'Not breathing deeply'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Lying Spinal Twist',
              'duration': 50,
              'rest': 0,
              'reps': null,
              'instructions': ['Lie on back, extend arms out', 'Bring both knees to chest', 'Lower knees to right side', 'Hold for 20 seconds', 'Switch to left side'],
              'breathingRhythm': 'Deep breaths, relax into stretch',
              'actionFeeling': 'Gentle release in spine and core',
              'commonMistakes': ['Forcing the stretch', 'Lifting shoulder off mat'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'belly_2',
      'title': 'Flat Abs Focus: Easy Start',
      'category': 'belly',
      'duration': 14,
      'calories': 84,
      'intensity': 'low',
      'equipment': 'Yoga Mat',
      'focusZones': 'Abs',
      'imageUrl': 'assets/images/belly_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Side Bends',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': ['Stand with feet hip-width apart', 'Place left hand on hip, raise right arm overhead', 'Bend to the left side', 'Return to center, switch sides', 'Move slowly and controlled'],
              'breathingRhythm': 'Exhale as you bend, inhale as you return',
              'actionFeeling': 'Gentle stretch along side body',
              'commonMistakes': ['Bending forward or backward', 'Forcing the stretch', 'Moving too quickly'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Heel Touches',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Lie on back, knees bent, feet flat', 'Lift shoulders slightly off mat', 'Reach right hand toward right heel', 'Switch sides', 'Alternate quickly'],
              'breathingRhythm': 'Exhale on each reach',
              'actionFeeling': 'Obliques burning, abs engaged',
              'commonMistakes': ['Pulling on neck', 'Not crunching up enough', 'Moving just arms, not torso'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Reverse Crunches',
              'duration': 35,
              'rest': 15,
              'reps': null,
              'instructions': ['Lie on back, knees bent at 90 degrees', 'Lift hips off mat toward ceiling', 'Lower hips back down with control', 'Keep upper body still', 'Focus on lower abs'],
              'breathingRhythm': 'Exhale as you lift, inhale as you lower',
              'actionFeeling': 'Lower abs contracting and burning',
              'commonMistakes': ['Using momentum instead of control', 'Swinging legs', 'Not lifting hips high enough'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Toe Taps',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Lie on back, legs raised at 90 degrees', 'Lower right foot to tap mat', 'Return to start', 'Switch legs', 'Keep lower back pressed to mat'],
              'breathingRhythm': 'Exhale on each tap',
              'actionFeeling': 'Lower abs working to control movement',
              'commonMistakes': ['Lower back arching', 'Moving too fast', 'Legs not straight'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Knees to Chest Stretch',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': ['Lie on back', 'Bring both knees to chest', 'Wrap arms around shins', 'Gently rock side to side', 'Breathe deeply'],
              'breathingRhythm': 'Deep, relaxing breaths',
              'actionFeeling': 'Lower back and core releasing',
              'commonMistakes': ['Pulling knees too hard', 'Tensing shoulders'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Supine Breathing',
              'duration': 35,
              'rest': 0,
              'reps': null,
              'instructions': ['Lie flat on back, arms at sides', 'Close eyes', 'Breathe deeply into belly', 'Feel belly rise and fall', 'Let your body completely relax'],
              'breathingRhythm': '5 counts in, 7 counts out',
              'actionFeeling': 'Complete relaxation and recovery',
              'commonMistakes': ['Shallow breathing', 'Rushing the cooldown'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'belly_3',
      'title': 'Belly Burner: Intense Core Blast',
      'category': 'belly',
      'duration': 18,
      'calories': 156,
      'intensity': 'high',
      'equipment': 'None',
      'focusZones': 'Core',
      'imageUrl': 'assets/images/belly_3.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Knee to Elbow',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand tall, hands behind head', 'Bring right knee to left elbow', 'Crunch to the side', 'Alternate sides', 'Engage core with each crunch'],
              'breathingRhythm': 'Exhale on crunch',
              'actionFeeling': 'Core warming up, heart rate rising',
              'commonMistakes': ['Not engaging core', 'Pulling on neck', 'Moving too fast'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Mountain Climbers',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Start in high plank position', 'Drive right knee toward chest', 'Quickly switch legs', 'Keep hips level', 'Move as fast as you can'],
              'breathingRhythm': 'Quick breaths matching pace',
              'actionFeeling': 'Abs burning, heart pounding',
              'commonMistakes': ['Hips too high', 'Not bringing knees far enough', 'Losing form'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Russian Twists',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': ['Sit with knees bent, feet slightly off ground', 'Lean back slightly', 'Twist torso left and right', 'Touch floor beside you each side', 'Keep core tight'],
              'breathingRhythm': 'Exhale on each twist',
              'actionFeeling': 'Obliques on fire, core shaking',
              'commonMistakes': ['Slouching', 'Moving just arms', 'Feet touching ground'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Plank to Downward Dog',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Start in high plank', 'Push hips up to downward dog', 'Return to plank', 'Move with control', 'Keep core engaged'],
              'breathingRhythm': 'Inhale in plank, exhale to dog',
              'actionFeeling': 'Full core engagement, hamstrings stretching',
              'commonMistakes': ['Sagging in plank', 'Not pushing hips high enough', 'Forgetting to breathe'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Cobra Stretch',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': ['Lie face down', 'Place hands under shoulders', 'Lift chest off mat', 'Keep hips on ground', 'Feel stretch in abs'],
              'breathingRhythm': 'Deep breaths into belly',
              'actionFeeling': 'Gentle stretch releasing tight abs',
              'commonMistakes': ['Lifting too high', 'Tensing shoulders', 'Holding breath'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Seated Forward Fold',
              'duration': 50,
              'rest': 0,
              'reps': null,
              'instructions': ['Sit with legs extended', 'Reach forward toward toes', 'Relax into stretch', 'Breathe deeply', 'Let tension melt away'],
              'breathingRhythm': 'Long, slow breaths',
              'actionFeeling': 'Hamstrings and lower back releasing',
              'commonMistakes': ['Bouncing', 'Rounding back too much', 'Forcing it'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'belly_4',
      'title': 'Abs Revolution: 10-Day Challenge',
      'category': 'belly',
      'duration': 25,
      'calories': 198,
      'intensity': 'high',
      'equipment': 'Yoga Mat',
      'focusZones': 'Core',
      'imageUrl': 'assets/images/belly_1.jpeg',
      'isVip': true,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Jumping Jacks',
              'duration': 50,
              'rest': 10,
              'reps': null,
              'instructions': ['Start with feet together', 'Jump feet out, raise arms overhead', 'Jump back to start', 'Keep a steady rhythm', 'Land softly'],
              'breathingRhythm': 'Breathe naturally with movement',
              'actionFeeling': 'Heart rate rising, body warming',
              'commonMistakes': ['Landing too hard', 'Arms not fully extended', 'Going too fast'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'High Knees',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Run in place', 'Drive knees up high', 'Pump arms', 'Move quickly', 'Stay on balls of feet'],
              'breathingRhythm': 'Quick breaths matching pace',
              'actionFeeling': 'Heart pounding, ready to work',
              'commonMistakes': ['Knees not high enough', 'Slowing down', 'Flat-footed'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Full Plank Hold',
              'duration': 45,
              'rest': 20,
              'reps': null,
              'instructions': ['High plank on hands', 'Body straight from head to heels', 'Engage entire core', 'Don\'t let hips sag', 'Hold strong'],
              'breathingRhythm': 'Steady, controlled breathing',
              'actionFeeling': 'Entire body shaking, core on fire',
              'commonMistakes': ['Hips sagging', 'Hips too high', 'Holding breath', 'Hands too wide'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'V-Ups',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Lie flat, arms overhead', 'Simultaneously lift legs and torso', 'Touch hands to feet in V position', 'Lower with control', 'Repeat'],
              'breathingRhythm': 'Exhale on crunch up, inhale down',
              'actionFeeling': 'Intense ab burn, full core activation',
              'commonMistakes': ['Using momentum', 'Not reaching toes', 'Neck strain'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Plank Right',
              'duration': 30,
              'rest': 15,
              'reps': null,
              'instructions': ['Lie on right side', 'Prop up on right elbow', 'Lift hips off ground', 'Hold straight line', 'Engage obliques'],
              'breathingRhythm': 'Steady breathing',
              'actionFeeling': 'Right obliques burning intensely',
              'commonMistakes': ['Hips sagging', 'Rolling forward or back', 'Not breathing'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Plank Left',
              'duration': 30,
              'rest': 15,
              'reps': null,
              'instructions': ['Switch to left side', 'Prop on left elbow', 'Lift hips', 'Hold the line', 'Feel the burn'],
              'breathingRhythm': 'Steady breathing',
              'actionFeeling': 'Left obliques screaming',
              'commonMistakes': ['Hips dropping', 'Poor alignment', 'Forgetting to breathe'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Burpees',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Start standing', 'Drop to plank', 'Do push-up', 'Jump feet forward', 'Jump up with arms overhead'],
              'breathingRhythm': 'Exhale on push-up and jump',
              'actionFeeling': 'Full body exhaustion, abs working hard',
              'commonMistakes': ['Skipping push-up', 'Not jumping high', 'Poor plank form'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Extended Child\'s Pose',
              'duration': 50,
              'rest': 10,
              'reps': null,
              'instructions': ['Kneel, sit on heels', 'Walk hands far forward', 'Lower chest toward mat', 'Feel deep stretch', 'Breathe into back'],
              'breathingRhythm': 'Deep, slow breaths',
              'actionFeeling': 'Deep release in entire core and back',
              'commonMistakes': ['Not reaching far enough', 'Shallow breathing'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Happy Baby Pose',
              'duration': 50,
              'rest': 0,
              'reps': null,
              'instructions': ['Lie on back', 'Bring knees to chest', 'Grab outside of feet', 'Pull knees toward armpits', 'Rock gently'],
              'breathingRhythm': 'Relaxed breathing',
              'actionFeeling': 'Lower back and hips releasing',
              'commonMistakes': ['Pulling too hard', 'Tensing up', 'Not relaxing'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'belly_5',
      'title': 'Waist Sculptor: Side Obliques',
      'category': 'belly',
      'duration': 16,
      'calories': 124,
      'intensity': 'medium',
      'equipment': 'None',
      'focusZones': 'Obliques',
      'imageUrl': 'assets/images/belly_2.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Windmill Stretches',
              'duration': 45,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand with feet wide', 'Extend arms out to sides', 'Reach right hand to left foot', 'Alternate sides', 'Twist through torso'],
              'breathingRhythm': 'Exhale on reach',
              'actionFeeling': 'Obliques warming, hamstrings stretching',
              'commonMistakes': ['Bending knees', 'Not rotating torso', 'Moving too fast'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 3,
          'exercises': [
            {
              'exerciseName': 'Standing Side Crunches',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Stand with hands behind head', 'Lift right knee to right elbow', 'Crunch to the side', 'Lower and repeat', 'Switch sides halfway'],
              'breathingRhythm': 'Exhale on crunch',
              'actionFeeling': 'Obliques contracting hard',
              'commonMistakes': ['Not crunching side enough', 'Pulling on neck', 'Using momentum'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Oblique Crunches Right',
              'duration': 35,
              'rest': 15,
              'reps': null,
              'instructions': ['Lie on back, knees bent', 'Drop knees to right side', 'Hands behind head', 'Crunch up', 'Focus on right obliques'],
              'breathingRhythm': 'Exhale on crunch',
              'actionFeeling': 'Right side obliques burning',
              'commonMistakes': ['Pulling on neck', 'Not crunching high enough', 'Using hands'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Oblique Crunches Left',
              'duration': 35,
              'rest': 15,
              'reps': null,
              'instructions': ['Drop knees to left', 'Same crunch position', 'Lift shoulders off mat', 'Feel left obliques work', 'Control the movement'],
              'breathingRhythm': 'Exhale on crunch',
              'actionFeeling': 'Left obliques on fire',
              'commonMistakes': ['Rushing', 'Not crunching fully', 'Neck strain'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Side Bends',
              'duration': 40,
              'rest': 20,
              'reps': null,
              'instructions': ['Stand, arms by sides', 'Slide right hand down right leg', 'Feel left side stretch', 'Return to center', 'Alternate sides'],
              'breathingRhythm': 'Exhale on bend',
              'actionFeeling': 'Obliques stretching and contracting',
              'commonMistakes': ['Bending forward', 'Not going low enough', 'Moving too fast'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Lying Side Stretch',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': ['Lie on back', 'Extend right arm overhead', 'Reach left hand to right side', 'Feel stretch along right side', 'Hold 20 seconds, switch'],
              'breathingRhythm': 'Deep breaths into stretched side',
              'actionFeeling': 'Obliques releasing and lengthening',
              'commonMistakes': ['Not breathing into stretch', 'Forcing it'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Supine Twist',
              'duration': 45,
              'rest': 0,
              'reps': null,
              'instructions': ['Bring knees to chest', 'Drop both knees right', 'Keep shoulders flat', 'Hold 20 seconds', 'Switch sides'],
              'breathingRhythm': 'Deep, relaxing breaths',
              'actionFeeling': 'Gentle release through obliques and spine',
              'commonMistakes': ['Forcing knees down', 'Lifting shoulders'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    {
      'id': 'belly_6',
      'title': 'Tummy Toner: Standing Abs',
      'category': 'belly',
      'duration': 12,
      'calories': 92,
      'intensity': 'low',
      'equipment': 'None',
      'focusZones': 'Abs',
      'imageUrl': 'assets/images/belly_3.jpeg',
      'isVip': false,
      'workoutSets': [
        {
          'setTitle': 'Warm Up',
          'setType': 'warmup',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Torso Circles',
              'duration': 40,
              'rest': 10,
              'reps': null,
              'instructions': ['Stand with hands on hips', 'Circle torso clockwise', 'Make circles large', 'Reverse direction', 'Keep hips still'],
              'breathingRhythm': 'Breathe naturally',
              'actionFeeling': 'Core warming, loosening up',
              'commonMistakes': ['Moving hips', 'Circles too small', 'Going too fast'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Main Workout',
          'setType': 'main',
          'sets': 2,
          'exercises': [
            {
              'exerciseName': 'Standing Cross-Body Crunches',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand, hands behind head', 'Bring right elbow to left knee', 'Crunch across body', 'Alternate sides', 'Engage core each time'],
              'breathingRhythm': 'Exhale on crunch',
              'actionFeeling': 'Abs and obliques working',
              'commonMistakes': ['Not crunching enough', 'Just moving limbs', 'No core engagement'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Knee Raises',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand tall', 'Lift right knee high', 'Lower with control', 'Alternate legs', 'Keep core tight'],
              'breathingRhythm': 'Exhale on lift',
              'actionFeeling': 'Lower abs activating',
              'commonMistakes': ['Not lifting high enough', 'Leaning back', 'Losing balance'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Wood Chops',
              'duration': 40,
              'rest': 15,
              'reps': null,
              'instructions': ['Stand with feet wide', 'Clasp hands together', 'Swing from high right to low left', 'Like chopping wood', 'Switch directions halfway'],
              'breathingRhythm': 'Exhale on chop down',
              'actionFeeling': 'Obliques and core working',
              'commonMistakes': ['Using just arms', 'Not rotating torso', 'Moving too fast'],
              'thumbnailUrl': null
            }
          ]
        },
        {
          'setTitle': 'Cool Down',
          'setType': 'cooldown',
          'sets': 1,
          'exercises': [
            {
              'exerciseName': 'Standing Forward Fold',
              'duration': 45,
              'rest': 10,
              'reps': null,
              'instructions': ['Stand, hinge at hips', 'Let upper body hang down', 'Relax neck and shoulders', 'Breathe deeply', 'Feel hamstrings and lower back stretch'],
              'breathingRhythm': 'Deep breaths',
              'actionFeeling': 'Full body release',
              'commonMistakes': ['Bouncing', 'Tensing up', 'Locking knees'],
              'thumbnailUrl': null
            },
            {
              'exerciseName': 'Standing Recovery Breathing',
              'duration': 40,
              'rest': 0,
              'reps': null,
              'instructions': ['Stand comfortably', 'Arms relaxed', 'Breathe deeply', 'Let heart rate settle', 'Feel accomplished'],
              'breathingRhythm': '6 counts in, 8 counts out',
              'actionFeeling': 'Calm, recovered, proud',
              'commonMistakes': ['Rushing', 'Not breathing fully'],
              'thumbnailUrl': null
            }
          ]
        }
      ]
    },

    // ==================== PLUS-SIZE FRIENDLY WORKOUTS ====================

{
  'id': 'plus_size_1',
  'title': 'Leg Power Boost: Safe Sculpting for Beginners',
  'category': 'plus_size',
  'duration': 28,
  'calories': 111,
  'intensity': 'low',
  'equipment': 'Chair or Wall',
  'focusZones': 'Lower Body',
  'imageUrl': 'assets/images/plus_size_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Ankle Circles & Calf Pumps',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on a chair, feet flat on the floor.',
            'Lift right foot slightly and rotate ankle 30 seconds clockwise, then counter-clockwise.',
            'Switch legs and repeat.',
            'Alternate pointing toes away and flexing them back (pumps).'
          ],
          'breathingRhythm': 'Breathe naturally and evenly',
          'actionFeeling': 'Warming up feet and lower legs, improving circulation',
          'commonMistakes': [
            'Slouching in the chair',
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Arm Circles',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Remain seated, extend arms out to the sides at shoulder height.',
            'Make small circles forward for 15 seconds.',
            'Reverse direction for 15 seconds.',
            'Keep shoulders relaxed.'
          ],
          'breathingRhythm': 'Breathe steadily, deep belly breaths',
          'actionFeeling': 'Light warming sensation in shoulders and arms',
          'commonMistakes': [
            'Making circles too large too quickly',
            'Tensing shoulders up to ears'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Supported Mini Squats (Chair Tap)',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand in front of a sturdy chair, feet hip-width apart.',
            'Hold the back of the chair lightly for balance.',
            'Lower your hips back and down until you *just* tap the chair seat.',
            'Push through your heels to return to standing.',
            'Keep chest up and knees tracking over toes.'
          ],
          'breathingRhythm': 'Exhale as you stand up, inhale as you lower down',
          'actionFeeling': 'Glutes and thighs engaging, focus on a comfortable range of motion',
          'commonMistakes': [
            'Letting knees collapse inward',
            'Leaning too far forward',
            'Bouncing off the chair'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Rear Leg Lifts (Hold Chair)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, holding onto a chair for balance.',
            'Lift one leg straight behind you, squeezing your glute.',
            'Only lift as high as comfortable, keeping back straight.',
            'Lower slowly with control.',
            'Switch legs halfway through.'
          ],
          'breathingRhythm': 'Exhale as you lift, inhale as you lower',
          'actionFeeling': 'Gentle squeeze in the glutes and lower back',
          'commonMistakes': [
            'Arching your lower back',
            'Swinging the leg instead of controlled movement'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Knee Extensions',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Sit on edge of chair, back straight.',
            'Extend right leg straight out in front, flex foot.',
            'Hold for 2 seconds, squeezing the quad.',
            'Lower slowly and switch legs.',
            'Alternate legs for duration.'
          ],
          'breathingRhythm': 'Exhale as you extend, inhale as you lower',
          'actionFeeling': 'Front of thigh (quadriceps) engaging, helping stabilize the knee',
          'commonMistakes': [
            'Slumping in chair',
            'Locking knee joint'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Figure-Four Glute Stretch',
          'duration': 45,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Sit tall on a chair.',
            'Cross your right ankle over your left knee.',
            'Gently lean forward slightly for a deeper stretch (only if comfortable).',
            'Hold for 20 seconds, then switch sides.',
            'Keep your back straight.'
          ],
          'breathingRhythm': 'Deep, slow breaths, relax into the stretch',
          'actionFeeling': 'Gentle stretch in the outer hip and glute of the crossed leg',
          'commonMistakes': [
            'Rounding the back',
            'Forcing the knee down'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Overhead Arm Stretch & Deep Breaths',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Remain seated, interlace fingers and reach arms straight overhead.',
            'Gently stretch side to side.',
            'Inhale deeply through the nose.',
            'Exhale slowly through the mouth.'
          ],
          'breathingRhythm': 'Focus on long, slow exhales',
          'actionFeeling': 'Relaxation, heart rate returning to normal',
          'commonMistakes': [
            'Holding breath',
            'Tensing shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'plus_size_2',
  'title': 'Strong Back: Friendly for Plus-Size',
  'category': 'plus_size',
  'duration': 30,
  'calories': 129,
  'intensity': 'low',
  'equipment': 'Chair or Wall',
  'focusZones': 'Core, Back, Shoulders',
  'imageUrl': 'assets/images/plus_size_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Shoulder Blade Squeezes (Seated)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, arms relaxed by your sides.',
            'Gently pinch your shoulder blades together as if holding a pencil.',
            'Hold the squeeze for 2 seconds.',
            'Release slowly.',
            'Keep your chin level and shoulders down.'
          ],
          'breathingRhythm': 'Breathe naturally, don’t hold your breath during the squeeze',
          'actionFeeling': 'Mid-back muscles warming up',
          'commonMistakes': [
            'Hunching shoulders up to ears',
            'Arching lower back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Torso Twists (Small Range)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hands gently on hips or crossed on chest.',
            'Slowly twist your torso to the right, looking over your shoulder.',
            'Return to center.',
            'Slowly twist to the left.',
            'Keep hips still.'
          ],
          'breathingRhythm': 'Exhale on the twist, inhale on return',
          'actionFeeling': 'Gentle warming in the core and sides of the back',
          'commonMistakes': [
            'Moving too fast or jerking',
            'Twisting hips'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Wall Push-Ups (or Counter Push-Ups)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand arm’s length from a sturdy wall or counter.',
            'Place palms flat on wall/counter at shoulder height and width.',
            'Bend elbows to lean your chest toward the surface.',
            'Push back to starting position.',
            'Keep core engaged and body in a straight line.'
          ],
          'breathingRhythm': 'Inhale as you lower, exhale as you push away',
          'actionFeeling': 'Chest, shoulders, and triceps working, without putting pressure on the back',
          'commonMistakes': [
            'Arching the lower back',
            'Locking elbows at the top'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Alternating Bird-Dog (Modified)',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, facing the back of a chair for balance.',
            'Extend your right arm forward as you lift your left leg slightly behind you.',
            'Keep core tight and hips level.',
            'Return and alternate, extending left arm and right leg.',
            'Focus on stability, not height.'
          ],
          'breathingRhythm': 'Exhale as you extend, inhale as you return',
          'actionFeeling': 'Core, glutes, and back working for stability',
          'commonMistakes': [
            'Arching the back',
            'Lifting the leg too high and losing hip alignment'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Row (Imaginary)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width, soft bend in knees.',
            'Hinge slightly forward from the hips (keep back straight).',
            'Pretend to hold weights. Pull elbows back, squeezing shoulder blades together.',
            'Extend arms back out with control.',
            'Avoid rounding the upper back.'
          ],
          'breathingRhythm': 'Exhale as you pull elbows back, inhale as you extend',
          'actionFeeling': 'Upper back muscles (lats and rhomboids) working',
          'commonMistakes': [
            'Pulling with your neck/shoulders',
            'Rounding your spine'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wall Chest Stretch',
          'duration': 45,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Stand next to a wall, place right palm flat on wall at shoulder height.',
            'Gently turn your body away from the arm until you feel a stretch across your chest and front of shoulder.',
            'Hold for 20 seconds, then switch sides.',
            'Keep shoulders relaxed.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Release of tension across the chest and shoulders',
          'commonMistakes': [
            'Leaning too far and forcing the stretch'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Cat-Cow Flow',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand with a slight bend in the knees, hands resting on thighs.',
            'Inhale: Arch your back slightly, looking up (Cow Pose).',
            'Exhale: Round your back, tucking chin and pelvis (Cat Pose).',
            'Move slowly, coordinating breath with movement.'
          ],
          'breathingRhythm': 'Inhale on the arch, exhale on the round',
          'actionFeeling': 'Gentle mobility and release in the spine',
          'commonMistakes': [
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'plus_size_3',
  'title': 'Confident Curves: Full Body Flow',
  'category': 'plus_size',
  'duration': 22,
  'calories': 167,
  'intensity': 'medium',
  'equipment': 'Yoga Mat (optional)',
  'focusZones': 'Full Body',
  'imageUrl': 'assets/images/plus_size_3.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Gentle March in Place with Arm Swings',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width apart.',
            'Gently lift one knee, then the other, marching in place.',
            'Add gentle arm swings forward and back.',
            'Focus on soft landings.',
            'Keep your core gently engaged.'
          ],
          'breathingRhythm': 'Breathe naturally, inhale through nose, exhale through mouth',
          'actionFeeling': 'Heart rate gently increasing and muscles warming up',
          'commonMistakes': [
            'Lifting knees too high initially',
            'Landing heavily'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Side Reaches (Standing)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width apart.',
            'Reach right arm overhead and gently lean to the left.',
            'Return to center.',
            'Repeat on the opposite side.',
            'Alternate smoothly.'
          ],
          'breathingRhythm': 'Exhale on the lean, inhale on return',
          'actionFeeling': 'Warming up side body and shoulders',
          'commonMistakes': [
            'Bending forward or backward'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Side Step with Arm Raise',
          'duration': 50,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Start with feet together.',
            'Step right foot out, raise arms out to sides up to shoulder height.',
            'Step feet back together, lower arms.',
            'Repeat on the left side, alternating.',
            'Focus on a slow, controlled step.'
          ],
          'breathingRhythm': 'Inhale on step out, exhale on return to center',
          'actionFeeling': 'Glutes, legs, and shoulders working, light cardio',
          'commonMistakes': [
            'Steps too wide',
            'Rushing the arms'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Incline Push-Ups (Wall or Counter)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Refer to "Wall Push-Ups" instructions in workout 2, using a counter if you feel stronger.',
            'The lower the surface (closer to the ground), the harder the exercise.',
            'Maintain a neutral spine and controlled movement.'
          ],
          'breathingRhythm': 'Inhale as you lower, exhale as you push away',
          'actionFeeling': 'Building upper body strength, chest and arms engaging',
          'commonMistakes': [
            'Sagging hips',
            'Letting head drop'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Oblique Side Bends',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width apart, hands behind head.',
            'Bend straight down to the right, feeling a stretch in the left side.',
            'Return to center.',
            'Bend straight down to the left, feeling a stretch in the right side.',
            'Do not bend forward or backward.'
          ],
          'breathingRhythm': 'Exhale on the side bend, inhale on the return',
          'actionFeeling': 'Core and oblique muscles engaging and lengthening',
          'commonMistakes': [
            'Bending forward instead of sideways',
            'Pulling on the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Quad Stretch (Assisted)',
          'duration': 40,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Hold onto a chair or wall for balance.',
            'Gently bend one knee and bring your heel toward your glute, holding your ankle or pant leg.',
            'Do not pull on the knee joint.',
            'Keep your knees close together and hips level.',
            'Hold for 20 seconds each side.'
          ],
          'breathingRhythm': 'Deep, slow breaths, relax the muscles',
          'actionFeeling': 'Gentle stretch in the front of the thigh',
          'commonMistakes': [
            'Arching your lower back',
            'Losing balance'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Forward Fold against Wall (Modified)',
          'duration': 40,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand facing a wall, a little more than arms-length away.',
            'Place hands on wall at hip height.',
            'Walk feet back and hinge at the hips until your body forms an L-shape.',
            'Let your head hang loosely, stretching your back and hamstrings.',
            'Hold and breathe.'
          ],
          'breathingRhythm': 'Long, slow inhales and exhales',
          'actionFeeling': 'Full back and hamstring stretch',
          'commonMistakes': [
            'Rounding the lower back'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'plus_size_4',
  'title': 'Body Positive: Strength Training',
  'category': 'plus_size',
  'duration': 25,
  'calories': 189,
  'intensity': 'medium',
  'equipment': 'Chair or Wall',
  'focusZones': 'Full Body, Strength',
  'imageUrl': 'assets/images/plus_size_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'High Knee March (Slow & Controlled)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, march slowly in place.',
            'Focus on lifting knees using core strength, not momentum.',
            'You may hold a chair or wall for balance.',
            'Keep movement controlled and gentle on the joints.'
          ],
          'breathingRhythm': 'Exhale on the knee lift, inhale on the lower',
          'actionFeeling': 'Core and hip flexors warming up',
          'commonMistakes': [
            'Rocking side to side excessively',
            'Slouching'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Triceps Kickbacks (No Weight)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with a slight hinge at the hips, back straight.',
            'Bend elbows to 90 degrees, keeping them tucked near your sides.',
            'Straighten arms behind you, squeezing the triceps (back of arm).',
            'Return slowly to the bent position.'
          ],
          'breathingRhythm': 'Exhale on the extension (squeeze), inhale on the return',
          'actionFeeling': 'Back of arms engaging',
          'commonMistakes': [
            'Swinging the arms',
            'Raising the elbows too high'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Wall Sit (Hold)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand with your back flat against a sturdy wall.',
            'Walk feet out and slide down until knees are at a comfortable angle (not necessarily 90 degrees).',
            'Make sure your feet are flat and shins are relatively vertical.',
            'Hold the position.',
            'To increase intensity, slide slightly lower.'
          ],
          'breathingRhythm': 'Maintain steady, deep breaths',
          'actionFeeling': 'Deep burn in the thighs, major leg muscle engagement',
          'commonMistakes': [
            'Letting knees go past toes',
            'Lifting hips off the wall'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Bicep Curls (Imaginary/Light Water Bottles)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, arms by your sides (holding light weights or nothing).',
            'Curl arms up toward shoulders, squeezing biceps.',
            'Lower slowly with control.',
            'Keep elbows close to your sides, do not swing.'
          ],
          'breathingRhythm': 'Exhale on the curl, inhale on the lower',
          'actionFeeling': 'Biceps working, feeling strong activation',
          'commonMistakes': [
            'Using your back to help lift the arms',
            'Dropping the arms quickly'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Calf Raises (Controlled)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, holding onto a chair or wall for balance.',
            'Rise up slowly onto the balls of your feet.',
            'Hold at the top for 2 seconds.',
            'Lower back down with control, feeling a stretch in the calves.'
          ],
          'breathingRhythm': 'Exhale as you rise, inhale as you lower',
          'actionFeeling': 'Calves burning and strengthening',
          'commonMistakes': [
            'Bouncing up and down quickly',
            'Leaning forward too much'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Hamstring Stretch (Assisted)',
          'duration': 45,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Place one heel on a low step or curb, or simply extend the leg in front of you on the floor.',
            'Gently hinge forward from the hips until you feel a stretch in the back of the leg.',
            'Keep your back straight.',
            'Hold for 20 seconds, then switch legs.'
          ],
          'breathingRhythm': 'Deep breaths, relax into stretch',
          'actionFeeling': 'Gentle stretch back of thigh and calf',
          'commonMistakes': [
            'Rounding your back',
            'Locking the standing knee'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Slow Shoulder Rolls and Arm Shakes',
          'duration': 40,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand tall, roll shoulders backward for 20 seconds.',
            'Reverse, rolling them forward for 20 seconds.',
            'Shake arms loosely by your sides to release tension.'
          ],
          'breathingRhythm': 'Deep, steady breathing',
          'actionFeeling': 'Tension release, circulation calming down',
          'commonMistakes': [
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'plus_size_5',
  'title': 'Gentle Giant: Low Impact Cardio',
  'category': 'plus_size',
  'duration': 20,
  'calories': 145,
  'intensity': 'low',
  'equipment': 'None',
  'focusZones': 'Cardio, Full Body',
  'imageUrl': 'assets/images/plus_size_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Heel Digs with Bicep Curls',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, shift weight to one foot.',
            'Tap the opposite heel out in front of you.',
            'Alternate heel taps at a gentle pace.',
            'Coordinate with a light bicep curl (no weights) on each heel tap.'
          ],
          'breathingRhythm': 'Breathe smoothly and continuously',
          'actionFeeling': 'Lower body and arms warming up, light cardiovascular activation',
          'commonMistakes': [
            'Hinging too far at the hips',
            'Slouching'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Step-Touch with Overhead Reach',
          'duration': 50,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Step right foot to the side, tap left foot next to it.',
            'As you step, reach both arms straight up overhead (just below ears).',
            'Step back to the left, tapping feet and lowering arms.',
            'Keep movements smooth and your feet light.'
          ],
          'breathingRhythm': 'Exhale on the reach up, inhale on the step in',
          'actionFeeling': 'Cardio intensity increasing, full body movement',
          'commonMistakes': [
            'Stepping too wide or fast',
            'Shrugging shoulders on the reach'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Side Leg Lifts (Modified)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand tall, holding onto a chair for balance.',
            'Lift your right leg straight out to the side (abduction), only a few inches.',
            'Lower slowly, resisting the drop.',
            'Switch legs halfway through.',
            'Keep your core tight to avoid leaning.'
          ],
          'breathingRhythm': 'Exhale as you lift, inhale as you lower',
          'actionFeeling': 'Outer hip and thigh muscles working for stability',
          'commonMistakes': [
            'Leaning significantly to the side',
            'Lifting the leg too high and rotating the hips'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Boxing Punches (Forward and Up)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand with feet shoulder-width, soft knees, core engaged.',
            'Alternate punching straight forward (crosses).',
            'Switch to alternating punching straight up overhead (jabs/reaches).',
            'Keep elbows soft and movements fast but controlled.'
          ],
          'breathingRhythm': 'Exhale sharply with each punch',
          'actionFeeling': 'Upper body and core working, heart rate remaining elevated',
          'commonMistakes': [
            'Locking elbows or shoulders',
            'Not engaging the core'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Slow March and Wrist/Ankle Rolls',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Walk very slowly in place.',
            'Begin rotating wrists and ankles (one at a time) in small circles.',
            'Gradually slow the march to a stop.',
            'Focus on slowing down your breath.'
          ],
          'breathingRhythm': 'Deep, calming breaths, 4 counts in, 6 counts out',
          'actionFeeling': 'Heart rate returning to normal, limbs relaxing',
          'commonMistakes': [
            'Stopping movement too abruptly'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'plus_size_6',
  'title': 'Empower & Strengthen: Chair Workout',
  'category': 'plus_size',
  'duration': 18,
  'calories': 123,
  'intensity': 'low',
  'equipment': 'Chair',
  'focusZones': 'Full Body, Strength, Seated',
  'imageUrl': 'assets/images/plus_size_3.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Tummy Twist (Torso only)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the edge of a sturdy chair, feet flat on floor.',
            'Cross arms over chest.',
            'Twist torso gently to the right, hold for 1 second.',
            'Return to center, then twist gently to the left.',
            'Keep lower body stable.'
          ],
          'breathingRhythm': 'Exhale on the twist, inhale on the return',
          'actionFeeling': 'Spine and core gently mobilizing',
          'commonMistakes': [
            'Using your arms to pull the twist',
            'Slouching'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Seated Bicep Curls (Band or Imaginary)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, back straight.',
            'Place arms by your sides (or hold a resistance band/light object).',
            'Curl the hands toward the shoulders, flexing the bicep.',
            'Lower slowly with control.'
          ],
          'breathingRhythm': 'Exhale on the curl, inhale on the lower',
          'actionFeeling': 'Front of upper arms working',
          'commonMistakes': [
            'Swinging the arms',
            'Letting elbows move too far forward'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Marching with Core Focus',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, on the front edge of the chair.',
            'Lift right knee up, focusing on pulling with the deep abdominal muscles.',
            'Lower and lift left knee.',
            'March slowly and deliberately, prioritizing core engagement over speed.'
          ],
          'breathingRhythm': 'Exhale on the knee lift, inhale on the lower',
          'actionFeeling': 'Abdominal muscles engaging, light leg work',
          'commonMistakes': [
            'Leaning back into the chair',
            'Hunching forward'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Overhead Arm Extension',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hold arms straight up overhead (hands touching or apart).',
            'Bend elbows, lowering hands behind your head (triceps stretch/work).',
            'Extend arms back up to the ceiling.',
            'Keep elbows pointing forward, not flaring out.'
          ],
          'breathingRhythm': 'Inhale down, exhale up (on extension)',
          'actionFeeling': 'Back of arms (triceps) and shoulders engaging',
          'commonMistakes': [
            'Arching the lower back to compensate',
            'Letting elbows flare widely'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Chest Opener',
          'duration': 40,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Remain seated, clasp hands together behind your back (or hold a towel).',
            'Gently lift your chest and pull your shoulders back and down.',
            'Hold and feel the stretch across the chest and front of shoulders.'
          ],
          'breathingRhythm': 'Deep, expansive chest breaths',
          'actionFeeling': 'Opening up the chest, relaxing the shoulders',
          'commonMistakes': [
            'Holding breath',
            'Forcing the clasp or stretch'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Deep Breathing and Relaxation',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit comfortably, close eyes if desired.',
            'Inhale for a slow count of 5, feeling your belly and ribcage expand.',
            'Exhale slowly for a count of 7, letting go of any tension.',
            'Repeat until heart rate is fully recovered.'
          ],
          'breathingRhythm': 'Focus on long, slow exhales to promote relaxation',
          'actionFeeling': 'Calm, centered, complete recovery',
          'commonMistakes': [
            'Rushing the breath'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== HEALTHIER YOU WORKOUTS ====================

{
  'id': 'healthy_1',
  'title': 'Core Awakening: Beginner Abs Easy',
  'category': 'healthier_you',
  'duration': 27,
  'calories': 76,
  'intensity': 'low',
  'equipment': 'Yoga Mat',
  'focusZones': 'Core, Abs',
  'imageUrl': 'assets/images/healthy_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Pelvic Tilts (Supine)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on your back with knees bent, feet flat on the floor.',
            'Flatten your lower back against the floor by gently rocking your pelvis up.',
            'Hold for 3 seconds.',
            'Gently release, allowing a small arch in your lower back.',
            'Repeat smoothly to warm the core and lower back.'
          ],
          'breathingRhythm': 'Exhale as you flatten (tilt), inhale as you release',
          'actionFeeling': 'Gentle activation in the deep core and lower back',
          'commonMistakes': [
            'Pushing down with your legs',
            'Holding breath'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Marching Abs (Lying Down)',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lie on your back with knees bent and feet flat.',
            'Engage your core to keep your lower back pressed to the floor.',
            'Slowly lift your right foot a few inches off the floor (marching motion).',
            'Lower and repeat with the left foot.',
            'Alternate legs with control.'
          ],
          'breathingRhythm': 'Exhale as you lift the leg, inhale as you lower',
          'actionFeeling': 'Deep lower abdominal engagement',
          'commonMistakes': [
            'Arching the lower back (if this happens, lift the knee less)',
            'Moving too quickly'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Russian Twist (Modified)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Sit on the floor (or edge of a chair), knees bent, feet flat.',
            'Keep your back straight, lean back slightly (only if on floor).',
            'Twist your torso to the right, tapping the floor/chair side with both hands.',
            'Twist to the left, tapping the floor/chair side.',
            'Maintain slow, deliberate movement.'
          ],
          'breathingRhythm': 'Exhale on each twist',
          'actionFeeling': 'Obliques (side abs) working',
          'commonMistakes': [
            'Rounding the back',
            'Using momentum instead of muscle'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Single Leg Bridge (Beginner)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lie on your back, knees bent, feet flat.',
            'Lift your hips into a standard bridge position.',
            'Hold the bridge and extend one leg straight up (or simply straighten it forward).',
            'Hold for 5 seconds, lower leg, and lower hips.',
            'Switch sides each round.'
          ],
          'breathingRhythm': 'Exhale as you lift the bridge, inhale as you hold/lower',
          'actionFeeling': 'Glutes and lower back strengthening',
          'commonMistakes': [
            'Lifting hips too high (arching back)',
            'Dropping the hips when extending the leg'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Knee-to-Chest Hold (Both Legs)',
          'duration': 45,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Lie on your back.',
            'Gently bring both knees to your chest.',
            'Wrap your arms around your shins or behind your knees.',
            'Rock gently side to side, massaging the lower back.',
            'Hold the stretch for the duration.'
          ],
          'breathingRhythm': 'Deep, slow, relaxing breaths',
          'actionFeeling': 'Relief and gentle stretch in the lower back and glutes',
          'commonMistakes': [
            'Pulling too hard or quickly'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Full Body Spread (Starfish)',
          'duration': 40,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie flat on your back, extend arms and legs wide (like a starfish).',
            'Let your whole body relax into the floor.',
            'Focus solely on breathing deeply and evenly.',
            'Clear your mind and allow recovery.'
          ],
          'breathingRhythm': '6 counts in, 8 counts out',
          'actionFeeling': 'Complete calm and recovery',
          'commonMistakes': [
            'Tensing muscles, especially jaw and shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'healthy_2',
  'title': 'Sculpt While Sleep: Strength Training',
  'category': 'healthier_you',
  'duration': 31,
  'calories': 86,
  'intensity': 'low',
  'equipment': 'Chair, Mat',
  'focusZones': 'Glutes, Arms',
  'imageUrl': 'assets/images/healthy_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Hip Circles',
          'duration': 50,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, feet slightly wider than hips.',
            'Place hands on hips or hold a chair for support.',
            'Make slow, large circles with your hips, 25 seconds in each direction.',
            'Keep your knees soft.'
          ],
          'breathingRhythm': 'Breathe steadily throughout the movement',
          'actionFeeling': 'Hips and lower back loosening up',
          'commonMistakes': [
            'Moving too fast or jerking',
            'Arching the back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 4,
      'exercises': [
        {
          'exerciseName': 'Glute Bridges (Controlled)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on your back, knees bent, feet flat, hip-width apart.',
            'Squeeze your glutes and lift your hips toward the ceiling until your body forms a straight line from shoulders to knees.',
            'Hold at the top for 2 seconds, squeezing tightly.',
            'Lower slowly with control.'
          ],
          'breathingRhythm': 'Exhale as you lift, inhale as you lower',
          'actionFeeling': 'Glutes and hamstrings activating strongly',
          'commonMistakes': [
            'Pushing up with your neck and shoulders',
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Chair Dips (Modified)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit on the edge of a sturdy chair, hands gripping the edge near your hips.',
            'Slide your hips forward off the chair, keeping feet flat and knees bent 90 degrees.',
            'Bend elbows slightly, lowering your body a few inches (small range).',
            'Push back up using tricep strength.',
            'Keep your back close to the chair.'
          ],
          'breathingRhythm': 'Inhale down, exhale up (on the push)',
          'actionFeeling': 'Triceps (back of arms) working intensely',
          'commonMistakes': [
            'Shrugging shoulders',
            'Lowering too far if causing shoulder pain'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Fire Hydrants (Kneeling)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees (on a mat).',
            'Keeping the knee bent, lift your right leg out to the side (like a dog lifting its leg).',
            'Only lift until you feel the outer glute/hip engage.',
            'Lower with control and switch sides halfway through the duration.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Outer glutes and hips stabilizing',
          'commonMistakes': [
            'Shifting weight too much to one side',
            'Arching the back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Child\'s Pose (Modified)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Kneel on a mat, sitting back on your heels (use pillow if uncomfortable).',
            'Walk hands forward, resting your forehead on the floor or a cushion.',
            'Allow your arms to stretch out in front of you.',
            'Hold the pose, feeling a stretch in your back and shoulders.'
          ],
          'breathingRhythm': 'Deep, grounding breaths, relax the abdomen',
          'actionFeeling': 'Gentle stretch in the back, hips, and shoulders',
          'commonMistakes': [
            'Tensing the shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'healthy_3',
  'title': 'Morning Energy: Wake Up Workout',
  'category': 'healthier_you',
  'duration': 15,
  'calories': 112,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Full Body, Cardio',
  'imageUrl': 'assets/images/healthy_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Opposite Toe Touches (Standing)',
          'duration': 45,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Stand with feet shoulder-width apart.',
            'Reach your right hand down towards your left foot/shin.',
            'Stand up tall.',
            'Repeat on the opposite side (left hand to right foot).',
            'Move gently, don\'t force the stretch.'
          ],
          'breathingRhythm': 'Exhale as you reach down, inhale as you stand up',
          'actionFeeling': 'Hamstrings and core warming up gently',
          'commonMistakes': [
            'Rounding your upper back instead of hinging at the hips',
            'Moving too fast'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Side-to-Side Shuffle (No crossover)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, take a small step to the right, bringing your left foot to meet it.',
            'Repeat, shuffling three steps to the right, then three steps to the left.',
            'Stay low and springy on your feet, but avoid jumping.',
            'Keep your pace quick and steady.'
          ],
          'breathingRhythm': 'Keep your breath moving with the pace',
          'actionFeeling': 'Heart rate elevating, legs and hips working',
          'commonMistakes': [
            'Letting your upper body be too stiff',
            'Forgetting to breathe'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Windmills (Large Arm Circles)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width apart.',
            'Extend arms out, making large, smooth circles forward.',
            'Focus on shoulder mobility and a full range of motion.',
            'Switch to backward circles halfway through.'
          ],
          'breathingRhythm': 'Breathe smoothly, keeping shoulders relaxed',
          'actionFeeling': 'Shoulder joints mobilizing, upper body cardio',
          'commonMistakes': [
            'Tensing the neck',
            'Slamming arms down'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Quick Feet (Standing Option)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the edge of a chair or stand in place.',
            'Quickly lift and tap your feet in place as fast as you can.',
            'Keep movement low to the ground and light.',
            'If standing, keep feet close and soft landing (mini high-knees).'
          ],
          'breathingRhythm': 'Maintain a quick, shallow breath to match the pace',
          'actionFeeling': 'Quick heart rate spike, legs and metabolism activating',
          'commonMistakes': [
            'Making foot taps too loud or heavy',
            'Hunching over'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Ear-to-Shoulder Neck Stretch',
          'duration': 40,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand or sit tall.',
            'Gently drop your right ear toward your right shoulder.',
            'Use your right hand to gently guide your head deeper (optional).',
            'Hold for 15 seconds, then switch sides.',
            'Keep your shoulders down and relaxed.'
          ],
          'breathingRhythm': 'Deep, slow breaths into the stretch',
          'actionFeeling': 'Release of neck and upper shoulder tension',
          'commonMistakes': [
            'Pulling too hard',
            'Letting the opposite shoulder creep up'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'healthy_4',
  'title': 'Wellness Warrior: Mind & Body',
  'category': 'healthier_you',
  'duration': 22,
  'calories': 156,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Flexibility, Core',
  'imageUrl': 'assets/images/healthy_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Cat-Cow Flow (Kneeling)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees (tabletop position).',
            'Inhale: Drop your belly, look up gently (Cow Pose).',
            'Exhale: Round your spine, tuck chin to chest (Cat Pose).',
            'Move slowly and fluidly, matching the movement to your breath.'
          ],
          'breathingRhythm': 'Inhale on the arch, exhale on the round',
          'actionFeeling': 'Spinal mobility and gentle core awakening',
          'commonMistakes': [
            'Rushing the movement',
            'Forcing the arch/round'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Bird Dog (Controlled)',
          'duration': 50,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Start on hands and knees.',
            'Extend your right arm forward and left leg straight back, keeping hips level.',
            'Hold for 2 seconds, maintaining a neutral spine.',
            'Return to start and switch sides.',
            'Focus on stability and a slow transition.'
          ],
          'breathingRhythm': 'Exhale as you extend, inhale as you return',
          'actionFeeling': 'Core stabilizers and glutes working for balance',
          'commonMistakes': [
            'Lifting the leg too high (causes back arch)',
            'Rotating the hips'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Side Lying Leg Lifts',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lie on your side, bottom knee bent, top leg straight.',
            'Gently lift your top leg toward the ceiling (hip abduction).',
            'Lower with control, touching the bottom leg lightly.',
            'Keep your toe pointed straight ahead.',
            'Switch sides halfway through the duration.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Outer glutes and hip muscles burning gently',
          'commonMistakes': [
            'Rolling onto your back/stomach',
            'Using momentum'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Tabletop Crunch (Reverse Crunch Prep)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lie on your back, bring knees over hips (Tabletop position).',
            'Gently use your lower abs to tilt your pelvis, lifting your tailbone slightly off the floor.',
            'Lower tailbone slowly back down.',
            'Keep movement small and focused on the lower abdomen.'
          ],
          'breathingRhythm': 'Exhale on the slight lift, inhale on the lower',
          'actionFeeling': 'Deep lower abdominal engagement',
          'commonMistakes': [
            'Using hip flexors to swing legs',
            'Straining the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Reclined Figure-Four Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on your back, cross your right ankle over your left knee.',
            'Grasp the back of your left thigh and gently pull toward your chest.',
            'Hold for 30 seconds, keeping your back flat.',
            'Switch sides for the remainder of the time.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths, focusing on tension release',
          'actionFeeling': 'Deep stretch in the glute and outer hip',
          'commonMistakes': [
            'Tucking chin too hard to chest',
            'Forcing the stretch'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'healthy_5',
  'title': 'Healthy Habits: Daily Routine',
  'category': 'healthier_you',
  'duration': 18,
  'calories': 134,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Full Body, Mobility',
  'imageUrl': 'assets/images/healthy_1.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Reach and Ankle Tap (Standing)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, gently reach down to tap your left ankle with your right hand.',
            'Stand up tall, then tap your right ankle with your left hand.',
            'Keep your knees soft and move rhythmically.',
            'Focus on mobility, not depth.'
          ],
          'breathingRhythm': 'Exhale on the tap, inhale on the stand',
          'actionFeeling': 'Hamstrings and core activating',
          'commonMistakes': [
            'Locking the knees',
            'Bending only at the waist'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Power Walks (High Knees)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Walk in place, lifting your knees higher than usual.',
            'Pump your arms vigorously to match the leg rhythm.',
            'Keep movement controlled and maintain soft foot landings.',
            'This is your cardio booster.'
          ],
          'breathingRhythm': 'Maintain a steady, deep breath to fuel the movement',
          'actionFeeling': 'Heart rate elevated, full body working',
          'commonMistakes': [
            'Slouching the shoulders',
            'Slapping feet loudly'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Reverse Lunges (Standing, Modified)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, step your right foot straight back.',
            'Only slightly bend both knees (not necessarily 90 degrees).',
            'Return to the start, and switch legs.',
            'Focus on stability and keeping weight on the front heel.',
            'You may hold a chair for balance.'
          ],
          'breathingRhythm': 'Exhale as you step back/lower, inhale as you stand up',
          'actionFeeling': 'Glutes and thighs strengthening',
          'commonMistakes': [
            'Stepping out to the side (keep feet hip-width apart)',
            'Leaning forward too much'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Shoulder Presses (Imaginary/Light)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, bring elbows out to sides at shoulder height (goalpost arms).',
            'Press your hands/arms straight up toward the ceiling.',
            'Lower slowly back to the start position.',
            'Keep core tight to prevent arching your back.'
          ],
          'breathingRhythm': 'Exhale on the press up, inhale on the lower down',
          'actionFeeling': 'Shoulders and upper back engaging',
          'commonMistakes': [
            'Arching the back',
            'Shrugging up to the ears'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Ankle and Wrist Shakes',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand tall, lift one foot and shake your ankle out loosely.',
            'Do the same with your wrist/hand.',
            'Switch sides, shaking the other foot/hand.',
            'Finish by shaking all four limbs lightly to release any residual tension.'
          ],
          'breathingRhythm': 'Breathe deeply and sigh out loud if needed',
          'actionFeeling': 'Tension release and circulation relaxation',
          'commonMistakes': [
            'Tensing muscles while trying to shake'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'healthy_6',
  'title': 'Vitality Boost: Energy Flow',
  'category': 'healthier_you',
  'duration': 20,
  'calories': 145,
  'intensity': 'medium',
  'equipment': 'Mat',
  'focusZones': 'Full Body, Mobility',
  'imageUrl': 'assets/images/healthy_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Shoulder and Hip Swings (Figure 8)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width apart.',
            'Start making a large figure 8 motion with your hips, rotating slowly.',
            'Coordinate by swinging your arms loosely in the opposite direction.',
            'Keep movement fluid and gentle.'
          ],
          'breathingRhythm': 'Breathe naturally, focusing on fluid movement',
          'actionFeeling': 'Full body joints warming up and mobilizing',
          'commonMistakes': [
            'Straining or forcing the swing',
            'Stopping abruptly'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Plank (Knees or Modified)',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Start on your forearms and knees, or forearms and toes (full plank).',
            'Ensure your body forms a straight line from head to knees or heels.',
            'Engage your core and squeeze your glutes.',
            'Hold this static position, drawing naval to spine.'
          ],
          'breathingRhythm': 'Maintain steady, deep breaths, avoid holding breath',
          'actionFeeling': 'Deep core muscles shaking and working hard',
          'commonMistakes': [
            'Letting hips sag or lift too high',
            'Straining the neck'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Alternating Side Squats (Controlled)',
          'duration': 40,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand with feet wider than hip-width, toes pointing forward.',
            'Shift your weight to the right, bending the right knee (left leg stays mostly straight).',
            'Push back to center, then shift weight to the left.',
            'Keep your chest lifted and squatting knee behind your toes.'
          ],
          'breathingRhythm': 'Inhale on the lower, exhale on the push back to center',
          'actionFeeling': 'Inner and outer thighs and glutes activating',
          'commonMistakes': [
            'Letting the back round',
            'Not controlling the descent'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Kneeling Push-Ups (or Incline)',
          'duration': 35,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Start on hands and knees (on a mat) or against a wall/counter.',
            'Lower your chest toward the floor/surface by bending your elbows.',
            'Push back up, keeping core tight.',
            'Body should move as one unit.'
          ],
          'breathingRhythm': 'Inhale down, exhale up',
          'actionFeeling': 'Chest, shoulders, and triceps working',
          'commonMistakes': [
            'Dropping the head or neck',
            'Letting hips sag'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Forward Fold (on Mat)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit on your mat, legs extended straight in front of you.',
            'Hinge forward gently from your hips, reaching toward your feet/ankles/shins.',
            'Allow your head and shoulders to relax.',
            'Hold the stretch, deepening gently with each exhale.'
          ],
          'breathingRhythm': 'Long, slow inhales and complete exhales',
          'actionFeeling': 'Stretch across the hamstrings and lower back',
          'commonMistakes': [
            'Bouncing in the stretch',
            'Trying to pull yourself down aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== STRENGTHEN AND STRETCH WORKOUTS ====================

{
  'id': 'strengthen_1',
  'title': 'Wall Power: Full-Body Strength Building',
  'category': 'strengthen_stretch',
  'duration': 7,
  'calories': 10,
  'intensity': 'low',
  'equipment': 'Wall',
  'focusZones': 'Full Body, Strength',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wall Arm Slides',
          'duration': 40,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Stand with your back against a wall, feet shoulder-width apart.',
            'Press your lower back, head, and arms flat against the wall (goalpost position).',
            'Slowly slide your arms straight up overhead, keeping contact with the wall.',
            'Slide them back down. Repeat smoothly.'
          ],
          'breathingRhythm': 'Inhale up, exhale down',
          'actionFeeling': 'Shoulder blades engaging, upper back warming up',
          'commonMistakes': [
            'Arching the lower back',
            'Letting hands/elbows lose contact with the wall'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wall Squat (Hold)',
          'duration': 60,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lean back against the wall, slide down until knees are bent to 90 degrees (or a comfortable angle).',
            'Keep your back flat against the wall and weight in your heels.',
            'Hold the static position, engaging your quads and glutes.'
          ],
          'breathingRhythm': 'Steady, controlled breaths',
          'actionFeeling': 'Thighs and glutes working intensely',
          'commonMistakes': [
            'Knees extending past toes',
            'Holding breath'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Wall Push-Ups (Slow)',
          'duration': 50,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand arm’s length from wall, place palms flat at shoulder height.',
            'Lower your body slowly toward the wall (3 seconds down).',
            'Push back to start (2 seconds up).',
            'Keep body straight from head to heels.'
          ],
          'breathingRhythm': 'Inhale down, exhale up',
          'actionFeeling': 'Controlled work in chest, shoulders, and arms',
          'commonMistakes': [
            'Letting hips sag',
            'Moving too fast'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Calf Raises (Wall Assisted)',
          'duration': 45,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Stand facing the wall, lightly touch wall for balance.',
            'Slowly rise up onto the balls of your feet.',
            'Pause at the top, then lower slowly back down.'
          ],
          'breathingRhythm': 'Exhale up, inhale down',
          'actionFeeling': 'Calves contracting and stretching',
          'commonMistakes': [
            'Bouncing the movement',
            'Relying heavily on the wall'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wall Chest Stretch',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand next to wall, place forearm on wall at shoulder height.',
            'Gently step your outside foot forward, rotating your body away from the wall.',
            'Hold the stretch across your chest and front of shoulder (20 seconds each side).'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Gentle release in the chest',
          'commonMistakes': [
            'Tensing the shoulder'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'strengthen_2',
  'title': 'Stretch & Renewal: Flexibility Reset',
  'category': 'strengthen_stretch',
  'duration': 4,
  'calories': 7,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Flexibility, Hips, Back',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Ankle and Wrist Rolls',
          'duration': 30,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Sit comfortably on the mat.',
            'Lift right foot and rotate ankle clockwise, then counter-clockwise.',
            'At the same time, circle your wrists.',
            'Switch feet and repeat.'
          ],
          'breathingRhythm': 'Breathe naturally and evenly',
          'actionFeeling': 'Joints mobilizing gently',
          'commonMistakes': [
            'Rushing the circles'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Forward Fold',
          'duration': 60,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Sit on the mat with legs extended.',
            'Inhale, sit up tall. Exhale, hinge forward from the hips.',
            'Grab shins, ankles, or feet (do not round your back forcefully).',
            'Hold the stretch in your hamstrings and lower back.'
          ],
          'breathingRhythm': 'Exhale to deepen the stretch, inhale to lengthen',
          'actionFeeling': 'Release in hamstrings and lower back',
          'commonMistakes': [
            'Rounding the spine too much',
            'Bouncing in the stretch'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Lying Spinal Twist',
          'duration': 60,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Lie on your back, extend arms to sides.',
            'Bring both knees to your chest, then drop them slowly to the right.',
            'Turn your head to the left.',
            'Hold for 30 seconds, then switch sides.',
            'Keep both shoulders grounded.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths into your abdomen',
          'actionFeeling': 'Release and stretch in the spine and hips',
          'commonMistakes': [
            'Letting shoulders lift too high'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Corpse Pose (Savasana)',
          'duration': 40,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie flat on your back, arms relaxed by your sides, palms up.',
            'Close your eyes and let your body sink into the mat.',
            'Focus on complete stillness and deep, calming breaths.',
            'Allow full relaxation.'
          ],
          'breathingRhythm': 'Slowest, deepest breathing possible',
          'actionFeeling': 'Complete rest and recovery',
          'commonMistakes': [
            'Tensing muscles, especially jaw'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'strengthen_3',
  'title': 'Yoga Flow: Morning Stretch',
  'category': 'strengthen_stretch',
  'duration': 12,
  'calories': 45,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Full Body, Mobility',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Cat-Cow Flow',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on all fours on the mat.',
            'Inhale, arch your back, lift your tailbone and gaze up (Cow).',
            'Exhale, round your spine, tuck chin and tailbone (Cat).',
            'Move slowly with your breath for spinal mobility.'
          ],
          'breathingRhythm': 'Inhale on the arch, exhale on the round',
          'actionFeeling': 'Spine mobilizing, hips warming',
          'commonMistakes': [
            'Rushing the transition between poses'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Downward-Facing Dog (Hold)',
          'duration': 60,
          'rest': 20,
          'reps': null,
          'instructions': [
            'From hands and knees, tuck your toes and lift hips toward the ceiling.',
            'Form an inverted V shape.',
            'Press hands firmly into the mat, keeping a slight bend in knees if needed.',
            'Hold the pose, pedaling out the feet if desired.'
          ],
          'breathingRhythm': 'Steady, long breaths',
          'actionFeeling': 'Stretch in hamstrings, calves, and shoulders; gentle strength in arms',
          'commonMistakes': [
            'Rounding the upper back',
            'Letting hips drop too low'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Cobra Pose (Modified)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on your stomach, hands under shoulders, elbows tucked in.',
            'Inhale and gently lift your chest a few inches off the floor (using your back muscles).',
            'Keep your gaze soft and neck long.',
            'Exhale and lower slowly.'
          ],
          'breathingRhythm': 'Inhale on the lift, exhale on the lower',
          'actionFeeling': 'Gentle stretch in the abdomen, lower back engaging',
          'commonMistakes': [
            'Pushing up too high (keep it low and gentle)',
            'Shrugging shoulders up to ears'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Reclined Pigeon Pose',
          'duration': 50,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Lie on your back, perform the Reclined Figure-Four stretch (see strengthen\_2).',
            'Hold for 25 seconds on the right side.',
            'Hold for 25 seconds on the left side.',
            'Focus on relaxing the hip joint.'
          ],
          'breathingRhythm': 'Deep, tension-releasing breaths',
          'actionFeeling': 'Deep stretch in the hip and glute area',
          'commonMistakes': [
            'Pulling too hard on the thigh'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Meditation',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit comfortably cross-legged or on a cushion, spine tall.',
            'Close your eyes, place hands gently on your knees.',
            'Focus on the feeling of your breath moving in and out.',
            'Clear your mind and set an intention for the day.'
          ],
          'breathingRhythm': 'Slow, rhythmic, abdominal breathing',
          'actionFeeling': 'Mental clarity and calm',
          'commonMistakes': [
            'Fidgeting or rushing the final minute'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'strengthen_4',
  'title': 'Flexibility Master: Deep Stretch',
  'category': 'strengthen_stretch',
  'duration': 15,
  'calories': 56,
  'intensity': 'low',
  'equipment': 'Mat, Towel/Strap (optional)',
  'focusZones': 'Flexibility, Legs, Hips',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Quadriceps and Hip Flexor Stretch',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Hold onto a wall for balance.',
            'Bend right knee, bringing heel toward glute, hold ankle with hand.',
            'Hold for 20 seconds.',
            'Switch sides. Keep hips slightly tucked forward for a deeper stretch.'
          ],
          'breathingRhythm': 'Deep, slow breaths',
          'actionFeeling': 'Front of thighs lengthening',
          'commonMistakes': [
            'Arching lower back',
            'Forcing the stretch'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Hamstring Stretch (Lying with Strap)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on your back, loop a strap/towel around your right foot (optional).',
            'Keep your left leg flat (or bent if needed).',
            'Gently pull the strap to draw the straight right leg toward your head.',
            'Hold for 45 seconds, then switch legs.',
            'Focus on keeping the hip grounded.'
          ],
          'breathingRhythm': 'Long, slow exhales to release tension',
          'actionFeeling': 'Deep stretch throughout the back of the lifted leg',
          'commonMistakes': [
            'Lifting the hip off the floor',
            'Jerking the stretch'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Butterfly Stretch (Seated)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit on mat, soles of feet together, knees dropped to sides.',
            'Sit up tall, gently fold forward, resting forearms on shins or knees.',
            'Hold for 45 seconds.',
            'Do not press down forcefully on knees.',
            'Feel the inner thigh and hip opening.'
          ],
          'breathingRhythm': 'Inhale to lengthen spine, exhale to deepen the fold',
          'actionFeeling': 'Inner thighs and hips opening',
          'commonMistakes': [
            'Rounding the upper back excessively'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Triceps and Shoulder Stretch (Seated)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit comfortably, reach right arm overhead, bend elbow (palm toward back).',
            'Use left hand to gently press down on right elbow.',
            'Hold for 30 seconds, then switch arms.',
            'Keep your chin level.'
          ],
          'breathingRhythm': 'Steady, relaxing breaths',
          'actionFeeling': 'Stretch in the back of the arm and side of the shoulder',
          'commonMistakes': [
            'Pulling on the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Supported Bridge Pose (Relaxation)',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on your back, knees bent, feet flat.',
            'Lift hips and slide a pillow or block under your lower back/sacrum.',
            'Rest your hips on the support.',
            'Let your entire body relax, releasing tension in the lower back and hips.'
          ],
          'breathingRhythm': 'Deep, calming breaths (abdominal focus)',
          'actionFeeling': 'Deep relaxation and spinal decompression',
          'commonMistakes': [
            'Using muscle strength to hold the pose'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'strengthen_5',
  'title': 'Gentle Stretch: Relaxation',
  'category': 'strengthen_stretch',
  'duration': 8,
  'calories': 28,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Full Body, Relaxation',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Gentle Sway',
          'duration': 40,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width, soft knees.',
            'Gently sway your body side to side, letting your arms swing loosely.',
            'Keep your gaze steady and breath soft.',
            'Movement should be minimal and relaxing.'
          ],
          'breathingRhythm': 'Breathe smoothly with the sway',
          'actionFeeling': 'Full body loosening up, tension releasing',
          'commonMistakes': [
            'Swinging too violently',
            'Tensing the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Kneeling Half Split (Hamstring)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start in a kneeling position, extend your right leg straight out in front of you, heel down.',
            'Flex your right foot toward the ceiling.',
            'Gently hinge at the hips for a hamstring stretch.',
            'Hold for 30 seconds, then switch legs.'
          ],
          'breathingRhythm': 'Exhale to fold deeper, slow inhale to hold',
          'actionFeeling': 'Hamstring lengthening gently',
          'commonMistakes': [
            'Hyperextending the front knee',
            'Rounding the back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Side Body Stretch',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit cross-legged, reach right arm overhead.',
            'Gently lean to the left, stretching the entire right side of your body.',
            'Hold for 30 seconds, keeping both hips grounded.',
            'Switch sides and repeat.'
          ],
          'breathingRhythm': 'Deep breaths into the stretched side of the ribs',
          'actionFeeling': 'Sides of the torso stretching, deep breathing opens chest',
          'commonMistakes': [
            'Leaning forward or backward instead of sideways'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Gentle Head and Neck Rolls',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, let your chin drop to your chest.',
            'Slowly roll your right ear toward your right shoulder.',
            'Roll back down, then roll left ear toward left shoulder.',
            'Avoid rolling all the way back; keep it gentle (half rolls).'
          ],
          'breathingRhythm': 'Slow and deep to relax the neck',
          'actionFeeling': 'Release of tension in neck and upper traps',
          'commonMistakes': [
            'Moving too fast or forcing the roll'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'strengthen_6',
  'title': 'Balance & Stretch: Stability Work',
  'category': 'strengthen_stretch',
  'duration': 10,
  'calories': 38,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Balance, Core, Lower Body',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Heel-to-Toe Taps (Standing)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, step your right foot forward, tap your heel.',
            'Step it back, tap your toe (heel off floor).',
            'Alternate heel tap and toe tap, then switch legs halfway through.',
            'Focus on smooth, small movements.'
          ],
          'breathingRhythm': 'Breathe steadily and smoothly',
          'actionFeeling': 'Ankles and feet warming up, preparing for balance',
          'commonMistakes': [
            'Losing balance due to fast movement'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Single-Leg Stand (Assisted if needed)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand on your right leg, lifting your left knee slightly.',
            'Focus gaze on a fixed point.',
            'If needed, lightly touch a wall or chair for support.',
            'Hold the balance for 30 seconds, then switch sides.',
            'Engage your core to help stabilize.'
          ],
          'breathingRhythm': 'Breathe slowly and deeply to maintain calm',
          'actionFeeling': 'Ankle stabilizers and core working hard',
          'commonMistakes': [
            'Slouching the standing leg knee',
            'Letting the lifted hip drop'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Reverse Taps (Glute Focus)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, lightly holding a wall or chair.',
            'Keeping your leg straight, gently tap your right heel back and up (small movement).',
            'Squeeze your glute on the tap/lift.',
            'Repeat rhythmically for 30 seconds, then switch legs.'
          ],
          'breathingRhythm': 'Exhale on the tap/squeeze, inhale on the return',
          'actionFeeling': 'Glutes and back of thighs strengthening',
          'commonMistakes': [
            'Arching the lower back',
            'Kicking too high and using momentum'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Quad Stretch (Assisted)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform the Standing Quad Stretch from strengthen\_4.',
            'Focus on maintaining your single-leg balance while holding the stretch.',
            'Hold for 30 seconds each side.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Quad stretching while standing leg stabilizes',
          'commonMistakes': [
            'Losing alignment to maintain balance'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Final Tadasana (Mountain Pose)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand tall, feet hip-width, arms by sides, palms facing forward.',
            'Close your eyes, root down through your feet, and lengthen your spine.',
            'Hold the pose, focusing on stillness and a calm mind.',
            'Feel the strength and stretch achieved in the session.'
          ],
          'breathingRhythm': 'Slowest, most deliberate breaths possible',
          'actionFeeling': 'Centered, stable, and recovered',
          'commonMistakes': [
            'Shifting weight constantly',
            'Tensing the shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== SEAT EXERCISES WORKOUTS ====================

{
  'id': 'seat_1',
  'title': 'Lean & Lovely: Sculpt Stronger Legs',
  'category': 'seat_exercises',
  'duration': 33,
  'calories': 94,
  'intensity': 'low',
  'equipment': 'Sturdy Chair',
  'focusZones': 'Lower Body, Quads',
  'imageUrl': 'assets/images/seat_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Marching (Slow)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the edge of your chair, feet flat on the floor.',
            'Lift your right knee, then your left knee, mimicking a slow marching pace.',
            'Keep your core engaged to prevent leaning back.'
          ],
          'breathingRhythm': 'Breathe naturally, exhale on the lift',
          'actionFeeling': 'Hip flexors warming, gentle elevation of heart rate',
          'commonMistakes': [
            'Slouching in the chair',
            'Relying on momentum'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 4,
      'exercises': [
        {
          'exerciseName': 'Seated Knee Extensions (Alternating)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hands gripping the sides of the chair for stability.',
            'Extend your right leg straight out in front, squeezing the quad (front of thigh).',
            'Hold the extension for 2 seconds.',
            'Lower slowly and switch legs.',
            'Alternate legs for the duration.'
          ],
          'breathingRhythm': 'Exhale as you extend, inhale as you lower',
          'actionFeeling': 'Quadriceps engaging strongly',
          'commonMistakes': [
            'Locking the knee joint aggressively',
            'Slumping the torso'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Calf Raises',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit with feet flat, lift both heels off the floor, rising onto the balls of your feet.',
            'Keep your toes on the floor.',
            'Hold the contraction for 2 seconds at the top.',
            'Lower heels slowly back down.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Calf muscles working under control',
          'commonMistakes': [
            'Bouncing the movement',
            'Lifting the whole foot off the floor'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Foot Presses (Against Floor)',
          'duration': 30,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, place your feet flat on the floor.',
            'Press both feet forcefully down into the floor, engaging your thighs and glutes.',
            'Hold the contraction tightly for 5 seconds.',
            'Relax and repeat.'
          ],
          'breathingRhythm': 'Exhale during the press and hold',
          'actionFeeling': 'Full leg engagement (isometric strength)',
          'commonMistakes': [
            'Tensing up shoulders and neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Hamstring Stretch (Toe Reach)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Extend your right leg straight out, heel on the floor, toe pointing up.',
            'Gently lean forward from the hips, reaching toward your right foot/shin.',
            'Hold for 30 seconds, then switch legs.',
            'Keep your back as straight as possible.'
          ],
          'breathingRhythm': 'Deep, slow breaths, exhale to relax into the stretch',
          'actionFeeling': 'Back of the thigh lengthening',
          'commonMistakes': [
            'Rounding your upper back instead of hinging at the hip'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'seat_2',
  'title': 'Sit & Sculpt: Full-Body Strong Easy',
  'category': 'seat_exercises',
  'duration': 35,
  'calories': 98,
  'intensity': 'low',
  'equipment': 'Sturdy Chair',
  'focusZones': 'Full Body, Core',
  'imageUrl': 'assets/images/seat_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Side Bends (Arms Overhead)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, feet flat, reach both arms straight overhead.',
            'Inhale, then exhale and gently lean to the right, stretching your left side.',
            'Return to center and repeat to the left.',
            'Alternate sides smoothly.'
          ],
          'breathingRhythm': 'Exhale on the bend, inhale on the center',
          'actionFeeling': 'Sides of the torso and shoulders warming up',
          'commonMistakes': [
            'Bending forward instead of sideways'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Seated Arm Raises (Front and Side)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall. Raise both arms straight out in front of you (up to shoulder height).',
            'Lower and immediately raise both arms straight out to the sides (up to shoulder height).',
            'Alternate between front and side raises, keeping core tight.',
            'Use light weights if available.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Shoulders and upper back engaging',
          'commonMistakes': [
            'Arching your back',
            'Shrugging shoulders up to ears'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Torso Twists (Resistance)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, cross your arms over your chest.',
            'Twist your torso to the right, using only your core muscles.',
            'Return to center, then twist to the left.',
            'Try to go a little further with each repetition while keeping hips fixed.'
          ],
          'breathingRhythm': 'Exhale on the twist, inhale on the center',
          'actionFeeling': 'Obliques and side core muscles working',
          'commonMistakes': [
            'Letting your back round',
            'Twisting with momentum'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Leg Abduction (Outer Thigh Squeeze)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, feet flat, place hands on the outside of your thighs.',
            'Gently press your hands inward (resistance).',
            'Simultaneously press your legs outward against your hands.',
            'Hold the isometric squeeze for 5 seconds.',
            'Release and repeat.'
          ],
          'breathingRhythm': 'Exhale during the squeeze and hold',
          'actionFeeling': 'Outer thighs and hips engaging',
          'commonMistakes': [
            'Slouching or leaning back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Neck Half-Rolls',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit comfortably, let your chin drop to your chest.',
            'Slowly roll your right ear toward your right shoulder.',
            'Roll back down, then left ear toward left shoulder.',
            'Keep movements extremely gentle, focusing on neck relaxation.'
          ],
          'breathingRhythm': 'Slow, deep breaths to aid relaxation',
          'actionFeeling': 'Neck and upper shoulders releasing tension',
          'commonMistakes': [
            'Rolling the head backward (only half circles)'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},


{
  'id': 'seat_3',
  'title': 'Office Workout: Desk Exercise',
  'category': 'seat_exercises',
  'duration': 12,
  'calories': 56,
  'intensity': 'medium',
  'equipment': 'Chair, Desk',
  'focusZones': 'Core, Shoulders',
  'imageUrl': 'assets/images/seat_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Shoulder Shrugs and Rolls',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall. Lift shoulders toward ears (shrug).',
            'Lower and repeat 5 times.',
            'Then, roll shoulders backward in 5 large circles.',
            'Reverse and roll them forward 5 times.'
          ],
          'breathingRhythm': 'Inhale on shrug up, exhale on lower',
          'actionFeeling': 'Upper back and neck tension releasing',
          'commonMistakes': [
            'Moving too fast'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Desk Push-Ups (Seated Incline)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit back slightly, place hands shoulder-width apart on the edge of your sturdy desk.',
            'Lean your chest toward the desk by bending your elbows.',
            'Push back up, engaging your chest and triceps.',
            'Keep your back straight.'
          ],
          'breathingRhythm': 'Inhale down, exhale up',
          'actionFeeling': 'Chest and arms strengthening',
          'commonMistakes': [
            'Using an unstable desk',
            'Letting hips drop'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Core Tucks',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the front edge of the chair.',
            'Lean back slightly and lift both knees up towards your chest (as high as comfortable).',
            'Lower feet slowly back down, maintaining core tension.',
            'If too hard, alternate single knee lifts.'
          ],
          'breathingRhythm': 'Exhale as you lift knees, inhale as you lower',
          'actionFeeling': 'Lower abs and hip flexors activating',
          'commonMistakes': [
            'Rounding the lower back excessively',
            'Swinging the legs'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Back Squeeze (Rhomboids)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, extend arms straight out in front.',
            'Pull elbows back, squeezing your shoulder blades together tightly.',
            'Hold the squeeze for 2 seconds.',
            'Release slowly, extending arms forward.'
          ],
          'breathingRhythm': 'Exhale on the squeeze, inhale on the release',
          'actionFeeling': 'Mid-back muscles strengthening (posture muscles)',
          'commonMistakes': [
            'Shrugging shoulders instead of squeezing back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Figure-Four Stretch (Hips)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, cross right ankle over left knee.',
            'Gently lean forward until you feel a comfortable stretch in your right hip/glute.',
            'Hold for 30 seconds, then switch legs.'
          ],
          'breathingRhythm': 'Deep, slow, tension-releasing breaths',
          'actionFeeling': 'Outer hip and glute lengthening',
          'commonMistakes': [
            'Rounding your back'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

{
  'id': 'seat_4',
  'title': 'Chair Cardio: Seated Movement',
  'category': 'seat_exercises',
  'duration': 18,
  'calories': 89,
  'intensity': 'medium',
  'equipment': 'Sturdy Chair',
  'focusZones': 'Cardio, Full Body',
  'imageUrl': 'assets/images/seat_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Heel Taps (Quick)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, feet flat.',
            'Quickly tap your right heel out and back in, then your left heel.',
            'Increase speed to elevate heart rate gently.',
            'Keep the movement low to the ground.'
          ],
          'breathingRhythm': 'Breathe quickly but smoothly',
          'actionFeeling': 'Leg muscles warming, heart rate gently increasing',
          'commonMistakes': [
            'Slouching'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Seated Punches (Front & Uppercuts)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, core engaged.',
            'Punch alternating arms straight forward quickly for 30 seconds.',
            'Switch to alternating uppercuts (punching upward) for 30 seconds.',
            'Keep elbows soft, engage core with each punch.'
          ],
          'breathingRhythm': 'Exhale sharply with each punch',
          'actionFeeling': 'Shoulders and arms working, cardio response',
          'commonMistakes': [
            'Locking elbows',
            'Using back momentum'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Jumping Jacks (Modified)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hands starting on thighs.',
            'Simultaneously slide/tap feet out wide, and lift arms out and up overhead.',
            'Return to start position.',
            'Move as quickly as possible without losing form.'
          ],
          'breathingRhythm': 'Inhale on the open, exhale on the close',
          'actionFeeling': 'Cardio spike, full body low-impact coordination',
          'commonMistakes': [
            'Losing control of the torso',
            'Rushing movements too fast'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Alternating Elbow-to-Knee',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hands behind head.',
            'Bring right elbow towards left knee (crunch motion).',
            'Return and alternate, bringing left elbow to right knee.',
            'Focus on the twist in your core, not pulling your neck.'
          ],
          'breathingRhythm': 'Exhale on the twist, inhale on the return',
          'actionFeeling': 'Core and obliques working, gentle cardio',
          'commonMistakes': [
            'Pulling on the neck',
            'Slumping the shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Deep Breathing (Hands on Belly)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit back comfortably, hands resting gently on your abdomen.',
            'Inhale deeply through your nose, feeling your hands rise with your belly.',
            'Exhale slowly through your mouth, letting all the air out.',
            'Focus on slowing your heart rate with your breath.'
          ],
          'breathingRhythm': '5 counts in, 7 counts out',
          'actionFeeling': 'Calm, heart rate recovering',
          'commonMistakes': [
            'Shallow chest breathing'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

{
  'id': 'seat_5',
  'title': 'Sitting Strong: Core Activation',
  'category': 'seat_exercises',
  'duration': 15,
  'calories': 67,
  'intensity': 'medium',
  'equipment': 'Sturdy Chair',
  'focusZones': 'Core, Abs',
  'imageUrl': 'assets/images/seat_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Pelvic Tilts',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the edge of the chair.',
            'Gently tuck your tailbone under (flattening lower back), engaging lower abs.',
            'Gently arch your lower back (sticking tailbone out).',
            'Rock back and forth smoothly between the two positions.'
          ],
          'breathingRhythm': 'Exhale on the tuck, inhale on the arch',
          'actionFeeling': 'Deep core muscles and lower back mobilizing',
          'commonMistakes': [
            'Using momentum instead of core control'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Seated Leg Lifts (Core Hold)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the front edge, lean back slightly (engaging core).',
            'Lift both feet off the floor, holding them up by core strength.',
            'Hold the lifted position for the duration.',
            'Keep your back straight and breathe steadily.'
          ],
          'breathingRhythm': 'Slow, controlled breathing throughout the hold',
          'actionFeeling': 'Deep core and lower abs burning',
          'commonMistakes': [
            'Rounding the back',
            'Letting the legs drop'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Scissors (Leg Flutter)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Maintain the slight lean back (core engaged).',
            'Lift feet off the floor.',
            'Quickly flutter your legs up and down, mimicking scissors.',
            'Keep movements small and fast, focusing on the lower abs to stabilize.'
          ],
          'breathingRhythm': 'Short, quick breaths to match the pace',
          'actionFeeling': 'Low abdominal wall intensely engaged',
          'commonMistakes': [
            'Too large a flutter (keep it small)'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Single-Leg Extension (Slow)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall. Extend the right leg straight out and hold for 2 seconds.',
            'Lower the right leg and immediately extend the left leg and hold.',
            'Alternate legs, emphasizing the slow, controlled extension and quad squeeze.'
          ],
          'breathingRhythm': 'Exhale on the extension, inhale on the lower',
          'actionFeeling': 'Quads and core working together',
          'commonMistakes': [
            'Using hip flexors only, minimize quad squeeze'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Overhead Side Stretch',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, interlace hands and reach arms straight overhead.',
            'Gently lean to the right, stretching the left side (Hold 20 seconds).',
            'Return to center and gently lean to the left, stretching the right side.'
          ],
          'breathingRhythm': 'Deep, lengthening breaths into your ribcage',
          'actionFeeling': 'Sides of the body stretching and relaxing',
          'commonMistakes': [
            'Hunching forward'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

{
  'id': 'seat_6',
  'title': 'Desk Warrior: Quick Break Workout',
  'category': 'seat_exercises',
  'duration': 10,
  'calories': 45,
  'intensity': 'medium',
  'equipment': 'Chair',
  'focusZones': 'Full Body, Quick Hits',
  'imageUrl': 'assets/images/seat_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Arm Swings (Forward & Back)',
          'duration': 40,
          'rest': 10,
          'reps': null,
          'instructions': [
            'Sit tall, let your arms hang loosely by your sides.',
            'Gently swing both arms forward and backward together in a small range of motion.',
            'Increase range gradually to warm up the shoulder joint.'
          ],
          'breathingRhythm': 'Breathe naturally, coordinate with movement',
          'actionFeeling': 'Shoulders loosening and warming',
          'commonMistakes': [
            'Tensing the shoulders up to the ears'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Workout',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Seated High Knees (Fast Pace)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, hands gripping chair sides.',
            'March your knees up quickly and rhythmically, focusing on speed and range.',
            'Coordinate with vigorous arm pumps for maximum cardio effect.'
          ],
          'breathingRhythm': 'Maintain a quick, steady, fueling breath',
          'actionFeeling': 'Cardio spike, full-body quick activation',
          'commonMistakes': [
            'Letting the pace slow down',
            'Slouching the back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Chest Press (Imaginary Resistance)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, elbows bent, hands in front of chest (like holding a ball).',
            'Forcefully press your hands straight out in front of you, squeezing your chest.',
            'Hold the squeeze for 1 second, then return slowly.',
            'Imagine pushing against heavy air.'
          ],
          'breathingRhythm': 'Exhale on the push, inhale on the return',
          'actionFeeling': 'Chest and front of shoulders working',
          'commonMistakes': [
            'Locking elbows too hard',
            'Shrugging shoulders'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Ankle Pumps & Flexes (Active)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, both feet flat.',
            'Lift heels and forcefully point toes, then forcefully flex toes back toward you (pumps).',
            'Repeat quickly and strongly to increase circulation and work the calves/shins.'
          ],
          'breathingRhythm': 'Breathe consistently',
          'actionFeeling': 'Calves and shins activating, circulation improving',
          'commonMistakes': [
            'Rushing without forceful flex/point'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Wrist and Finger Stretches',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall. Extend right arm straight, palm up.',
            'Use left hand to gently pull right fingers down toward the floor (stretching forearm).',
            'Hold for 30 seconds, then switch arms.',
            'Wiggle fingers loosely after each side.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Release of tension in wrists and forearms',
          'commonMistakes': [
            'Pulling too hard'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== REVITALIZE AND RENEW WORKOUTS ====================

{
  'id': 'revitalize_1',
  'title': 'Happy Knees: Gentle Relief for Joint Pain',
  'category': 'revitalize_renew',
  'duration': 14,
  'calories': 77,
  'intensity': 'low',
  'equipment': 'Chair, Mat',
  'focusZones': 'Knees, Quads',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Seated Mobility)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Gentle Knee Bends',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on a chair, feet flat on the floor.',
            'Slide your right foot forward, slowly straightening the knee (no lock).',
            'Slide it back, bending the knee deeply (no pain).',
            'Alternate legs slowly and smoothly.'
          ],
          'breathingRhythm': 'Breathe naturally, exhale as you extend',
          'actionFeeling': 'Knees moving smoothly, muscles gently warming',
          'commonMistakes': [
            'Forcing the knee straight until it locks',
            'Moving too fast'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Seated Static Quad Contractions',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, rest hands on thighs.',
            'Press the back of your right knee down into the seat, squeezing the quad muscle.',
            'Hold the squeeze for 5 seconds.',
            'Release and repeat on the left leg.',
            'Alternate legs slowly.'
          ],
          'breathingRhythm': 'Exhale during the hold, inhale on the release',
          'actionFeeling': 'Front of thigh muscles engaging to stabilize the knee',
          'commonMistakes': [
            'Slouching the back',
            'Tensing up shoulders'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Short Arc Quads (Lying, Pillow under Knee)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on mat, place a rolled towel/small pillow under the right knee.',
            'Extend the right lower leg fully, lifting the foot off the ground.',
            'Hold for 3 seconds, focusing on the quad contraction.',
            'Lower slowly. Switch legs halfway through.'
          ],
          'breathingRhythm': 'Exhale on the extension, inhale on the lower',
          'actionFeeling': 'Quadriceps working, minimal knee joint pressure',
          'commonMistakes': [
            'Lifting the knee off the support'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Hamstring Curl (Assisted)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand, hold onto a chair for balance.',
            'Slowly bend your right knee, bringing your heel toward your glute (halfway point).',
            'Lower the foot slowly. Focus on the contraction in the back of the thigh.',
            'Alternate legs slowly and controlled.'
          ],
          'breathingRhythm': 'Exhale on the curl up, inhale on the lower',
          'actionFeeling': 'Back of thighs (hamstrings) contracting',
          'commonMistakes': [
            'Arching the lower back',
            'Kicking the heel up quickly'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Gentle Calf Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, extend right leg straight, heel down, toe up.',
            'Gently lean forward and reach for your right foot (or shin).',
            'Hold for 30 seconds, maintaining a straight back.',
            'Switch legs and repeat.'
          ],
          'breathingRhythm': 'Slow, tension-releasing breaths',
          'actionFeeling': 'Gentle stretch in the back of the knee and calf',
          'commonMistakes': [
            'Rounding the spine aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'revitalize_2',
  'title': 'Strong Ankles: Stability for Every Step',
  'category': 'revitalize_renew',
  'duration': 15,
  'calories': 99,
  'intensity': 'low',
  'equipment': 'Chair (for support)',
  'focusZones': 'Ankles, Calves, Balance',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Foot and Ankle)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Ankle Alphabet (Seated)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit on the edge of a chair, lift right foot slightly off the floor.',
            'Use your foot to slowly draw the letters of the alphabet in the air (A-L).',
            'Switch feet and repeat (M-Z).',
            'Keep the movement controlled and smooth.'
          ],
          'breathingRhythm': 'Breathe naturally and evenly',
          'actionFeeling': 'Ankles mobilizing, feet warming up',
          'commonMistakes': [
            'Moving the entire leg instead of isolating the ankle'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Standing Single-Leg Balance (Assisted)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand near a chair/wall, lightly touch it for support.',
            'Shift weight to your right foot, lift your left foot slightly.',
            'Hold the balance for 30 seconds (or as long as possible).',
            'Switch sides and repeat.',
            'Keep the standing knee soft.'
          ],
          'breathingRhythm': 'Slow, controlled breaths for stability',
          'actionFeeling': 'Ankle stabilizers and core engaging',
          'commonMistakes': [
            'Gripping the floor too hard with toes',
            'Leaning heavily on the support'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Tandem Stance (Heel-to-Toe)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, place your right heel directly in front of your left toes.',
            'Lightly touch a wall for balance if needed.',
            'Hold this heel-to-toe stance for 30 seconds.',
            'Switch the front foot and repeat.'
          ],
          'breathingRhythm': 'Maintain steady breathing',
          'actionFeeling': 'Increased challenge to ankle stabilizers and core',
          'commonMistakes': [
            'Losing alignment of the feet'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Modified Calf Raises (Slow Descent)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Hold a chair for balance.',
            'Rise up onto both toes quickly.',
            'Lower your heels back to the floor **very slowly** (4 counts down).',
            'Focus on eccentric strength.'
          ],
          'breathingRhythm': 'Exhale up, inhale slow on the descent',
          'actionFeeling': 'Calves working, gentle stretch at the bottom',
          'commonMistakes': [
            'Dropping the heels too quickly'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wall Heel Drop Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand facing a wall, place the ball of your right foot against the wall (heel on floor).',
            'Keep the knee straight and lean forward gently to stretch the calf.',
            'Hold for 30 seconds, then switch legs.',
            'Keep your hips square to the wall.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Deep stretch in the calf and Achilles tendon',
          'commonMistakes': [
            'Bouncing in the stretch',
            'Rounding the back'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'revitalize_3',
  'title': 'Recovery Flow: Healing Movement',
  'category': 'revitalize_renew',
  'duration': 20,
  'calories': 112,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Spine, Hips, Gentle Strength',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Spinal Mobility)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Cat-Cow Flow (Slow)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees (tabletop).',
            'Inhale, drop belly, look up (Cow Pose).',
            'Exhale, round spine, tuck tailbone and chin (Cat Pose).',
            'Move extremely slowly, emphasizing the stretch and release in the spine.'
          ],
          'breathingRhythm': 'Inhale on arch, exhale on round (long and deep)',
          'actionFeeling': 'Spine mobilizing gently, core warming',
          'commonMistakes': [
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Bird Dog (Core Stabilization)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees.',
            'Extend right arm forward and left leg back (slowly).',
            'Hold for 3 seconds, keeping hips level and core tight.',
            'Return to center and switch sides.',
            'Focus on stability, not height.'
          ],
          'breathingRhythm': 'Exhale on the extension, inhale on the return',
          'actionFeeling': 'Core, glutes, and back muscles stabilizing',
          'commonMistakes': [
            'Letting the back arch',
            'Rotating the hips when extending the leg'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Knee-to-Chest Rotation (Supine)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on back, knees bent, feet flat.',
            'Bring right knee to chest, grasp with hands.',
            'Gently guide the knee outward toward the right armpit (hip opener).',
            'Hold for 15 seconds, return to center, and switch legs.'
          ],
          'breathingRhythm': 'Deep, purposeful breaths',
          'actionFeeling': 'Gentle stretch in the hip flexor and groin area',
          'commonMistakes': [
            'Pulling too hard or quickly'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Supported Cobra Flow (Low Intensity)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on stomach, forearms flat on mat (Sphinx Pose).',
            'Press forearms down to gently lift chest and arch back slightly.',
            'Relax shoulders away from ears.',
            'Hold the gentle backbend for the duration.'
          ],
          'breathingRhythm': 'Abdominal breathing into the stretch',
          'actionFeeling': 'Lower back release and gentle stretch in abdomen',
          'commonMistakes': [
            'Shrugging the shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Knees-to-Chest and Rock',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on back, hug both knees to chest.',
            'Gently rock side to side, massaging the spine.',
            'Allow your shoulders and neck to fully relax.',
            'Hold the static position for the final 30 seconds.'
          ],
          'breathingRhythm': 'Slowest, deepest breathing for full relaxation',
          'actionFeeling': 'Complete spinal decompression and calm',
          'commonMistakes': [
            'Tensing up instead of relaxing'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'revitalize_4',
  'title': 'Renewal Yoga: Body & Mind',
  'category': 'revitalize_renew',
  'duration': 25,
  'calories': 134,
  'intensity': 'medium',
  'equipment': 'Mat',
  'focusZones': 'Flexibility, Balance, Core',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Sun Salutation Prep)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Tadasana (Mountain Pose) to Arm Raise',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall (Tadasana), rooting down through feet.',
            'Inhale, sweep arms overhead, gazing up.',
            'Exhale, gently fold forward, hands toward floor (soft knees).',
            'Inhale, flatten back (half lift). Exhale, forward fold.',
            'Repeat the sequence slowly 4 times.'
          ],
          'breathingRhythm': 'Coordination of breath and movement (smooth flow)',
          'actionFeeling': 'Full body warming, spinal mobility increasing',
          'commonMistakes': [
            'Rushing the movement',
            'Locking the knees on the forward fold'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Warrior II Flow',
          'duration': 60,
          'rest': 20,
          'reps': null,
          'instructions': [
            'Step right foot forward (front knee bent 90 degrees), left foot angled out.',
            'Arms extended parallel to floor (Warrior II).',
            'Inhale, straighten front leg, reach arms up.',
            'Exhale, bend front knee, settle back into Warrior II.',
            'Flow between positions slowly. Switch legs each set.'
          ],
          'breathingRhythm': 'Inhale on the straight leg, exhale on the deep lunge',
          'actionFeeling': 'Leg and glute strength, hip opening',
          'commonMistakes': [
            'Letting the front knee collapse inward'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Tree Pose (Vrksasana)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand on right leg, bring left foot to inner calf or inner thigh (avoid knee).',
            'Hands at heart center, or reach arms up overhead (if balanced).',
            'Hold the balance for 20 seconds, maintaining a fixed gaze.',
            'Switch legs and repeat.'
          ],
          'breathingRhythm': 'Slow, centered breathing',
          'actionFeeling': 'Ankle stability and concentration challenged',
          'commonMistakes': [
            'Shifting weight side to side excessively'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Low Boat Pose (Modified)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit on mat, knees bent, feet flat.',
            'Lean back slightly, engaging core (keep back straight).',
            'Lift shins parallel to the floor (or keep toes tapped for modification).',
            'Hold the static position, breathing steadily.'
          ],
          'breathingRhythm': 'Exhale slowly, draw navel toward spine',
          'actionFeeling': 'Deep abdominal strength',
          'commonMistakes': [
            'Rounding the lower back severely',
            'Straining the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Spinal Twist (Seated)',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit cross-legged (or legs extended).',
            'Place right hand behind you, left hand on outer right knee.',
            'Gently twist your torso to the right, looking over your shoulder.',
            'Hold for 45 seconds, breathing deeply into the twist.',
            'Switch sides and repeat.'
          ],
          'breathingRhythm': 'Exhale to deepen the twist, inhale to maintain height',
          'actionFeeling': 'Spinal mobility and release',
          'commonMistakes': [
            'Twisting too aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'revitalize_5',
  'title': 'Joint Care: Gentle Mobility',
  'category': 'revitalize_renew',
  'duration': 12,
  'calories': 67,
  'intensity': 'low',
  'equipment': 'Chair',
  'focusZones': 'Shoulders, Hips, Knees',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Range)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Hip Flexor Circles',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall on the edge of a chair, hands on thighs.',
            'Lift your right knee slightly and move the thigh in small, slow circles.',
            'Do 30 seconds clockwise, then 30 seconds counter-clockwise.',
            'Keep your torso still.'
          ],
          'breathingRhythm': 'Breathe naturally and slowly',
          'actionFeeling': 'Hip joint lubricating gently',
          'commonMistakes': [
            'Leaning back or slouching'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Standing Pendulum Swings (Shoulders)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with feet wide, hinge forward slightly (supported by a chair/table if needed).',
            'Let your arms hang loosely.',
            'Gently swing both arms forward and backward (small, easy swings).',
            'Then switch to small side-to-side swings.',
            'Keep the movement pain-free.'
          ],
          'breathingRhythm': 'Gentle, steady breathing',
          'actionFeeling': 'Shoulder joints mobilizing with gravity assist',
          'commonMistakes': [
            'Stiffening the neck or back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Knee Extensions (Hold)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit tall, extend right leg straight, quad squeezed (do not lock knee).',
            'Hold the extension for 15 seconds.',
            'Lower and switch legs.',
            'Repeat the hold sequence.'
          ],
          'breathingRhythm': 'Controlled breathing during the isometric hold',
          'actionFeeling': 'Front of thigh strengthening for knee support',
          'commonMistakes': [
            'Holding breath during the squeeze'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Ankle Pumps (Dorsiflexion/Plantarflexion)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit, extend both legs slightly off the floor or rest heels down.',
            'Point toes away forcefully (plantarflexion), then pull toes back forcefully (dorsiflexion).',
            'Repeat rhythmically, focusing on maximum range of motion in the ankle.'
          ],
          'breathingRhythm': 'Breathe steadily with the pumping action',
          'actionFeeling': 'Calf and shin muscles contracting, improved circulation',
          'commonMistakes': [
            'Not fully flexing or pointing'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Spinal Side Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, drop right ear to right shoulder (hold 15 seconds).',
            'Return to center, drop left ear to left shoulder (hold 15 seconds).',
            'Finish by interlocking hands overhead and gently stretching to each side (15 seconds each side).'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Release of neck and side body tension',
          'commonMistakes': [
            'Pulling on the head or neck'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'revitalize_6',
  'title': 'Restore & Recharge: Active Recovery',
  'category': 'revitalize_renew',
  'duration': 18,
  'calories': 89,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Flexibility, Blood Flow',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Circulation Booster)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated (or Standing) Arm Wrings',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Extend arms straight out in front.',
            'Twist palms to face up, then twist forcefully to face down (wringing motion).',
            'Repeat rhythmically, focusing on the rotation in the wrist and forearm.',
            'Keep your shoulders relaxed.'
          ],
          'breathingRhythm': 'Breathe naturally, coordinate with the twist',
          'actionFeeling': 'Forearms and wrists mobilizing, improving hand circulation',
          'commonMistakes': [
            'Tensing the shoulders'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Lying Leg Slides (Hamstring Floss)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on back, one knee bent, one leg straight.',
            'Lift the straight leg up (only as high as comfortable).',
            'With the leg up, flex and point your foot rhythmically.',
            'Lower the leg and repeat. Switch legs each round.'
          ],
          'breathingRhythm': 'Steady, gentle breaths',
          'actionFeeling': 'Hamstrings gently stretching dynamically, nerve gliding',
          'commonMistakes': [
            'Lifting the leg too high and straining'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Supported Kneeling Hip Flexor Stretch',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Kneel on mat, step right foot forward (low lunge position).',
            'Tuck the pelvis slightly forward to deepen the stretch in the left hip flexor.',
            'Hold lightly onto a chair if needed for balance.',
            'Hold for 20 seconds, then switch legs.'
          ],
          'breathingRhythm': 'Deep, purposeful breaths into the stretched hip',
          'actionFeeling': 'Release of tension in the front of the hip',
          'commonMistakes': [
            'Arching the lower back (pelvis tuck is key)'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated (or Standing) Full Body Reach',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit or stand tall, inhale and stretch arms up and out, making yourself as tall as possible.',
            'Exhale and squeeze arms down to your sides, engaging your lats (back muscles).',
            'Repeat smoothly and mindfully, linking breath to movement.'
          ],
          'breathingRhythm': 'Inhale on the reach, exhale on the squeeze',
          'actionFeeling': 'Full body activation and controlled range of motion',
          'commonMistakes': [
            'Rushing the movement'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Supine Relaxation (Legs Up Chair)',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on your back, place lower legs/calves up onto a chair or sofa (knees at 90 degrees).',
            'Let your arms rest by your sides, palms up.',
            'Close your eyes and allow gravity to drain fluid and tension from your legs.',
            'Focus on deep, restful breathing.'
          ],
          'breathingRhythm': 'Deepest, slowest breaths for nervous system relaxation',
          'actionFeeling': 'Profound calm and physical restoration',
          'commonMistakes': [
            'Fidgeting or checking the clock'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== INNER CALM WORKOUTS ====================

{
  'id': 'inner_calm_1',
  'title': 'Fresh Face Starter: Yoga for Radiance',
  'category': 'inner_calm',
  'duration': 9,
  'calories': 20,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Neck, Spine, Breath',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Centering)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Breath Awareness',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit comfortably cross-legged or on a cushion, spine tall.',
            'Close your eyes and place one hand on your belly, one on your chest.',
            'Focus on the sensation of your breath.',
            'Notice the rising and falling of your hands.'
          ],
          'breathingRhythm': 'Natural, gentle breathing through the nose',
          'actionFeeling': 'Calm, centered, mental focus beginning',
          'commonMistakes': [
            'Forcing the breath',
            'Allowing distracting thoughts to dominate'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Flow',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Easy Twist',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Inhale, sit tall. Exhale, gently twist your torso to the right.',
            'Place your right hand behind you, left hand on outer right knee.',
            'Hold the gentle twist, breathing for 45 seconds.',
            'Return to center and gently twist to the left for 45 seconds.'
          ],
          'breathingRhythm': 'Exhale to deepen the twist, inhale to lengthen spine',
          'actionFeeling': 'Gentle mobilization in the spine and shoulders',
          'commonMistakes': [
            'Rounding the back instead of sitting tall'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Gentle Neck Circles',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Let your chin drop to your chest.',
            'Slowly roll your right ear toward your right shoulder (only half circles).',
            'Roll back down, then roll left ear toward left shoulder.',
            'Move extremely slow, coordinating with long exhales.'
          ],
          'breathingRhythm': 'Long, slow exhales with movement',
          'actionFeeling': 'Tension melting away from the neck and jaw',
          'commonMistakes': [
            'Rolling the head all the way back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Diaphragmatic Breathing',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit comfortably, close eyes.',
            'Inhale slowly for a count of 4, filling your belly.',
            'Exhale slowly for a count of 6 or 8, pulling your belly in.',
            'Repeat rhythmically for the duration.'
          ],
          'breathingRhythm': '4 counts in, 6-8 counts out (focused)',
          'actionFeeling': 'Deep calm, restored energy, inner radiance',
          'commonMistakes': [
            'Rushing the exhale'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'inner_calm_2',
  'title': 'Relax Forehead: Soothe Stress with Yoga',
  'category': 'inner_calm',
  'duration': 9,
  'calories': 19,
  'intensity': 'low',
  'equipment': 'Mat, Cushion',
  'focusZones': 'Face, Head, Upper Back',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Facial Release)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Jaw and Eyebrow Relaxers',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Gently massage your jaw muscles with your fingertips (30 seconds).',
            'Use your fingertips to gently rub your temples and sweep across your forehead, smoothing tension.',
            'Gently open and close your mouth widely (slowly) 3 times.'
          ],
          'breathingRhythm': 'Breathe naturally, maybe sigh on the jaw release',
          'actionFeeling': 'Tension leaving the face and head',
          'commonMistakes': [
            'Pressing too hard or aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Flow',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Child\'s Pose (Supported)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Kneel on the mat, sitting hips back toward heels (use cushion if needed).',
            'Fold forward, resting your forehead gently on the mat or a prop.',
            'Let your arms rest by your sides or stretch forward lightly.',
            'Hold the pose, focusing on releasing tension from the forehead and back.'
          ],
          'breathingRhythm': 'Deep, grounding breaths, feel abdomen pressing into thighs',
          'actionFeeling': 'Calming the nervous system, lower back decompression',
          'commonMistakes': [
            'Holding tension in the shoulders'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Shoulder Shrugs and Release (Seated)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit up from Child\'s Pose. Inhale, shrug shoulders up hard toward ears.',
            'Exhale, sigh loudly, and let them drop completely.',
            'Repeat 5 times quickly, then let shoulders relax completely for the remainder.'
          ],
          'breathingRhythm': 'Audible sigh on the exhale/drop',
          'actionFeeling': 'Quick release of shoulder and neck tension',
          'commonMistakes': [
            'Not releasing the shoulders fully'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Alternate Nostril Breathing (Nadi Shodhana)',
          'duration': 90,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall. Close right nostril with thumb, inhale left (4 counts).',
            'Close left nostril with ring finger, exhale right (6 counts).',
            'Inhale right (4 counts). Close right, exhale left (6 counts).',
            'Continue alternating to balance energy and calm the mind.'
          ],
          'breathingRhythm': '4 counts inhale, 6 counts exhale (controlled)',
          'actionFeeling': 'Mental clarity, deep calm, soothing stress',
          'commonMistakes': [
            'Rushing the exhale',
            'Pinched grip on the nose'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'inner_calm_3',
  'title': 'Meditation Flow: Peaceful Mind',
  'category': 'inner_calm',
  'duration': 15,
  'calories': 34,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Mindfulness, Relaxation',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Transition to Stillness)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Gentle Head-to-Heart Flow (Seated)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit comfortably. Place hands on your knees.',
            'Inhale, lift chest and gaze up slightly (small arch).',
            'Exhale, tuck chin and round your back slightly (small rounding).',
            'Move between the two positions very slowly 5 times.'
          ],
          'breathingRhythm': 'Inhale on lift, exhale on tuck',
          'actionFeeling': 'Spine mobilizing gently, preparing for stillness',
          'commonMistakes': [
            'Arching too severely'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Seated Body Scan Meditation',
          'duration': 420,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, eyes closed. Bring awareness to your toes, feeling any sensation.',
            'Slowly move attention up through your feet, ankles, calves, and knees.',
            'Continue moving slowly up the body, resting attention on each area (hips, core, back, chest, shoulders, arms, hands, neck, face).',
            'Release any tension found in each area as you breathe.'
          ],
          'breathingRhythm': 'Maintain smooth, gentle, focused breaths',
          'actionFeeling': 'Deep relaxation, increased body awareness',
          'commonMistakes': [
            'Rushing through areas of the body',
            'Judging sensations'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Open Palm Seated Relaxation',
          'duration': 180,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Keep eyes closed. Turn palms up on your knees (receiving position).',
            'Set an intention or express gratitude for the session.',
            'Breathe normally, feeling fully rested.',
            'Gently open your eyes when ready.'
          ],
          'breathingRhythm': 'Natural, unforced breathing',
          'actionFeeling': 'Grounding, peaceful mind, fully present',
          'commonMistakes': [
            'Leaning or slouching'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'inner_calm_4',
  'title': 'Stress Relief: Calming Practice',
  'category': 'inner_calm',
  'duration': 12,
  'calories': 28,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Hips, Upper Back, Breath',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Gentle Mobilization)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Tabletop Taps (Alternating Limbs)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees.',
            'Gently lift and tap your right hand and left knee back down.',
            'Switch and lift and tap left hand and right knee back down.',
            'Keep the movement minimal, focusing on core engagement and control.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the tap down',
          'actionFeeling': 'Core activating, sense of control and stability',
          'commonMistakes': [
            'Rushing or losing connection to the core'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Flow',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Thread the Needle Pose',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start on hands and knees.',
            'Slide your right arm under your left armpit, resting your right shoulder and head on the mat.',
            'Hold the gentle twist and shoulder stretch for 45 seconds.',
            'Return to center and switch sides.'
          ],
          'breathingRhythm': 'Deep, expansive breaths into the back of the ribs',
          'actionFeeling': 'Release of tension in the upper back and shoulders',
          'commonMistakes': [
            'Letting the hips shift too far out of alignment'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Forward Fold (Supported)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit with legs extended, place a pillow or bolster across your thighs.',
            'Gently fold forward over the prop, resting your head down (if comfortable).',
            'Allow gravity to release tension in your hamstrings and back.',
            'Hold the passive stretch.'
          ],
          'breathingRhythm': 'Long, slow exhales to surrender the weight of the body',
          'actionFeeling': 'Calming the mind, releasing physical tension',
          'commonMistakes': [
            'Forcing the fold without support'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': '4-7-8 Breathwork (Seated)',
          'duration': 120,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Sit tall, eyes closed. Inhale through nose for 4 counts.',
            'Hold breath for 7 counts.',
            'Exhale completely through mouth (making a whoosh sound) for 8 counts.',
            'Repeat the cycle 4 times to down-regulate the nervous system.'
          ],
          'breathingRhythm': '4 in, 7 hold, 8 out (precisely timed)',
          'actionFeeling': 'Immediate calming, deep relaxation response',
          'commonMistakes': [
            'Holding the breath uncomfortably long',
            'Rushing the exhale'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'inner_calm_5',
  'title': 'Inner Peace: Mindful Movement',
  'category': 'inner_calm',
  'duration': 20,
  'calories': 45,
  'intensity': 'low',
  'equipment': 'Mat',
  'focusZones': 'Hips, Core, Total Body',
  'imageUrl': 'assets/images/strengthen_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Mindful March)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Weight Shift and Awareness',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, eyes soft.',
            'Slowly shift your weight entirely onto your right foot, then slowly shift to your left foot.',
            'Notice the feeling of the feet rooting down.',
            'Add gentle arm swings forward and back.'
          ],
          'breathingRhythm': 'Slow, rhythmic breaths',
          'actionFeeling': 'Grounding, gentle warming in the legs',
          'commonMistakes': [
            'Rushing the shift',
            'Tensing the upper body'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Flow',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Gate Pose (Parighasana)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Kneel on the mat, extend your right leg straight out to the side (foot flat).',
            'Inhale, reach left arm overhead. Exhale, side bend to the right, sliding right hand down right leg.',
            'Hold the deep side stretch for 30 seconds, breathing into your ribs.',
            'Return to center and switch sides.'
          ],
          'breathingRhythm': 'Deep breaths into the side body stretch',
          'actionFeeling': 'Intense side body lengthening, hip opening',
          'commonMistakes': [
            'Hunching forward or backward'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Low Lunge with Arm Sweep',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start in kneeling, step right foot forward (low lunge).',
            'Inhale, sweep arms up overhead.',
            'Exhale, sink into the stretch, feeling release in the left hip flexor.',
            'Hold the lunge for 45 seconds. Return and switch legs.'
          ],
          'breathingRhythm': 'Long, slow exhales to release hip tension',
          'actionFeeling': 'Hip flexor stretch, gentle backbend for vitality',
          'commonMistakes': [
            'Letting the front knee go past the ankle'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Seated Head-to-Knee Pose (Janu Sirsasana)',
          'duration': 90,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Sit, extend left leg, tuck right foot to inner left thigh.',
            'Inhale, sit tall. Exhale, fold forward over the extended leg.',
            'Hold for 45 seconds, relaxing the neck and back.',
            'Switch legs and repeat.'
          ],
          'breathingRhythm': 'Exhale to soften, inhale to lengthen',
          'actionFeeling': 'Hamstring and lower back release',
          'commonMistakes': [
            'Twisting the torso toward the bent knee'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Constructive Rest Pose (Legs Bent)',
          'duration': 180,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on back, knees bent, feet hip-width apart and flat on the floor.',
            'Let your knees rest against each other, arms by sides.',
            'Allow gravity to relax the pelvis and lower back.',
            'Rest in silence and stillness.'
          ],
          'breathingRhythm': 'Deep, calming, natural breaths',
          'actionFeeling': 'Spinal neutrality, deep inner peace',
          'commonMistakes': [
            'Allowing distracting thoughts to interrupt the rest'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'inner_calm_6',
  'title': 'Zen Zone: Deep Relaxation',
  'category': 'inner_calm',
  'duration': 18,
  'calories': 38,
  'intensity': 'low',
  'equipment': 'Mat, Blanket/Pillow',
  'focusZones': 'Total Relaxation, Stress Reduction',
  'imageUrl': 'assets/images/strengthen_2.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Gentle Joint Movement)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Supine Windshield Wiper Legs',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lie on back, knees bent, feet wide apart (wider than hips).',
            'Slowly let both knees drop over to the right (gentle twist).',
            'Bring them back up and let them drop to the left.',
            'Move slowly and rhythmically like a windshield wiper.'
          ],
          'breathingRhythm': 'Exhale on the drop, inhale on the lift',
          'actionFeeling': 'Gentle massage for the lower back and hips',
          'commonMistakes': [
            'Moving too fast or aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Focus',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Legs Up the Wall (Viparita Karani)',
          'duration': 420,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on mat, position your hips close to a wall, extending your legs straight up against the wall.',
            'Use a pillow under your head/lower back for comfort.',
            'Arms relaxed by sides. Hold this restorative pose.',
            'Allow your body to completely surrender to the support of the wall.'
          ],
          'breathingRhythm': 'Deep, passive, abdominal breathing',
          'actionFeeling': 'Inversion calming the nervous system, lower body fluid drainage',
          'commonMistakes': [
            'Tensing the hamstrings or back'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Extended Savasana (Corpse Pose)',
          'duration': 480,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie flat on your back, removing all props (use a blanket for warmth).',
            'Let feet fall open, palms up. Close your eyes.',
            'Intentionally relax every part of your body, starting from the toes up to the crown of your head.',
            'Rest in complete stillness and silence for the full duration.'
          ],
          'breathingRhythm': 'Natural, unforced resting breath',
          'actionFeeling': 'Profound mental and physical rest, deepest relaxation',
          'commonMistakes': [
            'Moving or checking the time'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

  // ==================== DANCE PARTY WORKOUTS ====================

{
  'id': 'dance_1',
  'title': 'Rhythm and Recharge',
  'category': 'dance_party',
  'duration': 4,
  'calories': 32,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Cardio, Hips, Legs',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Groove Starter)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Side-to-Side Step Touch',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot to the side, tap left foot to meet it.',
            'Keep your steps wide and light.',
            'Add gentle hip sway and arm swings to the beat.',
            'Maintain a soft bend in your knees.'
          ],
          'breathingRhythm': 'Breathe smoothly, matching movement rhythm',
          'actionFeeling': 'Heart rate gently increasing, joints lubricating',
          'commonMistakes': [
            'Landing heavily on feet',
            'Stiffening the torso'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Basic Grapevine with Claps',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right, cross left behind, step right, tap left (Grapevine Right).',
            'Reverse and go to the left.',
            'Add a clap when feet tap together at the end of each sequence.',
            'Keep the pace upbeat.'
          ],
          'breathingRhythm': 'Exhale on the clap, inhale during the steps',
          'actionFeeling': 'Hips mobilizing, heart rate high',
          'commonMistakes': [
            'Losing the rhythm/foot pattern',
            'Rushing the movements'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Shoulder Shimmies and Hip Circles',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with soft knees, shift hips in large, smooth circles (15 seconds one way).',
            'Reverse the hip circle (15 seconds).',
            'Finish with quick, small shoulder shimmies to the beat.'
          ],
          'breathingRhythm': 'Deep, continuous breaths',
          'actionFeeling': 'Core and upper body engaging rhythmically',
          'commonMistakes': [
            'Moving too stiffly',
            'Forgetting to engage the core'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Gentle Body Sway and Deep Breathing',
          'duration': 30,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Slow your movements to a gentle sway side to side.',
            'Raise arms overhead on the inhale, and lower them slowly on the exhale.',
            'Focus on recovering your breath and heart rate.'
          ],
          'breathingRhythm': 'Slow, long exhales (5 counts in, 7 counts out)',
          'actionFeeling': 'Calm, recovered, energized',
          'commonMistakes': [
            'Stopping movement immediately'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_2',
  'title': 'Maximum Fit Challenge',
  'category': 'dance_party',
  'duration': 5,
  'calories': 42,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'Cardio, Full Body',
  'imageUrl': 'assets/images/dance_card_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Core Activation)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Heel Digs and Arm Pumps',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Tap right heel forward, then left heel, at a steady pace.',
            'Pump arms vigorously forward and backward (like speed walking).',
            'Engage your core with each pump.',
            'Keep the intensity moderate.'
          ],
          'breathingRhythm': 'Breathe consistently with the pace',
          'actionFeeling': 'Warming up legs and raising heart rate quickly',
          'commonMistakes': [
            'Moving too slowly to warm up effectively'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'High Knee March (Double Time)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'March in place, bringing knees as high as possible.',
            'Focus on quick feet and short ground contact.',
            'Pump arms hard.',
            'If jumping is comfortable, transition to light knee-lift jumps for the last 15 seconds.'
          ],
          'breathingRhythm': 'Exhale on each knee lift',
          'actionFeeling': 'High cardio, major leg muscle engagement',
          'commonMistakes': [
            'Slouching the back',
            'Losing control of the core'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Power Squat Taps (Wide Stance)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand in a wide squat stance, toes turned slightly out.',
            'Lower hips into a squat (as low as comfortable).',
            'As you stand up, tap the right toe out to the side, then return to squat.',
            'Alternate tapping right and left toe on the stand up.'
          ],
          'breathingRhythm': 'Inhale down, exhale on the stand up/tap',
          'actionFeeling': 'Glutes and quads burning, core stability challenged',
          'commonMistakes': [
            'Letting knees collapse inward',
            'Rounding the back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Jabs and Crosses (Fast)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Feet wide, soft knees. Quickly throw alternating jabs (straight front punch).',
            'Switch to crosses (across the body) with a slight hip twist.',
            'Keep speed and force high for the duration.'
          ],
          'breathingRhythm': 'Exhale sharply with every punch',
          'actionFeeling': 'Upper body cardio, core rotation',
          'commonMistakes': [
            'Flailing arms loosely',
            'Locking elbows'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Full Body Reach and Slow Step',
          'duration': 30,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Walk slowly in place.',
            'Inhale, reach arms high overhead for a stretch.',
            'Exhale, fold halfway forward, letting arms swing loosely.',
            'Repeat twice, then stop and focus on breathing.'
          ],
          'breathingRhythm': 'Deep, calming breaths',
          'actionFeeling': 'Heart rate lowering, muscles lengthening',
          'commonMistakes': [
            'Bouncing on the fold'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_3',
  'title': 'Energy & Excellence',
  'category': 'dance_party',
  'duration': 5,
  'calories': 45,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Cardio, Core, Arms',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Stretch)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Arm Circles (Forward and Back)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, make large forward circles with arms for 20 seconds.',
            'Reverse the direction, making large backward circles for 20 seconds.',
            'Keep your core braced and try to avoid arching your back.'
          ],
          'breathingRhythm': 'Steady, fluid breathing',
          'actionFeeling': 'Shoulders loosening, heart rate increasing',
          'commonMistakes': [
            'Lifting shoulders to the ears'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Alternating Front Kicks (Low)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Kick your right foot low in front of you, then switch to the left.',
            'Keep the kicks controlled and low (shin height is fine).',
            'Add alternating arm punches or reaches to the kick rhythm.'
          ],
          'breathingRhythm': 'Exhale with each kick',
          'actionFeeling': 'Core, hip flexors, and quads engaging for balance',
          'commonMistakes': [
            'Kicking too high and losing balance',
            'Rounding the back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'V-Step Shuffle',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot forward and out, left foot forward and out (forming a V).',
            'Step right foot back, left foot back (closing the V).',
            'Keep repeating the V pattern, adding big arm scoops or raises.'
          ],
          'breathingRhythm': 'Match your breath to the stepping rhythm',
          'actionFeeling': 'Cardio and leg coordination working',
          'commonMistakes': [
            'Steps too small or rushed'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Grapevine with Side Taps',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform a regular grapevine (like dance\_1).',
            'Instead of tapping, pause and tap the free foot out to the side 3 times before starting the grapevine in the opposite direction.'
          ],
          'breathingRhythm': 'Focus on deep, continuous breaths',
          'actionFeeling': 'Coordination and hip work',
          'commonMistakes': [
            'Losing the flow between the tap and the grapevine'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Overhead Breathing Stretch (Standing)',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand still, interlace fingers and turn palms up toward the ceiling.',
            'Inhale, stretch high. Exhale, gently lean to the right (hold for 10 seconds).',
            'Inhale to center. Exhale and lean to the left (hold for 10 seconds).',
            'Lower arms slowly.'
          ],
          'breathingRhythm': 'Deep, expansive breaths',
          'actionFeeling': 'Release in core and side body, heart rate calming',
          'commonMistakes': [
            'Arching the lower back on the reach'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_4',
  'title': 'Cardio Blast',
  'category': 'dance_party',
  'duration': 6,
  'calories': 54,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'Cardio, Full Body Endurance',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Active Mobility)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Arm and Leg Swings (Alternating)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Swing right arm forward as you swing left leg forward (low range).',
            'Reverse: left arm forward, right leg forward.',
            'Keep movements small, controlled, and synchronized.',
            'Increase range slightly halfway through.'
          ],
          'breathingRhythm': 'Breathe naturally with the swing',
          'actionFeeling': 'Shoulders and hips mobilizing',
          'commonMistakes': [
            'Jerking the movement'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Cha-Cha Steps (Quick Feet)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Feet together, step right, step left, step right (Cha-Cha-Cha).',
            'Repeat going left: step left, step right, step left.',
            'Keep steps quick and light, almost a shuffle.',
            'Add rhythmic arm pumps.'
          ],
          'breathingRhythm': 'Maintain quick, shallow breaths',
          'actionFeeling': 'High pace, lower body quickness, cardio spike',
          'commonMistakes': [
            'Lifting feet too high',
            'Losing the beat'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Jumping Jack Variation (Tap Out)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Instead of jumping, step right foot out, bring arms overhead.',
            'Step right foot in, bring arms down.',
            'Alternate stepping right and left to the side (No-Jump Jack).',
            'Keep the pace very fast to maintain cardio intensity.'
          ],
          'breathingRhythm': 'Inhale on the open, exhale on the close',
          'actionFeeling': 'Full body endurance, sustained cardio',
          'commonMistakes': [
            'Slowing the pace down too much'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Slow March and Shoulder Relaxation',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Slow your pace to a gentle march.',
            'Gently roll your shoulders back and forth.',
            'Gradually slow the march to a stop and let arms hang loosely.',
            'Take deep, belly-focused breaths.'
          ],
          'breathingRhythm': 'Slow, long exhales',
          'actionFeeling': 'Heart rate returning to resting level',
          'commonMistakes': [
            'Tensing the upper body'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_5',
  'title': 'Dance Fusion',
  'category': 'dance_party',
  'duration': 7,
  'calories': 63,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Coordination, Full Body',
  'imageUrl': 'assets/images/dance_card_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Core)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Knee-to-Elbow Touch (Slow)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lift right knee and bring left elbow towards it (slow diagonal crunch).',
            'Return to center and switch sides.',
            'Focus on core rotation and balance.',
            'Keep back straight, do not pull on the neck.'
          ],
          'breathingRhythm': 'Exhale on the crunch, inhale on the return',
          'actionFeeling': 'Core and obliques activating, hips mobilizing',
          'commonMistakes': [
            'Rounding the spine too much',
            'Moving too fast to engage the core'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Salsa Side Steps with Arm Pumps',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right, bring left foot to right (touch), step left, bring right foot to left (touch).',
            'Keep your hips loose and bounce slightly to the beat.',
            'Add strong, rhythmic arm pumps forward and back.',
            'Focus on consistent rhythm.'
          ],
          'breathingRhythm': 'Steady and rhythmic breaths',
          'actionFeeling': 'Cardio, lower body endurance, fast feet',
          'commonMistakes': [
            'Stiff legs or torso'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Low Squat Pulse and Hip Rock',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lower into a shallow squat position (hold).',
            'Pulse your hips up and down in the squat for 20 seconds.',
            'Then, rock your hips side to side in the squat position for 20 seconds.',
            'Keep the core tight and chest up.'
          ],
          'breathingRhythm': 'Inhale for recovery, exhale with the pulsing/rocking',
          'actionFeeling': 'Leg muscles burning, hip mobility',
          'commonMistakes': [
            'Letting knees cave in',
            'Lifting hips too high'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Merengue March (Fast)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'March in place quickly, keeping feet close to the floor.',
            'Add strong alternating hip thrusts to the beat (Merengue style).',
            'The movement should originate from the hips and core.',
            'Add expressive arm movements like waves or shakes.'
          ],
          'breathingRhythm': 'Quick, steady breaths',
          'actionFeeling': 'Core, hips, and cardio maintaining a high pace',
          'commonMistakes': [
            'Using the whole body to swing instead of isolating the hip work'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Triceps and Quad Stretch (Standing)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Hold wall for balance. Stretch right quad (30 seconds).',
            'Switch legs and stretch left quad (30 seconds).',
            'During the hold, stretch one arm overhead for triceps/side body.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths',
          'actionFeeling': 'Muscles lengthening, tension releasing',
          'commonMistakes': [
            'Rushing the stretch or losing balance'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_6',
  'title': 'Party Power',
  'category': 'dance_party',
  'duration': 5,
  'calories': 47,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'Explosive Cardio, Full Body',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Cardio)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Wide Leg Toe Touches (Alternating)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with feet wider than hips.',
            'Reach right hand down to tap left toe/ankle.',
            'Stand up tall, reach left hand to tap right toe/ankle.',
            'Keep a rhythm, using a slight squat motion.'
          ],
          'breathingRhythm': 'Exhale on the touch, inhale on the stand',
          'actionFeeling': 'Hamstrings and lower back warming up, energy building',
          'commonMistakes': [
            'Rounding the spine too much'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Skipping in Place (High Intensity)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform small, quick skips in place (no jump if uncomfortable, just fast march).',
            'Lift knees high and swing arms vigorously.',
            'Focus on minimal ground contact time and maximum height/speed.'
          ],
          'breathingRhythm': 'Fast, controlled breaths',
          'actionFeeling': 'Cardio peaking, full body explosive work',
          'commonMistakes': [
            'Heavy landings'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Running Man Variation (Standing)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot up, step left foot back, keeping a bent knee rhythm.',
            'Coordinate with alternating arms (as if running in place).',
            'Keep your feet light and the pace quick and rhythmic.'
          ],
          'breathingRhythm': 'Steady, active breathing',
          'actionFeeling': 'Coordination, leg speed, sustained cardio',
          'commonMistakes': [
            'Slouching the shoulders'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Disco Point and Punch',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot out, point right arm up and out.',
            'Step left foot out, point left arm up and out.',
            'Alternate steps and points quickly, adding a sharp hip thrust on each point.'
          ],
          'breathingRhythm': 'Exhale on the point/thrust',
          'actionFeeling': 'Core, hips, and shoulders working for rhythm and power',
          'commonMistakes': [
            'Uncontrolled arm movements'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Gentle Leg and Arm Shakes',
          'duration': 45,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand tall, gently shake your arms and legs loosely.',
            'Let gravity pull the tension out of your limbs.',
            'Finish with 5 deep breaths, sighing on the exhale.'
          ],
          'breathingRhythm': 'Deep, audible sighs on the exhale',
          'actionFeeling': 'Full body tension release',
          'commonMistakes': [
            'Not allowing the body to fully relax'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_7',
  'title': 'Latin Heat',
  'category': 'dance_party',
  'duration': 8,
  'calories': 72,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'Hips, Core, Fast Cardio',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Hip Opener)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Mambo Steps (Slow)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot forward, step left foot back (slowly).',
            'Add gentle hip pops/sways to the beat.',
            'Keep feet light and knees soft.',
            'Increase the pace gently after 30 seconds.'
          ],
          'breathingRhythm': 'Steady, fluid breathing',
          'actionFeeling': 'Hips and core warming up, ready for movement',
          'commonMistakes': [
            'Stiff legs'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Reggaeton Bounce and Hip Isolation',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand on the balls of your feet and bounce rhythmically (soft knees).',
            'Isolate your hips, tucking them under and pushing them back (pelvic tilt).',
            'Keep the bounce consistent while moving the hips intensely.',
            'Add chest pops or shoulder shimmies.'
          ],
          'breathingRhythm': 'Quick, active breaths',
          'actionFeeling': 'Deep core and hip flexor engagement, high cardio',
          'commonMistakes': [
            'Moving the entire torso instead of isolating the hips'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Salsa/Cumbia Basic (Fast)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step out to the side (right), step back to center, step out to the side (left), step back to center.',
            'Add exaggerated hip swings and flowing arm movements.',
            'Maintain a high pace and use strong weight shifts.'
          ],
          'breathingRhythm': 'Breathe deeply to sustain energy',
          'actionFeeling': 'Sustained fast-paced cardio, coordination challenge',
          'commonMistakes': [
            'Forgetting the weight transfer'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Grapevine with Latin Travel',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform a fast grapevine (step-cross-step-tap).',
            'Add a small directional turn (e.g., pivot 1/4 turn on the tap).',
            'Keep the energy high and the movements sharp.'
          ],
          'breathingRhythm': 'Active breaths',
          'actionFeeling': 'High energy, directional change challenging stability',
          'commonMistakes': [
            'Losing balance during the pivot'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Slow Latin Sway and Arm Waves',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Slow the music/pace down significantly.',
            'Gently sway your hips side to side (slow motion).',
            'Add long, slow arm waves up and down, stretching the torso.',
            'Close your eyes and focus on the cool-down process.'
          ],
          'breathingRhythm': 'Long, slow inhales and exhales',
          'actionFeeling': 'Complete recovery and stretching of the core',
          'commonMistakes': [
            'Skipping the slow breathing'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_8',
  'title': 'Hip Hop Flow',
  'category': 'dance_party',
  'duration': 6,
  'calories': 56,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Groove, Legs, Core',
  'imageUrl': 'assets/images/dance_card_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Foundation Groove)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Hip Hop Bounce (Small Pulse)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with feet wide, soft knees.',
            'Pulse your knees and hips up and down gently to the beat.',
            'Add small shoulder pops and head nods.',
            'Keep the movement relaxed but rhythmic.'
          ],
          'breathingRhythm': 'Breathe naturally with the pulse',
          'actionFeeling': 'Energy building, finding the core rhythm',
          'commonMistakes': [
            'Stiffening the torso'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 2,
      'exercises': [
        {
          'exerciseName': 'Step Touch & Snap',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right, touch left foot, step left, touch right foot.',
            'Add a downward arm swing and a sharp finger snap on the touch.',
            'Stay low and groovy, emphasizing the downbeat.'
          ],
          'breathingRhythm': 'Exhale on the snap/downbeat',
          'actionFeeling': 'Rhythmic cardio, core engagement through rhythm',
          'commonMistakes': [
            'Overthinking the steps; keep it simple and low'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Side-to-Side Body Waves (Torso Isolation)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Feet wide, shift weight right, then left.',
            'As you shift, send a wave motion through your chest and torso (chest out, then back).',
            'Focus on isolating the chest movement from the hips.'
          ],
          'breathingRhythm': 'Continuous breathing',
          'actionFeeling': 'Core control, upper body mobility and fluidity',
          'commonMistakes': [
            'Letting the whole body collapse'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Arm Tuts (Geometric Hand Movements)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Keep feet moving with a small bounce.',
            'Use your arms to make sharp, angular, geometric shapes in the air.',
            'Focus on sharp stops and starts with the hands and wrists.',
            'Maintain a rhythmic bounce in the legs.'
          ],
          'breathingRhythm': 'Focus on steady breaths despite the arm intensity',
          'actionFeeling': 'Arm strength and coordination, brain-body connection',
          'commonMistakes': [
            'Rounded arm movements instead of sharp angles'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Slow Head and Shoulder Isolation',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand still, perform very slow head circles (half rolls only).',
            'Slowly roll shoulders back and forth.',
            'Conclude by slowly raising arms overhead and lowering them, focusing on the breath and stillness.'
          ],
          'breathingRhythm': 'Long, gentle exhales',
          'actionFeeling': 'Mindful recovery and relaxation',
          'commonMistakes': [
            'Moving too fast or aggressively'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'dance_9',
  'title': 'Zumba Zone',
  'category': 'dance_party',
  'duration': 10,
  'calories': 89,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'Max Cardio, Full Body Endurance',
  'imageUrl': 'assets/images/dance_card_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Latin Hips)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Cumbia Shakes (Slow Step)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot to side, step left to center, step left foot to side, step right to center.',
            'Add strong, yet controlled, hip shakes and sways to the rhythm.',
            'Use expressive arm movements (shrugs, waves).'
          ],
          'breathingRhythm': 'Steady, active breaths',
          'actionFeeling': 'Hips and core loosening, preparing for fast pace',
          'commonMistakes': [
            'Stiffening the knees'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Dance Block',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'High-Energy Four Corners',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step touch diagonally to the front right corner (2 steps), then back to center.',
            'Step touch diagonally to the front left corner, back to center.',
            'Repeat the sequence to the back right and back left corners.',
            'Add large arm scoops or claps on each step.'
          ],
          'breathingRhythm': 'Exhale on the clap, inhale during the travel',
          'actionFeeling': 'High cardio, using space, multi-directional movement',
          'commonMistakes': [
            'Steps too small or losing the pattern'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Quick Step Knee Lifts (Alternating)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'March quickly, bringing alternating knees high up toward the chest.',
            'Use your opposite elbow to touch the knee for a core crunch.',
            'Maintain speed and control.',
            'Keep feet light.'
          ],
          'breathingRhythm': 'Exhale sharply with each knee/elbow touch',
          'actionFeeling': 'Maximum core engagement, sustained high cardio',
          'commonMistakes': [
            'Leaning too far forward, pulling on neck'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Samba Bounce and Weight Shift',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Keep a rhythmic, quick bounce on the balls of your feet.',
            'Shift weight quickly from left foot to right foot.',
            'Isolate the hips with a subtle hip thrust on each beat.',
            'Add sharp arm throws/punches (samba style).'
          ],
          'breathingRhythm': 'Fast, active breaths',
          'actionFeeling': 'Leg endurance, intense hip work, maximum fun',
          'commonMistakes': [
            'Stiffening the torso or back'
          ]
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Calf and Hamstring Flow',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Step right foot forward, flex foot, and gently fold forward (15 seconds).',
            'Step left foot back into a low lunge (or just a deep step) to stretch the hip (15 seconds).',
            'Switch legs and repeat the hamstring fold (15 seconds) and hip stretch (15 seconds).'
          ],
          'breathingRhythm': 'Deep, purposeful breaths into the stretch',
          'actionFeeling': 'Lower body lengthening and heart rate decreasing',
          'commonMistakes': [
            'Locking the knees'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

// ==================== LOSE WEIGHT WORKOUTS ====================

{
  'id': 'lose_weight_1',
  'title': 'Sweat & Burn: Quick Cardio Toning',
  'category': 'lose_weight',
  'duration': 22,
  'calories': 220,
  'intensity': 'medium',
  'equipment': 'None',
  'focusZones': 'Cardio, Full Body',
  'imageUrl': 'assets/images/lose_weight_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Movement)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Marching in Place with Arm Pumps',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'March briskly in place, lifting knees to hip height.',
            'Pump arms vigorously, driving elbows back.',
            'Maintain a quick pace to elevate the heart rate.'
          ],
          'breathingRhythm': 'Active and steady breathing (slightly faster than normal)',
          'actionFeeling': 'Heart rate rising quickly, large muscle groups engaging',
          'commonMistakes': [
            'Slouching the shoulders',
            'Slowing the pace down too early'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit',
      'setType': 'main',
      'sets': 4,
      'exercises': [
        {
          'exerciseName': 'Squat to Calf Raise Combo',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform one full bodyweight squat (hips back, chest up).',
            'As you stand up, immediately rise onto your toes (calf raise).',
            'Lower heels and go straight into the next squat.',
            'Keep movements fluid.'
          ],
          'breathingRhythm': 'Inhale down on squat, exhale forcefully on the calf raise',
          'actionFeeling': 'Quads, glutes, and calves burning; functional movement',
          'commonMistakes': [
            'Letting knees cave in',
            'Not going low enough on the squat'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Side Crunch (Fast)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Hands behind head, lift right knee to side while dropping right elbow toward it.',
            'Quickly alternate sides.',
            'Focus on speed and torso rotation, not pulling the neck.'
          ],
          'breathingRhythm': 'Exhale sharply with each crunch',
          'actionFeeling': 'Obliques and core activating quickly, maintaining cardio',
          'commonMistakes': [
            'Bending forward instead of sideways',
            'Using momentum instead of core muscle'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'High-Knee Taps (No Jump)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'March knees up quickly, aiming for hip height.',
            'Tap your hands to your knees (or thighs) with each lift.',
            'Keep the pace fast and the core tight.'
          ],
          'breathingRhythm': 'Fast, active breaths',
          'actionFeeling': 'Cardio, hip flexors, and core driving the burn',
          'commonMistakes': [
            'Losing intensity or speed'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Quad Stretch (Assisted)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Hold onto a support. Bend right knee and hold ankle/shin for a quad stretch.',
            'Hold for 30 seconds (keep knees aligned).',
            'Switch sides and repeat.',
            'Breathe deeply to signal recovery.'
          ],
          'breathingRhythm': 'Deep, relaxing breaths, exhaling tension',
          'actionFeeling': 'Front of thigh lengthening, heart rate calming',
          'commonMistakes': [
            'Arching the lower back'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'lose_weight_2',
  'title': 'Beginner Starter: Full Body Sculpt',
  'category': 'lose_weight',
  'duration': 20,
  'calories': 173,
  'intensity': 'low',
  'equipment': 'Chair or Wall',
  'focusZones': 'Full Body, Strength',
  'imageUrl': 'assets/images/lose_weight_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Joint Prep)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Arm Circles and Shoulder Rolls',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Extend arms out, make small circles forward (30 seconds).',
            'Reverse to backward circles (30 seconds).',
            'Finish with 5 large shoulder rolls backward to release tension.'
          ],
          'breathingRhythm': 'Breathe smoothly and consistently',
          'actionFeeling': 'Shoulders warming up, upper body mobilization',
          'commonMistakes': [
            'Tensing the neck'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Wall Push-Ups (Controlled)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand arm’s length from a wall, hands flat at shoulder width.',
            'Lower your chest toward the wall by bending elbows.',
            'Push back to the start, keeping the body in a straight line.',
            'Control the movement (2 seconds down, 2 seconds up).'
          ],
          'breathingRhythm': 'Inhale down, exhale up (on the push)',
          'actionFeeling': 'Chest, shoulders, and arms engaging in a supported position',
          'commonMistakes': [
            'Arching the lower back',
            'Dropping the head'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Chair-Assisted Squats (Sit-to-Stand)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand in front of a sturdy chair, feet hip-width apart.',
            'Slowly sit down until you gently touch the chair (do not rest).',
            'Immediately stand back up, squeezing glutes at the top.',
            'Keep chest up and weight in your heels.'
          ],
          'breathingRhythm': 'Inhale on the sit, exhale on the stand',
          'actionFeeling': 'Glutes and quads strengthening, gentle on knees',
          'commonMistakes': [
            'Leaning forward excessively',
            'Relying on the chair for the push up'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Alternating Knee Lift',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall, lift right knee toward chest, engaging your core.',
            'Lower and switch to the left knee.',
            'Alternate steadily. Hold a chair for balance if needed.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Core, hip flexors, and lower abs activating',
          'commonMistakes': [
            'Slouching the back or using momentum'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Chest and Arm Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand, interlace fingers behind your back (or hold a towel).',
            'Gently lift your chest and pull your hands down and away from your back.',
            'Hold for 30 seconds.',
            'Release, then hold your right elbow with your left hand across your chest (30 seconds).'
          ],
          'breathingRhythm': 'Deep, slow breaths for relaxation',
          'actionFeeling': 'Chest opening, shoulder release',
          'commonMistakes': [
            'Rounding shoulders during the chest stretch'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'lose_weight_3',
  'title': 'Fat Burner: High Intensity',
  'category': 'lose_weight',
  'duration': 25,
  'calories': 245,
  'intensity': 'high',
  'equipment': 'Mat (optional)',
  'focusZones': 'HIIT, Full Body',
  'imageUrl': 'assets/images/lose_weight_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Prep)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Low Impact Jumping Jacks (Taps)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot out, bring arms overhead.',
            'Step right foot in, bring arms down.',
            'Alternate sides quickly (no jumping impact).',
            'Focus on speed and large arm movements.'
          ],
          'breathingRhythm': 'Active, rapid breaths',
          'actionFeeling': 'Heart rate rising quickly, full body coordination',
          'commonMistakes': [
            'Small, lazy movements'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit (Tabata Style)',
      'setType': 'main',
      'sets': 5,
      'exercises': [
        {
          'exerciseName': 'Fast High Knees (Running in Place)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Run in place as fast as possible, lifting knees high.',
            'Pump arms vigorously.',
            'Maintain maximum effort for the entire duration.'
          ],
          'breathingRhythm': 'Short, intense breaths (Exhale hard on effort)',
          'actionFeeling': 'Maximal heart rate and cardiovascular effort',
          'commonMistakes': [
            'Slowing down the pace mid-set',
            'Slouching'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Speed Squats (Controlled)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform bodyweight squats quickly but safely.',
            'Go only as low as you can without losing form or knee pain.',
            'Maintain quick tempo, keeping chest lifted.'
          ],
          'breathingRhythm': 'Exhale sharply on the stand up',
          'actionFeeling': 'High burn in legs, increased metabolic rate',
          'commonMistakes': [
            'Leaning forward heavily',
            'Rounding the back'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Plank Hold (Forearm or High)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Hold a plank position (forearms or hands, knees or toes).',
            'Keep the body in a straight line from head to heels/knees.',
            'Squeeze glutes and core hard to maintain tension.'
          ],
          'breathingRhythm': 'Deep, steady breaths (avoid holding breath)',
          'actionFeeling': 'Core stability challenged, full body isometric strength',
          'commonMistakes': [
            'Letting the hips sag or lift too high'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Full Body Slow Stretch (Overhead)',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand tall, interlace fingers, stretch arms straight overhead, reaching high.',
            'Gently sway side to side.',
            'Lower arms slowly, taking deep recovery breaths.',
            'Walk slowly in place until heart rate drops.'
          ],
          'breathingRhythm': 'Slow, measured breaths to lower heart rate',
          'actionFeeling': 'Lengthening, rapid recovery from intense effort',
          'commonMistakes': [
            'Stopping all movement suddenly'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'lose_weight_4',
  'title': 'Metabolism Boost: Quick Results',
  'category': 'lose_weight',
  'duration': 18,
  'calories': 198,
  'intensity': 'high',
  'equipment': 'None',
  'focusZones': 'HIIT, Core, Legs',
  'imageUrl': 'assets/images/lose_weight_2.jpeg',
  'isVip': true,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Quick Mobilization)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Fast Butt Kicks (Heel to Glute)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Run in place, trying to tap your heels to your glutes with each step.',
            'Keep the upper body upright, pump arms vigorously.',
            'This stretches the quads dynamically and raises heart rate.'
          ],
          'breathingRhythm': 'Quick, active breaths to keep up the pace',
          'actionFeeling': 'Quads and hamstrings warming, quick cardio start',
          'commonMistakes': [
            'Leaning too far forward'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit',
      'setType': 'main',
      'sets': 3,
      'exercises': [
        {
          'exerciseName': 'Squat Pulse with Overhead Reach',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Lower into a comfortable squat (hold).',
            'Pulse quickly up and down (small movements) for 20 seconds.',
            'Stand up fully, reach both arms overhead, then return to the squat pulse.'
          ],
          'breathingRhythm': 'Steady breathing during the pulse, exhale on the stand/reach',
          'actionFeeling': 'Deep burn in legs, cardio endurance',
          'commonMistakes': [
            'Relying on momentum instead of muscle control'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Mountain Climbers (Modified)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start in a high plank position (or standing incline against a wall).',
            'Alternately bring your right knee toward your chest, then your left knee.',
            'Move as quickly as possible without lifting hips too high or low.'
          ],
          'breathingRhythm': 'Exhale with each knee drive',
          'actionFeeling': 'Core, shoulders, and cardio working intensely',
          'commonMistakes': [
            'Arching the lower back',
            'Letting hips sway'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Speed Jacks (No Jump Tap Outs)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform fast No-Jump Jacks (see lose\_weight\_3).',
            'Maintain maximum speed and full range of motion in the arms.',
            'Focus on explosive movement and light feet.'
          ],
          'breathingRhythm': 'Fast, active breaths to keep fueling the speed',
          'actionFeeling': 'High cardiovascular intensity, full body coordination',
          'commonMistakes': [
            'Slowing down the tempo'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Lying Figure-Four Glute Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Lie on your back, cross right ankle over left knee.',
            'Grasp the back of the left thigh and gently pull toward your chest.',
            'Hold for 30 seconds, then switch legs.',
            'Breathe deeply into the stretch.'
          ],
          'breathingRhythm': 'Slow, deep breaths, exhale to relax the hip',
          'actionFeeling': 'Glute and hip release, deep recovery',
          'commonMistakes': [
            'Pulling too hard or quickly'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'lose_weight_5',
  'title': 'Weight Loss Warrior: Total Body',
  'category': 'lose_weight',
  'duration': 30,
  'calories': 289,
  'intensity': 'medium',
  'equipment': 'Mat, Chair (optional)',
  'focusZones': 'Total Body Endurance, Core',
  'imageUrl': 'assets/images/lose_weight_1.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Dynamic Core)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Torso Twists (Large Range)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand with feet wide, arms extended out to sides.',
            'Swing your arms loosely, twisting your torso side to side.',
            'Allow your back foot to pivot naturally.',
            'Increase the range of rotation gradually.'
          ],
          'breathingRhythm': 'Breathe naturally with the swing/twist',
          'actionFeeling': 'Core mobilizing, spine loosening',
          'commonMistakes': [
            'Lifting feet off the floor too much'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit',
      'setType': 'main',
      'sets': 4,
      'exercises': [
        {
          'exerciseName': 'Reverse Lunge and Knee Drive (Alternating)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Step right foot back into a reverse lunge (modified/shallow).',
            'Immediately push off the back foot and drive the right knee up toward the chest.',
            'Return to the lunge and repeat on the other side.',
            'Alternate legs smoothly for the duration.'
          ],
          'breathingRhythm': 'Exhale on the knee drive, inhale on the lunge',
          'actionFeeling': 'Glutes, quads, and core working hard for power',
          'commonMistakes': [
            'Wobbling or losing balance'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Plank to Dolphin Pose (Core Flow)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start in a forearm plank (on toes or knees).',
            'Lift your hips up and back toward the ceiling (Dolphin Pose), keeping forearms grounded.',
            'Lower hips back to plank position.',
            'Flow smoothly between the two poses.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the return to plank',
          'actionFeeling': 'Shoulder stability, core strength, and hamstring stretch',
          'commonMistakes': [
            'Letting hips sag in the plank'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Bicep Curl to Overhead Press (Imaginary)',
          'duration': 45,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Stand tall. Perform a bicep curl (imagining resistance).',
            'Rotate hands, push arms straight overhead (overhead press).',
            'Reverse the movement: lower to shoulders, then uncurl to sides.',
            'Keep core tight to prevent back arching.'
          ],
          'breathingRhythm': 'Exhale on curl and press, inhale on the lower',
          'actionFeeling': 'Upper body strength and muscle endurance',
          'commonMistakes': [
            'Arching the lower back on the overhead press'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing T-Spine Rotation and Hold',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Stand, hinge forward slightly, hands on thighs.',
            'Place left hand on left thigh. Rotate chest to the right, reaching right arm to the ceiling.',
            'Hold the rotation for 30 seconds.',
            'Return and switch sides (right hand on thigh, left arm up).'
          ],
          'breathingRhythm': 'Deep, steady breaths into the twist',
          'actionFeeling': 'Mid-back release, core and hip stretching',
          'commonMistakes': [
            'Locking the knees'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},



{
  'id': 'lose_weight_6',
  'title': 'Slim Down: Cardio Strength Combo',
  'category': 'lose_weight',
  'duration': 28,
  'calories': 267,
  'intensity': 'high',
  'equipment': 'Mat',
  'focusZones': 'Cardio Endurance, Total Body',
  'imageUrl': 'assets/images/lose_weight_2.jpeg',
  'isVip': false,
  'workoutSets': [
    {
      'setTitle': 'Warm Up (Pulse Raiser)',
      'setType': 'warmup',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Lateral Shuffles (Quick Step)',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Shuffle quickly 3 steps to the right, then 3 steps to the left.',
            'Stay light on your feet and low to the ground (soft knees).',
            'Keep the pace fast for maximum pulse elevation.'
          ],
          'breathingRhythm': 'Quick, active breaths',
          'actionFeeling': 'Legs and hips mobilizing, heart rate increasing fast',
          'commonMistakes': [
            'Crossover steps (keep it a shuffle)'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Main Circuit',
      'setType': 'main',
      'sets': 4,
      'exercises': [
        {
          'exerciseName': 'Squat to Alternating Front Kick',
          'duration': 60,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Perform one squat (hips back).',
            'As you stand up, immediately kick your right leg straight forward (low/medium kick).',
            'Squat again, then kick your left leg straight forward.',
            'Alternate kicks, maintaining explosive power from the squat.'
          ],
          'breathingRhythm': 'Exhale sharply on the kick, inhale down on squat',
          'actionFeeling': 'High intensity leg work, core control for the kick',
          'commonMistakes': [
            'Leaning back too far on the kick'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Plank Jack (Modified Tap Out)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Start in high plank (on hands or forearms).',
            'Step right foot out to the side, then back in.',
            'Step left foot out to the side, then back in.',
            'Alternate taps quickly. Keep hips low and steady.'
          ],
          'breathingRhythm': 'Active, steady breathing (focus on maintaining core tension)',
          'actionFeeling': 'Core stability, hip flexor endurance, and cardio',
          'commonMistakes': [
            'Lifting hips too high or low',
            'Swaying the torso'
          ],
          'thumbnailUrl': null
        },
        {
          'exerciseName': 'Standing Side Leg Raise (Fast Tempo)',
          'duration': 40,
          'rest': 15,
          'reps': null,
          'instructions': [
            'Hold a chair lightly. Quickly lift your right leg out to the side and back down.',
            'Perform this quickly like a pulse (20 seconds).',
            'Switch legs and repeat (20 seconds).',
            'Focus on quick contractions in the outer hip.'
          ],
          'breathingRhythm': 'Exhale on the lift, inhale on the lower',
          'actionFeeling': 'Outer glutes and hips strengthening fast, stability challenged',
          'commonMistakes': [
            'Leaning heavily on the chair'
          ],
          'thumbnailUrl': null
        }
      ]
    },
    {
      'setTitle': 'Cool Down',
      'setType': 'cooldown',
      'sets': 1,
      'exercises': [
        {
          'exerciseName': 'Standing Hamstring and Calf Stretch',
          'duration': 60,
          'rest': 0,
          'reps': null,
          'instructions': [
            'Extend right leg straight forward, heel down, toe up.',
            'Hinge at hips, reach for shin/foot (30 seconds).',
            'Switch legs and repeat the hamstring stretch.',
            'Finish with deep, recovering breaths.'
          ],
          'breathingRhythm': 'Slow, measured breaths to lower heart rate',
          'actionFeeling': 'Hamstring and calf lengthening, final cool down',
          'commonMistakes': [
            'Rounding the back'
          ],
          'thumbnailUrl': null
        }
      ]
    }
  ]
},

    
  ];
}