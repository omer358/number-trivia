import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';
import 'package:time_trivira/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:time_trivira/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/core.dart';

typedef ConcreteOrRandomChooser = Future<NumberTriviaModel>;

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      ConcreteOrRandomChooser Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        var remoteNumberTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteNumberTrivia);
        return Right(remoteNumberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        var localNumberTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localNumberTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
