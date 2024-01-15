import 'package:flutter/material.dart';
import 'package:frc_detective/appconfig.dart';

class ActivityMenu extends StatelessWidget {
  const ActivityMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 226, 226, 226), borderRadius: const BorderRadius.all(Radius.circular(20.0)), boxShadow: [BoxShadow(blurRadius: 4, offset: const Offset(0,2), color: Colors.black.withOpacity(0.3))],),
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Wrap(
          runSpacing: 6,
          children: [
            MaterialButton(onPressed: () {},
              child: Container(
                decoration: BoxDecoration(color: mainColor.withAlpha(200), borderRadius: defaultRadius,),
                padding: const EdgeInsets.all(6),
                width: 90,
                child: const Column(children: [Icon(Icons.search, color: Colors.white,), Text("View Team", style: appBarTitle,)]),
              ),
            ),

            MaterialButton(onPressed: () {},
              child: Container(
                decoration: BoxDecoration(color: mainColor.withAlpha(200), borderRadius: defaultRadius,),
                padding: const EdgeInsets.all(6),
                width: 90,
                child: const Column(children: [Icon(Icons.edit_note, color: Colors.white,), Text("Edit File", style: appBarTitle,)]),
              ),
            ),

            MaterialButton(onPressed: () {},
              child: Container(
                decoration: BoxDecoration(color: mainColor.withAlpha(200), borderRadius: defaultRadius,),
                padding: const EdgeInsets.all(6),
                width: 90,
                child: const Column(children: [Icon(Icons.add, color: Colors.white,), Text("Scout Game", style: appBarTitle, textAlign: TextAlign.center,)]),
              ),
            ),
          ]
        ),
      ),
    );
  }
}