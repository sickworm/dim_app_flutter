import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../res.dart';

class NoLoginPage extends StatelessWidget {
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
          _GuildButton('Create Account', 'Create a new DIM Account and save'),
          _GuildButton('Import Account', 'Import DIM Account created before')
        ],
      ),
    ));
  }
}

class _GuildButton extends StatelessWidget {
  final String buttonString;
  final String tipsString;

  _GuildButton(this.buttonString, this.tipsString);

  @override
  Widget build(BuildContext context) {
    return Center(
        heightFactor: 2,
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {},
                color: kColorPrimary,
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      buttonString,
                      style: TextStyle(color: kColorWhite, fontSize: 24),
                    ))),
            SizedBox(height: 16),
            Text(
              tipsString,
              style: TextStyle(fontSize: 16, color: kColorShadow),
            ),
          ],
        ));
  }
}
