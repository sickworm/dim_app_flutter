import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
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
  void initState() {
    super.initState();
    () async {
      var launchJob = DimClient.getInstance().launch(null);
      var userJob = DimDataManager.getInstance().getLocalUserInfo();
      await launchJob;
      var userData = await userJob;
      if (userData == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainTabPage()));
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
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
