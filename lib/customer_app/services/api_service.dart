class ApiService {
  // Mock API service for future integration
  
  static Future<void> login(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
