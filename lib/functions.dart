import 'dart:math';

class Commit{
  late final int linesAdded;
  late final int linesDeleted;
  late final double daysSinceLastCommit;
  late int sum;
  late int difference;

  Commit(this.linesAdded, this.linesDeleted, this.daysSinceLastCommit){
    sum = linesAdded + linesDeleted;
    difference = linesAdded - linesDeleted;
  }
}

class Point{
  late final double x;
  late final double y;
  Point(this.x, this.y);
}

//calculate the two points for the line of best fit based on the list of commit objects, and the attribute in question
List<Point> getLineOfBestFitPoints(List<Commit> commitObjects, bool viewingLinesAdded, bool viewingLinesDeleted, bool viewingSum){
  double meanX = 0;
  double meanY = 0;

  double maxX = 0;
  double maxY = 0;

  for(int i=0; i<commitObjects.length; i++){
    Commit currentCommit = commitObjects[i];
      if(currentCommit.daysSinceLastCommit > maxX){
        maxX = currentCommit.daysSinceLastCommit;
      }
      meanX += currentCommit.daysSinceLastCommit;
      if(viewingLinesAdded){
        meanY += currentCommit.linesAdded;
        if(currentCommit.linesAdded > maxY){
          maxY = currentCommit.linesAdded as double;
        }
      }else if (viewingLinesDeleted){
        meanY += currentCommit.linesDeleted;
        if(currentCommit.linesDeleted > maxY){
          maxY = currentCommit.linesDeleted as double;
        }
      }else if(viewingSum){
        meanY += currentCommit.sum;
        if(currentCommit.sum > maxY){
          maxY = currentCommit.sum as double;
        }
      }else {
        meanY += currentCommit.difference;
        if(currentCommit.difference > maxY) {
          maxY = currentCommit.difference as double;
        }
      }
  }
  meanX = meanX / commitObjects.length;
  meanY = meanY / commitObjects.length;

  double sumNumerator = 0;
  double sumDenominator = 0;
  for(int i=0; i<commitObjects.length; i++){
    Commit currentCommit = commitObjects[i];
    sumDenominator += ((currentCommit.daysSinceLastCommit - meanX) *
        (currentCommit.daysSinceLastCommit - meanX));
    if (viewingLinesAdded) {
      sumNumerator += ((currentCommit.daysSinceLastCommit - meanX) *
          (currentCommit.linesAdded - meanY));
    } else if (viewingLinesDeleted) {
      sumNumerator += ((currentCommit.daysSinceLastCommit - meanX) *
          (currentCommit.linesDeleted - meanY));
    } else if (viewingSum) {
      sumNumerator += ((currentCommit.daysSinceLastCommit - meanX) *
          (currentCommit.sum - meanY));
    } else{
      sumNumerator += ((currentCommit.daysSinceLastCommit - meanX) *
          (currentCommit.difference - meanY));
    }
  }
  double m = sumNumerator / sumDenominator;
  double c = meanY - (m*meanX);
  return [Point(0, c), Point(maxX, (maxX*m)+c), Point(maxX, maxY), Point(m,c)];
}


List<Commit> getCommitObjectsFromStringList(List<String> commits, double xRangeStart, double xRangeEnd, double yRangeStart, double yRangeEnd, bool viewingLinesAdded, bool viewingLinesDeleted, bool viewingSum){
  List<Commit> commitObjects = [];
  List<String> commitComponents = [];
  for(int i=0; i<commits.length; i++){
    commitComponents = commits[i].split(",");
    Commit currentCommit = Commit(int.parse(commitComponents[1]), int.parse(commitComponents[2]), double.parse(commitComponents[0]));
    if (viewingLinesAdded && currentCommit.daysSinceLastCommit >= xRangeStart && currentCommit.daysSinceLastCommit <= xRangeEnd && currentCommit.linesAdded >= yRangeStart && currentCommit.linesAdded <= yRangeEnd) {
      commitObjects.add(currentCommit);
    }else if (viewingLinesDeleted && currentCommit.daysSinceLastCommit >= xRangeStart && currentCommit.daysSinceLastCommit <= xRangeEnd && currentCommit.linesDeleted >= yRangeStart && currentCommit.linesDeleted <= yRangeEnd) {
      commitObjects.add(currentCommit);
    }else if (viewingSum && currentCommit.daysSinceLastCommit >= xRangeStart && currentCommit.daysSinceLastCommit <= xRangeEnd && currentCommit.sum >= yRangeStart && currentCommit.sum <= yRangeEnd) {
      commitObjects.add(currentCommit);
    }else if(currentCommit.daysSinceLastCommit >= xRangeStart && currentCommit.daysSinceLastCommit <= xRangeEnd && currentCommit.difference >= yRangeStart && currentCommit.difference <= yRangeEnd){
      commitObjects.add(currentCommit);
    }
  }
  return commitObjects;
}

double roundDouble(double value, int places){
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}