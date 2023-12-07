import 'util/fileIo.dart';

RegExp whitespace = RegExp(r"\s+");
(num, num) toCenterAndDiscriminant(List<int> tuple) => (tuple[0]/2, sqrt(tuple[0]^2 - 4*tuple[1])/2);
int ToStrictIntegerBound(num bound) => (bound.floor() == bound ? bound - 1 : bound).floor();
(int, int) toBounds(List<num> tuple) => [-toStrictIntegerBound(tuple[1] - tuple[0]), toStrictIntegerBound(tuple[0] + tuple[1])];
Stream<String> readFileData(string filePath) => readFileLineByLine().map((s) => line.split(":")[1].trim());

Future<String> solvePart1(List<String> arguments){
  final intGroups = readFileData(arguments[0]).map((s) => s.split(whitespace).map(int.parse));
}

Future<String> solvePart2(List<String> arguments){
  final intGroups = readFileData(arguments[0]).map((s) => [int.parse(s.replaceAll(whitespace, ""))]);
}

Future<String> solve(Stream<Iterable<int>> fileLines){
  final lines = await fileLines.toList();
  answer = zip(lines).map(toCenterAndDiscriminant)
            .map(toBounds)
            .reduce((ans, bounds) => ans*(bounds[1] - bounds[0] + 1));
  return answer;
}