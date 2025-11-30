import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/seed/discover_workouts_seed.dart';

/// Standalone script to upload discovery workouts to Firestore
/// Run with: dart run lib/scripts/upload_discovery_workouts.dart
void main() async {
  print('🚀 Discovery Workouts Upload Script');
  print('=' * 50);
  
  try {
    // Initialize Firebase
    print('\n🔧 Initializing Firebase...');
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'YOUR_API_KEY',
        appId: 'YOUR_APP_ID',
        messagingSenderId: 'YOUR_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        storageBucket: 'YOUR_STORAGE_BUCKET',
      ),
    );
    print('✅ Firebase initialized');

    // Get Firestore instance
    final firestore = FirebaseFirestore.instance;
    
    // Confirm before upload
    print('\n📊 Ready to upload ${DiscoveryWorkoutsSeed.allWorkouts.length} workouts');
    print('⚠️  This will overwrite existing data!');
    print('\nType "yes" to continue or anything else to cancel:');
    
    final confirmation = stdin.readLineSync();
    
    if (confirmation?.toLowerCase() != 'yes') {
      print('❌ Upload cancelled');
      exit(0);
    }

    // Upload workouts
    print('\n🌱 Starting upload...\n');
    
    int successCount = 0;
    int errorCount = 0;
    
    for (var i = 0; i < DiscoveryWorkoutsSeed.allWorkouts.length; i++) {
      final workout = DiscoveryWorkoutsSeed.allWorkouts[i];
      
      try {
        final workoutId = workout['id'] as String;
        
        // Add timestamps
        final workoutData = Map<String, dynamic>.from(workout);
        workoutData['createdAt'] = FieldValue.serverTimestamp();
        workoutData['updatedAt'] = FieldValue.serverTimestamp();
        
        // Upload to Firestore
        await firestore
            .collection('discovery_workouts')
            .doc(workoutId)
            .set(workoutData);
        
        successCount++;
        print('✅ [${i + 1}/${DiscoveryWorkoutsSeed.allWorkouts.length}] $workoutId - ${workout['title']}');
        
        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 100));
        
      } catch (e) {
        errorCount++;
        print('❌ [${i + 1}/${DiscoveryWorkoutsSeed.allWorkouts.length}] Error: ${workout['id']} - $e');
      }
    }

    // Summary
    print('\n' + '=' * 50);
    print('🎉 UPLOAD COMPLETE!');
    print('=' * 50);
    print('✅ Successful: $successCount workouts');
    if (errorCount > 0) {
      print('❌ Failed: $errorCount workouts');
    }
    print('\n✨ Discovery workouts are now live in Firestore!');
    
    exit(0);
    
  } catch (e) {
    print('\n❌ Fatal Error: $e');
    exit(1);
  }
}
