import 'dart:convert';
import 'dart:io';


Stream<String> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter());
  return lines;
}

Future<String> solvePart1(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    List<({String color, int invalidThreshold, RegExp cubePattern})> forbiddenCubes = [
    (color: "red",   invalidThreshold:  12, cubePattern: RegExp(r'(?<red>\d+) red')),
    (color: "blue",  invalidThreshold:  14, cubePattern: RegExp(r'(?<blue>\d+) blue')),
    (color: "green", invalidThreshold:  13, cubePattern: RegExp(r'(?<green>\d+) green'))];
    var result = await solve(inputPath, forbiddenCubes);
    return result;
}

Future<String> solve(String inputPath, List<({String color, int invalidThreshold, RegExp cubePattern})> forbiddenCubes) async{
    final lines = readInputFile(inputPath);
    int validGameTotal = 0;

    await for (final line in lines){
        var gameId = line.substring(5, line.indexOf(':'));
        var input = line.substring(line.indexOf(':')+1);
        if (isGameInvalid(gameId, input, forbiddenCubes)){
          continue; 
        }
        
        validGameTotal += int.parse(gameId);
    }

    return validGameTotal.toString();
}

bool isGameInvalid(String id, String input, List<({String color, int invalidThreshold, RegExp cubePattern})> forbiddenCubes){
  print(id);
  for (final forbiddenCube in forbiddenCubes){
    print("  "+forbiddenCube.color);
    for (final cubeMatch in forbiddenCube.cubePattern.allMatches(input)){
      final cubeCount = int.parse(cubeMatch.namedGroup(forbiddenCube.color) ?? "0");
      print("    "+cubeCount.toString());
      if (forbiddenCube.invalidThreshold < cubeCount){
        return true;
      }
    }
  }
  return false;
}