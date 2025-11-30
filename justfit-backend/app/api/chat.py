from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter(prefix="/api", tags=["chat"])

# Configure Gemini
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))

class ChatMessage(BaseModel):
    role: str  # 'user' or 'assistant'
    content: str

class ChatRequest(BaseModel):
    message: str
    conversationHistory: List[ChatMessage] = []
    userContext: Optional[dict] = None  # User's plan, goals, cycle info

class ChatResponse(BaseModel):
    response: str
    suggestions: List[str] = []

@router.post("/chat", response_model=ChatResponse)
async def chat_with_ai(request: ChatRequest):
    """
    Context-aware fitness chatbot endpoint
    """
    try:
        # Build context-aware system prompt
        system_prompt = """You are FitBot, an expert women's fitness coach and wellness advisor for JustFit app.

PERSONALITY:
- Supportive, encouraging, and empathetic
- Evidence-based fitness advice
- Sensitive to women's health (menstrual cycle, pelvic floor, hormones)
- Concise but thorough responses (2-4 sentences typically)

CAPABILITIES:
- Workout form corrections and modifications
- Exercise alternatives for injuries/limitations
- Nutrition guidance for fitness goals
- Motivation and mental wellness
- Menstrual cycle-aware training advice
- Progress tracking insights

GUIDELINES:
- Keep responses under 100 words unless detailed explanation needed
- Use emojis sparingly (1-2 per message)
- Be caring and non-judgmental
- Prioritize safety over intensity
- Reference user's specific context when available
"""

        # Add user context if available
        if request.userContext:
            context_info = "\n\nUSER CONTEXT:\n"
            if 'currentDay' in request.userContext:
                context_info += f"- Currently on Day {request.userContext['currentDay']} of their plan\n"
            if 'planTitle' in request.userContext:
                context_info += f"- Plan: {request.userContext['planTitle']}\n"
            if 'cyclePhase' in request.userContext:
                context_info += f"- Menstrual cycle phase: {request.userContext['cyclePhase']}\n"
            if 'currentStreak' in request.userContext:
                context_info += f"- Current workout streak: {request.userContext['currentStreak']} days\n"
            
            system_prompt += context_info

        # Build conversation for Gemini
        chat_contents = [{"role": "user", "parts": [system_prompt]}]
        
        # Add conversation history
        for msg in request.conversationHistory[-6:]:  # Last 6 messages for context
            role = "user" if msg.role == "user" else "model"
            chat_contents.append({"role": role, "parts": [msg.content]})
        
        # Add current message
        chat_contents.append({"role": "user", "parts": [request.message]})

        # Call Gemini
        model = genai.GenerativeModel('gemini-2.5-flash')
        response = model.generate_content(chat_contents)
        
        ai_response = response.text.strip()

        # Generate contextual suggestions
        suggestions = _generate_suggestions(request.message, request.userContext)

        return ChatResponse(
            response=ai_response,
            suggestions=suggestions
        )

    except Exception as e:
        print(f"❌ Chat error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Chat failed: {str(e)}")


def _generate_suggestions(user_message: str, context: Optional[dict]) -> List[str]:
    """Generate contextual quick action suggestions"""
    
    # Default suggestions
    suggestions = [
        "💪 Workout form tips",
        "🥗 Nutrition advice",
        "🎯 Modify my plan",
    ]
    
    # Context-aware suggestions
    if context:
        if context.get('cyclePhase') == 'Menstruation':
            suggestions = [
                "🌸 Gentle exercises for today",
                "😌 Pain management tips",
                "🍵 What to eat during period",
            ]
        elif 'currentStreak' in context and context['currentStreak'] > 7:
            suggestions = [
                "🔥 How to maintain my streak",
                "😴 Recovery tips",
                "💪 Progressive overload tips",
            ]
    
    return suggestions[:3]