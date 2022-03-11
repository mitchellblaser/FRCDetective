import 'dart:convert';
import 'package:FRCDetective/widgets/newround/teleop.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sortedmap/sortedmap.dart';

import 'config.dart';
import 'filehandler.dart';
import 'database.dart';
import 'package:FRCDetective/main.dart' as mainapp;

import 'window_main.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

Map serverDiffList = {};

SortedMap sortedTeamList = SortedMap(const Ordering.byValue());
class ClientEntry {
  int totalScore;
  int entries;
  
  ClientEntry({required this.totalScore, required this.entries});
}


class RoundInformationEntry {
  bool isQualifier;
  int roundNumber;
  int teamNumber;

  int autoLowGoal;
  int autoLowMiss;
  int autoHighGoal;
  int autoHighMiss;
  bool autoCrossTaxi;

  int teleopLowGoal;
  int teleopLowMiss;
  int teleopHighGoal;
  int teleopHighMiss;
  ClimbState climb;

  String notes;

  RoundInformationEntry({
    required this.isQualifier,
    required this.roundNumber,
    required this.teamNumber,
    required this.autoLowGoal,
    required this.autoLowMiss,
    required this.autoHighGoal,
    required this.autoHighMiss,
    required this.autoCrossTaxi,
    required this.teleopLowGoal,
    required this.teleopLowMiss,
    required this.teleopHighGoal,
    required this.teleopHighMiss,
    required this.climb,
    required this.notes
  });
}

class TeamInformationEntry {
  int teamNumber;
  Map<int, RoundInformationEntry> rounds = {};

  int totalScore;
  int entries;

  TeamInformationEntry({required this.teamNumber, required this.totalScore, required this.entries});
}

Map<String, TeamInformationEntry> teamInformation = {};

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
  teamInformation = {};

  // (await getFileList())["chunks"].forEach((dynamic k, dynamic v) async {
  Iterable<String> chunkdata = (await getFileList())["chunks"].keys.toList().cast<String>();
  await Future.forEach(chunkdata, (String k) async {

    Map _fileData = jsonDecode((await readFile("datastore/matchchunks/" + k + ".chunk")).last);
    String _client = k.split("_")[1];

    int _score = _fileData["auto_goal_high"]*4 + _fileData["auto_goal_low"]*2 + _fileData["tele_goal_high"]*2 + _fileData["tele_goal_low"];
      
    if (_fileData["tele_hangar"] == "ClimbState.low") { _score = _score + 4; }
    else if (_fileData["tele_hangar"] == "ClimbState.mid") { _score = _score + 6; }
    else if (_fileData["tele_hangar"] == "ClimbState.high") { _score = _score + 10; }
    else if (_fileData["tele_hangar"] == "ClimbState.traversal") { _score = _score + 15; }

    if (_fileData["auto_taxi"] == true) { _score = _score + 2; }

    if (!teamInformation.keys.contains(_client)) {
      teamInformation[_client] = TeamInformationEntry(
        teamNumber: int.parse(_client),
        entries: 1,
        totalScore: _score
      );
    }
    else {
      teamInformation[_client]!.totalScore = teamInformation[_client]!.totalScore + _score;
      teamInformation[_client]!.entries = teamInformation[_client]!.entries + 1;
    }

    bool _qual = true;
    ClimbState _climb = ClimbState.none;
    if (_fileData["round"][0] == "F") {_qual = false;}
    if (_fileData["tele_hangar"] == "ClimbState.low") {_climb = ClimbState.low;}
    if (_fileData["tele_hangar"] == "ClimbState.mid") {_climb = ClimbState.mid;}
    if (_fileData["tele_hangar"] == "ClimbState.high") {_climb = ClimbState.high;}
    if (_fileData["tele_hangar"] == "ClimbState.traversal") {_climb = ClimbState.traversal;}

    // print();

    teamInformation[_client]!.rounds[int.parse(_fileData["round"].substring(1))] = RoundInformationEntry(
      isQualifier: _qual,
      roundNumber: int.parse(_fileData["round"].substring(1)),
      teamNumber: _fileData["team"],
      autoLowGoal: _fileData["auto_goal_low"],
      autoLowMiss: _fileData["auto_miss_low"],
      autoHighGoal: _fileData["auto_goal_high"],
      autoHighMiss: _fileData["auto_miss_high"],
      autoCrossTaxi: _fileData["auto_taxi"],
      teleopLowGoal: _fileData["tele_goal_low"],
      teleopLowMiss: _fileData["tele_miss_low"],
      teleopHighGoal: _fileData["tele_goal_high"],
      teleopHighMiss: _fileData["tele_miss_high"],
      climb: _climb,
      notes: _fileData["notes"]
    );
  });
  return;
}

void doServerUpdate() async {
  await getChunkData();

  teamInformation.forEach((key, value) {
    sortedTeamList.addAll({key.toString(): -(value.totalScore/value.entries)});
  });

  // print(sortedClientList);

  try {
    var s = await Socket.connect(serverAddress, int.parse(serverPort)).timeout(const Duration(milliseconds: serverPollIntervalMS));
    serverState = const Icon(Icons.link);
    
    // print(await getFileList());
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
        // print("done.");
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
