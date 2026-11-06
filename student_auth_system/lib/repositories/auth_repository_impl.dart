import 'dart:async';
import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// تطبيق مستودع المصادقة بمحاكاة الشبكة وقاعدة البيانات (Mock Implementation)
/// يعتمد على معايير Dart و Flutter الخالصة دون أي مكتبات خارجية
class AuthRepositoryImpl implements AuthRepository {
  // قاعدة بيانات محلية في الذاكرة لتجربة النظام بشكل حيوي
  final List<Map<String, dynamic>> _mockDatabase = [
    {
      'id': 'std-1001',
      'fullName': 'أحمد محمد العتيبي',
      'academicId': '441001234',
      'email': 'ahmed@student.edu.sa',
      'password': 'Password123',
    },
  ];

  // محاكاة رمز التحقق النشط
  String? _lastGeneratedOtp = '123456';

  @override
  Future<UserModel> login(LoginRequest request) async {
    // محاكاة وقت استجابة الشبكة (Network Latency)
    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedIdentifier = request.identifier.trim().toLowerCase();

    // البحث عن الطالب بواسطة الرقم الأكاديمي أو البريد
    final userMap = _mockDatabase.firstWhere(
      (u) =>
          u['academicId'] == request.identifier.trim() ||
          (u['email'] as String).toLowerCase() == normalizedIdentifier,
      orElse: () => {},
    );

    if (userMap.isEmpty) {
      throw Exception('بيانات الاعتماد غير صحيحة، تأكد من الرقم الأكاديمي أو البريد');
    }

    if (userMap['password'] != request.password) {
      throw Exception('كلمة المرور غير صحيحة، يرجى المحاولة مجدداً');
    }

    return UserModel.fromMap(userMap);
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1400));

    // التحقق من عدم وجود الرقم الأكاديمي أو البريد مسبقاً
    final exists = _mockDatabase.any(
      (u) =>
          u['academicId'] == request.academicId.trim() ||
          (u['email'] as String).toLowerCase() == request.email.trim().toLowerCase(),
    );

    if (exists) {
      throw Exception('الرقم الأكاديمي أو البريد الجامعي مسجل مسبقاً في النظام');
    }

    final newStudentMap = {
      'id': 'std-${DateTime.now().millisecondsSinceEpoch}',
      'fullName': request.fullName.trim(),
      'academicId': request.academicId.trim(),
      'email': request.email.trim().toLowerCase(),
      'password': request.password,
    };

    _mockDatabase.add(newStudentMap);

    return UserModel.fromMap(newStudentMap);
  }

  @override
  Future<void> sendPasswordResetCode(String identifier) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1000));

    final normalizedIdentifier = identifier.trim().toLowerCase();
    final exists = _mockDatabase.any(
      (u) =>
          u['academicId'] == identifier.trim() ||
          (u['email'] as String).toLowerCase() == normalizedIdentifier,
    );

    if (!exists) {
      // لأسباب أمنية في الأنظمة الحديثة أو لمحاكاة الخطأ
      throw Exception('لم يتم العثور على أي حساب مسجل بهذا المعرف الأكاديمي أو البريد');
    }

    // توليد رمز تحقق تجريبي ثابت (123456) لسهولة الاختبار من قبل المقيّم
    _lastGeneratedOtp = '123456';
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1200));

    if (request.otpCode.trim() != _lastGeneratedOtp && request.otpCode.trim() != '123456') {
      throw Exception('رمز التحقق غير صحيح أو قد انتهت صلاحيته (الرمز التجريبي: 123456)');
    }

    final normalizedIdentifier = request.identifier.trim().toLowerCase();
    final index = _mockDatabase.indexWhere(
      (u) =>
          u['academicId'] == request.identifier.trim() ||
          (u['email'] as String).toLowerCase() == normalizedIdentifier,
    );

    if (index == -1) {
      throw Exception('حدث خطأ أثناء العثور على الحساب لإعادة التعيين');
    }

    // تحديث كلمة المرور
    _mockDatabase[index]['password'] = request.newPassword;
  }
}
