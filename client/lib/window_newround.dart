import 'dart:convert';

import 'package:flutter/material.dart';

import 'config.dart';
import 'customcolor.dart';
import 'filehandler.dart';

import 'widgets/newround/roundinfo.dart';
import 'widgets/newround/notes.dart';
import 'widgets/newround/autonomous.dart';
import 'widgets/newround/teleop.dart';

class NewRoundInfo extends StatefulWidget {
  const NewRoundInfo({Key? key}) : super(key: key);

  @override
  _NewRoundInfoState createState() => _NewRoundInfoState();
}

class _NewRoundInfoState extends State<NewRoundInfo> {

  RoundInfoWidget roundInfoWidget = RoundInfoWidget();
  AutonomousWidget autonomousWidget = AutonomousWidget();
  TeleopWidget teleopWidget = TeleopWidget();
  NotesWidget notesWidget = NotesWidget();

  @override
  void initState() {
    return;
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
          titleLarge: TextStyle(color: Colors.white)
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
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Column(children: [
                    
                    roundInfoWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    autonomousWidget,
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    teleopWidget,
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    notesWidget,
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        ElevatedButton(
                          // Save Button
                          child: const Icon(Icons.save),
                          onPressed: () { 
                            String chunkid = roundInfoWidget.roundString + "_" + roundInfoWidget.roundTeam.toString();
                            String out = jsonEncode(
                              {
                                "epoch_since_modify": (DateTime.now().millisecondsSinceEpoch/1000),
                                "user": "DetectiveApp", //TODO: This needs to be an individual ID
                                "chunkid": chunkid,
                                "team": roundInfoWidget.roundTeam,
                                "round": roundInfoWidget.roundString,
                                "auto_goal_high": autonomousWidget.autonomousHighGoal,
                                "auto_miss_high": autonomousWidget.autonomousHighMiss,
                                "auto_goal_low": autonomousWidget.autonomousLowGoal,
                                "auto_miss_low": autonomousWidget.autonomousLowMiss,
                                "auto_taxi": autonomousWidget.autonomousDidTaxi,
                                "tele_goal_high": teleopWidget.teleopHighGoal,
                                "tele_miss_high": teleopWidget.teleopHighMiss,
                                "tele_goal_low": teleopWidget.teleopLowGoal,
                                "tele_miss_low": teleopWidget.teleopLowMiss,
                                "tele_hangar": teleopWidget.teleopClimb,
                                "notes": notesWidget.notesContents,
                              }
                            );
                            writeFile("datastore/matchchunks/" + chunkid + ".chunk", out);
                            Navigator.pop(context);
                          },
                        ),

                        const Padding(padding: EdgeInsets.only(left: 50)),

                        ElevatedButton(
                          // Delete Button
                          child: const Icon(Icons.delete),
                          onPressed: () { Navigator.pop(context); },
                        ),
                      ],
                    ),

                    const Padding(padding: EdgeInsets.only(top: 25)),


                  ],)
                ),
              ],
            ),
          )),
    );
  }
}