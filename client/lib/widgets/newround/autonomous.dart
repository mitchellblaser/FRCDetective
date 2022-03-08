import 'package:flutter/material.dart';
import 'package:FRCDetective/styles.dart';
import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/config.dart';

class AutonomousWidget extends StatefulWidget {
  const AutonomousWidget({Key? key}) : super (key: key);

  @override
  _AutonomousWidgetState createState() => _AutonomousWidgetState();
}

class _AutonomousWidgetState extends State<AutonomousWidget> {

  bool _didTaxi = false;

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
                            height: 200 + boxHeight,
                            child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Autonomous", style: bodyStyle))),

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
                                    const Padding(child: Text("Low Goal"), padding: EdgeInsets.only(right: 50)),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: _didTaxi,
                                      onChanged: (bool? value) {
                                        setState(() {_didTaxi = value!;});
                                      },
                                    ),
                                    const Padding(padding: EdgeInsets.only(left: 5)),
                                    const Text("Crossed Taxi Line"),
                                    const Padding(padding: EdgeInsets.only(right: 10))
                                  ],
                                )

                              ],

                            ),
                          ),
                        ),
                    );
  }
}