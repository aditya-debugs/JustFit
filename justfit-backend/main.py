import logging
import sys
from app.api import chat

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s:     %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)


import firebase_admin
from firebase_admin import credentials
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os
from dotenv import load_dotenv
from app.routes import workout
from app.api import chat  

load_dotenv()

# ✅ ADD FIREBASE INITIALIZATION (before creating FastAPI app)
try:
    firebase_admin.get_app()
    logging.info("✅ Firebase already initialized")
except ValueError:
    # Firebase not initialized yet
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)
    logging.info("✅ Firebase Admin SDK initialized")


app = FastAPI(
    title="JustFit AI Backend",
    description="AI-powered fitness coach backend using Gemini 2.5 Flash",
    version="2.0.0"
)

# CORS - Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(workout.router)
app.include_router(chat.router)


@app.get("/")
async def root():
    return {
        "message": "JustFit AI Backend is running! 🏋️",
        "version": "2.0.0",
        "model": "gemini-2.5-flash",
        "status": "healthy",
        "endpoints": {
            "health": "/health",
            "workout_generate": "/api/workout/generate",
            "exercise_details": "/api/workout/exercise-details",
            "chat": "/api/chat/*"
        }
    }

@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "model": "gemini-2.5-flash",
        "version": "2.0.0"
    }

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    print("=" * 60)
    print("🚀 JustFit AI Backend Starting...")
    print(f"📍 Server: http://localhost:{port}")
    print(f"📚 Docs: http://localhost:{port}/docs")
    print(f"🤖 Model: gemini-2.5-flash")
    print("=" * 60)
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=True
    )