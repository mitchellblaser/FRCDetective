import 'package:FRCDetective/widgets/viewer/scorevstime.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ScoreChart extends StatelessWidget {
  final List<ScoreSeries> data;

  ScoreChart({required this.data});

  @override
  Widget build(BuildContext context) {
    
    List<charts.Series<ScoreSeries, num>> series = [
      charts.Series(
        id: "score",
        data: data,
        domainFn: (ScoreSeries series, _) => series.roundInt,
        measureFn: (ScoreSeries series, _) => series.scoreTeleop,
        colorFn: (ScoreSeries series, _) => charts.Color.fromHex(code: "#a1abff"),
        )
    ];

    return Expanded(
      child: charts.LineChart(
        series,
        domainAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          // viewport: charts.NumericExtents(0, 60),
          renderSpec: charts.GridlineRendererSpec(labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white))
        ),
        animate: false,
        primaryMeasureAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          // viewport: charts.NumericExtents(0, 40),
          renderSpec: charts.GridlineRendererSpec(labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white))
        ),
      )
    );

  }
}

class ScoreChartAutonomous extends StatelessWidget {
  final List<ScoreSeries> data;

  ScoreChartAutonomous({required this.data});

  @override
  Widget build(BuildContext context) {
    
    List<charts.Series<ScoreSeries, num>> series = [
      charts.Series(
        id: "score",
        data: data,
        domainFn: (ScoreSeries series, _) => series.roundInt,
        measureFn: (ScoreSeries series, _) => series.scoreAutonomous,
        colorFn: (ScoreSeries series, _) => charts.Color.fromHex(code: "#eb4034"),
        )
    ];

    return Expanded(
      child: charts.LineChart(
        series,
        domainAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          // viewport: charts.NumericExtents(0, 60),
          renderSpec: charts.GridlineRendererSpec(labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white))
        ),
        animate: false,
        primaryMeasureAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          // viewport: charts.NumericExtents(0, 20),
          renderSpec: charts.GridlineRendererSpec(labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white))
        ),
      )
    );

  }
}