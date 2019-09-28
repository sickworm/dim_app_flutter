import 'package:dim_app_flutter/dim/dim_data.dart';
import 'package:dim_app_flutter/login/login.dart';
import 'package:flutter/material.dart';
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
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainTabPage()));
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
