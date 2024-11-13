import 'dart:convert';

import 'package:http/http.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

abstract class NumberTriviaRemoteDataSource {
  /// call the https://numbersapi.com/{number} endpoint
  /// Throw a [ServerException] for all error calls
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// call the https://numbersapi.com/random endpoint
  /// Throw a [ServerException] for all error calls
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getConcreteOrRandom("https://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getConcreteOrRandom("https://numbersapi.com/random");
  }

  Future<NumberTriviaModel> _getConcreteOrRandom(String url) async {
    final result = await client.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (result.statusCode == 200) {
      final NumberTriviaModel numberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(result.body));
      return numberTriviaModel;
    } else {
      throw ServerException();
    }
  }
}
