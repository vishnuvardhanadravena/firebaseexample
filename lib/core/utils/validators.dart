class AppValidators {
  AppValidators._();

  /// Required Field
  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    const pattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    if (!RegExp(pattern).hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  /// Password
  static String? password(
    String? value, {
    int minLength = 6,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Confirm Password
  static String? confirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Mobile Number
  static String? phone(
    String? value, {
    int length = 10,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    if (value.length != length) {
      return 'Phone number must be $length digits';
    }

    return null;
  }

  /// OTP
  static String? otp(
    String? value, {
    int length = 6,
  }) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != length) {
      return 'OTP must be $length digits';
    }

    return null;
  }

  /// URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);

    if (uri == null || !uri.hasAbsolutePath) {
      return 'Enter a valid URL';
    }

    return null;
  }

  /// PAN Card (India)
  static String? pan(String? value) {
    if (value == null || value.isEmpty) {
      return 'PAN is required';
    }

    const pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid PAN Number';
    }

    return null;
  }

  /// Aadhaar (India)
  static String? aadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar is required';
    }

    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
      return 'Invalid Aadhaar Number';
    }

    return null;
  }
}