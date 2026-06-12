import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';

class ApiService {
  static const String baseUrl = 'https://arcgo.in/api';

  Future<UserProfile> getUserProfile({
    required String token,
    required String userId,
  }) async {
    final url = Uri.parse('$baseUrl/user/profile');
    
    debugPrint('API Request: GET $url');
    debugPrint('Headers: {Authorization: Bearer $token, id: $userId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'id': userId,
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return UserProfile.fromJson(responseData['user']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load profile');
        }
      } else if (response.statusCode == 401) {
        throw Exception('UNAUTHORIZED');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      debugPrint('API Error (getUserProfile): $e');
      if (e is FormatException) {
        throw Exception('Invalid JSON response from server');
      }
      rethrow;
    }
  }

  Future<UserProfile> updateProfile({
    required String token,
    required int id,
    required String name,
    required String email,
    String? base64Image,
  }) async {
    final url = Uri.parse('$baseUrl/user/profile');
    
    final body = jsonEncode({
      'id': id,
      'name': name,
      'email': email,
      if (base64Image != null) 'profileImage': base64Image,
    });

    debugPrint('API Request: PUT $url');
    debugPrint('Headers: {Authorization: Bearer $token}');
    // Not printing full base64 to avoid log spam
    debugPrint('Request Body: {id: $id, name: $name, email: $email, profileImage: ${base64Image != null ? 'BASE64_STRING' : 'null'}}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      ).timeout(const Duration(seconds: 30));

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return UserProfile.fromJson(responseData['user']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to update profile');
        }
      } else if (response.statusCode == 401) {
        throw Exception('UNAUTHORIZED');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      debugPrint('API Error (updateProfile): $e');
      rethrow;
    }
  }
}
