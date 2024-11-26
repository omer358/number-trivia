import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:time_trivira/core/errors/failure.dart';
import 'package:time_trivira/core/usecases/usecases.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';

class GetConcreteNumberTrivia implements UseCases<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({required this.number});

  @override
  List<Object?> get props => [number];
}
