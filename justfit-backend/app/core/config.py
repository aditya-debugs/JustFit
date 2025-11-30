import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    FIREBASE_SERVICE_ACCOUNT_PATH: str = os.getenv("FIREBASE_SERVICE_ACCOUNT_PATH", "./firebase-service-account.json")
    PORT: int = int(os.getenv("PORT", 8000))
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "development")
    
    GEMINI_MODEL: str = "gemini-2.5-flash"
    
    GEMINI_TEMPERATURE: float = 0.3  # Changed from 0.7 to 0.3 (more deterministic, less likely to trigger filters)
    GEMINI_MAX_TOKENS: int = 8192

settings = Settings()