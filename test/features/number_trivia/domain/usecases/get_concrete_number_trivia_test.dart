import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository, NetworkFailure])
void main() {
  late MockNumberTriviaRepository repository;
  late GetConcreteNumberTrivia useCase;
  late MockNetworkFailure networkFailure;

  setUp(() {
    repository = MockNumberTriviaRepository();
    networkFailure = MockNetworkFailure();
    useCase = GetConcreteNumberTrivia(repository: repository);
  });

  group("Get concrete number trivia", () {
    test("Should get trivia number from the repository", () async {
      final tNumber = 1;
      final numberTrivia = NumberTrivia(text: "text", number: tNumber);
      // arrange
      when(repository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));
      // act
      final result = await useCase(Params(number: tNumber));
      // assert
      expect(result, Right(numberTrivia));
      verify(repository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(repository);
    });

    test("Should get Failure from the repository", () async {
      final tNumber = 1;
      final numberTrivia = NumberTrivia(text: "text", number: tNumber);
      // arrange
      when(repository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left((networkFailure)));
      // act
      final result = await useCase(Params(number: tNumber));
      // assert
      expect(result, Left(networkFailure));
      verify(repository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(repository);
    });
  });
}
