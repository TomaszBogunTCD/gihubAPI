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
          children: const [
            Text(
              "This visualisation graphs the link between time between commits by a user and the size of the commits. The size of the commit is either: lines added, lines deleted, sum of those two, or the difference of those two. Any commits by a user that has contributed only one commit to the repo will not be counted, because the time between their commits cannot be determined from one commit",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "The flutter web application contacts a python server, which calls the github API to gather a list of commits in the inputted repository. The server then extracts the size of the commit in terms on lines added, lines deleted, and calculates the days that passed since the last commit by the author of the current commit. The server then sends a cvs file format containing triples of this data to the flutter web application, which can graph and provide interactive functionality for the data.",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Estimated server gather time:",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            Text(
              "1 second for every 3-4 commits present in a repository",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "All the flutter source code is in the lib folder and the github api gathering server is in the files main.py and githubGather.py:",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ],
        ),
    );
  }
}
