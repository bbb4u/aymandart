/// دوال التحقق النقية للنماذج (Pure Form Validators)
/// تم تصميمها كدوال نقية (Pure Functions) قابلة للاختبار والفصل الكامل عن واجهة المستخدم
class FormValidators {
  FormValidators._();

  /// التحقق من الحقول الإلزامية العامة
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'حقل $fieldName مطلوب ولا يمكن تركه فارغاً';
    }
    return null;
  }

  /// التحقق من المعرف الأكاديمي أو البريد (شاشة تسجيل الدخول)
  /// الشروط: غير فارغ، الطول ≥ 5 محارف
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الرقم الأكاديمي أو البريد الجامعي';
    }
    final trimmed = value.trim();
    if (trimmed.length < 5) {
      return 'يجب أن يتكون المعرف الأكاديمي أو البريد من 5 خانات على الأقل';
    }
    return null;
  }

  /// التحقق من كلمة مرور تسجيل الدخول
  /// الشروط: غير فارغة، الطول ≥ 6 محارف
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب ألا تقل عن 6 محارف';
    }
    return null;
  }

  /// التحقق من الاسم الكامل (شاشة التسجيل)
  /// الشروط: غير فارغ، الطول ≥ 3 محارف
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم الكامل للطالب';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'يجب ألا يقل الاسم الكامل عن 3 أحرف';
    }
    return null;
  }

  /// التحقق من الرقم الأكاديمي (شاشة التسجيل)
  /// الشروط: أرقام حصراً، من 9 إلى 10 خانات
  static String? validateAcademicId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الرقم الأكاديمي';
    }
    final trimmed = value.trim();
    final academicIdRegex = RegExp(r'^\d{9,10}$');
    if (!academicIdRegex.hasMatch(trimmed)) {
      return 'الرقم الأكاديمي يجب أن يتكون من 9 أو 10 أرقام حصراً';
    }
    return null;
  }

  /// التحقق من البريد الجامعي (شاشة التسجيل واستعادة الحساب)
  /// الشروط: صيغة Regex قياسية للبريد الإلكتروني
  static String? validateUniversityEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'صيغة البريد الإلكتروني غير صحيحة (مثال: student@edu.sa)';
    }
    return null;
  }

  /// التحقق من سياسة كلمة المرور القوية (شاشة التسجيل وتعيين كلمة المرور)
  /// الشروط: ≥ 8 محارف + رقم واحد على الأقل + حرف كبير واحد على الأقل (Uppercase)
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تتكون من 8 محارف على الأقل';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9)';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z)';
    }
    return null;
  }

  /// التحقق من مطابقة تأكيد كلمة المرور
  /// الشروط: مطابقة تامة 100% مع كلمة المرور
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != originalPassword) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  /// التحقق من رمز التحقق OTP (شاشة تعيين كلمة المرور الجديدة)
  /// الشروط: مكون من 6 أرقام رقمية حصراً
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رمز التحقق OTP';
    }
    final trimmed = value.trim();
    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(trimmed)) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام حصراً';
    }
    return null;
  }
}
