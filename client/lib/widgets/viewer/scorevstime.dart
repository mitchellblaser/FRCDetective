import 'package:charts_flutter/flutter.dart';
import 'package:flutter/foundation.dart';

class ScoreSeries {
  final int roundInt;
  final int scoreAutonomous;
  final int scoreTeleop;

  ScoreSeries(
    {
      required this.roundInt,
      required this.scoreAutonomous,
      required this.scoreTeleop
    }
  );

}