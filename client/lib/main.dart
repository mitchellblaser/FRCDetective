import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/rendering.dart';

const String applicationName = "FRCDetective";

int counter = 0;
void update_elements() {
  counter++;
  return;
}

double _boxHeight = 14;
String _logoPath = "assets/images/logo.png";

void main() {
  runApp(const DetectiveApp());
  Timer.periodic(const Duration(milliseconds: 200), (Timer t) => { update_elements() });
  // Platform-specific code...
  if (Platform.isAndroid) {
    _boxHeight = 0;
  } else if (Platform.isWindows) {
    _logoPath = "assets/images/logo-small.png";
  }
}

TextStyle headerStyle = const TextStyle(fontSize: 48, fontFamily: 'LeagueSpartan');
TextStyle bodyStyle = const TextStyle(fontSize: 20, fontFamily: 'Roboto');
TextStyle bodySmallStyle = const TextStyle(fontSize: 16, fontFamily: 'Roboto');
TextStyle bodyXSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto');
TextStyle bodyItalSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto', fontStyle: FontStyle.italic);

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
                      Container(padding: const EdgeInsets.only(top: 2, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text(counter.toString(), style: headerStyle))),
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
                  height: 67 + _boxHeight,
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
                  height: 67 + _boxHeight,
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

class DetectiveApp extends StatelessWidget {
  const DetectiveApp({Key? key}) : super(key: key);

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