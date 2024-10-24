import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/errors/failure.dart';
import 'package:time_trivira/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
