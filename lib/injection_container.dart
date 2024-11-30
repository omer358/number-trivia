import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:time_trivira/core/core.dart';
import 'package:time_trivira/features/number_trivia/data/data.dart';
import 'package:time_trivira/features/number_trivia/domain/domain.dart';
import 'package:time_trivira/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'core/presentation/utils/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  _initFeatures();
  //! Core
  _initCore();
  //! Externals
  await _initExternals();
}

void _initFeatures() {
  // BLoC
  sl.registerFactory(
    () => NumberTriviaBloc(
        concreteNumberTrivia: sl(),
        randomNumberTrivia: sl(),
        inputConverter: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
}

void _initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnection: sl()));
}

Future<void> _initExternals() async {
  sl.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnection());
}
