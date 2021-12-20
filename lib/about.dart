import 'dart:math';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'package:http/http.dart';
import 'main.dart';
import 'functions.dart';


class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("About")
        ),
        backgroundColor: globals.color3,
      ),
      body:
        Column(
          children: [
            const Text(
              "This visualisation graphs the link between time between commits by a user and the size of the commits. The size of the commit is either: lines added, lines deleted, sum of those two, or the difference of those two. Any commits by a user that has contributed only one commit to the repo will not be counted, because the time between their commits cannot be determined from one commit",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Topology Diagram: ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ],
            ),
            Image.asset("assets/images/topologyDiagram.png", height: 300,),
          ],
        ),
    );
  }
}
