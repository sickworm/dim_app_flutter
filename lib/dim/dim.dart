import 'dart:async';

enum ContentType { Text, Image, File }

class Content {
  final ContentType type;
  final String data;

  Content(this.type, this.data);

  String toString() {
    return 'Content: $type, $data';
  }
}

typedef OnReceive = void Function(Content message);

abstract class DimClient {
  OnReceive receive;
  DimClient(this.receive);
  Future<void> send(Content content);
}

class EchoDimClient extends DimClient {
  EchoDimClient(OnReceive receiver) : super(receiver);

  @override
  Future<void> send(Content content) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      Future.delayed(Duration(milliseconds: 1000), () {
        receive(Content(ContentType.Text, content.data));
      });
    });
  }
}

class DimManager {
  static DimManager _instance = new DimManager._();
  static DimManager getInstance() {
    return _instance;
  }

  List<OnReceive> listeners = List();
  DimClient client;

  DimManager._() {
    client = EchoDimClient((Content content) {
      dispatch(content);
    });
  }

  Future<void> send(Content content) {
    return client.send(content);
  }

  addListener(OnReceive receiver) {
    listeners.add(receiver);
  }

  removeListener(OnReceive receiver) {
    listeners.remove(receiver);
  }

  dispatch(Content content) {
    for (OnReceive listener in listeners) {
      listener(content);
    }
  }
}
