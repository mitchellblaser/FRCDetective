import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';

import 'config.dart';
import 'filehandler.dart';
import 'customcolor.dart';

import 'widgets/main/teaminformation.dart';
import 'widgets/main/serversync.dart';
import 'widgets/main/livestream.dart';
import 'widgets/main/teamrankings.dart';

//TODO: This does not currently support web applications because of the incompatible WebSocket. Create wrapper?

Icon serverState = const Icon(Icons.hourglass_bottom);

void doServerUpdateInitial() async {
  final List<String> f = await readFile("server.txt");
  _SERVER_ADDRESS_ = f[0];
  _SERVER_PORT_ = f[1];

  doServerUpdate();
  return;
}

void doServerUpdate() async {
    try {
      var s = await Socket.connect(_SERVER_ADDRESS_, int.parse(_SERVER_PORT_)).timeout(const Duration(seconds: 10)); //TODO: Error checking here in case server is not available
      serverState = const Icon(Icons.link);
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

String _SERVER_ADDRESS_ = "";
String _SERVER_PORT_ = "";

String __SERVER_ADDRESS_ = "";
String __SERVER_PORT_ = "";

// double _boxHeight = 0;
String _logoPath = "assets/images/logo.png";

void main() {
  // Platform-specific code...
  if (!kIsWeb) {
    if (Platform.isWindows) {
      boxHeight = 14;
      _logoPath = "assets/images/logo-small.png";
    }
  }
  // Run GUI
  runApp(const DetectiveApp());
  // Start Periodic Functions
  Timer.periodic(const Duration(milliseconds: serverPollIntervalMS), (Timer t) => { doServerUpdate() });
  doServerUpdateInitial();
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
                  icon: serverState,
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
                    icon: const Icon(Icons.settings),
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
                        onChanged: (String value) => {__SERVER_ADDRESS_ = value},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15, top: 35,),
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
                        style: const TextStyle(fontFamily: 'LeagueSpartan'),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Container(
                      width: 370,
                      child: TextField(
                        controller: TextEditingController(text: _SERVER_PORT_),
                        onChanged: (String value) {__SERVER_PORT_ = value; print("value: $value");},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15, top: 35,),
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
                        style: const TextStyle(fontFamily: 'LeagueSpartan'),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),

                    ElevatedButton(
                      child: const Text("Save Changes and Exit."),
                      onPressed: () async {
                        // file.writeAsString("$_SERVER_ADDRESS_\n$_SERVER_PORT_");
                        _SERVER_ADDRESS_ = __SERVER_ADDRESS_;
                        _SERVER_PORT_ = __SERVER_PORT_;
                        print("$_SERVER_ADDRESS_\n$_SERVER_PORT_");
                        await writeFile("server.txt", "$_SERVER_ADDRESS_\n$_SERVER_PORT_");                        
                        Navigator.pop(context);
                      },
                    ),
                    
                    ElevatedButton(
                      child: const Text("CHECK FILE"),
                      onPressed: () async {
                        // file.writeAsString("$_SERVER_ADDRESS_\n$_SERVER_PORT_");
                        print(await readFile("server.txt"));
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