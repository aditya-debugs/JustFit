import google.generativeai as genai
from dotenv import load_dotenv
import os

load_dotenv()

# Configure API
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Use the model you actually have access to!
model = genai.GenerativeModel('gemini-2.5-flash')

try:
    response = model.generate_content(
        "You are a fitness coach. Say 'Hello JustFit!' and list 3 exercise types.",
        generation_config={
            "temperature": 0.7,
            "max_output_tokens": 1024,
        }
    )
    
    print("✅ SUCCESS with gemini-2.5-flash!")
    print(f"\nResponse:\n{response.text}")
    
except Exception as e:
    print(f"❌ ERROR: {e}")