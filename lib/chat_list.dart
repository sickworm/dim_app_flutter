import 'package:dim_app_flutter/chat_window.dart';
import 'package:dim_app_flutter/dim/data.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'common_ui.dart';

final Logger log = new Logger('ChatListPage');

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return createLoadingFutureBuilder<List<ChatSession>>(
        DimDataManager.getInstance().getChatSessionList(),
        (context, data) =>
            ListView(children: data.map((c) => _ChatItem(c)).toList()));
  }
}

class _ChatItem extends StatelessWidget {
  final ChatSession _chatSession;

  _ChatItem(this._chatSession);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatWindowPage()));
        },
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(_chatSession.avatar),
                backgroundColor: Colors.transparent,
                radius: 24,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_chatSession.name,
                          maxLines: 1, style: const TextStyle(fontSize: 18)),
                      Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(_chatSession.lastMessage,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black45))),
                    ],
                  ))
            ])));
  }
}
