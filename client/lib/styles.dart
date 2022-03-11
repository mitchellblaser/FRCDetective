import 'package:flutter/material.dart';

TextStyle headerStyleShadow = const TextStyle(fontSize: 48, fontFamily: 'LeagueSpartan', shadows: <Shadow>[
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 3.0,
    color: Color.fromARGB(255, 0, 0, 0),
  ),
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 8.0,
    color: Color.fromARGB(62, 14, 14, 54),
  ),
]);
TextStyle headerStyle = const TextStyle(fontSize: 48, fontFamily: 'LeagueSpartan');
TextStyle bodyStyle = const TextStyle(fontSize: 20, fontFamily: 'Roboto', color: Colors.white);
TextStyle bodySmallStyle = const TextStyle(fontSize: 16, fontFamily: 'Roboto');
TextStyle bodyXSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto');
TextStyle bodyItalSmallStyle = const TextStyle(fontSize: 14, fontFamily: 'Roboto', fontStyle: FontStyle.italic, color: Colors.white);
TextStyle bodyItalSmallStyleShadow = const TextStyle(fontSize: 14, fontFamily: 'Roboto', fontStyle: FontStyle.italic, color: Colors.white, shadows: <Shadow>[
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 2.0,
    color: Color.fromARGB(255, 0, 0, 0),
  ),
  Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 8.0,
    color: Color.fromARGB(62, 14, 14, 54),
  ),
]);