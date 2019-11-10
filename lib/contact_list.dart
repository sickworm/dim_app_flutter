import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_window.dart';
import 'common_ui.dart';

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactListPageState();
  }
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    return createLoadingFutureBuilder<List<UserInfo>>(
        DimDataManager.getInstance().getContactList(),
        (context, data) =>
            ListView(children: data.map((c) => _ContactItem(c)).toList()));
  }
}

class _ContactItem extends StatelessWidget {
  final UserInfo userInfo;

  _ContactItem(this.userInfo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          DimDataManager.getInstance()
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
