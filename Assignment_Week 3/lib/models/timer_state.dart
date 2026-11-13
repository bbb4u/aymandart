enum TimerStatus {
  stopped,
  running,
  paused,
}

extension TimerStatusExtension on TimerStatus {
  String get label {
    switch (this) {
      case TimerStatus.stopped:
        return 'متوقف (Stopped)';
      case TimerStatus.running:
        return 'يعمل (Running)';
      case TimerStatus.paused:
        return 'مؤقت (Paused)';
    }
  }
}
