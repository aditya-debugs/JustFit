import google.generativeai as genai
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)

class GeminiService:
    def __init__(self):
        if not settings.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY not found in environment variables")
        
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel(settings.GEMINI_MODEL)
        
        self.safety_settings = [
            {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_NONE"
            },
            {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_NONE"
            },
            {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_NONE"
            },
            {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_NONE"
            },
        ]
        
        logger.info(f"✅ Gemini service initialized: {settings.GEMINI_MODEL}")
    
    async def generate_content(self, prompt: str, json_mode: bool = False) -> str:
        """Generate content with optional JSON mode for guaranteed valid JSON"""
        try:
            # INCREASED TOKEN LIMIT for complex JSON responses
            max_tokens = 32000 if json_mode else settings.GEMINI_MAX_TOKENS
            
            generation_config = genai.GenerationConfig(
                temperature=settings.GEMINI_TEMPERATURE,
                max_output_tokens=max_tokens,
            )
            
            # Enable JSON mode if requested
            if json_mode:
                generation_config.response_mime_type = "application/json"
                logger.info(f"🔧 JSON mode enabled (max_tokens: {max_tokens})")
            
            response = self.model.generate_content(
                prompt,
                generation_config=generation_config,
                safety_settings=self.safety_settings
            )
            
            if not response.candidates:
                logger.error(f"❌ No candidates returned. Prompt feedback: {response.prompt_feedback}")
                raise Exception(f"Response blocked by safety filters: {response.prompt_feedback}")
            
            candidate = response.candidates[0]
            
            # Check if response was truncated
            if hasattr(candidate, 'finish_reason'):
                finish_reason = str(candidate.finish_reason)
                logger.info(f"📊 Finish reason: {finish_reason}")
                
                if finish_reason == "MAX_TOKENS" or finish_reason == "2":
                    logger.warning(f"⚠️ Response truncated due to token limit! Consider increasing max_tokens.")
                    raise Exception(f"Response truncated (finish_reason: {finish_reason}). Increase max_tokens or simplify prompt.")
            
            if not candidate.content or not candidate.content.parts:
                logger.error(f"❌ No content in candidate. Safety ratings: {candidate.safety_ratings}")
                raise Exception(f"Response blocked. Safety ratings: {candidate.safety_ratings}")
            
            text_parts = []
            for part in candidate.content.parts:
                if hasattr(part, 'text'):
                    text_parts.append(part.text)
            
            if not text_parts:
                raise Exception("No text content in response")
            
            result = ''.join(text_parts)
            
            if json_mode:
                logger.info(f"📄 JSON response received (length: {len(result)} chars)")
                
                # Validate JSON is complete
                open_braces = result.count('{')
                close_braces = result.count('}')
                
                if open_braces != close_braces:
                    logger.error(f"❌ JSON appears incomplete! Brace mismatch: open={open_braces}, close={close_braces}")
                    raise Exception(f"Incomplete JSON response (brace mismatch). Response length: {len(result)} chars")
            
            return result
            
        except Exception as e:
            logger.error(f"Gemini API error: {str(e)}")
            raise Exception(f"Gemini API error: {str(e)}")

gemini_service = GeminiService()