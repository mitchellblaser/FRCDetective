import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'filehandler.dart';

import 'window_main.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

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
      var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(seconds: 10));
      serverState = const Icon(Icons.link);

      // final directory = await getApplicationDocumentsDirectory();
      // String appFilePath = directory.path;
      // s.write('{"request": "PUT_CHUNK", "data": ' + File(appFilePath + "/datastore/matchchunks/" + "Q12_0" + ".chunk").readAsStringSync() + '}');
      s.write('{"request": "GET_CHUNK", "data": {"chunkid": "Q12_0"}}');
      s.listen(
        (Uint8List data) {
          final r = String.fromCharCodes(data);
          print(jsonDecode(r));
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
