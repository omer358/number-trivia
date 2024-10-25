import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/core/usecases/usecases.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';
import 'package:time_trivira/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository, NetworkFailure])
void main() {
  late MockNumberTriviaRepository repository;
  late GetRandomNumberTrivia useCase;
  late MockNetworkFailure networkFailure;

  setUp(() {
    repository = MockNumberTriviaRepository();
    networkFailure = MockNetworkFailure();
    useCase = GetRandomNumberTrivia(repository: repository);
  });

  group("Get random number trivia", () {
    test("Should get trivia from the repository", () async {
      const numberTrivia = NumberTrivia(text: "text", number: 1);
      // arrange
      when(repository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(numberTrivia));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Right(numberTrivia));
      verify(repository.getRandomNumberTrivia());
      verifyNoMoreInteractions(repository);
    });

    test("Should get Failure from the repository", () async {
      const numberTrivia = NumberTrivia(text: "text", number: 1);
      // arrange
      when(repository.getRandomNumberTrivia())
          .thenAnswer((_) async => Left((networkFailure)));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Left(networkFailure));
      verify(repository.getRandomNumberTrivia());
      verifyNoMoreInteractions(repository);
    });
  });
}
