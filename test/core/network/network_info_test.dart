import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_trivira/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnection])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnection mockInternetConnection;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    networkInfo = NetworkInfoImpl(internetConnection: mockInternetConnection);
  });

  group("isConnected", () {
    test("Should forward the call to DataConnectionChecker.hasConnection",
        () async {
      // arrange
      final Future<bool> tHasConnectionFuture = Future.value(true);
      when(mockInternetConnection.hasInternetAccess)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfo.isConnected;
      //assert
      verify(mockInternetConnection.hasInternetAccess);
      expect(result, tHasConnectionFuture);
    });
  });
}
