import 'dart:io';

import 'package:flutter/material.dart';

typedef OnFinish<T> = Function(BuildContext context, T snapshot);

FutureBuilder createLoadingFutureBuilder<T>(
    Future<T> future, OnFinish<T> onFinish,
    {needLoadingUi: true}) {
  return new FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            if (needLoadingUi) {
              return Center(child: Text('Idle'));
            }
            break;
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (needLoadingUi) {
              return Center(child: Text('Refreshing data...'));
            }
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              if (needLoadingUi) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const SizedBox();
              }
            }
            return onFinish(context, snapshot.data);
        }
        return const SizedBox();
      });
}

ImageProvider getImageProvider(String path) {
  if (path == null) {
    return AssetImage('assets/images/error.png');
  } else if (path.startsWith('http')) {
    return NetworkImage(path);
  } else if (path.startsWith('assets/images')) {
    return AssetImage(path);
  } else {
    return FileImage(File(path));
  }
}
