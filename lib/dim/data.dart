class Contact {
  final String name;
  final String avatar;

  Contact(this.name, this.avatar);
}

class ChatSession {
  final String name;
  final String avatar;
  final String lastMessage;

  ChatSession(this.name, this.avatar, this.lastMessage);
}

class UserInfo {
  final String name;
  final String avatar;
  final String userId;
  final String slogan;

  UserInfo(this.name, this.avatar, this.userId, this.slogan);
}

abstract class DimData {
  Future<List<Contact>> getContactList();
  Future<List<ChatSession>> getChatSessionList();
  Future<UserInfo> getUserInfo(String userId);
  Future<UserInfo> getLocalUserInfo();
}

class MockDimData extends DimData {
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
    return Future.delayed(
        Duration(milliseconds: 300),
        () => UserInfo(
            'Sickworm',
            'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
            'sickworm@address',
            'I am Sickworm'));
  }

  Future<UserInfo> getLocalUserInfo() {
    return Future.delayed(Duration(milliseconds: 1000), () => null);
  }
}

class DimDataManager extends DimData {
  static DimDataManager _instance = new DimDataManager._();
  static DimDataManager getInstance() {
    return _instance;
  }

  DimData _impl = MockDimData();

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
}
