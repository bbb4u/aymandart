import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_scope.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

/// 3. شاشة استعادة كلمة المرور (ForgotPasswordPage)
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: '441001234');

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode(AuthController controller) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final identifier = _identifierController.text.trim();
    final success = await controller.sendPasswordResetCode(identifier);

    if (!mounted) return;

    if (success) {
      // إظهار SnackBar أخضر
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم إرسال رمز التحقق بنجاح إلى وسيلة الاتصال المسجلة (الرمز التجريبي: 123456)',
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

      // الانتقال التلقائي لشاشة تعيين كلمة المرور
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(identifier: identifier),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'تعذر إرسال رمز التحقق'),
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
        title: const Text('استعادة الحساب الأكاديمي'),
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
                  // بطاقة توجيهية أعلى الشاشة توضح آلية إرسال رمز التحقق
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF), // Blue tint
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            color: Color(0xFF1D4ED8),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'آلية استعادة كلمة المرور',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'أدخل الرقم الأكاديمي أو البريد الجامعي المعتمد، وسيتم إرسال رمز تحقق مؤلف من 6 أرقام (OTP) للتحقق من هويتك الأكاديمية.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // حقل البريد أو الرقم الأكاديمي مع التحقق
                  TextFormField(
                    controller: _identifierController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'الرقم الأكاديمي أو البريد الجامعي',
                      hintText: 'مثال: 441001234 أو student@edu.sa',
                      prefixIcon: const Icon(Icons.account_box_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateIdentifier,
                    onFieldSubmitted: (_) => _handleSendResetCode(controller),
                  ),
                  const SizedBox(height: 24),

                  // زر "إرسال رمز التحقق"
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
                          : () => _handleSendResetCode(controller),
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
                              'إرسال رمز التحقق',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر العودة لتسجيل الدخول
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('العودة لتسجيل الدخول'),
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
