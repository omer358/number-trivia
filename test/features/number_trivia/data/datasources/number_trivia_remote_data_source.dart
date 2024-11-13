import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient mockedHttpClient;
  setUp(() {
    mockedHttpClient = MockClient();
    remoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockedHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockedHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setupMockHttpClientFailure404() {
    when(mockedHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response("something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));
    test('''should perform a GET request on a
         URL with number being the endpoint
          and with application/json header''', () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockedHttpClient.get(
          Uri.parse("https://numbersapi.com/$tNumber"),
          headers: {"Content-Type": "application/json"},
        ),
      );
    });

    test("should return NumberTrivia when the response code is 200", () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      final result =
          await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test(
        "should return a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setupMockHttpClientFailure404();
      //act
      final call = await remoteDataSourceImpl.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group("getRandomConcreteNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));
    test('''should perform a GET request on a
         URL with a random number endpoint
          and with application/json header''', () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      await remoteDataSourceImpl.getRandomNumberTrivia();
      // assert
      verify(
        mockedHttpClient.get(
          Uri.parse("https://numbersapi.com/random"),
          headers: {"Content-Type": "application/json"},
        ),
      );
    });

    test("should return NumberTrivia when the response code is 200", () async {
      // arrange
      setupMockHttpClientSuccess200();
      //act
      final result = await remoteDataSourceImpl.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test(
        "should return a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setupMockHttpClientFailure404();
      //act
      final call = remoteDataSourceImpl.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
