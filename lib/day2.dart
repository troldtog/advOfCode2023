import 'dart:convert';
import 'dart:io';

List<({String color, RegExp cubePattern})> CubeInfo = [
    (color: "red",   cubePattern: RegExp(r'(?<red>\d+) red')),
    (color: "blue",  cubePattern: RegExp(r'(?<blue>\d+) blue')),
    (color: "green", cubePattern: RegExp(r'(?<green>\d+) green'))];

Map<String, int> CubeThresholds = { "red": 12, "blue": 14, "green": 13};

Stream<String> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter());
  return lines;
}

Future<String> solvePart1(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    final lines = readInputFile(inputPath);
    int validGameTotal = 0;

    await for (final line in lines){
        var gameId = line.substring(5, line.indexOf(':'));
        var input = line.substring(line.indexOf(':')+1);
        if (isGameInvalid(gameId, input)){
          continue; 
        }
        
        validGameTotal += int.parse(gameId);
    }

    return validGameTotal.toString();
}

Future<String> solvePart2(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    final lines = readInputFile(inputPath);
    int gamePowerTotal = 0;

    await for (final line in lines){  
        gamePowerTotal += computePowerOfGame(line);
    }

    return gamePowerTotal.toString();
}

int computePowerOfGame(String input){
  int powerOfGame = 1;
  for (final cubeInfo in CubeInfo){
    int maxCubeCount = 0;
    for (final cubeMatch in cubeInfo.cubePattern.allMatches(input)){
      final cubeCount = int.parse(cubeMatch.namedGroup(cubeInfo.color) ?? "0");
      maxCubeCount = maxCubeCount < cubeCount ? cubeCount : maxCubeCount;
    }
    powerOfGame *= maxCubeCount;
  }

  return powerOfGame;
}

bool isGameInvalid(String id, String input){
  for (final cubeInfo in CubeInfo){
    for (final cubeMatch in cubeInfo.cubePattern.allMatches(input)){
      final cubeCount = int.parse(cubeMatch.namedGroup(cubeInfo.color) ?? "0");
      if (CubeThresholds[cubeInfo.color]! < cubeCount){
        return true;
      }
    }
  }
  return false;
}