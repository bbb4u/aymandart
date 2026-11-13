import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'getx_version/counter_screen_getx.dart';
import 'riverpod_version/counter_screen_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // تغليف التطبيق بـ ProviderScope لدعم Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام GetMaterialApp لدعم تنقل وإدارة GetX
    return GetMaterialApp(
      title: 'تكليف إدارة الحالة - GetX vs Riverpod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('واجب الأسبوع 3: إدارة الحالة'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'تطبيق العداد والتحكم بالمؤقت ودورة الحياة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'اختر إحدى النسختين المتطابقتين لمعاينة تنفيذ إدارة الحالة:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Card 1: GetX
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.deepPurple.shade300, width: 1.5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.to(() => const CounterScreenGetX());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.bolt, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. نسخة GetX',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• GetxController مع المتغيرات التفاعلية (.obs)\n'
                        '• بناء الواجهة التفاعلي عبر Obx()\n'
                        '• تتبع دورة الحياة: onInit, onReady, onClose\n'
                        '• التحكم الكامل بالمؤقت والعداد',
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => const CounterScreenGetX());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('فتح نسخة GetX'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card 2: Riverpod 2.x
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.shade300, width: 1.5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Get.to(() => const CounterScreenRiverpod());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.waves, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '2. نسخة Modern Riverpod 2.x',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Notifier و NotifierProvider الحديث (v2.x)\n'
                        '• استهلاك الحالة عبر Consumer / ref.watch\n'
                        '• تتبع دورة الحياة: ref.onDispose و WidgetsBinding\n'
                        '• حالة غير قابلة للتغيير (Immutable State & copyWith)',
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => const CounterScreenRiverpod());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('فتح نسخة Riverpod'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
