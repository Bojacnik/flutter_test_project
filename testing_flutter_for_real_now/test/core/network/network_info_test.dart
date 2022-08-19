import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:testing_flutter_for_real_now/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

@GenerateMocks([DataConnectionChecker])
void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group(
    'isConnected',
    () {
      test('should forward the call to DataConnectionChecker.HasConnection',
          () async {
        // arrange
        final tHasConnectionFuture = await Future.value(true);

        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) async => Future.value(true));
        // act
        final result = await networkInfoImpl.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, equals(tHasConnectionFuture));
      });
    },
  );
}
