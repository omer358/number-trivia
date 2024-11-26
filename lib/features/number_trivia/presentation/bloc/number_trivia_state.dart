part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

final class NumberTriviaLoading extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

final class NumberTriviaFetched extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const NumberTriviaFetched({required this.numberTrivia});

  @override
  List<Object?> get props => [numberTrivia];
}

final class NumberTriviaFailed extends NumberTriviaState {
  final String message;

  const NumberTriviaFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
