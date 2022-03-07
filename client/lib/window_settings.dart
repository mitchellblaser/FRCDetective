import 'package:flutter/material.dart';

import 'config.dart';
import 'filehandler.dart';
import 'customcolor.dart';

String _serverAddress = "";
String _serverPort = "";

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
                    const Text("Server Connection"),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Container(
                      width: 370,
                      child: TextField(
                        controller: TextEditingController(text: serverAddress),
                        onChanged: (String value) => {_serverAddress = value},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15, top: 35,),
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xff424242),
                          hintText: "IP Address",
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
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Container(
                      width: 370,
                      child: TextField(
                        controller: TextEditingController(text: serverPort),
                        onChanged: (String value) {_serverPort = value;},
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15, top: 35,),
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xff424242),
                          hintText: "Port",
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
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),

                    ElevatedButton(
                      child: const Text("Save Changes and Exit."),
                      onPressed: () async {
                        // file.writeAsString("$_SERVER_ADDRESS_\n$_SERVER_PORT_");
                        serverAddress = _serverAddress;
                        serverPort = _serverPort;
                        await writeFile("server.txt", "$serverAddress\n$serverPort");                        
                        Navigator.pop(context);
                      },
                    ),
                  ],)
                ),
              ],
            ),
          )),
    );
  }

}


