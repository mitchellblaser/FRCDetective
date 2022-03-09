import 'package:flutter/material.dart';

import 'config.dart';
import 'customcolor.dart';
import 'styles.dart';

import 'widgets/newround/roundinfo.dart';
import 'widgets/newround/notes.dart';
import 'widgets/newround/autonomous.dart';

enum ClimbState {none, low, mid, high, traversal}

class NewRoundInfo extends StatefulWidget {
  const NewRoundInfo({Key? key}) : super(key: key);

  @override
  _NewRoundInfoState createState() => _NewRoundInfoState();
}

class _NewRoundInfoState extends State<NewRoundInfo> {

  ClimbState _climbState = ClimbState.low;

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

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          splashColor: customColor.withAlpha(50),
                          child: SizedBox(
                            width: 370,
                            height: 300 + boxHeight,
                            child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Teleop", style: bodyStyle))),

                                const Padding(padding: EdgeInsets.only(top: 20)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Padding(child: Text("High Goal"), padding: EdgeInsets.only(right: 50)),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          child: const Icon(Icons.keyboard_arrow_up),
                                          onPressed: () {},
                                        ),
                                        Padding(child: Text("69", style: bodyStyle,), padding: const EdgeInsets.only(left: 10, right: 10)),
                                        ElevatedButton(
                                          child: const Icon(Icons.keyboard_arrow_down),
                                          onPressed: () {},
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const Padding(padding: EdgeInsets.only(top: 20)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Padding(child: Text("Low Goal "), padding: EdgeInsets.only(right: 50)),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          child: const Icon(Icons.keyboard_arrow_up),
                                          onPressed: () {},
                                        ),
                                        Padding(child: Text("69", style: bodyStyle,), padding: const EdgeInsets.only(left: 10, right: 10)),
                                        ElevatedButton(
                                          child: const Icon(Icons.keyboard_arrow_down),
                                          onPressed: () {},
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const Padding(padding: EdgeInsets.only(top: 42)),

                                Text("Climb"),

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
                                          Radio(value: ClimbState.none, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!;});}),
                                          const Text("None", textAlign: TextAlign.left,),
                                        ]),

                                        Row(
                                          children: [
                                          Radio(value: ClimbState.low, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!;});}),
                                          const Text("Low", textAlign: TextAlign.left,),
                                        ]),

                                        Row(
                                          children: [
                                          Radio(value: ClimbState.mid, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!;});}),
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
                                          Radio(value: ClimbState.high, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!;});}),
                                          const Text("High", textAlign: TextAlign.left,),
                                        ]),

                                        Row(
                                          children: [
                                          Radio(value: ClimbState.traversal, groupValue: _climbState, onChanged: (ClimbState? value) {setState(() {_climbState = value!;});}),
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
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),

                    const NotesWidget(),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        ElevatedButton(
                          // Save Button
                          child: const Icon(Icons.save),
                          onPressed: () { Navigator.pop(context); },
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