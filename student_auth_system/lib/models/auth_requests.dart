/// نماذج طلبات المصادقة (Request Models)

/// نموذج طلب تسجيل الدخول
class LoginRequest {
  final String identifier; // البريد الجامعي أو الرقم الأكاديمي
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier.trim(),
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}

/// نموذج طلب إنشاء حساب جديد
class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;
  final bool acceptTerms;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
    required this.acceptTerms,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName.trim(),
      'academicId': academicId.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'acceptTerms': acceptTerms,
    };
  }
}

/// نموذج طلب إعادة تعيين كلمة المرور
class ResetPasswordRequest {
  final String identifier;
  final String otpCode;
  final String newPassword;

  const ResetPasswordRequest({
    required this.identifier,
    required this.otpCode,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier.trim(),
      'otpCode': otpCode.trim(),
      'newPassword': newPassword,
    };
  }
}
