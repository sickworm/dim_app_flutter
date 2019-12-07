import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'chat_window.dart';

final Logger log = new Logger('ContactListPage');

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactListPageState();
  }
}

class _ContactListPageState extends State<ContactListPage> {

  var contactList = List<UserInfo>();

  @override
  void initState() {
    super.initState();
    _getContactList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: contactList.map((c) => _ContactItem(c)).toList());
  }

  _getContactList() async {
    final result = await DimDataManager.getInstance().getContactList();
    var contactList = await Future.wait(result
        .map((userId) => DimDataManager.getInstance().getUserInfo(userId)));
    setState(() {
      this.contactList = contactList;
    });
  }
}

class _ContactItem extends StatelessWidget {
  final UserInfo userInfo;

  _ContactItem(this.userInfo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await DimDataManager.getInstance()
              .getChatSessionId(userInfo.userId)
              .then((sessionId) => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatWindowPage(sessionId, userInfo)))
                  });
        },
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                userInfo.avatar,
              ),
              backgroundColor: Colors.transparent,
              radius: 20,
            ),
            Text(
              userInfo.name,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ));
  }
}
