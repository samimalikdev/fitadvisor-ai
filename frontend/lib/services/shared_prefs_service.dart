import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _profileKey = 'user_profile_cache';
  static const String _dailyIntakeKey = 'daily_intake_cache';
  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveProfileData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(data));
  }

  Future<Map<String, dynamic>?> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_profileKey);
    if (dataString != null) {
      try {
        return json.decode(dataString) as Map<String, dynamic>;
      } catch (e) {
        print("Error decoding profile cache: $e");
        return null;
      }
    }
    return null;
  }

  Future<void> saveDailyIntakeData(List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_dailyIntakeKey, json.encode(data));
  }

  Future<List<dynamic>?> getDailyIntakeData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_dailyIntakeKey);
    if (dataString != null) {
      try {
        return json.decode(dataString) as List<dynamic>;
      } catch (e) {
        print("Error decoding daily intake cache: $e");
        return null;
      }
    }
    return null;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
