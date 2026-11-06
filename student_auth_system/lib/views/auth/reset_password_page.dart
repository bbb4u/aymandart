import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_scope.dart';
import '../../utils/form_validators.dart';

/// 4. شاشة تعيين كلمة المرور الجديدة (ResetPasswordPage)
class ResetPasswordPage extends StatefulWidget {
  final String identifier;

  const ResetPasswordPage({
    super.key,
    required this.identifier,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController(text: '123456');
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword(AuthController controller) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await controller.resetPassword(
      identifier: widget.identifier,
      otpCode: _otpController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      // عرض نافذة تأكيد نجاح التحديث والتوجيه لشاشة الدخول
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 56,
          ),
          title: const Text(
            'تم تحديث كلمة المرور بنجاح!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'تم تعيين كلمة المرور الأكاديمية الجديدة الخاصة بك بنجاح. يمكنك الآن تسجيل الدخول مباشرة.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // إغلاق الحوار
                // العودة لشاشة تسجيل الدخول وتفريغ المكدس
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('التوجه لشاشة الدخول'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'فشل تحديث كلمة المرور'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AuthScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('تعيين كلمة المرور الجديدة'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'إعادة ضبط كلمة المرور',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'تم إرسال رمز التحقق إلى: ${widget.identifier}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 1. حقل رمز التحقق (OTP): مكون من 6 أرقام رقمية حصراً
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      letterSpacing: 8,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: 'رمز التحقق (OTP - 6 أرقام)',
                      hintText: '123456',
                      prefixIcon: const Icon(Icons.pin_outlined),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateOtp,
                  ),
                  const SizedBox(height: 18),

                  // 2. حقل كلمة المرور الجديدة (مطابقة سياسة الأمان)
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      helperText: '8 محارف على الأقل، تتضمن رقماً وحرفاً كبيراً (A-Z)',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateStrongPassword,
                  ),
                  const SizedBox(height: 18),

                  // 3. حقل تأكيد كلمة المرور الجديدة (مطابقة الحقل السابق)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور الجديدة',
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) => FormValidators.validateConfirmPassword(
                      val,
                      _newPasswordController.text,
                    ),
                    onFieldSubmitted: (_) => _handleResetPassword(controller),
                  ),
                  const SizedBox(height: 28),

                  // 4. زر "تحديث كلمة المرور"
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: controller.isLoading
                          ? null
                          : () => _handleResetPassword(controller),
                      child: controller.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'تحديث كلمة المرور',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
