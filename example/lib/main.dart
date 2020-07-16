// Copyright (c) 2014-2020 sunyoujun.
// All right reserved.

import 'package:lite_log/lite_log.dart';
import 'package:flutter/material.dart';

/// main method
void main() {
  runApp(MyApp());
}

/// root widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// root state
class _MyAppState extends State<MyApp> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    LogUtil.i(tag: "init", content: "${this.runtimeType} page init");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('log example app'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text('click print log ${count++}'),
            onTap: () {
              LogUtil.i(content: "print log $count");
              setState(() {});
            },
          ),
          //child: Text('Running on: sample\n'),
        ),
      ),
    );
  }
}
