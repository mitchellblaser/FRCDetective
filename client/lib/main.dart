import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

const String applicationName = "FRCDetective";

Icon ServerState = Icon(Icons.hourglass_bottom);

int serverPollIntervalMS = 10000;

void doServerUpdate_initial() async {
  final directory = await getApplicationDocumentsDirectory();
  final AppFilePath = directory.path;

  try {
    final List<String> contents = await File(AppFilePath + "/server.txt").readAsLines();
    print("CONTENTS0 $contents[0]");
    print("CONTENTS1 $contents[1]");
  } 
  on FileSystemException catch (e) {
    return;
  }

  doServerUpdate();
}

void doServerUpdate() async {
    try {
      var s = await Socket.connect(_SERVER_ADDRESS_, int.parse(_SERVER_PORT_)).timeout(const Duration(seconds: 10)); //TODO: Error checking here in case server is not available
      s.write('{"request": "PUT_TEAM", "data": {"teamnumber": "5584"}}');
      s.listen(
        (Uint8List data) {
          final r = String.fromCharCodes(data);
          print('$r');
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
    on TimeoutException catch (e) {
      return;
    }
    on FormatException catch (e) {
      print("FormatException: $e");
      ServerState = Icon(Icons.warning);
      return;
    }
}

double _boxHeight = 0;
String _logoPath = "assets/images/logo.png";

String _SERVER_ADDRESS_ = "";
String _SERVER_PORT_ = "";

void main() {
  // Platform-specific code...
  if (!kIsWeb) {
    if (Platform.isWindows) {
      _boxHeight = 14;
      _logoPath = "assets/images/logo-small.png";
    }
  }
  // Run GUI
  runApp(const DetectiveApp());
  // Start Periodic Functions
  Timer.periodic(Duration(milliseconds: serverPollIntervalMS), (Timer t) => { doServerUpdate() });
  doServerUpdate_initial();
}

TextStyle headerStyle = const TextStyle(fontSize: 48, fontFamily: 'LeagueSpartan');
TextStyle bodyStyle = const TextStyle(fontSize: 20, fontFamily: 'Roboto', color: Colors.white);
TextStyle bodySmallStyle = const TextStyle(fontSize: 16, fontFamily: 'Roboto');
TextStyle bodyXSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto');
TextStyle bodyItalSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto', fontStyle: FontStyle.italic, color: Colors.white);

const _customColorValue = 0xFF000A59;
const MaterialColor customColor = MaterialColor(
  _customColorValue,
  <int, Color>{
    50: Color(0xFF000A59),
    100: Color(0xFF000A59),
    200: Color(0xFF000A59),
    300: Color(0xFF000A59),
    400: Color(0xFF000A59),
    500: Color(0xFF000A59),
    600: Color(0xFF000A59),
    700: Color(0xFF000A59),
    800: Color(0xFF000A59),
    900: Color(0xFF000A59),
  }
);

class TeamInformationWidget extends StatefulWidget {
  const TeamInformationWidget({Key? key}) : super (key: key);
  
  @override
  _TeamInformationWidgetState createState() => _TeamInformationWidgetState();
}

class _TeamInformationWidgetState extends State<TeamInformationWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(const Duration(milliseconds: 100), (Timer t) => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: customColor.withAlpha(50),
                // onTap: () {

                // },
                child: SizedBox(
                  width: 370,
                  height: 170 + _boxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Your Team", style: bodyStyle))),
                      Container(padding: const EdgeInsets.only(top: 2, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("5584", style: headerStyle))),
                      Container(padding: const EdgeInsets.only(top: 6, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Chance of Victory: 58.2%", style: bodyItalSmallStyle))),
                      Container(padding: const EdgeInsets.only(top: 0, left: 20), child: Align(alignment: Alignment.centerLeft,
                        child: RichText(text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "Qualifier 36 ", style: bodyStyle),
                            TextSpan(text: "at 11:17am today.", style: bodyItalSmallStyle)
                          ]
                        ))
                      )),
                      
                      Container(padding: const EdgeInsets.only(top: 4, left: 20), child: Align(alignment: Alignment.centerLeft,
                        child: RichText(text: TextSpan(
                          style: bodySmallStyle,
                          children: const <TextSpan>[
                            TextSpan(text: "5584 ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            TextSpan(text: "1234 5678 ", style: TextStyle(color: Colors.blue)),
                            TextSpan(text: "9123 4567 8910", style: TextStyle(color: Colors.red))
                          ]
                        ))
                      ))

                    ],
                  ),
                ),
              ),
          );
  }
}

class ServerSyncWidget extends StatefulWidget {
  const ServerSyncWidget({Key? key}) : super (key: key);

  @override
  _ServerSyncWidgetState createState() => _ServerSyncWidgetState();
}

class _ServerSyncWidgetState extends State<ServerSyncWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(const Duration(milliseconds: 100), (Timer t) => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey.withAlpha(50),
                onTap: () {
                  print("Hello World");
                },
                child: SizedBox(
                  width: 370,
                  height: 72 + _boxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Sync With Server", style: bodyStyle))),
                      Container(padding: const EdgeInsets.only(top: 0, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("You have 3 unsaved changes.", style: bodyXSmallStyle))),
                    ],
                  ),
                ),
              ),
              color: customColor,
          );
  }
}

class LiveStreamWidget extends StatefulWidget {
  const LiveStreamWidget({Key? key}) : super (key: key);

