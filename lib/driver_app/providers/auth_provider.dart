import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  DriverModel? _driver;
  bool _isLoading = false;
  String? _error;

  DriverModel? get driver => _driver;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _driver != null;

  Future<bool> login(String mobile, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.login(mobile, password);

    if (result['success'] == true) {
      _driver = result['driver'];
      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = result['message'];
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.getProfile();

    if (result['success'] == true) {
      _driver = result['driver'];
      _error = null;
    } else {
      _error = result['message'];
      // If profile fails, usually means token is invalid or expired
      if (_error!.contains('Session expired') || _error!.contains('token')) {
        await logout();
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _driver = null;
    // We don't clear _error here so it can be displayed after logout if needed
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
