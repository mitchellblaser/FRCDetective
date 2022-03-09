import 'package:flutter/material.dart';
import 'package:FRCDetective/styles.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({Key? key}) : super (key: key);

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 202,
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
    );
  }
}