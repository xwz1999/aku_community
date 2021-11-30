/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-16  15:21 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'package:path_provider/path_provider.dart';

typedef ReadFileCallback = Function(bool success, File file, String msg);
typedef WriteFileCallback = Function(bool success, File file, String msg);

class FileOperationResult {
  Object? data;
  String msg;
  bool success;

  FileOperationResult(this.data, this.msg, this.success);
}

class FileUtils {
  static Future<String> tempPath() async {
    try {
      var tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      return tempPath;
    } catch (err) {
      print(err);
      return '';
    }
  }

  static Future<String> appDocPath() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      return appDocPath;
    } catch (err) {
      print(err);
      return '';
    }
  }

  // 读取 json 数据
  static Future<FileOperationResult> readJSON(String path) async {
    try {
      String filePath = await appDocPath();
      final File file = await localFile(filePath+path);
      String str = await file.readAsString();
      return FileOperationResult(str, "读取成功", true);
    } catch (err) {
      return FileOperationResult(null, err.toString(), false);
    }
  }

// 写入 json 数据
  static Future<FileOperationResult> writeJSON(String path, String jsonStr) async {
    try {
      String filePath = await appDocPath();
      final File file = await localFile(filePath+path);
      await file.writeAsString(jsonStr);
      return FileOperationResult(file, "写入成功", true);
    } catch (err) {
      return FileOperationResult(null, err.toString(), false);
    }
  }

  static localFile(path) async {
    print('文件目录: ' + path);
    return new File(path);
  }
}
