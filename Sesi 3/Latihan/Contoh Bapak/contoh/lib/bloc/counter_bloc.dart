import 'package:flutter_bloc/flutter_bloc.dart';

/// 3. BLoC: the UI never changes state directly.
///
///   UI --(event)--> Bloc --(new state)--> UI
///
/// Events describe WHAT happened. The Bloc decides HOW the state changes.

// Events
sealed class CounterEvent {}

class CounterIncremented extends CounterEvent {}

class CounterDecremented extends CounterEvent {}

class CounterReset extends CounterEvent {}

// Bloc<Event type, State type>. The state here is just an int.
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncremented>((event, emit) => emit(state + 1));
    on<CounterDecremented>((event, emit) => emit(state - 1));
    on<CounterReset>((event, emit) => emit(0));
  }
}