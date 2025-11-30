import os
import sys
from dotenv import load_dotenv

print("=" * 60)
print("GEMINI API DIAGNOSTIC TOOL")
print("=" * 60)

# Load environment
load_dotenv()
api_key = os.getenv("GEMINI_API_KEY")

print(f"\n1. API Key Status:")
print(f"   ✓ Found: {bool(api_key)}")
if api_key:
    print(f"   ✓ Format: {api_key[:10]}...{api_key[-4:]}")
    print(f"   ✓ Length: {len(api_key)} chars")
else:
    print("   ✗ NOT FOUND! Check your .env file")
    sys.exit(1)

# Check library
try:
    import google.generativeai as genai
    print(f"\n2. Library Version:")
    print(f"   ✓ google-generativeai: {genai.__version__}")
except ImportError as e:
    print(f"\n2. Library Version:")
    print(f"   ✗ ERROR: {e}")
    print("   Run: pip install google-generativeai --upgrade")
    sys.exit(1)

# Configure and list models
try:
    genai.configure(api_key=api_key)
    print(f"\n3. API Connection:")
    print(f"   ✓ Successfully configured")
    
    print(f"\n4. Available Models:")
    models_found = False
    for model in genai.list_models():
        if 'generateContent' in model.supported_generation_methods:
            models_found = True
            print(f"   ✓ {model.name}")
            print(f"      - Display Name: {model.display_name}")
            print(f"      - Input Token Limit: {model.input_token_limit}")
            print(f"      - Output Token Limit: {model.output_token_limit}")
            print()
    
    if not models_found:
        print("   ✗ No models found with generateContent support")
        
except Exception as e:
    print(f"\n3. API Connection:")
    print(f"   ✗ ERROR: {e}")
    sys.exit(1)

# Test simple generation
print("\n5. Testing Generation:")
try:
    # Try the latest model naming convention
    model = genai.GenerativeModel('gemini-1.5-flash')
    response = model.generate_content("Say 'Hello JustFit!' in 3 words")
    print(f"   ✓ SUCCESS!")
    print(f"   ✓ Response: {response.text}")
except Exception as e:
    print(f"   ✗ ERROR: {e}")
    print(f"\n   Trying alternative model name...")
    try:
        model = genai.GenerativeModel('gemini-1.5-flash-latest')
        response = model.generate_content("Say 'Hello JustFit!' in 3 words")
        print(f"   ✓ SUCCESS with gemini-1.5-flash-latest!")
        print(f"   ✓ Response: {response.text}")
    except Exception as e2:
        print(f"   ✗ Still failed: {e2}")

print("\n" + "=" * 60)
print("DIAGNOSTIC COMPLETE")
print("=" * 60)