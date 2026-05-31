import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rideHistoryKey = 'ride_history';

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStr = prefs.getString(_userKey);
    Map<String, dynamic> mergedData = {};
    if (currentStr != null) {
      mergedData = jsonDecode(currentStr);
    }
    mergedData.addAll(userData);
    await prefs.setString(_userKey, jsonEncode(mergedData));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveRide(Map<String, dynamic> rideData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_rideHistoryKey) ?? [];
    history.insert(0, jsonEncode(rideData));
    await prefs.setStringList(_rideHistoryKey, history);
  }

  static Future<List<Map<String, dynamic>>> getRideHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_rideHistoryKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<String?> getAuthToken() async {
    final user = await getUser();
    return user?['token'] as String?;
  }

  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?['id']?.toString();
  }

  static Future<Map<String, String?>> getAuthData() async {
    final user = await getUser();
    return {
      'token': user?['token'] as String?,
      'id': user?['id']?.toString(),
    };
  }

  // how to use getAuthData in api service
  //   // To get the token for an API header:
  //     String? token = await PreferenceService.getAuthToken();
  //
  //   // To get both ID and Token at once:
  //     final auth = await PreferenceService.getAuthData();
  //     print("User ID: ${auth['id']}");
  //     print("Token: ${auth['token']}");
}
