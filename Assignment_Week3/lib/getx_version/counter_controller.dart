import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/timer_state.dart';

class CounterGetxController extends GetxController with WidgetsBindingObserver {
  // --- Reactive States (Rx) ---
  final RxInt counter = 0.obs;
  final Rx<TimerStatus> timerStatus = TimerStatus.stopped.obs;
  final RxInt secondsElapsed = 0.obs;
  final RxList<String> lifecycleLogs = <String>[].obs;

  Timer? _timer;

  // --- Helper to log lifecycle events ---
  void _addLog(String event) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final logEntry = '[$timestamp] $event';
    lifecycleLogs.insert(0, logEntry);
    debugPrint(logEntry);
  }

  // --- Controller Lifecycle Hooks ---
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _addLog('[GetX Lifecycle] onInit: تم تهيئة المتحكم (Controller Initialized)');
  }

  @override
  void onReady() {
    super.onReady();
    _addLog('[GetX Lifecycle] onReady: واجهة المستخدم جاهزة للعرض (Widget Ready)');
  }

  @override
  void onClose() {
    _addLog('[GetX Lifecycle] onClose: إتلاف المتحكم وإيقاف المؤقت (Disposed)');
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // --- App Lifecycle Observer ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _addLog('[App Lifecycle] تغيرت حالة التطبيق إلى: ${state.name}');
    if (state == AppLifecycleState.paused && timerStatus.value == TimerStatus.running) {
      pauseTimer();
      _addLog('[App Lifecycle Auto] تم إيقاف المؤقت تلقائياً عند الانتقال للخلفية');
    }
  }

  // --- Counter Controls ---
  void increment() {
    counter.value++;
    _addLog('زيادة العداد: ${counter.value}');
  }

  void decrement() {
    if (counter.value > 0) {
      counter.value--;
      _addLog('إنقاص العداد: ${counter.value}');
    }
  }

  void reset() {
    counter.value = 0;
    _addLog('تصفير العداد إلى 0');
  }

  // --- Timer Controls ---
  void startTimer() {
    if (_timer != null) _timer!.cancel();

    timerStatus.value = TimerStatus.running;
    _addLog('[Timer] بدء المؤقت التلقائي (Start)');

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsElapsed.value++;
      counter.value++;
    });
  }

  void pauseTimer() {
    if (timerStatus.value == TimerStatus.running) {
      _timer?.cancel();
      timerStatus.value = TimerStatus.paused;
      _addLog('[Timer] إيقاف مؤقت (Paused)');
    }
  }

  void resumeTimer() {
    if (timerStatus.value == TimerStatus.paused) {
      timerStatus.value = TimerStatus.running;
      _addLog('[Timer] استئناف المؤقت (Resumed)');
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        secondsElapsed.value++;
        counter.value++;
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    timerStatus.value = TimerStatus.stopped;
    secondsElapsed.value = 0;
    _addLog('[Timer] إيقاف كلي وإعادة ضبط المؤقت (Stopped & Reset)');
  }

  void clearLogs() {
    lifecycleLogs.clear();
  }
}
