import 'dart:io';

import 'package:dim_app_flutter/common_ui.dart';
import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserInfoPage extends StatelessWidget {
  final String userId;

  UserInfoPage(this.userId);

  @override
  Widget build(BuildContext context) {
    return createLoadingFutureBuilder<UserInfo>(
        DimDataManager.getInstance().getUserInfo(this.userId),
        (context, userInfo) => Scaffold(
              body: SafeArea(
                child: Column(children: [
                  CircleAvatar(
                      backgroundImage: FileImage(File(userInfo.avatar)),
                      radius: 24),
                  Text(userInfo.name),
                  Text(userInfo.userId),
                  Text(userInfo.slogan)
                ]),
              ),
            ));
  }
}
