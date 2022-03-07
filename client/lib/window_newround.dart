import 'package:flutter/material.dart';

import 'config.dart';
import 'customcolor.dart';
import 'styles.dart';

class NewRoundInfo extends StatelessWidget {
  const NewRoundInfo({Key? key}) : super(key: key);

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
                            height: 170 + boxHeight,
                            child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Round Information", style: bodyStyle))),
                                Container(padding: const EdgeInsets.only(top: 4, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Round: ", style: bodySmallStyle))),
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
                                Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Notes", style: bodyStyle)))
                              ],

                            ),
                          ),
                        ),
                    )


                  ],)
                ),
              ],
            ),
          )),
    );
  }
}