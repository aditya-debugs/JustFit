from app.core.gemini import gemini_service
from typing import Optional

class ChatbotService:
    def __init__(self):
        self.gemini = gemini_service
    
    def _build_chat_prompt(self, message: str, context: Optional[dict] = None) -> str:
        """
        Build a prompt for the fitness chatbot
        """
        base_prompt = """
You are a friendly, knowledgeable fitness coach assistant named "JustFit AI". You help users with:
- Workout technique and form questions
- Nutrition advice
- Motivation and encouragement
- Exercise substitutions
- Progress tracking insights

**Your Personality:**
- Supportive and encouraging
- Clear and concise
- Evidence-based advice
- Always prioritize user safety

"""
        
        if context:
            base_prompt += f"\n**User Context:**\n"
            if context.get("currentGoal"):
                base_prompt += f"- Goal: {context['currentGoal']}\n"
            if context.get("fitnessLevel"):
                base_prompt += f"- Fitness Level: {context['fitnessLevel']}\n"
            if context.get("injuries"):
                base_prompt += f"- Injuries/Limitations: {context['injuries']}\n"
        
        base_prompt += f"\n**User Question:**\n{message}\n\n**Your Response:**"
        
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