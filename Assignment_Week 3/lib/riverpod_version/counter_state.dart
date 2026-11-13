import '../models/timer_state.dart';

class CounterState {
  final int counter;
  final TimerStatus timerStatus;
  final int secondsElapsed;
  final List<String> lifecycleLogs;

  const CounterState({
    required this.counter,
    required this.timerStatus,
    required this.secondsElapsed,
    required this.lifecycleLogs,
  });

  CounterState copyWith({
    int? counter,
    TimerStatus? timerStatus,
    int? secondsElapsed,
    List<String>? lifecycleLogs,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      timerStatus: timerStatus ?? this.timerStatus,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
      lifecycleLogs: lifecycleLogs ?? this.lifecycleLogs,
    );
  }
}
