import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

import 'package:frc_detective/appconfig.dart';

class YourTeam extends StatefulWidget {
  final EventEmitter emitter;

  const YourTeam({super.key, required this.emitter});

  @override   
  State<YourTeam> createState() => _YourTeamState();
}

class _YourTeamState extends State<YourTeam> {

  int _teamNumber = 1234;
  int _teamRank = 0;
  String _nextMatch = "0:00pm";

  void update(int teamNumber, int teamRank, String nextMatch) {
    setState(() {
      _teamNumber = teamNumber;
      _teamRank = teamRank;
      _nextMatch = nextMatch;
    });
  }  

  @override
  Widget build(BuildContext context) {

    widget.emitter.on("updateYourTeam", null, (event, event_context) {
      List eventdata = event.eventData as List;
      update(eventdata[0], eventdata[1], eventdata[2]);
    });

    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
      child: Container(

        decoration: BoxDecoration(color: mainColor.withAlpha(215), borderRadius: const BorderRadius.all(Radius.circular(20.0)), boxShadow: [BoxShadow(blurRadius: 4, offset: const Offset(0,2), color: Colors.black.withOpacity(0.3))],),
        width: 310,
        height: 100,

        child: Column(
          children: [

            Text("$_teamNumber", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, shadows: [BoxShadow(blurRadius: 10,)]),),
            Text("Next Match: $_nextMatch", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, shadows: [BoxShadow(blurRadius: 10,)])),
            Text("Rank: #$_teamRank", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, shadows: [BoxShadow(blurRadius: 10,)])),

          ],
        ),

      ),
    );
  }
}