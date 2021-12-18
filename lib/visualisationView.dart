import 'dart:math';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'package:http/http.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Visualisation extends StatefulWidget {
  const Visualisation({Key? key}) : super(key: key);

  @override
  _VisualisationState createState() => _VisualisationState();
}

class _VisualisationState extends State<Visualisation> {
  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    List<String> commits = data["commits"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        charts.ScatterPlotChart(seriesList, animate: animate);
      ],
    );
  }
}
