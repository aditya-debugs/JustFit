from fastapi import APIRouter, HTTPException
from app.models.workout import ChatMessage
from app.services.chatbot import chatbot_service

router = APIRouter(prefix="/api/chat", tags=["Chat"])

@router.post("/message")
async def send_message(chat_message: ChatMessage):
    """
    Send a message to the fitness chatbot
    """
    try:
        response = await chatbot_service.get_response(
            message=chat_message.message,
            context=chat_message.context
        )
        return {
            "response": response,
            "userId": chat_message.userId
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/test")
async def test_chat_endpoint():
    """
    Test endpoint to verify chat routes are working
    """
    return {
        "message": "Chat endpoint is working!",
        "available_endpoints": [
            "POST /api/chat/message - Send message to chatbot"
        ]
    }