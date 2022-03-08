import 'package:flutter/material.dart';

import 'config.dart';
import 'customcolor.dart';
import 'styles.dart';

enum roundState {rQual, rFinal}

class NewRoundInfo extends StatefulWidget {
  const NewRoundInfo({Key? key}) : super(key: key);

  @override
  _NewRoundInfoState createState() => _NewRoundInfoState();
}

class _NewRoundInfoState extends State<NewRoundInfo> {

  roundState _roundState = roundState.rQual;

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
                    
                    Card(
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
                                            Radio(value: roundState.rQual, groupValue: _roundState, onChanged: (roundState? value) {setState(() {_roundState = value!;});}),
                                            const Text("Qualifier", textAlign: TextAlign.left,),
                                          ],),

                                          Row(
                                            children: [
                                            Radio(value: roundState.rFinal, groupValue: _roundState, onChanged: (roundState? value) {setState(() {_roundState = value!;});}),
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
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          splashColor: customColor.withAlpha(50),
                          child: SizedBox(
                            width: 370,
                            height: 170 + boxHeight,
                            child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Autonomous", style: bodyStyle)))
                              ],

                            ),
                          ),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          splashColor: customColor.withAlpha(50),
                          child: SizedBox(
                            width: 370,
                            height: 170 + boxHeight,
                            child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Teleop", style: bodyStyle)))
                              ],

                            ),
                          ),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),

                    Container(
                      width: 370,
                      height: 205,
                      decoration: const BoxDecoration(
                        color: Color(0xFF424242),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),

                      child: Column(children: [
                        Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Notes", style: bodyStyle))),

                        Container(
                          padding: const EdgeInsets.only(left:15, right: 15, top: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(255, 75, 75, 75),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          )
                        )
                      ],)
                    ),
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