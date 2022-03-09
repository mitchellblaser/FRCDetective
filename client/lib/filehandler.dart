import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> writeFile(String filePath, String contents) async {
  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;

  try {
    final File file = File(appFilePath + "/" + filePath);
    await file.writeAsString(contents);
    return;
  } 
  on FileSystemException catch (e) {
    print("writeFile (e) => FileSystemException: $e");
    return;
  }
}

Future<List<String>> readFile(String filePath) async {
  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;

  try {
    final File file = File(appFilePath + "/" + filePath);
    final List<String> contents = await file.readAsLines();
    return contents;
  } 
  on FileSystemException catch (e) {
    return ["FileSystemException", "$e"];
  }
}