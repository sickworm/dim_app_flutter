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
      await Future.wait([
        DimDataManager.getInstance().init(),
        DimClient.getInstance().launch(null)
      ]);
      var userInfo = await DimDataManager.getInstance().getLocalUserInfo();
      if (userInfo == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        await DimClient.getInstance().login(userInfo);
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
