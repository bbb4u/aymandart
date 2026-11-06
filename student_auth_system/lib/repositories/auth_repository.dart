import '../models/auth_requests.dart';
import '../models/user_model.dart';

/// العقد التجريدي لمستودع المصادقة (Auth Repository Contract)
/// يحدد كافة العمليات البرمجية للمصادقة واستعادة الحساب
abstract class AuthRepository {
  /// تسجيل الدخول
  Future<UserModel> login(LoginRequest request);

  /// إنشاء حساب طالب جديد
  Future<UserModel> register(RegisterRequest request);

  /// إرسال رمز التحقق لاستعادة الحساب
  Future<void> sendPasswordResetCode(String identifier);

  /// إعادة تعيين كلمة المرور عبر رمز التحقق
  Future<void> resetPassword(ResetPasswordRequest request);
}
