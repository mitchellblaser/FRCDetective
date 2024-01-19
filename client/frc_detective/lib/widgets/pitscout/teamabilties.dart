import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/services.dart';

import 'package:frc_detective/appconfig.dart';

class TeamAbilities extends StatefulWidget {

  const TeamAbilities({super.key});

  @override   
  State<TeamAbilities> createState() => _TeamAbilitiesState();
}

class _TeamAbilitiesState extends State<TeamAbilities> {

  bool _climb = false;
  bool _groundNote = false;
  bool _chuteNote = false;
  bool _speakerShoot = false;
  bool _scoreAmp = false;
  bool _scoreTrap = false;
  List<DropdownMenuEntry> drivebaseTypes = [const DropdownMenuEntry(value: null, label: "DriveBase?"), const DropdownMenuEntry(value: null, label: "Swerve"), const DropdownMenuEntry(value: null, label: "tank")];

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.all(30),
        width: 250,
        child: Column(children: [

        TextField(keyboardType: TextInputType.number, decoration: InputDecoration(hintText: "Team number"), inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]),
        
        CheckboxListTile(title: Text("Climb"),value: _climb, onChanged: (bool? climbCheck) {
          if (climbCheck !=null){
            setState(() {
              _climb = climbCheck;
            });
          }
        }),
        
        CheckboxListTile(title: Text("Ground pickup"),value: _groundNote, onChanged: (bool? groundPickupCheck) {
          if (groundPickupCheck !=null){
            setState(() {
              _groundNote = groundPickupCheck;
            });
          }
        }),

        CheckboxListTile(title: Text("Chute pickup"),value: _chuteNote, onChanged: (bool? chutePickupCheck) {
          if (chutePickupCheck !=null){
            setState(() {
              _chuteNote = chutePickupCheck;
            });
          }
        }),

        CheckboxListTile(title: Text("Shoot speaker"),value: _speakerShoot, onChanged: (bool? shootSpeakerCheck) {
          if (shootSpeakerCheck !=null){
            setState(() {
              _speakerShoot = shootSpeakerCheck;
            });
          }
        }),

        CheckboxListTile(title: Text("Score amp"),value: _scoreAmp, onChanged: (bool? ampScoreCheck) {
          if (ampScoreCheck !=null){
            setState(() {
              _scoreAmp = ampScoreCheck;
            });
          }
        }),

        CheckboxListTile(title: Text("Score trap"),value: _scoreTrap, onChanged: (bool? trapScoreCheck) {
          if (trapScoreCheck !=null){
            setState(() {
              _scoreTrap = trapScoreCheck;
            });
          }
        }),

        DropdownMenu(dropdownMenuEntries: drivebaseTypes),
        
      ],),

      );
  }

}