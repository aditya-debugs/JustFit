from app.core.gemini import gemini_service
from typing import Optional

class ChatbotService:
    def __init__(self):
        self.gemini = gemini_service
    
    def _build_chat_prompt(self, message: str, context: Optional[dict] = None) -> str:
        """
        Build a comprehensive prompt for the fitness chatbot with full user context
        """
        base_prompt = """
You are "JustFit AI", a highly knowledgeable fitness coach assistant with access to the user's complete profile and progress data. You provide:
- Personalized workout advice based on their plan and progress
- Nutrition guidance tailored to their goals
- Motivation based on their achievements
- Exercise modifications considering their fitness level and limitations
- Evidence-based fitness insights

**Your Personality:**
- Supportive, encouraging, and celebratory of their progress
- Clear, concise, and actionable advice
- Evidence-based recommendations
- Safety-first approach
- Reference their specific data when relevant (e.g., "Great job on your 5-day streak!")

"""
        
        if context:
            base_prompt += f"\n**📊 USER PROFILE & CONTEXT:**\n"
            
            # Personal Info
            if context.get("age") or context.get("gender"):
                base_prompt += "**Personal:**\n"
                if context.get("age"):
                    base_prompt += f"- Age: {context['age']} years\n"
                if context.get("gender"):
                    base_prompt += f"- Gender: {context['gender']}\n"
                if context.get("bmi"):
                    base_prompt += f"- BMI: {context['bmi']}\n"
            
            # Goals & Physical Stats
            if context.get("currentWeight") or context.get("goalWeight"):
                base_prompt += "\n**Goals & Stats:**\n"
                if context.get("currentWeight"):
                    base_prompt += f"- Current Weight: {context['currentWeight']} kg\n"
                if context.get("goalWeight"):
                    base_prompt += f"- Goal Weight: {context['goalWeight']} kg\n"
                if context.get("height"):
                    base_prompt += f"- Height: {context['height']} cm\n"
                if context.get("primaryGoal"):
                    base_prompt += f"- Primary Goal: {context['primaryGoal']}\n"
            
            # Fitness Profile
            if context.get("fitnessLevel") or context.get("activityLevel"):
                base_prompt += "\n**Fitness Profile:**\n"
                if context.get("fitnessLevel"):
                    base_prompt += f"- Fitness Level: {context['fitnessLevel']}\n"
                if context.get("activityLevel"):
                    base_prompt += f"- Daily Activity: {context['activityLevel']}\n"
                if context.get("bodyType"):
                    base_prompt += f"- Current Body Type: {context['bodyType']}\n"
                if context.get("desiredBodyType"):
                    base_prompt += f"- Desired Body Type: {context['desiredBodyType']}\n"
                if context.get("focusAreas"):
                    base_prompt += f"- Focus Areas: {', '.join(context['focusAreas']) if isinstance(context['focusAreas'], list) else context['focusAreas']}\n"
            
            # Limitations
            if context.get("limitations"):
                base_prompt += f"\n**⚠️ Important - Physical Limitations:**\n"
                limitations = context['limitations']
                if isinstance(limitations, list):
                    for limit in limitations:
                        base_prompt += f"- {limit}\n"
                else:
                    base_prompt += f"- {limitations}\n"
                base_prompt += "**Always consider these when giving advice!**\n"
            
            # Current Workout Plan
            if context.get("planTitle"):
                base_prompt += f"\n**💪 Current Workout Plan:**\n"
                base_prompt += f"- Plan: {context['planTitle']}\n"
                if context.get("currentDay") and context.get("totalDays"):
                    base_prompt += f"- Progress: Day {context['currentDay']} of {context['totalDays']}\n"
                if context.get("currentStreak"):
                    base_prompt += f"- Current Streak: {context['currentStreak']} days 🔥\n"
                if context.get("totalWorkoutsCompleted"):
                    base_prompt += f"- Total Workouts: {context['totalWorkoutsCompleted']} completed\n"
                
                # Today's workout details
                if context.get("todaysWorkout"):
                    workout = context['todaysWorkout']
                    base_prompt += f"\n**Today's Workout:**\n"
                    base_prompt += f"- Title: {workout.get('title', 'N/A')}\n"
                    base_prompt += f"- Duration: {workout.get('duration', 'N/A')}\n"
                    base_prompt += f"- Intensity: {workout.get('intensity', 'N/A')}\n"
                    if workout.get('exercises'):
                        base_prompt += f"- Exercises: {', '.join(workout['exercises'][:5])}\n"
                
                # Cycle phase for female users
                if context.get("cyclePhase"):
                    base_prompt += f"- Cycle Phase: {context['cyclePhase']} (adapt intensity accordingly)\n"
            
            # Recent Progress
            if context.get("last30Days"):
                progress = context['last30Days']
                base_prompt += f"\n**📈 Recent Progress (Last 30 Days):**\n"
                base_prompt += f"- Workouts Completed: {progress.get('workoutsCompleted', 0)}\n"
                base_prompt += f"- Total Calories Burned: {progress.get('totalCalories', 0):,}\n"
                base_prompt += f"- Avg Calories/Workout: {progress.get('avgCaloriesPerWorkout', 0)}\n"
        
        base_prompt += f"\n**💬 User Question:**\n{message}\n\n"
        base_prompt += "**🎯 Your Response:** (Be specific, reference their data when relevant, and be encouraging!)\n"
        
        return base_prompt
    
    async def get_response(
        self, 
        message: str, 
        context: Optional[dict] = None,
        conversation_history: Optional[list] = None
    ) -> str:
        """
        Get chatbot response for user message with conversation history
        """
        try:
            prompt = self._build_chat_prompt(message, context)
            
            # Add conversation history if provided
            if conversation_history:
                history_text = "\n**Previous Conversation:**\n"
                for msg in conversation_history[-5:]:  # Last 5 messages for context
                    role = "User" if msg.get('role') == 'user' else "Assistant"
                    history_text += f"{role}: {msg.get('content', '')}\n"
                prompt = prompt.replace("**User Question:**", history_text + "\n**User Question:**")
            
            response = await self.gemini.generate_content(prompt)
            return response
        except Exception as e:
            raise Exception(f"Chatbot error: {str(e)}")

# Singleton instance
chatbot_service = ChatbotService()