import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_model.dart';

/// 1. Provider
///
/// ChangeNotifierProvider puts one CounterModel into the widget tree.
/// Any widget below it can reach it with `context`, so no parameters
/// need to be passed down.
class ProviderPage extends StatelessWidget {
  const ProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('1. Provider')),
        body: const Center(child: _CounterText()),
        floatingActionButton: const _CounterButtons(),
      ),
    );
  }
}

class _CounterText extends StatelessWidget {
  const _CounterText();

  @override
  Widget build(BuildContext context) {
    // watch = read the value AND rebuild when it changes.
    final count = context.watch<CounterModel>().count;
    return Text('$count', style: Theme.of(context).textTheme.displayLarge);
  }
}

class _CounterButtons extends StatelessWidget {
  const _CounterButtons();

  @override
  Widget build(BuildContext context) {
    // read = get the object once, without rebuilding. Use it for actions.
    final counter = context.read<CounterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: counter.reset,
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'dec',
          onPressed: counter.decrement,
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'inc',
          onPressed: counter.increment,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}