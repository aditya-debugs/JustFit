import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'get_it.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';
import 'controllers/workout_plan_controller.dart'; // ← NEW LINE
import 'core/services/firestore_service.dart';
// import 'data/seed/seed_discovery_workouts.dart';  // ✅ CORRECT PATH
import 'core/services/discovery_workout_service.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized successfully');

  // // 🔥 CLEAR AND RE-SEED (DELETE AFTER USE!)
  // await SeedDiscoveryWorkouts.clearAll();
  // await SeedDiscoveryWorkouts.seedAll();


  // Initialize Services (GetX)
  Get.put(AuthService(), permanent: true);
  Get.put(UserService(), permanent: true);
  Get.put(FirestoreService(), permanent: true);
  Get.put(WorkoutPlanController(), permanent: true); // ← NEW LINE
  Get.put(DiscoveryWorkoutService(), permanent: true); // ✅ ADD THIS LINE
  
  print('✅ Auth Service initialized');
  print('✅ User Service initialized');
  print('✅ Firestore Service initialized');
  print('✅ Workout Plan Controller initialized'); // ← NEW LINE
  print('✅ Discovery Workout Service initialized'); // ✅ ADD THIS LINE


  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JustFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}








