class Contact {
  final String name;
  final String avatar;

  const Contact(this.name, this.avatar);
}

class ChatSession {
  final String name;
  final String avatar;
  final String lastMessage;

  const ChatSession(this.name, this.avatar, this.lastMessage);
}

class UserInfo {
  final String name;
  final String avatar;
  final String userId;
  final String slogan;

  const UserInfo(this.name, this.avatar, this.userId, this.slogan);
}

class LocalUserKey {
  final String userId;
  final String keyData; // json

  const LocalUserKey(this.userId, this.keyData);
}

abstract class IDimData {
  Future<List<Contact>> getContactList();
  Future<List<ChatSession>> getChatSessionList();
  Future<UserInfo> getUserInfo(String userId);
  Future<UserInfo> getLocalUserInfo();
  Future<void> setLocalUserInfo(UserInfo userInfo, LocalUserKey key);
}

class MockDimData extends IDimData {
  static const kTestLogin = false;
  static const UserInfo kMocklocalUser = UserInfo(
      'Sickworm',
      'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
      'sickworm@address',
      'I am Sickworm');
  UserInfo _localUser = kTestLogin ? null : kMocklocalUser;

  Future<List<Contact>> getContactList() {
    return Future.delayed(
        Duration(milliseconds: 300),
        () => List.generate(
            20,
            (i) => Contact('Sickworm',
                'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4')));
  }

  Future<List<ChatSession>> getChatSessionList() {
    return Future.delayed(
        Duration(milliseconds: 300),
        () => List.generate(
            20,
            (i) => ChatSession(
                'Sickworm',
                'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
                'hi this is a last chat message')));
  }

  Future<UserInfo> getUserInfo(String userId) {
    return Future.delayed(Duration(milliseconds: 300), () => _localUser);
  }

  Future<UserInfo> getLocalUserInfo() {
    return Future.delayed(Duration(milliseconds: 1000), () => _localUser);
  }

  Future<void> setLocalUserInfo(UserInfo userInfo, LocalUserKey key) {
    return Future.delayed(
        Duration(milliseconds: 50), () => _localUser = userInfo);
  }
}

class DimDataManager extends IDimData {
  static DimDataManager _instance = new DimDataManager._();
  static DimDataManager getInstance() {
    return _instance;
  }

  IDimData _impl = MockDimData();

  DimDataManager._();

  Future<List<Contact>> getContactList() {
    return _impl.getContactList();
  }

  Future<List<ChatSession>> getChatSessionList() {
    return _impl.getChatSessionList();
  }

  Future<UserInfo> getUserInfo(String userId) {
    return _impl.getUserInfo(userId);
  }

  Future<UserInfo> getLocalUserInfo() {
    return _impl.getLocalUserInfo();
  }

  Future<void> setLocalUserInfo(UserInfo userInfo, LocalUserKey key) {
    return _impl.getLocalUserInfo();
  }
}
