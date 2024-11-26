import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/core/presentation/presentation.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.concreteNumberTrivia,
      required this.randomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumberTrivia>(_getConcreteTriviaHandler);
    on<GetTriviaForRandomNumberTrivia>(_getRandomTriviaHandler);
  }

  @override
  void onChange(Change<NumberTriviaState> change) {
    print('State changed: $change');
  }

  @override
  void onEvent(NumberTriviaEvent event) {
    print('Event triggered: $event');
  }

  Future<void> _getConcreteTriviaHandler(GetTriviaForConcreteNumberTrivia event,
      Emitter<NumberTriviaState> emit) async {
    emit(NumberTriviaLoading());

    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    if (inputEither.isLeft()) {
      emit(const NumberTriviaFailed(message: INVALID_INPUT_NUMBER_MESSAGE));
      return;
    }

    final number = inputEither.getOrElse(() => 0); // Extract the number safely
    final result = await concreteNumberTrivia(Params(number: number));

    result.fold(
      (failure) => _handleFailure(failure, emit),
      (trivia) => _handleSuccess(trivia, emit),
    );
  }

  void _getRandomTriviaHandler(GetTriviaForRandomNumberTrivia event,
      Emitter<NumberTriviaState> emit) async {
    emit(NumberTriviaLoading());
    final result = await randomNumberTrivia(NoParams());
    result.fold((failure) {
      _handleFailure(failure, emit);
    }, (numberTrivia) {
      emit(NumberTriviaFetched(numberTrivia: numberTrivia));
    });
  }

  void _handleFailure(Failure failure, Emitter<NumberTriviaState> emit) {
    if (failure is ServerFailure) {
      emit(const NumberTriviaFailed(message: SERVER_FAILURE_MESSAGE));
    } else {
      emit(const NumberTriviaFailed(message: CACHE_FAILURE_MESSAGE));
    }
  }

  void _handleSuccess(NumberTrivia trivia, Emitter<NumberTriviaState> emit) {
    emit(NumberTriviaFetched(numberTrivia: trivia));
  }
}
