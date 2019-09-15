import 'package:dim_app_flutter/chat_window.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = new Logger('ChatListPage');

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: Column(children: [_Header(), _ChatList()])));
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
            ),
            backgroundColor: Colors.transparent,
            radius: 32,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text('Sickworm', style: const TextStyle(fontSize: 28))),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          IconButton(
            icon: Icon(Icons.add, size: 32),
            onPressed: () {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('add button')));
            },
          )
        ]));
  }
}

class _ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: List.generate(
          20,
          (i) => _ChatItem(
              'https://avatars3.githubusercontent.com/u/2757460?s=460&v=4',
              'Sickworm',
              'hi this is a last chat message')),
    ));
  }
}

class _ChatItem extends StatelessWidget {
  final String url;
  final String name;
  final String lastChat;

  _ChatItem(this.url, this.name, this.lastChat);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => ChatWindowPage()));
        },
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(url),
                backgroundColor: Colors.transparent,
                radius: 24,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          maxLines: 1, style: const TextStyle(fontSize: 18)),
                      Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(lastChat,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black45))),
                    ],
                  ))
            ])));
  }
}
