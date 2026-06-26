import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/driver_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://arcgo.in/api/driver',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static const String _tokenKey = 'driver_token';

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      if (e.response?.data is Map) {
        return e.response?.data['message'] ?? 'An error occurred';
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet.";
      case DioExceptionType.receiveTimeout:
        return "Server is taking too long to respond.";
      case DioExceptionType.connectionError:
        return "No internet connection.";
      default:
        return "Something went wrong. Please try again.";
    }
  }

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'mobile': mobile,
        'password': password,
      });

      if (response.data['success'] == true) {
        final token = response.data['token'];
        final driverData = response.data['driver'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        
        return {
          'success': true,
          'driver': DriverModel.fromJson(driverData),
          'token': token,
        };
      }
      return {'success': false, 'message': response.data['message'] ?? 'Login failed'};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleDioError(e)};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) return {'success': false, 'message': 'Session expired. Please login again.'};

      final response = await _dio.get('/profile', options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ));

      if (response.data['success'] == true) {
        return {
          'success': true,
          'driver': DriverModel.fromJson(response.data['driver']),
        };
      }
      return {'success': false, 'message': response.data['message'] ?? 'Failed to fetch profile'};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleDioError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Could not load profile'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will clear token and app_mode
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
