from app.core.gemini import gemini_service
from app.models.workout import ExerciseDetail, ExerciseDetailRequest, ExerciseDetailResponse
import json
import logging
import re

logger = logging.getLogger(__name__)

class ExerciseDetailsGeneratorService:
    def __init__(self):
        self.gemini = gemini_service
    
    def _build_exercise_details_prompt(self, exercise_ids: list[str]) -> str:
        """
        Ultra-concise prompt to prevent response truncation.
        """
        return f"""Generate exercise instructions in valid JSON format ONLY.

{{
  "exercises": [
    {{
      "exerciseId": "id",
      "name": "name",
      "category": "strength",
      "targetMuscle": "single word",
      "difficulty": "beginner",
      "equipment": "none",
      "thumbnailUrl": null,
      "videoUrl": null,
      "gifUrl": null,
      "actionSteps": ["step1", "step2", "step3", "step4", "step5", "step6"],
      "breathingRhythm": ["tip1", "tip2", "tip3", "tip4"],
      "actionFeeling": ["tip1", "tip2", "tip3", "tip4"],
      "commonMistakes": ["mistake1", "mistake2", "mistake3", "mistake4"],
      "modifications": {{
        "easier": "description",
        "harder": "description"
      }}
    }}
  ]
}}

RULES:
- Output ONLY JSON
- NO markdown fences
- NO parentheses
- targetMuscle must be ONE word ONLY: "Quadriceps" OR "Chest" OR "Core" OR "Glutes"
- Keep all descriptions SHORT and concise
- Start with {{ and end with }}

Exercises: {", ".join(exercise_ids)}
"""

    async def generate_exercise_details(self, request: ExerciseDetailRequest) -> ExerciseDetailResponse:
        """
        Fetch exercise details - FIRST check Firestore, then use AI if needed
        """
        from firebase_admin import firestore
        
        db = firestore.client()
        exercises_data = []
        missing_exercises = []
        
        logger.info(f"🔍 Fetching details for {len(request.exerciseIds)} exercises")
        
        # Step 1: Try to fetch from Firestore
        for exercise_id in request.exerciseIds:
            try:
                doc_ref = db.collection('exercises').document(exercise_id)
                doc = doc_ref.get()
                
                if doc.exists:
                    exercise_data = doc.to_dict()
                    exercises_data.append(exercise_data)
                    logger.info(f"✅ Loaded '{exercise_id}' from Firestore")
                else:
                    missing_exercises.append(exercise_id)
                    logger.warning(f"⚠️ '{exercise_id}' not in Firestore, will generate with AI")
            except Exception as e:
                logger.error(f"❌ Error fetching '{exercise_id}' from Firestore: {e}")
                missing_exercises.append(exercise_id)
        
        # Step 2: Generate missing exercises with AI (if any)
        if missing_exercises:
            logger.info(f"🤖 Generating {len(missing_exercises)} exercises with AI...")
            
            try:
                ai_prompt = self._build_exercise_details_prompt(missing_exercises)
                ai_response = await self.gemini.generate_content(ai_prompt)
                cleaned = self._clean_json_response(ai_response)
                ai_data = json.loads(cleaned)
                
                ai_generated = ai_data.get('exercises', [])
                exercises_data.extend(ai_generated)
                
                # Save AI-generated exercises to Firestore for future use
                for exercise in ai_generated:
                    try:
                        exercise_id = exercise.get('exerciseId')
                        if exercise_id:
                            db.collection('exercises').document(exercise_id).set(exercise)
                            logger.info(f"💾 Saved '{exercise_id}' to Firestore for future use")
                    except Exception as e:
                        logger.error(f"❌ Failed to save '{exercise_id}' to Firestore: {e}")
                
                logger.info(f"✅ Generated {len(ai_generated)} exercises with AI")
            except Exception as e:
                logger.error(f"❌ AI generation failed: {e}")
        
        logger.info(f"📦 Returning {len(exercises_data)} total exercises")
        
        # Convert to ExerciseDetail Pydantic models
        exercises = []
        for idx, ex_data in enumerate(exercises_data):
            try:
                exercise = ExerciseDetail(**ex_data)
                exercises.append(exercise)
                logger.info(f"  ✅ #{idx+1}: {exercise.exerciseId} - {exercise.name}")
            except Exception as e:
                logger.error(f"  ❌ #{idx+1}: Failed to parse exercise: {str(e)}")
        
        return ExerciseDetailResponse(exercises=exercises)
    
    def _clean_json_response(self, text: str) -> str:
        """
        Clean AI response to extract valid JSON using JSONDecoder.
        """
        text = text.strip()
        
        # Remove markdown code fences
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
        
        text = text.strip()
        
        # Find the first '{'
        start = text.find("{")
        if start == -1:
            return text
        
        # Use Python's JSONDecoder to extract one complete JSON object
        # Pass the substring starting from the first '{'
        decoder = json.JSONDecoder()
        try:
            obj, end_idx = decoder.raw_decode(text[start:])
            # Convert back to JSON string (this ensures it's valid)
            result = json.dumps(obj, indent=2)
            logger.info(f"✅ Extracted complete JSON object using JSONDecoder")
            return result
        except (json.JSONDecodeError, ValueError) as e:
            logger.warning(f"⚠️ JSONDecoder failed: {e}, falling back to simple extraction")
            # Fallback: just extract from first { to last }
            end = text.rfind("}")
            if end > start:
                text = text[start:end + 1]
        
        # Remove trailing commas like "item", ]
        text = re.sub(r",(\s*[}\]])", r"\1", text)
        
        # Replace undefined → null
        text = text.replace("undefined", "null")
        
        return text
    
    def _conservative_json_repair(self, text: str) -> str:
        """
        Conservative JSON repair - only fix obvious syntax errors.
        Does NOT attempt aggressive pattern matching that might break valid JSON.
        """
        logger.info("🔧 Running conservative JSON repair...")
        
        for attempt in range(5):
            original = text
            
            # Only fix trailing commas before } or ]
            text = re.sub(r',(\s*[}\]])', r'\1', text)
            
            # Remove JavaScript-style comments
            text = re.sub(r'//.*?$', '', text, flags=re.MULTILINE)
            text = re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)
            
            # If nothing changed, we're done
            if text == original:
                break
        
        logger.info(f"✅ Repair completed after {attempt + 1} passes")
        return text

# Singleton instance
exercise_details_generator = ExerciseDetailsGeneratorService()