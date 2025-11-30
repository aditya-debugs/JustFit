import os
import json
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import firebase_admin
from firebase_admin import credentials
from app.routes import workout, chat
from app.core.gemini import gemini_service

app = FastAPI(title="JustFit API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Gemini
print("✅ Gemini service initialized")

# Initialize Firebase
try:
    firebase_admin.get_app()
    print("✅ Firebase already initialized")
except ValueError:
    # Try to get credentials from environment variable first (for Render/production)
    firebase_creds_json = os.getenv("FIREBASE_CREDENTIALS")
    
    if firebase_creds_json:
        # Production: Use environment variable
        print("🔧 Loading Firebase credentials from environment variable...")
        firebase_creds = json.loads(firebase_creds_json)
        cred = credentials.Certificate(firebase_creds)
        firebase_admin.initialize_app(cred)
        print("✅ Firebase initialized from environment variable")
    else:
        # Local development: Use file
        print("🔧 Loading Firebase credentials from file...")
        cred = credentials.Certificate("serviceAccountKey.json")
        firebase_admin.initialize_app(cred)
        print("✅ Firebase initialized from file")

# Include routers
app.include_router(workout.router, prefix="/api/workout", tags=["workout"])
app.include_router(chat.router, prefix="/api/chat", tags=["chat"])

@app.get("/")
async def root():
    return {
        "status": "healthy",
        "message": "JustFit API is running",
        "version": "1.0.0"
    }

@app.get("/health")
async def health_check():
    return {"status": "ok", "firebase": "connected", "gemini": "connected"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=port,
        reload=False
    )