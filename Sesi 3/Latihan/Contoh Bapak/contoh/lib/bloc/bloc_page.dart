import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_bloc.dart';

/// 3. BLoC
///
/// BlocProvider puts one CounterBloc into the widget tree (like Provider)
/// and closes it automatically when this page is removed.
class BlocPage extends StatelessWidget {
  const BlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('3. BLoC')),
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
    // BlocBuilder rebuilds only this part whenever a new state is emitted.
    return BlocBuilder<CounterBloc, int>(
      builder: (context, count) =>
          Text('$count', style: Theme.of(context).textTheme.displayLarge),
    );
  }
}

class _CounterButtons extends StatelessWidget {
  const _CounterButtons();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();
    // Buttons don't call methods; they add EVENTS.
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: () => bloc.add(CounterReset()),
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'dec',
          onPressed: () => bloc.add(CounterDecremented()),
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'inc',
          onPressed: () => bloc.add(CounterIncremented()),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}