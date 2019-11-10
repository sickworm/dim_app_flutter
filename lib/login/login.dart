import 'dart:io';

import 'package:dim_sdk_flutter/dim_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../main_tab.dart';
import '../res.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Center(
            heightFactor: 2.8,
            child: Text('DIM',
                style: const TextStyle(fontSize: 64, color: kColorPrimary)),
          ),
          _GuildButton(
              'Create Account',
              'Create a DIM Account and save',
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAccountPage()))),
          _GuildButton(
              'Import Account', 'Import DIM Account created before', () {})
        ],
      ),
    ));
  }
}

class _GuildButton extends StatelessWidget {
  final String _buttonString;
  final String _tipsString;
  final VoidCallback _onPress;

  _GuildButton(this._buttonString, this._tipsString, this._onPress);

  @override
  Widget build(BuildContext context) {
    return Center(
        heightFactor: 2,
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: this._onPress,
                color: kColorPrimary,
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      _buttonString,
                      style: TextStyle(color: kColorWhite, fontSize: 24),
                    ))),
            SizedBox(height: 16),
            _tipsString == null
                ? Container()
                : Text(
                    _tipsString,
                    style: TextStyle(fontSize: 16, color: kColorShadow),
                  ),
          ],
        ));
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountPageState();
  }
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  ImageProvider _image = AssetImage('assets/images/avatar.png');
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
                heightFactor: 2,
                child: Column(children: [
                  InkWell(
                    child: CircleAvatar(
                      backgroundImage: _image,
                      radius: 44,
                    ),
                    onTap: _showBottom,
                  ),
                  SizedBox(height: 12),
                  Text('Tap to change logo',
                      style: TextStyle(fontSize: 16, color: kColorGrayText))
                ])),
            Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Nick Name',
                      style: TextStyle(fontSize: 24),
                    ),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              autofocus: true,
                              style: TextStyle(fontSize: 18),
                              controller: _controller,
                            )))
                  ],
                )),
            Expanded(child: SizedBox()),
            _GuildButton('Create', null, () => _createAccount(context)),
            SizedBox(
              height: 64,
            )
          ],
        ),
      ),
    );
  }

  void _showBottom() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [
            Column(
              children: [
                _menuItem(Icons.photo_album, 'From Gallery', () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                }),
                _menuItem(Icons.camera, 'From Camera', () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                }),
              ],
            ),
          ]);
        });
  }

  Widget _menuItem(IconData icon, String name, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(20),
            child: Row(children: <Widget>[
              SizedBox(width: 4),
              Icon(icon),
              SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(fontSize: 24),
              ),
            ])));
  }

  Future _getImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = FileImage(image);
      });
    }
  }

  void _createAccount(BuildContext context) async {
    var key = await DimUtils.createLocalUserKey();
    var userInfo =
        UserInfo(_controller.text, _image.toString(), key.userId, '');
    await DimDataManager.getInstance().setLocalUserInfo(userInfo, key);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainTabPage()));
  }
}
