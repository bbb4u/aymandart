import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';
import 'counter_notifier.dart';

class CounterScreenRiverpod extends ConsumerStatefulWidget {
  const CounterScreenRiverpod({super.key});

  @override
  ConsumerState<CounterScreenRiverpod> createState() => _CounterScreenRiverpodState();
}

class _CounterScreenRiverpodState extends ConsumerState<CounterScreenRiverpod>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(counterProvider.notifier).addLifecycleLog(
        '[Widget Lifecycle] initState: تم تحميل شاشة Riverpod بنجاح',
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    ref.read(counterProvider.notifier).addLifecycleLog(
      '[App Lifecycle] تغيرت حالة التطبيق إلى: ${appState.name}',
    );

    final timerStatus = ref.read(counterProvider).timerStatus;
    if (appState == AppLifecycleState.paused && timerStatus == TimerStatus.running) {
      ref.read(counterProvider.notifier).pauseTimer();
      ref.read(counterProvider.notifier).addLifecycleLog(
        '[App Lifecycle Auto] تم إيقاف المؤقت تلقائياً عند الانتقال للخلفية',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة الحالة باستخدام ref.watch
    final counterState = ref.watch(counterProvider);
    final notifier = ref.read(counterProvider.notifier);

    Color chipColor;
    switch (counterState.timerStatus) {
      case TimerStatus.running:
        chipColor = Colors.green;
        break;
      case TimerStatus.paused:
        chipColor = Colors.orange;
        break;
      case TimerStatus.stopped:
        chipColor = Colors.grey;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('نسخة Riverpod 2.x (Notifier & Consumer)'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.waves, color: Colors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'إدارة الحالة: Modern Riverpod 2.x (NotifierProvider & Consumer)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Counter Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'قيمة العداد الحالية',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    // Reactive Counter Display via ref.watch
                    Text(
                      '${counterState.counter}',
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: notifier.decrement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.remove),
                          label: const Text('إنقاص'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: notifier.reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('تصفير'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: notifier.increment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('زيادة'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timer Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'المؤقت التلقائي (Auto Timer)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Chip(
                          label: Text(
                            counterState.timerStatus.label,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: chipColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'الوقت المنقضي: ${counterState.secondsElapsed} ثانية',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Timer Controls
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: counterState.timerStatus == TimerStatus.running
                              ? null
                              : notifier.startTimer,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('بدء (Start)'),
                        ),
                        ElevatedButton.icon(
                          onPressed: counterState.timerStatus == TimerStatus.running
                              ? notifier.pauseTimer
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.pause),
                          label: const Text('إيقاف مؤقت (Pause)'),
                        ),
                        ElevatedButton.icon(
                          onPressed: counterState.timerStatus == TimerStatus.paused
                              ? notifier.resumeTimer
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.play_circle_filled),
                          label: const Text('استئناف (Resume)'),
                        ),
                        ElevatedButton.icon(
                          onPressed: counterState.timerStatus != TimerStatus.stopped
                              ? notifier.stopTimer
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.stop),
                          label: const Text('إيقاف كامل (Stop)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lifecycle Logs Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.history, color: Colors.teal),
                            SizedBox(width: 8),
                            Text(
                              'سجل تحليل دورة الحياة (Lifecycle Analysis)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'مسح السجل',
                          onPressed: notifier.clearLogs,
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: counterState.lifecycleLogs.isEmpty
                          ? const Center(child: Text('لا توجد أحداث مسجلة بعد'))
                          : ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: counterState.lifecycleLogs.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                return Text(
                                  counterState.lifecycleLogs[index],
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
