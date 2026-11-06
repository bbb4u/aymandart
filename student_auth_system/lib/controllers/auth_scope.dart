import 'package:flutter/material.dart';
import 'auth_controller.dart';

/// نطاق حقن المتحكم في شجرة الواجهات عبر معايير فلاتر الخالصة (InheritedNotifier)
/// يتيح الوصول للمتحكم وإعادة بناء الواجهة تلقائياً دون أي مكتبات خارجية مثل Provider أو GetX
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  /// دالة الوصول السريع للمتحكم والاستماع لتغييرات الحالة
  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'لم يتم العثور على AuthScope في شجرة الواجهات');
    return scope!.notifier!;
  }
}
