import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/models/user/user_model.dart';
import '../../data/models/user/onboarding_data_model.dart';
import '../../data/models/user/user_preference_model.dart';

class UserService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive user data
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes and load user data
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        loadUserProfile(firebaseUser.uid);
      } else {
        currentUser.value = null;
      }
    });
  }

  // ========== CREATE USER ==========

  /// Creates a new user profile in Firestore
  /// Call this after successful sign up or first anonymous sign in
  Future<UserModel?> createUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool isAnonymous = false,
  }) async {
    try {
      isLoading.value = true;

      final now = DateTime.now();
      final newUser = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        isAnonymous: isAnonymous,
        hasCompletedOnboarding: false,
        preferences: UserPreferences.defaultPreferences(),
        createdAt: now,
        updatedAt: now,
        lastActiveAt: now,
      );

      // Save to Firestore
      await _usersCollection.doc(uid).set(newUser.toFirestore());

      currentUser.value = newUser;
      print('✅ User created: $uid');
      
      return newUser;
    } catch (e) {
      print('❌ Error creating user: $e');
      _showError('Failed to create user profile');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ========== READ USER ==========

  /// Loads user profile from Firestore
  Future<UserModel?> loadUserProfile(String uid) async {
    try {
      isLoading.value = true;

      final docSnapshot = await _usersCollection.doc(uid).get();

      if (!docSnapshot.exists) {
        print('⚠️ User profile not found for: $uid');
        return null;
      }

      final user = UserModel.fromFirestore(docSnapshot);
      currentUser.value = user;

      // Update last active timestamp
      await updateLastActive(uid);

      print('✅ User profile loaded: ${user.email ?? user.uid}');
      return user;
    } catch (e) {
      print('❌ Error loading user profile: $e');
      _showError('Failed to load user profile');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user profile once (no subscription)
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _usersCollection.doc(uid).get();
      if (!docSnapshot.exists) return null;
      return UserModel.fromFirestore(docSnapshot);
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  // ========== UPDATE USER ==========

  /// Updates user profile fields
  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
    String? email,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        _showError('User not authenticated');
        return false;
      }

      isLoading.value = true;

      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (email != null) updateData['email'] = email;

      await _usersCollection.doc(uid).update(updateData);

      // Reload user data
      await loadUserProfile(uid);

      print('✅ Profile updated successfully');
      Get.snackbar(
        '✅ Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      _showError('Failed to update profile');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates last active timestamp
  Future<void> updateLastActive(String uid) async {
    try {
      await _usersCollection.doc(uid).update({
        'lastActiveAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('⚠️ Error updating last active: $e');
      // Silent fail - not critical
    }
  }

  // ========== ONBOARDING DATA ==========

  /// Saves onboarding data and marks onboarding as complete
    /// Saves onboarding data and marks onboarding as complete
  Future<bool> saveOnboardingData(OnboardingData onboardingData) async {
    try {
      final uid = _auth.currentUser?.uid;
      final user = _auth.currentUser;
      if (uid == null || user == null) {
        _showError('User not authenticated');
        return false;
      }

      isLoading.value = true;

      // Check if user document exists
      final docSnapshot = await _usersCollection.doc(uid).get();
      
      if (!docSnapshot.exists) {
        // Create user document first if it doesn't exist
        print('⚠️ User document not found, creating it first...');
        
        // ✅ FIX: Use named parameters for createUser
        final newUser = await createUser(
          uid: uid,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          isAnonymous: user.isAnonymous,
        );
        
        if (newUser == null) {
          throw Exception('Failed to create user document');
        }
      }

      // Now update with onboarding data (using set with merge to be safe)
      await _usersCollection.doc(uid).set({
        'onboardingData': onboardingData.toMap(),
        'hasCompletedOnboarding': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));

      // Reload user data
      await loadUserProfile(uid);

      print('✅ Onboarding data saved successfully');
      return true;
    } catch (e) {
      print('❌ Error saving onboarding data: $e');
      _showError('Failed to save onboarding data');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Gets onboarding data for current user
  Future<OnboardingData?> getOnboardingData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final docSnapshot = await _usersCollection.doc(uid).get();
      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data['onboardingData'] == null) return null;

      return OnboardingData.fromMap(data['onboardingData']);
    } catch (e) {
      print('❌ Error getting onboarding data: $e');
      return null;
    }
  }

  // ========== PREFERENCES ==========

  /// Updates user preferences
  Future<bool> updatePreferences(UserPreferences preferences) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        _showError('User not authenticated');
        return false;
      }

      await _usersCollection.doc(uid).update({
        'preferences': preferences.toMap(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Reload user data
      await loadUserProfile(uid);

      print('✅ Preferences updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating preferences: $e');
      _showError('Failed to update preferences');
      return false;
    }
  }

  /// Updates a single preference field
  Future<bool> updatePreference(String key, dynamic value) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      await _usersCollection.doc(uid).update({
        'preferences.$key': value,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Reload user data
      await loadUserProfile(uid);

      return true;
    } catch (e) {
      print('❌ Error updating preference: $e');
      return false;
    }
  }

  // ========== CURRENT PLAN ==========

  /// Links a workout plan to the user
  Future<bool> setCurrentPlan(String planId, DateTime startDate) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        _showError('User not authenticated');
        return false;
      }

      await _usersCollection.doc(uid).update({
        'currentPlanId': planId,
        'planStartDate': Timestamp.fromDate(startDate),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Reload user data
      await loadUserProfile(uid);

      print('✅ Current plan set: $planId');
      return true;
    } catch (e) {
      print('❌ Error setting current plan: $e');
      _showError('Failed to set workout plan');
      return false;
    }
  }

  /// Clears current plan (when plan is completed or archived)
  Future<bool> clearCurrentPlan() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      await _usersCollection.doc(uid).update({
        'currentPlanId': null,
        'planStartDate': null,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Reload user data
      await loadUserProfile(uid);

      print('✅ Current plan cleared');
      return true;
    } catch (e) {
      print('❌ Error clearing current plan: $e');
      return false;
    }
  }

  // ========== HELPERS ==========

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding {
    return currentUser.value?.hasCompletedOnboarding ?? false;
  }

  /// Check if user has an active plan
  bool get hasActivePlan {
    return currentUser.value?.currentPlanId != null;
  }

  /// Get current user ID
  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  /// Delete user account (careful!)
  Future<bool> deleteUserAccount() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      // Delete Firestore document
      await _usersCollection.doc(uid).delete();

      // Delete Firebase Auth user
      await _auth.currentUser?.delete();

      currentUser.value = null;

      print('✅ User account deleted');
      return true;
    } catch (e) {
      print('❌ Error deleting user account: $e');
      _showError('Failed to delete account');
      return false;
    }
  }

  // ========== ERROR HANDLING ==========

  void _showError(String message) {
    Get.snackbar(
      '❌ Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}