import 'package:dim_app_flutter/chat_window.dart';
import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = new Logger('ChatListPage');

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  var sessionList = List<ChatSession>();
  var userInfoList = List<UserInfo>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final sessionList = await DimDataManager.getInstance().getChatSessionList();
    final userInfoList = await Future.wait(sessionList.map((s) =>
        DimDataManager.getInstance().getUserInfo(s.userId)));
    setState(() {
      this.sessionList = sessionList;
      this.userInfoList = userInfoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: sessionList.map((c) => _ChatItem(c,
      userInfoList.firstWhere((u) => c.userId == u.userId))).toList());
  }
}

class _ChatItem extends StatelessWidget {
  final ChatSession _chatSession;
  final UserInfo _userInfo;

  _ChatItem(this._chatSession, this._userInfo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWindowPage(
                      _chatSession.sessionId, _userInfo)));
        },
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(_userInfo.avatar),
                backgroundColor: Colors.transparent,
                radius: 24,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_userInfo.name,
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
