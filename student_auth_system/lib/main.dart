import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'controllers/auth_scope.dart';
import 'views/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentAuthApp());
}

/// تطبيق نظام المصادقة الطلابي المتكامل
/// مبني بنمط MVC + Repository Pattern الخالص دون أي مكتبات خارجية
class StudentAuthApp extends StatefulWidget {
  const StudentAuthApp({super.key});

  @override
  State<StudentAuthApp> createState() => _StudentAuthAppState();
}

class _StudentAuthAppState extends State<StudentAuthApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    // تهيئة المتحكم
    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _authController,
      child: MaterialApp(
        title: 'نظام المصادقة الطلابي',
        debugShowCheckedModeBanner: false,
        // دعم اتجاه اليمين لليسار (RTL) للغة العربية بالكامل وبشكل قياسي
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Segoe UI', // خط نظام قياسي أنيق
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A), // أزرق أكاديمي ملكي
            primary: const Color(0xFF1E3A8A),
            secondary: const Color(0xFF0D9488),
            surface: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
