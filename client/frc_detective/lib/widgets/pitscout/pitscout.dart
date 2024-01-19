import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

import 'package:frc_detective/appconfig.dart';
import 'teamabilties.dart';

class PitScouting extends StatelessWidget {
  const PitScouting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Pit Scouting", style: appBarTitle,),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(children: [TeamAbilities(),],),

    );
  }
}