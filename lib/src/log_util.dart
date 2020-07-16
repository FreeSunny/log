// Copyright (c) 2014-2020 sunyoujun.
// All right reserved.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lite_log/src/time_util.dart';
import 'package:path_provider/path_provider.dart';

/// log level, control print
enum Level { verbose, debug, info, warning, error }

/// top method if debug mode return true, else return false
bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// log util class
class LogUtil {
  static Level logLevel = Level.debug;

  static void setupLogLevel(Level level) {
    logLevel = level;
  }

  static final LogsStorage _storage = LogsStorage.instance;

  /// print verbose level log
  static v({String tag, @required dynamic content}) {
    _log2File(Level.verbose, tag ?? "Verbose", content);
  }

  /// print debug level log
  static d({String tag, @required dynamic content}) {
    _log2File(Level.debug, tag ?? "Debug", content);
  }

  /// print info level log
  static i({String tag, @required dynamic content}) {
    _log2File(Level.info, tag ?? "Info", content);
  }

  /// print warning level log
  static w({String tag, @required dynamic content}) {
    _log2File(Level.warning, tag ?? "Warning", content);
  }

  /// print error level log
  static e({String tag, @required dynamic content}) {
    _log2File(Level.error, tag ?? "Error", content);
  }

  static _log2File(Level level, String tag, dynamic content) {
    String log = _SimplePrinter.format(level, tag, content);
    if (isInDebugMode) {
      print(log);
    }
    if (level.index >= logLevel.index) {
      _storage.writeLogsToFile(log);
    }
  }
}

/// simple format class
class _SimplePrinter {
  static final levelPrefixes = {
    Level.verbose: 'V/',
    Level.debug: 'D/',
    Level.info: 'I/',
    Level.warning: 'W/',
    Level.error: 'E/',
  };

  /// format print log: time level tag message
  static String format(Level level, String tag, dynamic content) {
    var message = _formatMessage(content);
    var timeStr = '${DateTime.now().toIso8601String()}';
    return '$timeStr ${levelPrefixes[level]} $tag $message\n';
  }

  /// if message is map: flat content
  static String _formatMessage(dynamic message) {
    if (message is Map) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}

/// log storage class
class LogsStorage {
  /// Singleton constructor
  static final LogsStorage _singleton = LogsStorage._();

  /// Singleton accessor
  static LogsStorage get instance => _singleton;

  /// A private constructor. Allows us to create instances of LogsStorage
  /// only from within the LogsStorage class itself.
  LogsStorage._() {
    deleteExpireLog();
  }

  /// get log print path
  Future<String> get _localPath async {
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory.path;
  }

  /// file
  File _file;

  /// get log print file
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

  /// write log to file
  void writeLogsToFile(String log) async {
    if (_file == null) {
      await _localFile;
    }
    // Write the file
    _file.writeAsStringSync('$log', mode: FileMode.writeOnlyAppend);
  }

  /// app save five days log , if log expire time delete
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
