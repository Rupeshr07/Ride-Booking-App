import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_repository.dart';
import '../services/preference_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authData = await PreferenceService.getAuthData();
      final token = authData['token'];
      final userId = authData['id'];

      if (token == null || userId == null) {
        throw Exception('UNAUTHORIZED');
      }

      _profile = await _repository.getProfile(
        token: token,
        userId: userId,
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('ProfileProvider Error (fetchProfile): $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? base64Image,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authData = await PreferenceService.getAuthData();
      final token = authData['token'];
      
      if (token == null || _profile == null) {
        throw Exception('UNAUTHORIZED');
      }

      final updatedUser = await _repository.updateProfile(
        token: token,
        id: _profile!.id,
        name: name,
        email: email,
        base64Image: base64Image,
      );

      _profile = updatedUser;
      
      // Update local preference sync
      await PreferenceService.saveUser({
        'name': updatedUser.name,
        'email': updatedUser.email,
        'full_name': updatedUser.name,
      });

      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      debugPrint('ProfileProvider Error (updateProfile): $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _profile = null;
    _error = null;
    notifyListeners();
  }
}
