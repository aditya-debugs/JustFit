import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_data_model.dart';
import 'user_preference_model.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  
  // Onboarding
  final bool hasCompletedOnboarding;
  final OnboardingData? onboardingData;
  
  // Current Plan
  final String? currentPlanId;
  final DateTime? planStartDate;
  
  // Preferences
  final UserPreferences preferences;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
    this.hasCompletedOnboarding = false,
    this.onboardingData,
    this.currentPlanId,
    this.planStartDate,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
  });

  // Factory constructor from Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      isAnonymous: data['isAnonymous'] ?? false,
      hasCompletedOnboarding: data['hasCompletedOnboarding'] ?? false,
      onboardingData: data['onboardingData'] != null
          ? OnboardingData.fromMap(data['onboardingData'])
          : null,
      currentPlanId: data['currentPlanId'],
      planStartDate: _parseDate(data['planStartDate']), // ← UPDATED
      preferences: data['preferences'] != null
          ? UserPreferences.fromMap(data['preferences'])
          : UserPreferences.defaultPreferences(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastActiveAt: data['lastActiveAt'] != null
          ? (data['lastActiveAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'onboardingData': onboardingData?.toMap(),
      'currentPlanId': currentPlanId,
      'planStartDate': planStartDate != null 
          ? Timestamp.fromDate(planStartDate!) 
          : null,
      'preferences': preferences.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastActiveAt': lastActiveAt != null 
          ? Timestamp.fromDate(lastActiveAt!) 
          : null,
    };
  }

  // CopyWith for immutability
  UserModel copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isAnonymous,
    bool? hasCompletedOnboarding,
    OnboardingData? onboardingData,
    String? currentPlanId,
    DateTime? planStartDate,
    UserPreferences? preferences,
    DateTime? updatedAt,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      onboardingData: onboardingData ?? this.onboardingData,
      currentPlanId: currentPlanId ?? this.currentPlanId,
      planStartDate: planStartDate ?? this.planStartDate,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  // ========== HELPER METHODS ==========
  
  /// Parse date from either Timestamp or String (handles legacy data)
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      }
    } catch (e) {
      print('⚠️ Error parsing date: $e');
    }
    
    return null;
  }
}