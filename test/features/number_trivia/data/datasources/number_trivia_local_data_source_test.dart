import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockedSharedPreferences;
  late NumberTriviaLocalDataSourceImpl localDatasourceImpl;

  setUp(() {
    mockedSharedPreferences = MockSharedPreferences();
    localDatasourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockedSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia_cached.json")));
    test(
        "Should return a NumberTrivia from the sharedPreferences when there is a one in the cache",
        () async {
      // arrange
      when(mockedSharedPreferences.getString(any))
          .thenReturn(fixture("trivia_cached.json"));
      //act
      final result = await localDatasourceImpl.getLastNumberTrivia();
      //assert
      verify(mockedSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test("Should throw an CacheException when there is no a cached value",
        () async {
      // arrange
      when(mockedSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = localDatasourceImpl.getLastNumberTrivia;
      //assert
      // verify(mockedSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 1);
    test("should call SharedPreferences to cache the data", () async {
      // arrange
      when(mockedSharedPreferences.setString(CACHED_NUMBER_TRIVIA, any))
          .thenAnswer((_) async => true);
      // act
      await localDatasourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockedSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedString));
    });
  });
}
