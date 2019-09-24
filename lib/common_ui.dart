import 'package:flutter/material.dart';

typedef OnFinish<T> = Function(BuildContext context, T snapshot);

FutureBuilder createLoadingFutureBuilder<T>(
    Future<T> futrue, OnFinish<T> onFinish) {
  return new FutureBuilder(
      future: futrue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Idle');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Refreshing data...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return onFinish(context, snapshot.data);
        }
        return null;
      });
}
