import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'preference_service.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  static const String baseUrl = 'https://arcgo.in/api/auth';

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/send-otp');
    final body = jsonEncode({'phoneNumber': phoneNumber});
    
    debugPrint('API Request: POST $url');
    debugPrint('Request Body: $body');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData;
      } else {
        throw AuthException(responseData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      debugPrint('API Error (sendOtp): $e');
      if (e is AuthException) rethrow;
      throw AuthException('An error occurred. Please check your internet connection.');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'otp': otp,
    });

    debugPrint('API Request: POST $url');
    debugPrint('Request Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save token and user info from API
        await PreferenceService.saveUser({
          'id': responseData['user']['id'].toString(),
          'phoneNumber': responseData['user']['phoneNumber'],
          'token': responseData['token'],
        });
        return responseData;
      } else {
        throw AuthException(responseData['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      debugPrint('API Error (verifyOtp): $e');
      if (e is AuthException) rethrow;
      throw AuthException('An error occurred. Please verify your internet connection.');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String name,
    required String email,
    required String gender,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'gender': gender,
    });

    debugPrint('API Request: POST $url');
    debugPrint('Request Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save token and full user info from API
        await PreferenceService.saveUser({
          'id': responseData['user']['id'].toString(),
          'phoneNumber': responseData['user']['phoneNumber'],
          'name': responseData['user']['name'],
          'email': responseData['user']['email'],
          'gender': responseData['user']['gender'],
          'token': responseData['token'],
          'full_name': responseData['user']['name'],
        });
        return responseData;
      } else {
        throw AuthException(responseData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('API Error (register): $e');
      if (e is AuthException) rethrow;
      throw AuthException('An error occurred. Please check your internet connection.');
    }
  }
}
