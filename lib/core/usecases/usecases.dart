import 'package:dartz/dartz.dart';
import 'package:time_trivira/core/core.dart';

abstract class UseCases<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
