
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // Save String
  Future<bool> saveString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // Get String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save int
  Future<bool> saveInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // Get int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save bool
  Future<bool> saveBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // Get bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Remove a specific key
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return _prefs.clear();
  }

}