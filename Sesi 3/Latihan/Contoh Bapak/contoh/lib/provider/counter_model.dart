import 'package:flutter/foundation.dart';

/// 1. Provider: the state is a class that extends ChangeNotifier.
///
/// Change the field, then call notifyListeners() so the UI rebuilds.
/// Forget notifyListeners() and nothing updates on screen.
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}