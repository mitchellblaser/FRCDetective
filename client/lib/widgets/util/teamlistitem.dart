import 'package:FRCDetective/customcolor.dart';
import 'package:FRCDetective/main.dart';
import 'package:flutter/material.dart';

import 'package:FRCDetective/window_teamviewer.dart';

import 'package:FRCDetective/styles.dart';

class TeamListItem extends StatefulWidget {
  String team;
  double score;
  TeamListItem({Key? key, required this.team, required this.score}) : super(key: key);

  @override
  _TeamListItemState createState() => _TeamListItemState();
}

class _TeamListItemState extends State<TeamListItem> {

  @override
  void initState() {
    return;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      // color: Colors.grey,
      child: Padding(padding: EdgeInsets.only(left: 24, right: 20, bottom: 6, top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text(widget.team, style: bodyStyle),
              Text(widget.score.abs().toString(), style: bodyItalSmallStyle),
            ]),
            IconButton(
              icon: Icon(Icons.arrow_circle_right_rounded),
              onPressed: () {
                try {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TeamViewerPage(teamNumber: int.parse(widget.team), teamInformation: teamInformation[widget.team]!,)));
                }
                on CastError {

                }
              }
            )
          ]
        ),
      )
    );
  }
}