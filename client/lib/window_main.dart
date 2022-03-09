import 'package:flutter/material.dart';
import 'dart:async';

import 'config.dart';
import 'customcolor.dart';

import 'widgets/main/teaminformation.dart';
import 'widgets/main/serversync.dart';
import 'widgets/main/livestream.dart';
import 'widgets/main/teamrankings.dart';

import 'window_newround.dart';
import 'window_settings.dart';

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
                  logoPath,
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