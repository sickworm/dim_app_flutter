import 'package:dim_app_flutter/dim/data.dart';
import 'package:dim_app_flutter/login/no_login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'main_tab.dart';
import 'res.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    DimDataManager.getInstance().getLocalUserInfo().then((userData) {
      if (userData == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NoLoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainTab()));
      }
    });
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
