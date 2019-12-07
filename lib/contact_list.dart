import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'chat_window.dart';
import 'common_ui.dart';

final Logger log = new Logger('ContactListPage');

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactListPageState();
  }
}

class _ContactListPageState extends State<ContactListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return createLoadingFutureBuilder<List<UserInfo>>(
        _getContactList(),
        (context, data) =>
            ListView(children: data.map((c) => _ContactItem(c)).toList()));
  }

  Future<List<UserInfo>> _getContactList() async {
    final result = await DimDataManager.getInstance().getContactList();
    return Future.wait(result
        .map((userId) => DimDataManager.getInstance().getUserInfo(userId)));
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
