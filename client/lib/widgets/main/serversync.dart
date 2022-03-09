import 'package:flutter/material.dart';
import 'dart:async';

import 'package:FRCDetective/config.dart';
import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/styles.dart';

class ServerSyncWidget extends StatefulWidget {
  const ServerSyncWidget({Key? key}) : super (key: key);

  @override
  _ServerSyncWidgetState createState() => _ServerSyncWidgetState();
}

class _ServerSyncWidgetState extends State<ServerSyncWidget> {
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
                splashColor: Colors.grey.withAlpha(50),
                child: SizedBox(
                  width: 370,
                  height: 72 + boxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(top: 16, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("Sync With Server", style: bodyStyle))),
                      Container(padding: const EdgeInsets.only(top: 0, left: 22), child: Align(alignment: Alignment.centerLeft, child: Text("You have 3 unsaved changes.", style: bodyXSmallStyle))),
                    ],
                  ),
                ),
              ),
              color: customColor,
          );
  }
}