import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

import 'activitymenu.dart';
import 'yourteam.dart';

class Summary extends StatelessWidget {
  Summary({super.key});

  final EventEmitter emitter = EventEmitter();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const ActivityMenu(),
      YourTeam(emitter: emitter,),
      IconButton(onPressed: () {emitter.emit("updateYourTeam", null, [5584, 1, "5:20pm"]);}, icon: const Icon(Icons.add)),
      IconButton(onPressed: () {emitter.emit("updateYourTeam", null, [5585, 2, "5:21pm"]);}, icon: const Icon(Icons.add)),
    ]);
  }
}