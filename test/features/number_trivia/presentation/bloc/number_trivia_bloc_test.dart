import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/core/presentation/utils/utils.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';
import 'package:time_trivira/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia concreteNumberTrivia;
  late MockGetRandomNumberTrivia randomNumberTrivia;
  late MockInputConverter inputConverter;
  late NumberTriviaBloc numberTriviaBloc;

  setUp(() {
    concreteNumberTrivia = MockGetConcreteNumberTrivia();
    randomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        concreteNumberTrivia: concreteNumberTrivia,
        randomNumberTrivia: randomNumberTrivia,
        inputConverter: inputConverter);
  });

  group("GetTriviaForConcreteNumber", () {
    const String tNumberString = "1";
    const String tInvalidNumber = "g2";
    const int tNumberParsed = 1;
    const NumberTrivia tNumberTrivia =
        NumberTrivia(text: "Test Text", number: 1);
    test("initial state is NumberTriviaInitialTest", () {
      expect(numberTriviaBloc.state, equals(NumberTriviaInitial()));
    });
    blocTest(
        "Should emits [NumberTriviaLoading, NumberTriviaFetched] when GetConcreteTrivia is fetched successfully",
        build: () {
          when(concreteNumberTrivia(any)).thenAnswer(
            (_) async => const Right(
              (tNumberTrivia),
            ),
          );
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(const Right(tNumberParsed));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(const GetTriviaForConcreteNumberTrivia(
            numberString: tNumberString)),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFetched(numberTrivia: tNumberTrivia)
            ],
        verify: (numberTriviaBloc) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
          verify(concreteNumberTrivia(Params(number: 1)));
        });
    blocTest("""should emit [NumberTriviaLoading, 
        NumberTriviaFailed(INVALID_INPUT_NUMBER_MESSAGE)] 
        when InputConverter return a failure""",
        build: () {
          when(inputConverter.stringToUnsignedInteger(tInvalidNumber))
              .thenReturn(Left(InvalidInputFailure()));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(const GetTriviaForConcreteNumberTrivia(
            numberString: tInvalidNumber)),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFailed(message: INVALID_INPUT_NUMBER_MESSAGE)
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tInvalidNumber));
          verifyZeroInteractions(concreteNumberTrivia);
        });
    blocTest("""""should emit [NumberTriviaLoading, 
        NumberTriviaFailed()]
        when GetConcreteNumberTrivia return ServerFailure""",
        build: () {
          when(concreteNumberTrivia(Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(ServerFailure()));
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(const Right(tNumberParsed));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(const GetTriviaForConcreteNumberTrivia(
            numberString: tNumberString)),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFailed(message: SERVER_FAILURE_MESSAGE)
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
          verify(concreteNumberTrivia(Params(number: tNumberParsed)));
        });
    blocTest("""""should emit [NumberTriviaLoading, 
        NumberTriviaFailed()]
        when GetConcreteNumberTrivia return CacheFailure""",
        build: () {
          when(concreteNumberTrivia(Params(number: tNumberParsed)))
              .thenAnswer((_) async => Left(CacheFailure()));
          when(inputConverter.stringToUnsignedInteger(tNumberString))
              .thenReturn(const Right(tNumberParsed));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(const GetTriviaForConcreteNumberTrivia(
            numberString: tNumberString)),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFailed(message: CACHE_FAILURE_MESSAGE)
            ],
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(tNumberString));
          verify(concreteNumberTrivia(Params(number: tNumberParsed)));
        });

    tearDown(() {
      numberTriviaBloc.close();
    });
  });
  group("GetTriviaForRandomNumber", () {
    const NumberTrivia tNumberTrivia =
        NumberTrivia(text: "Test Text", number: 1);
    test("initial state is NumberTriviaInitialTest", () {
      expect(numberTriviaBloc.state, equals(NumberTriviaInitial()));
    });
    blocTest(
        "Should emits [NumberTriviaLoading, NumberTriviaFetched] when GetRandomTrivia is fetched successfully",
        build: () {
          when(randomNumberTrivia(NoParams())).thenAnswer(
            (_) async => const Right(
              (tNumberTrivia),
            ),
          );
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(GetTriviaForRandomNumberTrivia()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFetched(numberTrivia: tNumberTrivia)
            ],
        verify: (numberTriviaBloc) {
          verify(randomNumberTrivia(NoParams()));
        });
    blocTest("""""should emit [NumberTriviaLoading, 
        NumberTriviaFailed()]
        when GetRandomNumberTrivia return ServerFailure""",
        build: () {
          when(randomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(GetTriviaForRandomNumberTrivia()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFailed(message: SERVER_FAILURE_MESSAGE)
            ],
        verify: (_) {
          verify(randomNumberTrivia(NoParams()));
        });
    blocTest("""""should emit [NumberTriviaLoading, 
        NumberTriviaFailed()]
        when GetRandomNumberTrivia return CacheFailure""",
        build: () {
          when(randomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
          return numberTriviaBloc;
        },
        act: (bloc) => bloc.add(GetTriviaForRandomNumberTrivia()),
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaFailed(message: CACHE_FAILURE_MESSAGE)
            ],
        verify: (_) {
          verify(randomNumberTrivia(NoParams()));
        });

    tearDown(() {
      numberTriviaBloc.close();
    });
  });
}
