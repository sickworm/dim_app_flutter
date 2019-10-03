import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return createLoadingFutureBuilder<List<Contact>>(
        DimDataManager.getInstance().getContactList(),
        (context, data) =>
            ListView(children: data.map((c) => _ContactItem(c)).toList()));
  }
}

class _ContactItem extends StatelessWidget {
  final Contact _contact;

  _ContactItem(this._contact);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
            _contact.avatar,
          ),
          backgroundColor: Colors.transparent,
          radius: 20,
        ),
        Text(
          _contact.name,
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }
}
