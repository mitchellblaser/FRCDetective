import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/styles.dart';

enum RoundState {rQual, rFinal}

class RoundInfoWidget extends StatefulWidget {
  const RoundInfoWidget({Key? key}) : super (key: key);

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
            height: 120 + boxHeight,
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
                      child: Container(

                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: ""),
                          onChanged: (String value) => {},
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