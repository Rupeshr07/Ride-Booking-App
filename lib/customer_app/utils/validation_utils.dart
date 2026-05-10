class ValidationUtils {
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter valid 10-digit mobile number";
    }
    final RegExp mobileRegExp = RegExp(r'^[0-9]{10}$');
    if (!mobileRegExp.hasMatch(value)) {
      return "Enter valid 10-digit mobile number";
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String? validateOTP(String? value, int length) {
    if (value == null || value.isEmpty) {
      return "OTP is required";
    }
    if (value.length != length) {
      return "Enter a $length-digit OTP";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (!emailRegExp.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }
}
