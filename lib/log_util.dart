library log;

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:log/time_util.dart';
import 'package:path_provider/path_provider.dart';

enum Level { DEBUG, INFO, WARNING, ERROR }

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class LogUtil {
  static Level logLevel = Level.DEBUG;

  static final LogsStorage _storage = LogsStorage.instance;

  static d({String tag, @required String content}) {
    _log2File(Level.DEBUG, tag ?? "Debug", content);
  }

  static i({String tag, @required String content}) {
    _log2File(Level.INFO, tag ?? "Info", content);
  }

  static w({String tag, @required String content}) {
    _log2File(Level.WARNING, tag ?? "Warning", content);
  }

  static e({String tag, @required String content}) {
    _log2File(Level.ERROR, tag ?? "Error", content);
  }

  static _log2File(Level level, String tag, String content) {
    String log = formatLog(level, tag, content);
    if (isInDebugMode) {
      print(log);
    }
    if (level.index >= logLevel.index) {
      _storage.writeLogsToFile(log);
    }
  }

  static String formatLog(Level level, String tag, String content) {
    String log;
    log = "${level.toString()} ";
    log += "${TimeUtil.getDateFormatFullWithMillisecond()} ";
    log += "$tag ";
    log += "$content\n";
    return log;
  }
}

class LogsStorage {
  static final LogsStorage _singleton = LogsStorage._();

  // Singleton accessor
  static LogsStorage get instance => _singleton;

  // A private constructor. Allows us to create instances of LogsStorage
  // only from within the LogsStorage class itself.
  LogsStorage._() {
    deleteExpireLog();
  }

  Future<String> get _localPath async {
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory.path;
  }

  File _file;

  Future<File> get _localFile async {
    final path = await _localPath + "/flogs/";

    //creating directory
    Directory(path).create()
        // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });

    //opening file
    var file = File("$path${TimeUtil.getDateFormatYMD()}.log");
    var isExist = await file.exists();

    //check to see if file exist
    if (isExist) {
      print('Log File exists');
    } else {
      print('Log File does not exist ');
    }
    _file = file;
    return file;
  }

  void writeLogsToFile(String log) async {
    if (_file == null) {
      await _localFile;
    }
    // Write the file
    _file.writeAsStringSync('$log', mode: FileMode.writeOnlyAppend);
  }

  Future deleteExpireLog() async {
    try {
      final path = await _localPath + "/flogs/";
      var fiveDayBefore = DateTime.now().subtract(Duration(days: 5));
      Directory(path).list().where((value) {
        var file = File(value.path);
        DateTime dateTime = file.lastModifiedSync();
        print(
            "delete log ${file.path} time=${dateTime.millisecondsSinceEpoch} before=${dateTime.isBefore(fiveDayBefore)}");
        if (dateTime.isBefore(fiveDayBefore)) {
          file.delete();
        }
        return true;
      }).toList();
    } catch (e) {
      print('delete expire time log error');
    }
  }
}
