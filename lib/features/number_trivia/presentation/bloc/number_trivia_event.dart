part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumberTrivia extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumberTrivia({required this.numberString});

  @override
  List<Object?> get props => [numberString];
}

class GetTriviaForRandomNumberTrivia extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
