import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/timer_state.dart';
import 'counter_controller.dart';

class CounterScreenGetX extends StatelessWidget {
  const CounterScreenGetX({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection via GetX
    final CounterGetxController controller = Get.put(CounterGetxController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('نسخة GetX (GetxController & Obx)'),
        backgroundColor: Colors.deepPurple,
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
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'إدارة الحالة: GetX (متحكم تفاعلي مع Rx و Obx)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
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
                    // Reactive Counter Display using Obx
                    Obx(
                      () => Text(
                        '${controller.counter.value}',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.decrement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.remove),
                          label: const Text('إنقاص'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: controller.reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('تصفير'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: controller.increment,
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
                        // Reactive Timer Status Chip using Obx
                        Obx(() {
                          final status = controller.timerStatus.value;
                          Color chipColor;
                          switch (status) {
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
                          return Chip(
                            label: Text(
                              status.label,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: chipColor,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Obx(
                        () => Text(
                          'الوقت المنقضي: ${controller.secondsElapsed.value} ثانية',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Timer Controls
                    Obx(() {
                      final status = controller.timerStatus.value;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: status == TimerStatus.running
                                ? null
                                : controller.startTimer,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('بدء (Start)'),
                          ),
                          ElevatedButton.icon(
                            onPressed: status == TimerStatus.running
                                ? controller.pauseTimer
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.pause),
                            label: const Text('إيقاف مؤقت (Pause)'),
                          ),
                          ElevatedButton.icon(
                            onPressed: status == TimerStatus.paused
                                ? controller.resumeTimer
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.play_circle_filled),
                            label: const Text('استئناف (Resume)'),
                          ),
                          ElevatedButton.icon(
                            onPressed: status != TimerStatus.stopped
                                ? controller.stopTimer
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.stop),
                            label: const Text('إيقاف كامل (Stop)'),
                          ),
                        ],
                      );
                    }),
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
                            Icon(Icons.history, color: Colors.deepPurple),
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
                          onPressed: controller.clearLogs,
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
                      child: Obx(() {
                        if (controller.lifecycleLogs.isEmpty) {
                          return const Center(child: Text('لا توجد أحداث مسجلة بعد'));
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: controller.lifecycleLogs.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return Text(
                              controller.lifecycleLogs[index],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            );
                          },
                        );
                      }),
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
