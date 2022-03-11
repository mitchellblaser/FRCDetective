import 'dart:convert';
import 'dart:io';

import 'package:FRCDetective/main.dart';
import 'package:FRCDetective/styles.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'filehandler.dart';
import 'customcolor.dart';

import 'widgets/viewer/scorevstime.dart' as score_vs_time;

String _serverAddress = "";
String _serverPort = "";

Future<String> getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;
  return appFilePath;
}

class TeamViewerPage extends StatelessWidget {
  int teamNumber;

  TeamViewerPage({Key? key, required this.teamNumber}) : super(key: key);

  score_vs_time.ScoreSeries round1 = score_vs_time.ScoreSeries(roundInt: 1, scoreAutonomous: 12, scoreTeleop: 18);
  score_vs_time.ScoreSeries round2 = score_vs_time.ScoreSeries(roundInt: 2, scoreAutonomous: 14, scoreTeleop: 19);
  score_vs_time.ScoreSeries round3 = score_vs_time.ScoreSeries(roundInt: 3, scoreAutonomous: 13, scoreTeleop: 14);

  @override
  Widget build(BuildContext context) {

  Image teamImage = Image.asset("assets/images/logo.png");

    try {
      teamImage = Image.file(File(mainAppFilePath + "/datastore/teamimage/" + teamNumber.toString() +".jpg"));
    }
    on FileSystemException {
      debugPrint("No Image for Team Found.");
    }
    
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
                  logoPath,
                  fit: BoxFit.contain,
                  height: 46,
                  filterQuality: FilterQuality.high,
                )
              ],
            ),
            backgroundColor: customColor,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [

                  const Padding(padding: EdgeInsets.only(top: 12)),
                  Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      child: SizedBox(
                        width: 370,
                        height: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(padding: const EdgeInsets.only(top: 20, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text(teamNumber.toString(), style: headerStyleShadow))),
                            Container(padding: const EdgeInsets.only(top: 0, left: 23),child: Align(alignment: Alignment.centerLeft, child: Text("Team Name", style: bodyItalSmallStyleShadow))),
                            
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: teamImage.image,
                          fit: BoxFit.cover,
                        )
                      ),
                    )
                  ),

                  const Padding(padding: EdgeInsets.only(top: 10)),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: customColor.withAlpha(50),
                        child: SizedBox(
                          width: 370,
                          height: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Score vs Time", style: bodyStyle))),
                            ],
                          ),
                        ),
                      ),
                  )

                ],
              ),
            )
            
            
          )),
    );
  }

}


