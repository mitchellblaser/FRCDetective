import 'dart:convert';

import 'package:flutter/material.dart';

import 'config.dart';
import 'customcolor.dart';

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
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Column(children: [
                    
                    const RoundInfoWidget(),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const AutonomousWidget(),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const TeleopWidget(),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    const NotesWidget(),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        ElevatedButton(
                          // Save Button
                          child: const Icon(Icons.save),
                          onPressed: () { 
                            String out = jsonEncode(
                              {"data": {
                                "epoch_since_modify": (DateTime.now().millisecondsSinceEpoch/1000),
                                "chunkid": "Q1_5584",
                                "team": 5584,
                                "round": "",
                                "auto_goal_high": 0,
                                "auto_goal_low": 0,
                                "auto_taxi": false,
                                "tele_goal_high": 0,
                                "tele_goal_low": 0,
                                "tele_hangar": "none",
                              }}
                            );
                            Navigator.pop(context);
                            print(out);
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