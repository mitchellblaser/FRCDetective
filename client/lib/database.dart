import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Map> getFileList() async {

  Map _chunkList = {};

  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;

  final chunkdir = Directory(appFilePath + "/datastore/matchchunks/");
  final chunkfiles = chunkdir.listSync();
  
  for (int i=0; i < chunkfiles.length; i++) {
    List<String> file = File(chunkfiles[i].path).readAsLinesSync();

    Map fileLast = jsonDecode(file.last);
    _chunkList[fileLast["chunkid"]] = [];

    for (int ver=0; ver < file.length; ver++) {
      Map fileCurrent = jsonDecode(file[ver]);
      _chunkList[fileLast["chunkid"]].add(fileCurrent["user"] + "_" + fileCurrent["epoch_since_modify"].toString());
    }

  }

  return {
    "teams": {},
    "matches": {},
    "chunks": _chunkList
  };
}

//TODO: Implement functions here so after we get the diff we can send/receive each file.