import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Observables
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isDevMode = false.obs;
  RxBool isLoading = false.obs;
  
  // Getters
  bool get isAuthenticated => firebaseUser.value != null;
  String? get userId => firebaseUser.value?.uid;
  String? get userEmail => firebaseUser.value?.email;
  String? get userName => firebaseUser.value?.displayName;
  String? get userPhoto => firebaseUser.value?.photoURL;
  
  @override
  void onInit() {
    super.onInit();
    // Bind firebase user to observable
    firebaseUser.bindStream(_auth.authStateChanges());
    _loadDevMode();
  }
  
  // Load dev mode preference
  Future<void> _loadDevMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDevMode.value = prefs.getBool('dev_mode') ?? false; // Default TRUE for development
    
    if (isDevMode.value) {
      await Future.delayed(Duration(milliseconds: 100));
      if (!isAuthenticated) {
        await signInAnonymouslyForDev();
      }
    }
  }
  
  // Toggle dev mode (for development only)
  Future<void> toggleDevMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dev_mode', value);
    isDevMode.value = value;
    
    if (value && !isAuthenticated) {
      await signInAnonymouslyForDev();
    } else if (!value && firebaseUser.value?.isAnonymous == true) {
      await signOut();
    }
    
    Get.snackbar(
      'Dev Mode',
      value ? '✅ Enabled - No auth required' : '❌ Disabled - Auth required',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Anonymous sign-in for development
  Future<void> signInAnonymouslyForDev() async {
    try {
      isLoading.value = true;
      await _auth.signInAnonymously();
      print('✅ Dev Mode: Signed in anonymously');
      print('✅ User ID: ${_auth.currentUser?.uid}');
    } catch (e) {
      print('❌ Dev Mode Error: $e');
      Get.snackbar('Dev Mode Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading.value = false;
        return null;
      }
      
      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Turn off dev mode when user signs in normally
      await toggleDevMode(false);
      
      Get.snackbar(
        'Success! 🎉',
        'Welcome, ${userCredential.user?.displayName}!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      print('✅ Google Sign-In successful: ${userCredential.user?.email}');
      
      return userCredential.user;
      
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      Get.snackbar('Sign-In Error', e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Email/Password Sign Up
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      
      // Turn off dev mode
      await toggleDevMode(false);
      
      Get.snackbar(
        'Success! 🎉',
        'Account created for $name',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      print('✅ Sign Up successful: $email');
      
      return _auth.currentUser;
      
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      Get.snackbar('Error', message);
      print('❌ Sign Up Error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('❌ Sign Up Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Email/Password Sign In
  Future<User?> signIn({
  required String email,
  required String password,
}) async {
  try {
    isLoading.value = true;
    
    print('🔐 ========================================');
    print('🔐 SIGN IN ATTEMPT');
    print('🔐 ========================================');
    print('📧 Email: $email');
    print('🔑 Password length: ${password.length} characters');
    
    // Test 1: Check if Firebase is initialized
    print('\n📱 TEST 1: Checking Firebase initialization...');
    try {
      final app = Firebase.app();
      print('✅ Firebase app initialized: ${app.name}');
      print('✅ Firebase options: ${app.options.projectId}');
    } catch (e) {
      print('❌ Firebase not initialized: $e');
      throw Exception('Firebase initialization failed');
    }
    
    // Test 2: Check network connectivity
    print('\n🌐 TEST 2: Checking network connectivity...');
    try {
      final testResponse = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(const Duration(seconds: 5));
      print('✅ Network test successful: ${testResponse.statusCode}');
    } catch (e) {
      print('❌ Network test failed: $e');
      print('⚠️ Device may not have internet access');
    }
    
    // Test 3: Check Firebase Auth instance
    print('\n🔥 TEST 3: Checking Firebase Auth instance...');
    try {
      print('✅ Firebase Auth instance: ${_auth.app.name}');
      print('✅ Current user before sign-in: ${_auth.currentUser?.email ?? "None"}');
    } catch (e) {
      print('❌ Firebase Auth error: $e');
    }
    
    // Test 4: Attempt sign-in
    print('\n🔓 TEST 4: Attempting Firebase sign-in...');
    print('⏳ Calling signInWithEmailAndPassword...');
    
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    print('✅ Sign-in successful!');
    print('👤 User ID: ${userCredential.user?.uid}');
    print('📧 User email: ${userCredential.user?.email}');
    print('✅ Email verified: ${userCredential.user?.emailVerified}');
    
    // Turn off dev mode
    await toggleDevMode(false);
    
    Get.snackbar(
      'Success! 🎉',
      'Welcome back, ${userCredential.user?.displayName ?? userCredential.user?.email}!',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    print('🔐 ========================================');
    print('🔐 SIGN IN COMPLETED SUCCESSFULLY');
    print('🔐 ========================================\n');
    
    return userCredential.user;
    
  } on FirebaseAuthException catch (e) {
    print('\n❌ ========================================');
    print('❌ FIREBASE AUTH EXCEPTION');
    print('❌ ========================================');
    print('❌ Error code: ${e.code}');
    print('❌ Error message: ${e.message}');
    print('❌ Error details: $e');
    print('❌ ========================================\n');
    
    String message = 'Sign in failed';
    if (e.code == 'user-not-found') {
      message = 'No account found with this email';
    } else if (e.code == 'wrong-password') {
      message = 'Incorrect password';
    } else if (e.code == 'invalid-email') {
      message = 'Invalid email address';
    } else if (e.code == 'user-disabled') {
      message = 'This account has been disabled';
    } else if (e.code == 'network-request-failed') {
      message = 'Network error. Please check your internet connection.';
      print('⚠️ NETWORK ISSUE DETECTED:');
      print('  - Check if emulator has internet access');
      print('  - Try opening Chrome in emulator and visit google.com');
      print('  - Verify AndroidManifest.xml has INTERNET permission');
      print('  - Try cold booting the emulator');
    }
    
    Get.snackbar('Error', message);
    return null;
    
  } on SocketException catch (e) {
    print('\n❌ ========================================');
    print('❌ SOCKET EXCEPTION (Network Issue)');
    print('❌ ========================================');
    print('❌ Error: $e');
    print('⚠️ This indicates a network connectivity problem');
    print('❌ ========================================\n');
    
    Get.snackbar('Error', 'Network connection failed');
    return null;
    
  } on TimeoutException catch (e) {
    print('\n❌ ========================================');
    print('❌ TIMEOUT EXCEPTION');
    print('❌ ========================================');
    print('❌ Error: $e');
    print('⚠️ Request timed out - slow or no internet connection');
    print('❌ ========================================\n');
    
    Get.snackbar('Error', 'Request timed out. Check your connection.');
    return null;
    
  } catch (e) {
    print('\n❌ ========================================');
    print('❌ UNKNOWN ERROR');
    print('❌ ========================================');
    print('❌ Error type: ${e.runtimeType}');
    print('❌ Error message: $e');
    print('❌ Stack trace: ${StackTrace.current}');
    print('❌ ========================================\n');
    
    Get.snackbar('Error', e.toString());
    return null;
    
  } finally {
    isLoading.value = false;
  }
}
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      
      Get.snackbar(
        'Signed Out',
        'You have been signed out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      print('✅ Sign out successful');
      
    } catch (e) {
      print('❌ Sign Out Error: $e');
    }
  }
  
  // Check if current user is anonymous (dev mode)
  bool get isAnonymous => firebaseUser.value?.isAnonymous ?? false;
}