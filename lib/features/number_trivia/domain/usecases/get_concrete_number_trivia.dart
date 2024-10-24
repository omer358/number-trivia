import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/errors/failure.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
