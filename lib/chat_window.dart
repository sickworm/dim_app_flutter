import 'package:dim_app_flutter/dim/dim.dart';
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
  final testData = List.generate(
      1, (i) => _ChatData(Content(ContentType.Text, 'hello'), i % 2 == 0));
  final _dimManager = DimManager.getInstance();

  _ChatWindowState() {
    _dimManager.addListener((content) {
      setState(() {
        // TODO log.info not work??
        print('receive $content');
        testData.add(_ChatData(content, false));
      });
    });
  }

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
      _ChatMessageList(testData),
      _TextInputBar((content) {
        // TODO show progress bar
        _dimManager.send(content).then((value) {
          print('send $content');
          // TODO close progress bar
          setState(() {
            testData.add(_ChatData(content, true));
          });
        });
      })
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

class _ChatMessageList extends StatelessWidget {
  final List<_ChatData> _list;

  _ChatMessageList(this._list);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(children: _list.map((d) => _ChatMessage(d)).toList()));
  }
}

class _ChatData {
  final Content content;
  final bool isSelf;
  _ChatData(this.content, this.isSelf);
}

class _ChatMessage extends StatelessWidget {
  final _ChatData chatData;

  _ChatMessage(this.chatData);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: chatData.isSelf ? WrapAlignment.end : WrapAlignment.start,
      children: [
        Container(
            decoration: _getDecoration(),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Text(chatData.content.data))
      ],
    );
  }

  Decoration _getDecoration() {
    const shadow = BoxShadow(
        color: kColorShadow, offset: Offset(3.0, 3.0), blurRadius: 6.0);
    if (chatData.isSelf) {
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

typedef OnSend = void Function(Content content);

class _TextInputBar extends StatelessWidget {
  final _controller = TextEditingController();
  final OnSend sender;
  _TextInputBar(this.sender);

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
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(),
                    )),
              ),
              InkWell(
                  child: IconButton(
                icon: const Icon(Icons.send, color: kColorIcon, size: 32),
                onPressed: () => _sendContent(),
              )),
            ])));
  }

  _sendContent() {
    if (_controller.text.isEmpty) {
      return;
    }
    var content = Content(ContentType.Text, _controller.text);
    _controller.clear();
    print('try to send $content');
    sender(content);
  }
}
