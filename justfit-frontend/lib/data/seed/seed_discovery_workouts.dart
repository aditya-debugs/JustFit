import 'package:cloud_firestore/cloud_firestore.dart';
import 'discover_workouts_seed.dart';

/// Script to upload all discovery workouts to Firestore
/// Run this ONCE to populate the database
class SeedDiscoveryWorkouts {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Main seeding function
  static Future<void> seedAll() async {
    print('🌱 Starting Discovery Workouts Seeding...');
    print('📊 Total workouts to upload: ${DiscoveryWorkoutsSeed.allWorkouts.length}');
    
    int successCount = 0;
    int errorCount = 0;

    for (var workout in DiscoveryWorkoutsSeed.allWorkouts) {
      try {
        final workoutId = workout['id'] as String;
        
        // Add timestamp
        workout['createdAt'] = FieldValue.serverTimestamp();
        workout['updatedAt'] = FieldValue.serverTimestamp();
        
        // Upload to Firestore
        await _firestore
            .collection('discovery_workouts')
            .doc(workoutId)
            .set(workout);
        
        successCount++;
        print('✅ Uploaded: $workoutId - ${workout['title']}');
        
      } catch (e) {
        errorCount++;
        print('❌ Error uploading ${workout['id']}: $e');
      }
    }

    print('\n🎉 Seeding Complete!');
    print('✅ Success: $successCount workouts');
    if (errorCount > 0) {
      print('❌ Errors: $errorCount workouts');
    }
  }

  /// Seed specific category
  static Future<void> seedCategory(String category) async {
    print('🌱 Seeding category: $category');
    
    final workouts = DiscoveryWorkoutsSeed.allWorkouts
        .where((w) => w['category'] == category)
        .toList();
    
    print('📊 Found ${workouts.length} workouts in $category');
    
    for (var workout in workouts) {
      try {
        final workoutId = workout['id'] as String;
        
        workout['createdAt'] = FieldValue.serverTimestamp();
        workout['updatedAt'] = FieldValue.serverTimestamp();
        
        await _firestore
            .collection('discovery_workouts')
            .doc(workoutId)
            .set(workout);
        
        print('✅ Uploaded: $workoutId');
        
      } catch (e) {
        print('❌ Error: $e');
      }
    }
    
    print('✅ Category $category seeded!');
  }

  /// Delete all discovery workouts (use with caution!)
  static Future<void> clearAll() async {
    print('⚠️ Clearing all discovery workouts...');
    
    final snapshot = await _firestore
        .collection('discovery_workouts')
        .get();
    
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
      print('🗑️ Deleted: ${doc.id}');
    }
    
    print('✅ All workouts cleared!');
  }

  /// Count workouts by category
  static Future<void> showStats() async {
    final snapshot = await _firestore
        .collection('discovery_workouts')
        .get();
    
    final categories = <String, int>{};
    
    for (var doc in snapshot.docs) {
      final category = doc.data()['category'] as String;
      categories[category] = (categories[category] ?? 0) + 1;
    }
    
    print('\n📊 Discovery Workouts Statistics:');
    print('Total: ${snapshot.docs.length} workouts\n');
    
    categories.forEach((category, count) {
      print('$category: $count workouts');
    });
  }
}