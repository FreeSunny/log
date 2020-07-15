import 'package:lite_log/log_util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          child: Text('Running on: sample\n'),
        ),
      ),
    );
  }
}
