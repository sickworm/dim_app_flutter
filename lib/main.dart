import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.loggerName}: ${rec.message}');
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingPage(),
    );
  }
}
