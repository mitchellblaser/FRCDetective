import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/styles.dart';
import 'package:FRCDetective/customcolor.dart';

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
                child: SizedBox(
                  width: 370,
                  height: 72,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.only(left: 25, bottom: 5), child: Icon(Icons.play_circle, size: 40),),
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