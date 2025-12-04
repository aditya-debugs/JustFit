import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'core/services/storage_service.dart';
import 'core/services/discovery_workout_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  final logger = Logger();

  try {
    // ====================
    // 1. CORE SERVICES
    // ====================

    getIt.registerLazySingleton<StorageService>(() => StorageService());
    getIt.registerLazySingleton<DiscoveryWorkoutService>(() => DiscoveryWorkoutService()); // ✅ ADD THIS

    // ====================
    // 2. INITIALIZE SERVICES (Order Matters!)
    // ====================

    await getIt<StorageService>().init();

    logger.i('✅ Dependency injection setup complete');
  } catch (e) {
    logger.e('❌ Dependency injection setup failed: $e');
    rethrow;
  }
}


