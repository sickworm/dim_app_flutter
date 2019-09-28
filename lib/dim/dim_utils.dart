import 'dim_data.dart';

class DimUtils {
  static Future<LocalUserKey> createLocalUserKey() {
    return Future.delayed(Duration(microseconds: 1000),
        () => LocalUserKey('mockUserId', '{"data": "mock_local_user_key"}'));
  }
}
