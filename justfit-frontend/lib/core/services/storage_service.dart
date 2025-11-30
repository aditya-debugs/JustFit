import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../constants/app_keys.dart';

class StorageService {
  SharedPreferences? _prefs;
  final Logger _logger = Logger();

  // ====================
  // INITIALIZATION
  // ====================

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('✅ StorageService initialized');
    } catch (e) {
      _logger.e('❌ StorageService initialization failed: $e');
      rethrow;
    }
  }

  // ====================
  // GENERIC SETTERS
  // ====================

  Future<bool> set<T>(String key, T value) async {
    try {
      if (value is String) {
        return await _prefs!.setString(key, value);
      } else if (value is int) {
        return await _prefs!.setInt(key, value);
      } else if (value is double) {
        return await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        return await _prefs!.setBool(key, value);
      } else if (value is List<String>) {
        return await _prefs!.setStringList(key, value);
      } else {
        throw ArgumentError('Unsupported type: ${value.runtimeType}');
      }
    } catch (e) {
      _logger.e('Error setting $key: $e');
      return false;
    }
  }

  // ====================
  // TYPED GETTERS WITH DEFAULTS
  // ====================

  String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  // ====================
  // UTILITY METHODS
  // ====================

  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  Future<bool> remove(String key) async {
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      _logger.e('Error removing $key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _prefs!.clear();
    } catch (e) {
      _logger.e('Error clearing storage: $e');
      return false;
    }
  }

  Set<String> getAllKeys() {
    return _prefs?.getKeys() ?? {};
  }

  // ====================
  // DOMAIN-SPECIFIC HELPERS
  // ====================

  Future<void> saveUser(Map<String, dynamic> userData) async {
    await set(AppKeys.spKeys.userId, userData['id'] ?? '');
    await set(AppKeys.spKeys.userName, userData['name'] ?? '');
  }

  String? getUserId() {
    final id = getString(AppKeys.spKeys.userId);
    return id.isEmpty ? null : id;
  }

  String? getUserName() {
    final name = getString(AppKeys.spKeys.userName);
    return name.isEmpty ? null : name;
  }

  Future<void> clearUserData() async {
    await remove(AppKeys.spKeys.userId);
    await remove(AppKeys.spKeys.userName);
  }

  bool get isFirstLaunch {
    return !getBool(AppKeys.spKeys.isFirstLaunch, defaultValue: false);
  }

  Future<void> setFirstLaunchComplete() async {
    await set(AppKeys.spKeys.isFirstLaunch, true);
  }
}