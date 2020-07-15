# lite_log

flutter lite log util wirte to file

## Features

1: debug mode print to console/file
2: control print log level

## Use this package as a library 

1. Depend on it

Add this to your package's pubspec.yaml file:

```
dependencies:
  log: ^0.0.x
  
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
import 'package:lite_log/log_util.dart';
  
```

## How to use 

```
import 'package:lite_log/log_util.dart';

void main() {
  runApp(HomePage());
}  

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //runtime permission
  final PermissionGroup _permissionGroup = PermissionGroup.storage;

  @override
  void initState() {
    super.initState();
    LogUtil.i(tag:"init", content;"${this.runtimeType} page init");
  }

  @override
  Widget build(BuildContext context) {
  }
}  
```