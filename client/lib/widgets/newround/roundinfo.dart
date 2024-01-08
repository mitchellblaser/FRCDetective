import 'package:flutter/material.dart';

import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/styles.dart';

enum RoundState {rQual, rFinal}

class RoundInfoWidget extends StatefulWidget {
  RoundInfoWidget({Key? key}) : super (key: key);

  String roundString = "";
  int roundTeam = 0;

  @override
  _RoundInfoWidgetState createState() => _RoundInfoWidgetState();
}

class _RoundInfoWidgetState extends State<RoundInfoWidget> {

  RoundState _roundState = RoundState.rQual;

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Card( //TODO: Need to add team member selection - six options with manual override?
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          splashColor: customColor.withAlpha(50),
          child: SizedBox(
            width: 370,
            height: 154 + boxHeight,
            child: Column(
              children: [
                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Round Information", style: bodyStyle))),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                            Radio(value: RoundState.rQual, groupValue: _roundState, onChanged: (RoundState? value) {setState(() {_roundState = value!;});}),
                            const Text("Qualifier", textAlign: TextAlign.left,),
                          ]),

                          Row(
                            children: [
                            Radio(value: RoundState.rFinal, groupValue: _roundState, onChanged: (RoundState? value) {setState(() {_roundState = value!;});}),
                            const Text("Final", textAlign: TextAlign.left,),
                          ],)
                        ],
                      ),
                      padding: const EdgeInsets.only(top: 10, left: 16),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 22),
                      child: SizedBox(

                        width: 80,
                        child: Column(children: [
                          TextField(
                            controller: TextEditingController(text: ""),
                            onChanged: (String value) => {
                              if (_roundState == RoundState.rQual) {
                                widget.roundString = "Q" + value
                              }
                              else if (_roundState == RoundState.rFinal) {
                                widget.roundString = "F" + value
                              }
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 15, top: 35, right: 15),
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0xff424242),
                              hintText: "Rnd. #",
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
                            textAlign: TextAlign.center,
                          ),

                          const Padding(padding: EdgeInsets.only(top: 10)),

                          TextField(
                          controller: TextEditingController(text: ""),
                          onChanged: (String value) => {
                            widget.roundTeam = int.parse(value)
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15, top: 35, right: 15),
                            isDense: true,
                            filled: true,
                            fillColor: const Color(0xff424242),
                            hintText: "Team #",
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
                          textAlign: TextAlign.center,
                        )
                        ],),

                      )
                    )

                  ],
                )

              ],

            ),
          ),
        ),
    );
  }
}