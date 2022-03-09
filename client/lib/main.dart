import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'filehandler.dart';
import 'database.dart';

import 'window_main.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

Map serverDiffList = {};

void doServerUpdateInitial() async {
  final List<String> f = await readFile("server.txt");
  serverAddress = f[0];
  serverPort = f[1];

  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;
  await Directory(appFilePath + "/datastore").create();
  await Directory(appFilePath + "/datastore/matchchunks").create();
  await Directory(appFilePath + "/datastore/matches").create();
  await Directory(appFilePath + "/datastore/teams").create();
  await Directory(appFilePath + "/datastore/users").create();

  doServerUpdate();
  return;
}

void doServerUpdate() async {
    try {
      var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(milliseconds: serverPollIntervalMS));
      serverState = const Icon(Icons.link);

      getFileList();

      // final directory = await getApplicationDocumentsDirectory();
      // String appFilePath = directory.path;
      // s.write('{"request": "PUT_CHUNK", "data": ' + File(appFilePath + "/datastore/matchchunks/" + "Q12_0" + ".chunk").readAsStringSync() + '}');
      // s.write('{"request": "GET_CHUNK", "data": {"chunkid": "Q12_0"}}');
      s.write('{"request": "GET_DIFF", "data": ' + jsonEncode(await getFileList()) + '}');
      s.listen(
        (Uint8List data) {
          final r = String.fromCharCodes(data);
          serverDiffList = jsonDecode(r);
          syncStackWithServer();
        },

        onError: (error) {
          print(error);
          s.destroy();
          s.close();
        },

        onDone: () {
          print("done.");
          s.destroy();
          s.close();
        }
      );
    }
    on TimeoutException {
      serverState = const Icon(Icons.link_off);
      return;
    }
    on FormatException {
      serverState = const Icon(Icons.warning);
      return;
    }
    on SocketException {
      serverState = const Icon(Icons.warning);
      return;
    }
}

void syncStackWithServer() async {

  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;

  serverDiffList["data"]["rxChunks"].forEach((String k, dynamic v) async {
    for (int i=0; i < v.length; i++) {

      var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(milliseconds: 100));

      List<String> currentFile = File(appFilePath + "/datastore/matchchunks/" + k + ".chunk").readAsLinesSync();

      for (int l=0; l < currentFile.length; l++) {
        Map currentLine = jsonDecode(currentFile[i]);
        if (currentLine["user"] + "_" + currentLine["epoch_since_modify"].toString() == v[i]) {
          s.write('{"request": "PUT_CHUNK", "data": ' + jsonEncode(currentLine) + '}');
        }
      }
    }
  });



}

void main() {
  // Platform-specific code...
  if (!kIsWeb) {
    if (Platform.isWindows) {
      boxHeight = 14;
      logoPath = "assets/images/logo-small.png";
    }
  }
  // Run GUI
  runApp(const DetectiveApp());
  // Start Periodic Functions
  Timer.periodic(const Duration(milliseconds: serverPollIntervalMS), (Timer t) => { doServerUpdate() });
  doServerUpdateInitial();
}
