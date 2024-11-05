import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

abstract class NumberTriviaRemoteDatasource {
  /// call the https://numbersapi.com/{number} endpoint
  /// Throw a [ServerException] for all error calls
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// call the https://numbersapi.com/random endpoint
  /// Throw a [ServerException] for all error calls
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
