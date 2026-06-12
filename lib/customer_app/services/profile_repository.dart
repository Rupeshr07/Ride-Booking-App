import '../models/user_profile.dart';
import 'api_service.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<UserProfile> getProfile({
    required String token,
    required String userId,
  }) async {
    return await _apiService.getUserProfile(token: token, userId: userId);
  }

  Future<UserProfile> updateProfile({
    required String token,
    required int id,
    required String name,
    required String email,
    String? base64Image,
  }) async {
    return await _apiService.updateProfile(
      token: token,
      id: id,
      name: name,
      email: email,
      base64Image: base64Image,
    );
  }
}
