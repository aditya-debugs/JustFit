import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout/workout_plan_model.dart';
import '../models/workout/exercise_model.dart';

class WorkoutApiService {
  // Backend deployed on Render
  static const String _baseUrl = 'https://justfit.onrender.com';

  // Timeout duration for API calls
  static const Duration _timeout = Duration(seconds: 120);

  /// Generate a personalized workout plan
  ///
  /// Takes the onboarding data and returns a complete workout plan
  /// with all phases, daily workouts, and exercise IDs
  Future<WorkoutPlanModel> generateWorkoutPlan({
    required Map<String, dynamic> onboardingData,
    required String userId,
    String? startDate,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/workout/generate');

      // Backend expects onboardingData as a nested object
      final requestBody = {
        'userId': userId,
        'startDate':
            startDate ?? DateTime.now().toIso8601String().split('T')[0],
        'onboardingData': onboardingData, // NEST IT HERE
      };

      print('🚀 Calling workout generation API...');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Workout plan generated successfully!');
        return WorkoutPlanModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['detail'] ?? 'Failed to generate workout plan');
      }
    } catch (e) {
      print('❌ Error generating workout plan: $e');
      rethrow;
    }
  }

  /// Fetch detailed instructions for multiple exercises at once
  ///
  /// Takes a list of exercise IDs and returns complete exercise details
  /// including action steps, breathing rhythm, common mistakes, etc.
  Future<List<ExerciseModel>> fetchExerciseDetails({
    required List<String> exerciseIds,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/workout/exercise-details');

      final requestBody = {
        'exerciseIds': exerciseIds,
      };

      print('🏋️ Fetching details for ${exerciseIds.length} exercises...');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exercises = (data['exercises'] as List)
            .map((exerciseJson) => ExerciseModel.fromJson(exerciseJson))
            .toList();

        print('✅ Fetched ${exercises.length} exercise details!');
        return exercises;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['detail'] ?? 'Failed to fetch exercise details');
      }
    } catch (e) {
      print('❌ Error fetching exercise details: $e');
      rethrow;
    }
  }

  /// Check if the backend is healthy and accessible
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/health');
      final response = await http.get(uri).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Backend health check failed: $e');
      return false;
    }
  }
}
