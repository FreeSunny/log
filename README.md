# lite_log

a lite log uitl with flutter, provide runtime log write to file,  when debug mode print console window, user can adjust log level control log print

## Features

1: debug mode print to console/file
2: control print log level

## Use this package as a library 

1. Depend on it [lite_log](https://pub.dev/packages/lite_log)

Add this to your package's pubspec.yaml file:

```
dependencies:
  lite_log: ^0.1.0
  
```

2. Install it

You can install packages from the command line:

with Flutter


```
$ flutter packages get
  
```

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.

3. Import it

Now in your Dart code, you can use:

```
import 'package:lite_log/lite_log.dart';
  
```

## How to use 

```
import 'package:lite_log/lite_log.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

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
              setState(() {

              });
            },
          ),
          //child: Text('Running on: sample\n'),
        ),
      ),
    );
  }
}

```