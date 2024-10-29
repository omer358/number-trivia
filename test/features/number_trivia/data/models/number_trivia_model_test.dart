import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_trivira/features/number_trivia/data/models/models.dart';
import 'package:time_trivira/features/number_trivia/domain/entities/entities.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("Should be subclass of NumberTrivia entity", () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("Should return a valid model when the JSON number is an integer", () {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
    test(
        "Should return a valid model when the JSON number is regarded as a double",
        () {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture("trivia_double.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test("Should return a JSON map containing the proper data", () {
      // act
      final result = tNumberTriviaModel.toJson();

      // expect
      final expectedMap = {"text": "Test Text", "number": 1};
      expect(result, expectedMap);
    });
  });
}
