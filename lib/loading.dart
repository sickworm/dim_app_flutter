import 'package:dim_app_flutter/chat_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'res.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _triggered = false;

  @override
  Widget build(BuildContext context) {
    if (!_triggered) {
      _triggered = true;
      Timer(Duration(seconds: 2), () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ChatListPage()));
      });
    }
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Text(
        'DIM',
        style: const TextStyle(fontSize: 64, color: kColorPrimary),
      )),
    ));
  }
}
