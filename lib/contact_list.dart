import 'package:dim_app_flutter/dim/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

class ContactListPage extends StatelessWidget {
  final _controller = IndexedScrollController();
  final List<Contact> _contactList;

  ContactListPage(this._contactList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: IndexedListView.builder(
                controller: _controller,
                itemBuilder: (context, i) => _ContactItem(_contactList[i]))));
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
          radius: 32,
        ),
        Text(
          _contact.name,
          style: const TextStyle(fontSize: 28),
        )
      ],
    );
  }
}
