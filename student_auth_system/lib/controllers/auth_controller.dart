import 'package:flutter/foundation.dart';
import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';

/// متحكم المصادقة وإدارة الحالة (Auth Controller - ChangeNotifier)
/// يربط بين واجهة المستخدم (Views) ومستودع البيانات (Repository) بدون مكتبات خارجية
class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl();

  // --- حالات المتحكم (State) ---
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  bool _rememberMe = false;
  bool _acceptTerms = false;

  // --- Getters لقراءة الحالة في الواجهات ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get rememberMe => _rememberMe;
  bool get acceptTerms => _acceptTerms;
  bool get isAuthenticated => _currentUser != null;

  // --- دوال التحكم في الحالة المحلية ---

  void setRememberMe(bool value) {
    if (_rememberMe != value) {
      _rememberMe = value;
      notifyListeners();
    }
  }

  void setAcceptTerms(bool value) {
    if (_acceptTerms != value) {
      _acceptTerms = value;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // --- دوال العمليات الرئيسية مع استدعاء الـ Repository ---

  /// تسجيل الدخول
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = LoginRequest(
        identifier: identifier,
        password: password,
        rememberMe: _rememberMe,
      );
      _currentUser = await _repository.login(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  /// إنشاء حساب جديد
  Future<bool> register({
    required String fullName,
    required String academicId,
    required String email,
    required String password,
  }) async {
    if (!_acceptTerms) {
      _errorMessage = 'يجب الموافقة على اللوائح والشروط الأكاديمية للمتابعة';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final request = RegisterRequest(
        fullName: fullName,
        academicId: academicId,
        email: email,
        password: password,
        acceptTerms: _acceptTerms,
      );
      await _repository.register(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  /// إرسال رمز التحقق لاستعادة الحساب
  Future<bool> sendPasswordResetCode(String identifier) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.sendPasswordResetCode(identifier);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  /// تحديث كلمة المرور
  Future<bool> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = ResetPasswordRequest(
        identifier: identifier,
        otpCode: otpCode,
        newPassword: newPassword,
      );
      await _repository.resetPassword(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  /// تسجيل الخروج
  void logout() {
    _currentUser = null;
    _rememberMe = false;
    _acceptTerms = false;
    _errorMessage = null;
    notifyListeners();
  }

  // --- دوال مساعدة خاصة ---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _cleanErrorMessage(Object error) {
    final str = error.toString();
    if (str.startsWith('Exception: ')) {
      return str.substring('Exception: '.length);
    }
    return str;
  }
}
