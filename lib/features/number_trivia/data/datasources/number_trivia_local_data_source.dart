import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

import '../../../../core/core.dart';

abstract class NumberTriviaLocalDataSource {
  /// Get the cached [NumberTriviaModel] which as gotten the last time
  /// the user had an internet connection.
  ///
  /// Throw [CacheException] if no cache is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) async {
    final jsonString = jsonEncode(numberTrivia.toJson());
    await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    String? jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString!)));
    }
    throw CacheException();
  }
}
