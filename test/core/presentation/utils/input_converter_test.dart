import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_trivira/core/presentation/presentation.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test(
        "should return an integer when the string represent an unsigned integer",
        () {
      // arrange
      const String str = "123";
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });

    test("should return a Failure when the string is not a integer", () {
      // arrange
      const String actualString = "lk2";
      //act
      final result = inputConverter.stringToUnsignedInteger(actualString);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test("should return a Failure when the string is a negative integer", () {
      // arrange
      const String actualString = "-2";
      //act
      final result = inputConverter.stringToUnsignedInteger(actualString);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
