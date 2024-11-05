import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

abstract class NumberTriviaLocalDatasource {
  /// Get the cached [NumberTriviaModel] which as gotten the last time
  /// the user had an internet connection.
  ///
  /// Throw [CacheException] if no cache is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}