  @override
  _LiveStreamWidgetState createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<LiveStreamWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(const Duration(milliseconds: 100), (Timer t) => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: customColor.withAlpha(50),
                onTap: () {
                  print("Hello World");
                },
                child: SizedBox(
                  width: 370,
                  height: 72 + _boxHeight,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.only(left: 25, bottom: 5), child: Image.asset("assets/images/livestream_icon.png", fit: BoxFit.contain, height: 44)),
                    Column(
                      children: [
                        Container(padding: const EdgeInsets.only(top: 16, left: 20), child: Align(alignment: Alignment.centerLeft, child: Text("Your event is live.", style: bodyStyle))),
                        Container(padding: const EdgeInsets.only(top: 0, left: 0), child: Align(alignment: Alignment.centerLeft, child: Text("Click here to tune in.", style: bodyXSmallStyle))),
                      ],
                    ),
                  ],)
                ),
              ),
          );
  }
}

class TeamRankingsWidget extends StatefulWidget {
  const TeamRankingsWidget({Key? key}) : super (key: key);

  @override
  _TeamRankingsWidgetState createState() => _TeamRankingsWidgetState();
}

class _TeamRankingsWidgetState extends State<TeamRankingsWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(const Duration(milliseconds: 100), (Timer t) => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: customColor.withAlpha(50),
                onTap: () {
                  print("Hello World");
                },
                child: SizedBox(
                  width: 370,
                  height: 400 + _boxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Team Rankings", style: bodyStyle))),

                    ],
                  ),
                ),
              ),
          );
  }
}


var _teamInformationWidget = const TeamInformationWidget();
var _serverSyncWidget = const ServerSyncWidget();
var _liveStreamWidget = const LiveStreamWidget();
var _teamRankingsWidget = const TeamRankingsWidget();

class DetectiveApp extends StatefulWidget {
  const DetectiveApp({Key? key}) : super(key: key);

  @override
  _DetectiveAppState createState() => _DetectiveAppState();
}

class _DetectiveAppState extends State<DetectiveApp> {

  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(const Duration(milliseconds: 100), (Timer t) => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Return a different scaffold with two columns for tablets/laptops.
      title: applicationName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: customColor,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white)
        )
      ),
      home: Scaffold(
          appBar: AppBar(
            // title: const Text(applicationName),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                IconButton(
                  icon: ServerState,
                  // icon: Icon(Icons.link_off),
                  // icon: Icon(Icons.link),
                  onPressed: () => print("Settings"),
                ),

                Image.asset(
                  _logoPath,
                  fit: BoxFit.contain,
                  height: 46,
                  filterQuality: FilterQuality.high,
                ),
                
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  ),
                ),
                
              ],
            ),
            backgroundColor: customColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Column(children: [
                    _teamInformationWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _serverSyncWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _liveStreamWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _teamRankingsWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                  ],)
                ),
              ],
            ),
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRoundInfo())),
              backgroundColor: customColor,
              child: const Icon(Icons.add_chart_sharp, color: Colors.white)
            ),
          ),
          ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {

    return MaterialApp(
      // TODO: Return a different scaffold with two columns for tablets/laptops.
      title: applicationName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: customColor,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white)
        )
      ),
      home: Scaffold(
          appBar: AppBar(
            // title: const Text(applicationName),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _logoPath,
                  fit: BoxFit.contain,
                  height: 46,
                  filterQuality: FilterQuality.high,
                )
              ],
            ),
            backgroundColor: customColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Column(children: [
                    const Text("Server Connection"),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Container(
                      width: 370,
                      child: TextField(
                        controller: TextEditingController(text: _SERVER_ADDRESS_),
                        onSubmitted: (String value) => {_SERVER_ADDRESS_ = value},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15, top: 35,),
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xff424242),
                          hintText: "IP Address",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(30),
                          )
                        ),
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Container(
                      width: 370,
                      child: TextField(
                        controller: TextEditingController(text: _SERVER_PORT_),
                        onSubmitted: (String value) => {_SERVER_PORT_ = value},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15, top: 35,),
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xff424242),
                          hintText: "Port",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(30),
                          )
                        ),
                        style: TextStyle(fontFamily: 'LeagueSpartan'),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),

                    ElevatedButton(
                      child: const Text("Save Changes and Exit."),
                      onPressed: () async {
                        final directory = await getApplicationDocumentsDirectory();
                        final AppFilePath = directory.path;
                        print("APPFILEPATH $AppFilePath");
                        final file = await File(AppFilePath + "/server.txt");
                        file.writeAsString("$_SERVER_ADDRESS_\n$_SERVER_PORT_");
                        Navigator.pop(context);
                      },
                    ),
                  ],)
                ),
              ],
            ),
          )),
    );
  }

}


class NewRoundInfo extends StatelessWidget {
  const NewRoundInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // TODO: Return a different scaffold with two columns for tablets/laptops.
      title: applicationName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: customColor,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white)
        )
      ),
      home: Scaffold(
          appBar: AppBar(
            // title: const Text(applicationName),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _logoPath,
                  fit: BoxFit.contain,
                  height: 46,
                  filterQuality: FilterQuality.high,
                )
              ],
            ),
            backgroundColor: customColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Column(children: [
                    const Text("Hello World"),
                    ElevatedButton(
                      child: const Text("Go Back"),
                      onPressed: () {Navigator.pop(context);},
                    ),
                  ],)
                ),
              ],
            ),
          )),
    );
  }
}