import 'package:dim_app_flutter/dim/dim.dart';
import 'package:dim_app_flutter/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:logging/logging.dart';

final Logger log = new Logger('ChatWindowPage');

class ChatWindowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatWindowPageState();
  }
}

class _ChatWindowPageState extends State<StatefulWidget>
    with WidgetsBindingObserver {
  final testData = List.generate(
      20,
      (i) =>
          _ChatData(Content(ContentType.Text, 'hello ${i + 1}'), i % 2 == 0));
  final _dimManager = DimManager.getInstance();
  final _scrollController = ScrollController();
  OnReceive _dimListener;
  int _keyboardListenerId;
  bool _needScroll = false;
  bool _needJump = true;

  @override
  void initState() {
    super.initState();
    _dimListener = (content) {
      setState(() {
        log.info('receive $content');
        testData.add(_ChatData(content, false));
        _needScroll = true;
      });
    };
    _dimManager.addListener(_dimListener);

    _keyboardListenerId = KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          setState(() {
            _needScroll = true;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dimManager.removeListener(_dimListener);
    KeyboardVisibilityNotification().removeListener(_keyboardListenerId);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Column(children: [
          _Header('Sickworm'),
          Container(
              height: 1,
              color: Colors.black26,
              margin: const EdgeInsets.only(left: 8, right: 8)),
          _ChatMessageList(testData, _scrollController),
          _TextInputBar((content) {
            var chatData = _ChatData(content, true, isLoading: true);
            setState(() {
              testData.add(chatData);
              _needScroll = true;
            });
            _dimManager.send(content).then((value) {
              print('send $content');
              setState(() {
                chatData.isLoading = false;
              });
            });
          })
        ])));
  }

  _scrollToEnd() async {
    if (_needJump) {
      _needJump = false;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    if (_needScroll) {
      _needScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    }
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
  final ScrollController _scrollController;

  _ChatMessageList(this._list, this._scrollController);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            controller: _scrollController,
            children: _list.map((d) => _ChatMessage(d)).toList()));
  }
}

class _ChatData {
  final Content content;
  final bool isSelf;
  bool isLoading;
  _ChatData(this.content, this.isSelf, {this.isLoading = false});
}

class _ChatMessage extends StatelessWidget {
  final _ChatData chatData;

  _ChatMessage(this.chatData);

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    if (chatData.isSelf) {
      items.add(const Flexible(fit: FlexFit.tight, child: SizedBox()));
      if (chatData.isLoading) {
        items.add(CupertinoActivityIndicator());
      }
    }

    items.add(Container(
        decoration: _getDecoration(),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Text(chatData.content.data)));

    if (!chatData.isSelf) {
      if (chatData.isLoading) {
        items.add(CupertinoActivityIndicator());
      }
      items.add(const Flexible(fit: FlexFit.tight, child: SizedBox()));
    }

    return Row(
      children: items,
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

class _TextInputBar extends StatefulWidget {
  final OnSend sender;

  _TextInputBar(this.sender);

  @override
  State<StatefulWidget> createState() {
    return _TextInputBarState();
  }
}

class _TextInputBarState extends State<_TextInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String _currentText = '';

  @override
  Widget build(BuildContext context) {
    _controller
      ..text = _currentText
      ..selection = TextSelection.collapsed(offset: _currentText.length);
    return Container(
        width: double.infinity,
        height: 52,
        padding: EdgeInsets.all(2),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: kColorShadow, blurRadius: 6.0)],
            color: kColorGrayBackground),
        child: Material(
            color: kColorGrayBackground,
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
                    focusNode: _focusNode,
                    controller: _controller,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(),
                    onChanged: (value) {
                      _currentText = value;
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_focusNode);
                      _sendContent();
                    }),
              )),
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
    _currentText = '';
    _controller.clear();
    widget.sender(content);
  }
}
