abstract class DimData {
  Future<List<Contact>> getContactList();
  Future<List<ChatSession>> getChatSessionList();
}

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

class MockDimData extends DimData {
  Future<List<Contact>> getContactList() async {
    return Future.delayed(
        Duration(milliseconds: 2000),
        () => List.generate(
            20,
            (i) => Contact('Sickworm',
                'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4')));
  }

  Future<List<ChatSession>> getChatSessionList() async {
    return Future.delayed(
        Duration(milliseconds: 2000),
        () => List.generate(
            20,
            (i) => ChatSession(
                'Sickworm',
                'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
                'hi this is a last chat message')));
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
}
