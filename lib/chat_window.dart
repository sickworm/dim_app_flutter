import 'package:dim_app_flutter/res.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = new Logger('ChatWindowPage');

class ChatWindowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatWindowState();
  }
}

class _ChatWindowState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _Header('Sickworm'),
      Container(
          height: 1,
          color: Colors.black26,
          margin: const EdgeInsets.only(left: 8, right: 8)),
      _ChatMessageList(),
      _TextInputBar()
    ])));
  }
}

class _Header extends StatelessWidget {
  final String name;

  _Header(this.name) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Ink(
            padding: EdgeInsets.only(top: 4, bottom: 0, left: 12, right: 12),
            child: Row(
              children: <Widget>[
                Text(name,
                    style: const TextStyle(
                      fontSize: 24,
                    )),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                IconButton(
                    icon: Icon(Icons.menu, size: 28),
                    onPressed: () {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('menu')));
                    }),
              ],
            )));
  }
}

class _ChatMessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatMessageListState();
  }
}

class _ChatMessageListState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            children:
                List.generate(20, (i) => _ChatMessage('hello', i % 2 == 0))));
  }
}

class _ChatMessage extends StatelessWidget {
  final String content;
  final bool isSelf;

  _ChatMessage(this.content, this.isSelf) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: isSelf ? WrapAlignment.end : WrapAlignment.start,
      children: [
        Container(
            decoration: _getDecoration(),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Text(content))
      ],
    );
  }

  Decoration _getDecoration() {
    const shadow = BoxShadow(
        color: kColorShadow, offset: Offset(3.0, 3.0), blurRadius: 6.0);
    if (isSelf) {
      return const BoxDecoration(
          color: kColorChatMessageSelf,
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
          boxShadow: [shadow]);
    } else {
      return const BoxDecoration(
          color: kColorChatMessageOther,
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
          boxShadow: [shadow]);
    }
  }
}

class _TextInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 52,
        padding: EdgeInsets.all(2),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: kColorShadow, blurRadius: 6.0)],
            color: kColorGray),
        child: Material(
            color: kColorGray,
            child: Row(children: [
              InkWell(
                  child: IconButton(
                icon: Icon(Icons.insert_emoticon, color: kColorIcon, size: 32),
                onPressed: () {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('emoticon')));
                },
              )),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(),
                    )),
              ),
              InkWell(
                  child: IconButton(
                icon: Icon(Icons.send, color: kColorIcon, size: 32),
                onPressed: () {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('send')));
                },
              )),
            ])));
  }
}
