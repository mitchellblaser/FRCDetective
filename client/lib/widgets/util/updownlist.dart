import 'package:flutter/material.dart';

import 'package:FRCDetective/styles.dart';

class UpDownList extends StatefulWidget {
  final Function onUpdate;
  const UpDownList({Key? key, required this.onUpdate}) : super(key: key);

  @override
  _UpDownListState createState() => _UpDownListState();
}

class _UpDownListState extends State<UpDownList> {

  int _counterState = 0;

  @override
  void initState() {
    return;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        ElevatedButton(
          child: const Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            if (_counterState < 99) {
              _counterState++;
            }
            setState(() {
              
            });
            widget.onUpdate(_counterState);
          },
        ),
        Padding(child: Text(_counterState.toString().padLeft(2, "0"), style: bodyStyle,), padding: const EdgeInsets.only(left: 10, right: 10)),
        ElevatedButton(
          child: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            if (_counterState > 0) {
              _counterState--;
            }
            setState(() {
              
            });
            widget.onUpdate(_counterState);
          },
        ),
      ],
    );

  }
}