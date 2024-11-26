import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/core/errors/exceptions.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';
import 'package:time_trivira/features/number_trivia/domain/entities/entities.dart';

import 'number_trivia_repository_imp_test.mocks.dart';

@GenerateMocks(
  [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo],
)
void main() {
  late NumberTriviaLocalDataSource localDataSource;
  late NumberTriviaRemoteDataSource remoteDataSource;
  late NetworkInfo networkInfo;
  late NumberTriviaRepositoryImpl repository;

  setUp(() {
    localDataSource = MockNumberTriviaLocalDataSource();
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });
  group("Get concrete number trivia", () {
    const tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: "Test Text", number: 1);
    const NumberTrivia tNumberTriviaEntity = tNumberTriviaModel;

    test("should check if the device is online", () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(remoteDataSource.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(networkInfo.isConnected);
    });
    group("device is online", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        when(remoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });
      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group("device is offline", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          "Should return last locally data when the call to cached data source is present",
          () async {
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTriviaModel));
      });
      test(
          "should return server failure when the call to local data source is unsuccessful",
          () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(localDataSource.getLastNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
  group("Get random number trivia", () {
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: "Test Text", number: 1);
    const NumberTrivia tNumberTriviaEntity = tNumberTriviaModel;

    test("should check if the device is online", () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(remoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(networkInfo.isConnected);
    });
    group("device is online", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(remoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });
      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          "should return server failure when the call to remote data source is unsuccessful",
          () async {
        // arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group("device is offline", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          "Should return last locally data when the call to cached data source is present",
          () async {
        //act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTriviaModel));
      });
      test(
          "should return server failure when the call to local data source is unsuccessful",
          () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(localDataSource.getLastNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
