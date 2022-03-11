import 'dart:convert';
import 'dart:io';

import 'package:FRCDetective/main.dart';
import 'package:FRCDetective/styles.dart';
import 'package:FRCDetective/widgets/newround/teleop.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:FRCDetective/widgets/viewer/notes.dart';

import 'config.dart';
import 'filehandler.dart';
import 'customcolor.dart';

import 'widgets/viewer/scorevstime.dart' as score_vs_time;
import 'package:FRCDetective/widgets/viewer/scorechart.dart';

String _serverAddress = "";
String _serverPort = "";

Future<String> getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  String appFilePath = directory.path;
  return appFilePath;
}

class TeamViewerPage extends StatelessWidget {
  int teamNumber;
  TeamInformationEntry teamInformation;

  TeamViewerPage({Key? key, required this.teamNumber, required this.teamInformation}) : super(key: key);
  
  double accuracyTeleopSum = 0;
  int accuracyTeleopCounter = 0;
  double accuracyAutonomousSum = 0;
  double accuracyAutonomousCounter = 0;

  List<score_vs_time.ScoreSeries> getListOfScores() {
    List<score_vs_time.ScoreSeries> _data = [];

    accuracyTeleopSum = 0;
    accuracyTeleopCounter = 0;

    accuracyAutonomousSum = 0;
    accuracyAutonomousCounter = 0;

    // for (int i=0; i < teamInformation.rounds.length; i++) {
    teamInformation.rounds.forEach((key, value) {
      // RoundInformationEntry _round = teamInformation.rounds[teamInformation.rounds.keys.toList()[i]]!;
      RoundInformationEntry _round = value;
      // print(key);
      int _autoLine = 0;
      if (_round.autoCrossTaxi = true) {
        _autoLine = 2;
      }
      int _climb = 0;
      if (_round.climb == ClimbState.low) {_climb = 4;}
      else if (_round.climb == ClimbState.mid) {_climb = 6;}
      else if (_round.climb == ClimbState.high) {_climb = 10;}
      else if (_round.climb == ClimbState.traversal) {_climb = 15;}
      _data.add(score_vs_time.ScoreSeries(
        roundInt: _round.roundNumber,
        scoreAutonomous: _round.autoHighGoal*4 + _round.autoLowGoal*2 + _autoLine,
        scoreTeleop: _round.teleopHighGoal*2 + _round.teleopLowGoal*1 + _climb
      ));

      accuracyTeleopSum = accuracyTeleopSum + (1-(_round.teleopHighMiss-_round.teleopLowMiss)/(_round.teleopHighGoal+_round.teleopLowGoal))*100;
      accuracyTeleopCounter = accuracyTeleopCounter + 1;

      accuracyAutonomousSum = accuracyAutonomousSum + (1-(_round.autoHighMiss-_round.autoLowMiss)/(_round.autoHighGoal+_round.autoLowGoal))*100;
      accuracyAutonomousCounter = accuracyAutonomousCounter + 1;
    });

    return _data;

  }

  @override
  Widget build(BuildContext context) {
    getListOfScores();
    Image teamImage = Image.asset("assets/images/logo.png");
    String rank = "";

    if (File(mainAppFilePath + "/datastore/teamimage/" + teamNumber.toString() + ".jpg").existsSync()) {
      teamImage = Image.file(File(mainAppFilePath + "/datastore/teamimage/" + teamNumber.toString() + ".jpg"));
    }
    int ranking = -1;
    int _teamCounter = 1;
    for (var key in sortedTeamList.keys.toList()) {
      if (key.toString() == teamNumber.toString()) {
        ranking = _teamCounter;
      }
      _teamCounter++;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                  Navigator.pop(context);
                },),

                Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                  height: 46,
                  filterQuality: FilterQuality.high,
                ),

                IconButton(icon: Icon(null), onPressed: () {},),
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
                          height: 94,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Average Score: " + (teamInformation.totalScore.abs()/teamInformation.entries.abs()).toStringAsFixed(2) + "pts.", style: bodyStyle))),
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Rank: " + ranking.toString()))),
                            ],
                          ),
                        ),
                      ),
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
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Score Tracker (Teleop)", style: bodyStyle))),
                              ScoreChart(data: getListOfScores()),
                            ],
                          ),
                        ),
                      ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 10)),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: customColor.withAlpha(50),
                        child: SizedBox(
                          width: 370,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Score Tracker (Autonomous)", style: bodyStyle))),
                              ScoreChartAutonomous(data: getListOfScores()),
                            ],
                          ),
                        ),
                      ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: customColor.withAlpha(50),
                        child: SizedBox(
                          width: 370,
                          height: 104,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(padding: const EdgeInsets.only(top: 12, left: 20),child: Align(alignment: Alignment.centerLeft, child: Text("Accuracy", style: bodyStyle))),
                              
                              Align(child: Padding(child: Text("Teleop: " + (accuracyTeleopSum/accuracyTeleopCounter).toStringAsFixed(2) + "%", textAlign: TextAlign.left,), padding: EdgeInsets.only(left: 20, top: 10),), alignment: Alignment.centerLeft),
                              Align(child: Padding(child: Text("Autonomous: " + (accuracyAutonomousSum/accuracyAutonomousCounter).toStringAsFixed(2) + "%", textAlign: TextAlign.left,), padding: EdgeInsets.only(left: 20),), alignment: Alignment.centerLeft),

                            ],
                          ),
                        ),
                      ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 14)),

                  for (var round in teamInformation.rounds.keys.toList()) Container(child: NotesWidget(notesContents: teamInformation.rounds[round]!.notes.toString(), roundname: (teamInformation.rounds[round]!.isQualifier ? "Q" : "F") + teamInformation.rounds[round]!.roundNumber.toString()), padding: EdgeInsets.only(bottom: 20)),

                ],
              ),
            ),
          )),
    );
  }

}


