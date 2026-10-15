import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'counter_notifier.dart';

/// 2. Riverpod
///
/// No provider widget is needed here; ProviderScope in main.dart already
/// holds everything. Widgets use `ref` (from ConsumerWidget) instead of
/// `context` to access state.
class RiverpodPage extends StatelessWidget {
  const RiverpodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2. Riverpod')),
      body: const Center(child: _CounterText()),
      floatingActionButton: const _CounterButtons(),
    );
  }
}

class _CounterText extends ConsumerWidget {
  const _CounterText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch = read the value AND rebuild when it changes.
    final count = ref.watch(counterProvider);
    return Text('$count', style: Theme.of(context).textTheme.displayLarge);
  }
}

class _CounterButtons extends ConsumerWidget {
  const _CounterButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // .notifier gives the CounterNotifier object, so we can call its methods.
    final counter = ref.read(counterProvider.notifier);
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