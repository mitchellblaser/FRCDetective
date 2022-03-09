import 'package:flutter/material.dart';

const String applicationName = "FRCDetective";
const int serverPollIntervalMS = 10000;
double boxHeight = 0;
String logoPath = "assets/images/logo.png";

String serverAddress = "";
String serverPort = "";

Icon serverState = const Icon(Icons.hourglass_bottom);