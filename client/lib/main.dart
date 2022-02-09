import 'package:flutter/material.dart';

const String applicationName = "FRCDetective";

void main() {
  runApp(DetectiveApp());
}

class DetectiveApp extends StatelessWidget {
  const DetectiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Return a different scaffold with two columns for tablets/laptops.
      title: applicationName,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(applicationName),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print("Hello World");
                      },
                      child: SizedBox(
                        width: 370,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: Text("Your Team"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
