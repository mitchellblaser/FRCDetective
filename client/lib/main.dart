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
import 'package:FRCDetective/main.dart' as mainapp;

import 'window_main.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

Map serverDiffList = {};

Map clientList = {};
class ClientEntry {
  int totalScore;
  int entries;
  
  ClientEntry({required this.totalScore, required this.entries});
}

String mainAppFilePath = "";

void doServerUpdateInitial() async {
  final List<String> f = await readFile("server.txt");
  serverAddress = f[0];
  serverPort = f[1];

  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;
  mainAppFilePath = appFilePath;
  await Directory(appFilePath + "/datastore").create();
  await Directory(appFilePath + "/datastore/matchchunks").create();
  await Directory(appFilePath + "/datastore/matches").create();
  await Directory(appFilePath + "/datastore/teams").create();
  await Directory(appFilePath + "/datastore/users").create();
  await Directory(appFilePath + "/datastore/teamimage").create();

  doServerUpdate();
  return;
}

Future<void> getChunkData() async {
  clientList = {};
  (await getFileList())["chunks"].forEach((dynamic k, dynamic v) async {
    Map _fileData = jsonDecode((await readFile("datastore/matchchunks/" + k + ".chunk")).last);
    String _client = k.split("_")[1];

    int _score = _fileData["auto_goal_high"]*4 + _fileData["auto_goal_low"]*2 + _fileData["tele_goal_high"]*2 + _fileData["tele_goal_low"];
      
    if (_fileData["tele_hangar"] == "ClimbState.low") { _score = _score + 4; }
    else if (_fileData["tele_hangar"] == "ClimbState.mid") { _score = _score + 6; }
    else if (_fileData["tele_hangar"] == "ClimbState.high") { _score = _score + 10; }
    else if (_fileData["tele_hangar"] == "ClimbState.traversal") { _score = _score + 15; }

    if (_fileData["auto_taxi"] == true) { _score = _score + 2; }

    print("_client $_client");

    if (!clientList.keys.contains(_client)) {
      print("!contains");
      clientList[_client] = ClientEntry(entries: 1, totalScore: _score);
    }
    else {
      print("contains");
      clientList[_client].totalScore = clientList[_client].totalScore + _score;
      clientList[_client].entries = clientList[_client].entries + 1;
    }
  });
}

void doServerUpdate() async {

  await getChunkData();

  try {
    var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(milliseconds: serverPollIntervalMS));
    serverState = const Icon(Icons.link);
    
    print(await getFileList());
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

  try {
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

    serverDiffList["data"]["txChunks"].forEach((String k, dynamic v) async {
      for (int i=0; i < v.length; i++) {

        for (int l=0; l < v.length; l++) {
          try {
            var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(milliseconds: 100));

            s.write('{"request": "GET_CHUNK", "data": {"chunkid": "' + k + '"}}');

            s.listen(
              (Uint8List data) {
                final r = String.fromCharCodes(data);
                // debugPrint(r);
                final j = jsonDecode(r)["data"];
                File f = File(appFilePath + "/datastore/matchchunks/" + k + ".chunk");
                if (f.existsSync()) {
                  f.deleteSync();
                }
                f.writeAsStringSync(jsonEncode(j));
              },

              onError: (error) {
                debugPrint(error);
                s.destroy();
                s.close();
              },

              onDone: () {
                s.destroy();
                s.close();
              }
            );
          }

          on TimeoutException {
            return;
          }

        }

      }
    });
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
