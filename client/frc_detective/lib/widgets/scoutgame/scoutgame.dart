import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';

import 'package:frc_detective/appconfig.dart';

class ScoutGame extends StatelessWidget {
  const ScoutGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Scout Game", style: appBarTitle,),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: const Column(children: [



      ],),

    );
  }
}