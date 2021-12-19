import 'dart:math';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'package:http/http.dart';
import 'main.dart';
import 'functions.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

Future<List<String>> fetchData(String repoLink) async {
  String repo = repoLink.split("github.com/")[1];
  if (repo[repo.length-1] != "/"){
    repo = repo + "/";
  }
  final response = await get(Uri.parse("http://127.0.0.1:5000/" + repo));
  String data = response.body;
  List<String> lines = data.split("\n");
  lines.removeAt(0);
  lines.removeLast();
  return lines;
}



class _HomeViewState extends State<HomeView> {
  @override
  bool invalid = false;
  String repoLink = "";
  List<String> commits = [];
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final width = viewport.width;
    final height = viewport.height;
    return Scaffold(
      backgroundColor: globals.color2,
      appBar: AppBar(
        title: const Center(
          child: Text("Github Visualiser"),
        ),
        backgroundColor: globals.color3,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              invalid? "Invalid repository link!" : "",
              style: TextStyle(color: Colors.red),
            ),
            Container(
              width: width/1.618,
              child: TextField(
                onChanged: (value){
                  setState(() {
                    repoLink = value;
                    invalid = false;
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    if(!repoLink.contains("github.") || !repoLink.contains("/")){
                      invalid = true;
                    }else{
                      invalid = false;
                    }
                  });
                },
                style: TextStyle(
                  color: color3,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color3),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color3),
                  ),
                  hintText: "Repository Link",
                  counterText: "",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                maxLines: 1,
                maxLength: 100,
              ),
            ),
            SizedBox(height: height/50),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  if(!repoLink.contains("github.") || !repoLink.contains("/")){
                    invalid = true;
                  }else{
                    invalid = false;
                  }
                  if(!invalid){
                    fetchData(repoLink).then((value){
                      commits = value;
                      Navigator.pushNamed(context, "/visualisation", arguments: {"commits": commits});
                    });
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color3),
              ),
              child:Text(
                "Visualise",
                style: TextStyle(
                  fontSize:20,
                  color: color2,
                ),
              ),
            ),
            const Text("This visualisation graphs the link between time between commits by a user and the size of the commits."),
            const Text("The size of the commit is either: lines added, lines deleted, sum of those two, or the difference of those two"),
            const Text("Any commits by a user that has contributed only one commit to the repo will not be counted, because the time between their commits cannot be determined from one commit", textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}

