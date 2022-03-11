import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/styles.dart';

import 'package:FRCDetective/widgets/util/updownlist.dart';

enum ClimbState {none, low, mid, high, traversal}

class TeleopWidget extends StatefulWidget {
  TeleopWidget({Key? key}) : super (key: key);

  int teleopHighGoal = 0;
  int teleopHighMiss = 0;
  int teleopLowGoal = 0;
  int teleopLowMiss = 0;
  String teleopClimb = ClimbState.none.toString();

  @override
  _TeleopWidgetState createState() => _TeleopWidgetState();
}

class _TeleopWidgetState extends State<TeleopWidget> {

  ClimbState _climbState = ClimbState.none;

  @override
  void initState() {
    super.initState();
    setState(() {

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
            height: 390 + boxHeight,
            child: Column(
              children: [
                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Teleop", style: bodyStyle))),

                const Padding(padding: EdgeInsets.only(top: 20)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(child: Text("High Goal"), padding: EdgeInsets.only(right: 50)),
                    UpDownList(
                      onUpdate: (int counter) {
                        widget.teleopHighGoal = counter;
                      },
                    )
                  ],
                ),

                const Padding(padding: EdgeInsets.only(top: 10)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(child: Text("High Miss"), padding: EdgeInsets.only(right: 50)),
                    UpDownList(
                      onUpdate: (int counter) {
                        widget.teleopHighMiss = counter;
                      },
                      color: const Color.fromARGB(255, 2, 33, 46),
                    )
                  ],
                ),

                const Padding(padding: EdgeInsets.only(top: 28)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(child: Text("Low Goal "), padding: EdgeInsets.only(right: 50)),
                    UpDownList(
                      onUpdate: (int counter) {
                        widget.teleopLowGoal = counter;
                      },
                    )
                  ],
                ),

                const Padding(padding: EdgeInsets.only(top: 10)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(child: Text("Low Miss "), padding: EdgeInsets.only(right: 50)),
                    UpDownList(
                      onUpdate: (int counter) {
                        widget.teleopLowMiss = counter;
                      },
                      color: const Color.fromARGB(255, 2, 33, 46),
                    )
                  ],
                ),

                const Padding(padding: EdgeInsets.only(top: 42)),

                const Text("Climb"),

                const Padding(padding: EdgeInsets.only(bottom: 2)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Padding(padding: EdgeInsets.only(left: 20)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                          Radio(value: ClimbState.none, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!; widget.teleopClimb = value.toString();});}),
                          const Text("None", textAlign: TextAlign.left,),
                        ]),

                        Row(
                          children: [
                          Radio(value: ClimbState.low, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!; widget.teleopClimb = value.toString();});}),
                          const Text("Low", textAlign: TextAlign.left,),
                        ]),

                        Row(
                          children: [
                          Radio(value: ClimbState.mid, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!; widget.teleopClimb = value.toString();});}),
                          const Text("Mid", textAlign: TextAlign.left,),
                        ]),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 31)),
                        Row(
                          children: [
                          Radio(value: ClimbState.high, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!; widget.teleopClimb = value.toString();});}),
                          const Text("High", textAlign: TextAlign.left,),
                        ]),

                        Row(
                          children: [
                          Radio(value: ClimbState.traversal, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!; widget.teleopClimb = value.toString();});}),
                          const Text("Traversal", textAlign: TextAlign.left,),
                        ]),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(right: 20)),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}