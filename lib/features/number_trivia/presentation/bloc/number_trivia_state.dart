part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}
