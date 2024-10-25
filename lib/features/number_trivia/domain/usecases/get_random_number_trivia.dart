import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/errors/failure.dart';
import 'package:time_trivira/core/usecases/usecases.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';

class GetRandomNumberTrivia implements UseCases<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
