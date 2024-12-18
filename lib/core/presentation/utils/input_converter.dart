import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/core.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) {
        throw const FormatException();
      }
      return Right(result);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
