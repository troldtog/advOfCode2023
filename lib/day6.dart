import 'util/file.dart' show readFileLineByLine;
import 'package:collection/collection.dart' show IterableZip;
import 'dart:math' show sqrt, pow;

RegExp whitespace = RegExp(r"\s+");

// takes race time and distance and returns the center and the discriminant of the parabola with zeros where result would tie the current
// record and vertex at the maximum possible distance
List<num> toCenterAndDiscriminant(List<int> tuple) => [tuple[0]/2, sqrt(pow(tuple[0],2) - 4*tuple[1])/2];

// takes a number that is the least upper bound of an open interval and returns
// the least upper bound of the largest closed interval with integer bounds
int toStrictIntegerBound(num bound) => (bound.floor() == bound ? bound - 1 : bound).floor();

// finds the least and greatest integer times that can beat the current record given the center (tuple[0])
// and discriminant (tuple[1]) provided by toCenterAndDiscriminant.
List<int> toBounds(List<num> tuple) => [-toStrictIntegerBound(tuple[1] - tuple[0]), toStrictIntegerBound(tuple[0] + tuple[1])];

// chops off the boring parts of each line.
Stream<String> readFileData(String filePath) => readFileLineByLine(filePath).map((s) => s.split(":")[1].trim());

Future<String> solvePart1(List<String> arguments) async {
  final raceInfo = readFileData(arguments[0]).map((s) => s.split(whitespace).map(int.parse));
  return (await solve(raceInfo)).toString();
}

Future<String> solvePart2(List<String> arguments) async {
  final raceInfo = readFileData(arguments[0]).map((s) => [int.parse(s.replaceAll(whitespace, ""))]);
  return (await solve(raceInfo)).toString();
}

Future<int> solve(Stream<Iterable<int>> fileLines) async {
  final lines = await fileLines.toList();
  final answer = IterableZip<int>(lines).map(toCenterAndDiscriminant)
            .map(toBounds)
            .fold<int>(1, (ans, bounds) => ans*(bounds[1] - bounds[0] + 1));
  return answer;
}