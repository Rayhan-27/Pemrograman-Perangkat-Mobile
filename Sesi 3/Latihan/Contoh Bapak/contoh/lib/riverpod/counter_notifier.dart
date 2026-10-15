import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 2. Riverpod: the state logic is a Notifier.
///
/// build() returns the initial state. Assigning a new value to `state`
/// rebuilds the UI automatically (no notifyListeners()).
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

/// A global variable, but safe: the actual value is stored in ProviderScope
/// (see main.dart), not in this variable.
///
/// Note: because it is global, the count is KEPT when you leave the page
/// and come back. Use NotifierProvider.autoDispose to reset it instead.
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);