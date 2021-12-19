import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'package:http/http.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'functions.dart';

class Visualisation extends StatefulWidget {
  const Visualisation({Key? key}) : super(key: key);

  @override
  _VisualisationState createState() => _VisualisationState();
}

class _VisualisationState extends State<Visualisation> {
  late List<Commit> commitObjects;
  late List<Point> points;
  late List<Point> lineOfBestFitPoints;
  late double maxX;
  late double maxY;
  late double m;
  late double c;

  late double xRangeStart;
  late double xRangeEnd;
  late double yRangeStart;
  late double yRangeEnd;

  late double graphXRangeStart;
  late double graphXRangeEnd;
  late double graphYRangeStart;
  late double graphYRangeEnd;

  Map data = {};
  bool slidersJustChanged = false;
  bool slidersFinishedChanging = false;
  bool viewingLinesAdded = true;
  bool viewingLinesDeleted = false;
  bool viewingSum = false;
  bool viewingDifference = false;
  bool firstRun = true;
  String labelText = "Lines Added";
  @override
  Widget build(BuildContext context) {
    if(!slidersJustChanged) {
      data = ModalRoute.of(context)!.settings.arguments as Map;
      List<String> commits = data["commits"];
      if(firstRun || !slidersFinishedChanging){
        print("///////////////////////");
        commitObjects = getCommitObjectsFromStringList(commits, double.negativeInfinity, double.infinity, double.negativeInfinity, double.infinity, viewingLinesAdded, viewingLinesDeleted, viewingSum);
        points = getLineOfBestFitPoints(commitObjects, viewingLinesAdded, viewingLinesDeleted, viewingSum);
        maxX = points[2].x;
        maxY = points[2].y;
        firstRun = false;
      }else{
        print("========================");
        commitObjects = getCommitObjectsFromStringList(commits, xRangeStart, xRangeEnd, yRangeStart, yRangeEnd, viewingLinesAdded, viewingLinesDeleted, viewingSum);
        points = getLineOfBestFitPoints(commitObjects, viewingLinesAdded, viewingLinesDeleted, viewingSum);
      }
      lineOfBestFitPoints = points.sublist(0, 2);
      m = points.last.x;
      c = points.last.y;
      if(!slidersFinishedChanging){
        xRangeStart = 0;
        xRangeEnd = maxX;
        yRangeStart = 0;
        yRangeEnd = maxY;
      }else{
        slidersFinishedChanging = false;
      }
      graphXRangeStart = xRangeStart;
      graphXRangeEnd = xRangeEnd;
      graphYRangeStart = yRangeStart;
      graphYRangeEnd = yRangeEnd;
    }else{
      slidersJustChanged = false;
    }

    List<charts.Series<Commit, double>> pointSeries = [
      charts.Series(
        id: "commits",
        data: commitObjects,
        domainFn: (Commit commit, _) => commit.daysSinceLastCommit,
        measureFn: (Commit commit, _) => viewingLinesAdded? commit.linesAdded : (viewingLinesDeleted ? commit.linesDeleted : (viewingSum ? commit.sum : commit.difference)),
      )
    ];
    List<charts.Series<Point, double>> lineSeries = [
      charts.Series(
        id: "line",
        data: lineOfBestFitPoints,
        domainFn: (Point point, _) => point.x,
        measureFn: (Point point, _) => point.y,
      )
    ];
    return Scaffold(
      backgroundColor: globals.color2,
      appBar: AppBar(
        title: const Center(
          child: Text("Github Visualiser"),
        ),
        backgroundColor: globals.color3,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Stack(children: [
                charts.ScatterPlotChart(
                  pointSeries,
                  animate: true,
                  domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                    const charts.BasicNumericTickProviderSpec(zeroBound: false),
                    viewport: charts.NumericExtents(graphXRangeStart, graphXRangeEnd),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                    const charts.BasicNumericTickProviderSpec(zeroBound: false),
                    viewport: charts.NumericExtents(graphYRangeStart, graphYRangeEnd),
                  ),
                ),
                charts.LineChart(
                  lineSeries,
                  animate: true,
                  domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                    const charts.BasicNumericTickProviderSpec(zeroBound: false),
                    viewport: charts.NumericExtents(graphXRangeStart, graphXRangeEnd),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec:
                    const charts.BasicNumericTickProviderSpec(zeroBound: false),
                    viewport: charts.NumericExtents(graphYRangeStart, graphYRangeEnd),
                  ),
                ),
              ],)
          ),
          const Text("Days Between Commits"),
          const SizedBox(height: 20,),
          Text("y = ${roundDouble(m, 3)}x + ${roundDouble(c, 3)}"),
          const SizedBox(height: 10,),
          Text("For every extra day spent between commits, the ${viewingLinesAdded? " amount of lines added " : (viewingLinesDeleted ? " amount of lines deleted" : (viewingSum ? "sum of lines added and lines deleted" : "difference between lines added and lines deleted"))} ${m > 0 ? "increased" : "decreased"} by ${roundDouble(m, 3)} on average"),
          Expanded(
            flex: 1,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lines Added"),
                      Checkbox(
                        value: viewingLinesAdded,
                        onChanged: (value){
                          setState(() {
                            viewingLinesAdded = true; viewingLinesDeleted = false; viewingSum = false; viewingDifference = false;
                            labelText = "Lines Added";
                          });
                        }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lines Deleted"),
                      Checkbox(
                        value: viewingLinesDeleted,
                        onChanged: (value){
                          setState(() {
                            labelText = "Lines Deleted";
                            viewingLinesAdded = false; viewingLinesDeleted = true; viewingSum = false; viewingDifference = false;
                          });
                        }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lines Added + Lines Deleted"),
                      Checkbox(
                        value: viewingSum,
                        onChanged: (value){
                          setState(() {
                            labelText = "Lines Added + Lines Deletes";
                            viewingLinesAdded = false; viewingLinesDeleted = false; viewingSum = true; viewingDifference = false;
                          });
                        }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Lines Added - Lines Deleted"),
                      Checkbox(
                        value: viewingDifference,
                        onChanged: (value){
                          setState(() {
                            labelText = "Lines Added - Lines Deleted";
                            viewingLinesAdded = false; viewingLinesDeleted = false; viewingSum = false; viewingDifference = true;
                          });
                        }
                      ),
                    ],
                  ),
                ],
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("X-Axis Range: "),
              SizedBox(
                  width: 40,
                  child: Text(roundDouble(xRangeStart, 1).toString())
              ),
              RangeSlider(
                min: 0,
                max: maxX,
                values: RangeValues(xRangeStart, xRangeEnd),
                onChanged: (RangeValues value) {
                  setState(() {
                    xRangeStart = value.start;
                    xRangeEnd = value.end;
                    slidersJustChanged = true;
                  });
                },
                onChangeEnd: (value){
                  setState(() {
                    xRangeStart = value.start;
                    xRangeEnd = value.end;
                    //slidersJustChanged = true;
                    slidersFinishedChanging = true;
                  });
                },
              ),
              SizedBox(
                  width: 40,
                  child: Text(roundDouble(xRangeEnd, 1).toString())
              ),
              const Text("Y-Axis Range: "),
              SizedBox(
                  width: 40,
                  child: Text(roundDouble(yRangeStart, 1).toString())
              ),
              RangeSlider(
                max: maxY,
                values: RangeValues(yRangeStart, yRangeEnd),
                onChanged: (RangeValues value) {
                  setState(() {
                    yRangeStart = value.start;
                    yRangeEnd = value.end;
                    slidersJustChanged = true;
                  });
                },
                onChangeEnd: (value){
                  setState(() {
                    yRangeStart = value.start;
                    yRangeEnd = value.end;
                    //slidersJustChanged = true;
                    slidersFinishedChanging = true;
                  });
                },
              ),
              SizedBox(
                  width: 40,
                  child: Text(roundDouble(yRangeEnd, 1).toString())
              ),
            ],
          )
        ],
      ),
    );
  }
}
