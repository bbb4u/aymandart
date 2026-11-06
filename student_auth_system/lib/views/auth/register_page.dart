import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_scope.dart';
import '../../utils/form_validators.dart';

/// 2. شاشة إنشاء الحساب (RegisterPage)
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(AuthController controller) async {
    // التحقق من حالة صندوق الشروط الأكاديمية
    if (!controller.acceptTerms) {
      setState(() {
        _termsError = true;
      });
    } else {
      setState(() {
        _termsError = false;
      });
    }

    // فحص صلاحية النموذج
    if (!_formKey.currentState!.validate() || !controller.acceptTerms) {
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await controller.register(
      fullName: _fullNameController.text,
      academicId: _academicIdController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // إشعار بالنجاح والعودة لشاشة الدخول
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إنشاء الحساب الأكاديمي بنجاح! يمكنك الآن تسجيل الدخول.'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'فشل إنشاء الحساب'),
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
        title: const Text('تسجيل حساب طالب جديد'),
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
                    'بيانات التسجيل الأكاديمي',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'يرجى إدخال البيانات المعتمدة في عمادة القبول والتسجيل',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // 1. حقل الاسم الكامل (≥ 3 محارف)
                  TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل للطالب',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateFullName,
                  ),
                  const SizedBox(height: 16),

                  // 2. حقل الرقم الأكاديمي (أرقام حصراً، 9-10 خانات)
                  TextFormField(
                    controller: _academicIdController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'الرقم الأكاديمي الجامعي (9-10 أرقام)',
                      hintText: '441001234',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateAcademicId,
                  ),
                  const SizedBox(height: 16),

                  // 3. حقل البريد الجامعي (صيغة Regex قياسية)
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني الجامعي',
                      hintText: 'student@edu.sa',
                      prefixIcon: const Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: FormValidators.validateUniversityEmail,
                  ),
                  const SizedBox(height: 16),

                  // 4. حقل كلمة المرور (≥ 8 محارف + رقم + حرف كبير)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
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
                  const SizedBox(height: 16),

                  // 5. حقل تأكيد كلمة المرور (مطابقة تامة 100%)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
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
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 6. صندوق الموافقة على اللوائح والشروط الأكاديمية (إلزامي للتقديم)
                  Container(
                    decoration: BoxDecoration(
                      color: _termsError ? Colors.red.shade50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: _termsError
                          ? Border.all(color: Colors.red.shade300)
                          : null,
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: controller.acceptTerms,
                      activeColor: const Color(0xFF1E3A8A),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'أوافق وأتعهد بالالتزام باللوائح والأنظمة والشروط الأكاديمية الجامعية',
                        style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
                      ),
                      subtitle: _termsError
                          ? const Text(
                              'الموافقة على الشروط الأكاديمية إلزامية للتسجيل',
                              style: TextStyle(color: Colors.red, fontSize: 11),
                            )
                          : null,
                      onChanged: (val) {
                        controller.setAcceptTerms(val ?? false);
                        if (val == true && _termsError) {
                          setState(() {
                            _termsError = false;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر إنشاء الحساب
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
                          : () => _handleRegister(controller),
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
                              'إنشاء الحساب الأكاديمي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // العودة لتسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('تسجيل الدخول'),
                      ),
                    ],
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
