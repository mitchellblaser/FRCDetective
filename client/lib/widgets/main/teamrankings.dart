import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/styles.dart';
import 'package:FRCDetective/customcolor.dart';

import 'package:FRCDetective/window_teamviewer.dart';

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
                child: SizedBox(
                  width: 370,
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Team Rankings", style: bodyStyle))),
                      
                      Builder(
                        builder: (context) => ElevatedButton(
                          child: const Text("Show Team 5584"),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamViewerPage(teamNumber: 5584))),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
          );
  }
}