import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/window_teamviewer.dart';
import 'package:FRCDetective/main.dart';

import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/styles.dart';

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
          child: SizedBox(
            width: 370,
            height: 180,
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