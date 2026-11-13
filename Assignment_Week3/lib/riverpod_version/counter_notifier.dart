import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';
import 'counter_state.dart';

class CounterNotifier extends Notifier<CounterState> {
  Timer? _timer;

  @override
  CounterState build() {
    // دورة حياة Riverpod الحديثة 2.x عبر ref.onDispose
    ref.onDispose(() {
      _timer?.cancel();
      debugPrint('[Riverpod Lifecycle] ref.onDispose: تم إلغاء المؤقت وتنظيف الذاكرة');
    });

    final now = DateTime.now().toIso8601String().substring(11, 19);
    return CounterState(
      counter: 0,
      timerStatus: TimerStatus.stopped,
      secondsElapsed: 0,
      lifecycleLogs: [
        '[$now] [Riverpod Lifecycle] build(): تم بناء المزوّد Notifier وتهيئة الحالة'
      ],
    );
  }

  void _addLog(String event) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final logEntry = '[$timestamp] $event';
    debugPrint(logEntry);
    state = state.copyWith(
      lifecycleLogs: [logEntry, ...state.lifecycleLogs],
    );
  }

  void addLifecycleLog(String event) {
    _addLog(event);
  }

  void increment() {
    state = state.copyWith(counter: state.counter + 1);
    _addLog('زيادة العداد: ${state.counter}');
  }

  void decrement() {
    if (state.counter > 0) {
      state = state.copyWith(counter: state.counter - 1);
      _addLog('إنقاص العداد: ${state.counter}');
    }
  }

  void reset() {
    state = state.copyWith(counter: 0);
    _addLog('تصفير العداد إلى 0');
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(timerStatus: TimerStatus.running);
    _addLog('[Timer] بدء المؤقت التلقائي (Start)');

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        secondsElapsed: state.secondsElapsed + 1,
        counter: state.counter + 1,
      );
    });
  }

  void pauseTimer() {
    if (state.timerStatus == TimerStatus.running) {
      _timer?.cancel();
      state = state.copyWith(timerStatus: TimerStatus.paused);
      _addLog('[Timer] إيقاف مؤقت (Paused)');
    }
  }

  void resumeTimer() {
    if (state.timerStatus == TimerStatus.paused) {
      state = state.copyWith(timerStatus: TimerStatus.running);
      _addLog('[Timer] استئناف المؤقت (Resumed)');
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(
          secondsElapsed: state.secondsElapsed + 1,
          counter: state.counter + 1,
        );
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(
      timerStatus: TimerStatus.stopped,
      secondsElapsed: 0,
    );
    _addLog('[Timer] إيقاف كلي وإعادة ضبط المؤقت (Stopped & Reset)');
  }

  void clearLogs() {
    state = state.copyWith(lifecycleLogs: []);
  }
}

// مزوّد Riverpod الحديث من نوع NotifierProvider
final counterProvider = NotifierProvider<CounterNotifier, CounterState>(() {
  return CounterNotifier();
});
