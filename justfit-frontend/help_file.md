📋 COMPLETE ONBOARDING FLOW - EXACT QUESTIONS & OPTIONS

PART 1: GOAL (3 Questions)
Q1: "What motivates you most?"
Type: Multi-select (can select multiple)
Options:
🏋️ Get Shaped
✨ Look Better
🏥 Improve Health
🧘 Release Stress
👍 Feel Confident
⚡ Boost Energy

Q2: "What's your main goal?"
Type: Single select with images
Options:
Lose weight
Build muscle
Keep fit

Q3: "Which areas do you want to focus on?"
Type: Multi-select (can select multiple)
Options:
💪 Toned Arms (bodyPart: 'arms')
🎯 Flat Belly (bodyPart: 'belly')
🍑 Round Butt (bodyPart: 'butt')
🦵 Slim Legs (bodyPart: 'legs')
🧘‍♀️ Full Body Slimming (bodyPart: 'fullbody')

PART 2: BODY DATA (5 Questions)
Q1: "What's your height?"
Type: Picker input
Data Type: Number (cm or ft+in)

Q2: "What's your weight?"
Type: Picker input
Data Type: Number (kg or lbs)

Q3: "What's your goal weight?"
Type: Picker input
Data Type: Number (kg or lbs)

Q4: "Choose your body type" (Current)
Type: Slider with 6 body type images
Options (slider from left to right):
< 15% - Athletic
15-20% - Lean
21-25% - Fit
26-30% - Average
31-40% - Curvy
Greater than 40%

Q5: "What's your desired body type?"
Type: Slider (must be lower than current)
Options: Same as Q4, but user can only select body types below their current selection


PART 3: WOMEN'S HEALTH (7 Questions)
Q1: "What's your age?"
Type: Wheel picker
Range: 18 to 80 years
Default: 24

Q2: "Do you want your plan to adapt to your menstrual cycle?"
Type: Single select (radio buttons)
Options:
Yes, adjust for my cycle
No, keep it consistent
Not applicable

Q3 (Conditional): "Where are you in your cycle right now?"
Shown only if: Q2 answer is "Yes"
Type: Single select
Options:
🩸 Week 1: Currently on my period
⚡ Week 2: Period just ended (high energy phase)
🌟 Week 3: Mid-cycle
🌙 Week 4: PMS / Period coming soon
❓ Irregular cycle / Not sure


Q4: "Have you experienced any pelvic floor issues?"
Type: Single select (radio buttons)
Options:
No issues
Occasional leaking when jumping or sneezing
Frequent stress incontinence
Prefer not to say

Q5: "Choose the place for your workout"
Type: Single select cards
Options:
📱 On the yoga mat → "It's suitable for all kinds of exercises."
🛋️ On the couch & bed → "It's suitable for some specific exercises."
🏠 No preference → "Let JustFit decide."

Q6: "Choose your preferred workout type"
Type: Single select cards
Options:
🚫 No equipment → "We will choose workouts that suit your lifestyle with no equipment."
🏃 No jumping → "We will select workouts without jumping especially for you."
🛏️ All lying down exercise → "We will offer you a broad suite of workouts without leaving your bed."
⭕ None of all → "We have achievable programs to progressively build your fitness."

Q7: "Choose your preferred level of workouts"
Type: Single select cards
Options:
😌 Easy enough → "Small changes add up to big results!"
🔥 Simple but a little bit sweaty → "Every drop counts!"
💪 Somewhat challenging → "You're on fire!"

Q8: "Have you ever suffered any injuries in these areas?"
Type: Multi-select (can select multiple)
Options:
🚫 None
🦵 Knee
🤸 LowerBack
🦶 Ankle
🤚 Wrist
🪑 Hip

PART 4: FITNESS ANALYSIS (13 Questions)
Q1: "What does your typical day look like?"
Type: Single select cards
Options:
💻 At work, mostly seated
🏠 At home, mostly sedentary
🚶 Walking daily
🏃 Working mostly on foot

Q2: "What's your activity level?"
Type: Horizontal swipeable cards (PageView)
Options:
Not active → "I easily get out of breath while walking up the stairs"
Lightly active → "Sometimes I do quick workouts to get my body moving"
Moderately active → "I exercise regularly, at least 1-2 times a week"
Highly active → "Fitness is an essential part of my life"

Q3: "What's your fitness level?"
Type: Horizontal swipeable cards with circular progress indicator
Options:
BEGINNER → "I am new to regular workouts"
INTERMEDIATE → "I have been training on a regular basis"
ADVANCED → "I have an abundant training experience"

Q4: "What's your belly type?"
Type: Horizontal swipeable image cards
Options:
Normal
Alcohol Belly
Mommy Belly
Stressed-out Belly
Hormonal Belly

Q5: "What's your hips type?"
Type: Horizontal swipeable image cards
Options:
Normal
Flat
Saggy
Double
Bubble

Q6: "What's your leg type?"
Type: Horizontal swipeable image cards
Options:
Normal
X-shaped curvature
O-shaped curvature
XO-shaped curvature

Q7: FLEXIBILITY TEST - "Bend over and try to touch your toes with your legs straight. How far can you reach?"
Type: Single select cards
Options:
🤸 Far from my feet → "Don't worry! 75% of users lack flexibility."
🤸 Close to my feet → "Cool! 80% of users face the same as you."
🤸 Easily touch my feet → "Wow, impressive! Your flexibility is better than 75% of users."

Q8: CARDIO TEST - "Can you climb 3 flights of stairs continuously?"
Type: Single select cards
Options:
😓 Out of breath → "We can help! Getting some cardio can be very helpful."
😐 Somewhat tired but okay → "Pretty good! You only need a bit more exercise."
😊 Easily → "Wow, great! Your cardiorespiratory function is in very good condition."

Q9: STATEMENT 1 - "I always feel unsatisfied with my body when I see the mirror."
Type: Yes/No buttons
Data: Boolean (true/false)

Q10: STATEMENT 2 - "I have no idea how to pick up suitable workouts for me."
Type: Yes/No buttons
Data: Boolean (true/false)

Q11: STATEMENT 3 - "I can easily give up when the exercises are too hard or boring."
Type: Yes/No buttons
Data: Boolean (true/false)


📊 SUMMARY: Total Questions = 28
Part 1 (Goal): 3 questions
Part 2 (Body Data): 5 questions
Part 3 (Women's Health): 7 questions (1 conditional)
Part 4 (Fitness Analysis): 13 questions