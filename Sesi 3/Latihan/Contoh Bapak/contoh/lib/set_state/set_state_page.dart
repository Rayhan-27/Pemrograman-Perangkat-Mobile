import 'package:flutter/material.dart';

/// 0. setState: the starting point (no package needed).
///
/// The counter lives inside this one State object. To show it in another
/// widget we must pass the value (and callbacks) down by hand through
/// constructors. This gets painful as the app grows, which is the problem
/// Provider, Riverpod and BLoC solve.
class SetStatePage extends StatefulWidget { /// buat halaman bernama setStatePage yang merupakan StatefulWidget
  const SetStatePage({super.key});

  @override
  State<SetStatePage> createState() => _SetStatePageState();
}

class _SetStatePageState extends State<SetStatePage> {
  int _count = 0;

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('0. setState')),
      body: Center(
        // Value is passed down manually ("prop drilling").
        child: _CounterText(count: _count),
      ),
      floatingActionButton: _CounterButtons(
        onIncrement: _increment,
        onDecrement: _decrement,
        onReset: _reset,
      ),
    );
  }
}

class _CounterText extends StatelessWidget {
  const _CounterText({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('$count', style: Theme.of(context).textTheme.displayLarge);
  }
}

class _CounterButtons extends StatelessWidget {
  const _CounterButtons({
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: onReset,
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'dec',
          onPressed: onDecrement,
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'inc',
          onPressed: onIncrement,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}