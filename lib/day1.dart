import 'dart:convert';
import 'dart:io';

// the written names of the digits - this implicitly relies on the fact that no name of a digit is a suffix in another name


Stream<String> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter());
  return lines;
}

Future<String> solvePart1(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    final searchPattern = "\\\d";
    var result = await solve(inputPath, searchPattern);
    return result;
}

Future<String> solvePart2(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    
    //search pattern in part 1 plus the written names of the digits - this implicitly relies on the fact that no name of a digit is a suffix in another name. Worse, counts on them all being lower-case.
    final searchPattern = "\\\d|zero|one|two|three|four|five|six|seven|eight|nine";
    var result = await solve(inputPath, searchPattern);
    return result;
}

Future<String> solve(String inputPath, String searchPattern) async{
    RegExp digitPattern = RegExp(searchPattern);
    final lines = readInputFile(inputPath);
    int tensPlaceTotal = 0;
    int onesPlaceTotal = 0;

    await for (final line in lines){
        final (firstMatch, lastMatch) = findDigits(line, digitPattern);
        print(line + " " + firstMatch.toString() + " " +lastMatch.toString());
        tensPlaceTotal += firstMatch;
        onesPlaceTotal += lastMatch;
    }

    return (10*tensPlaceTotal + onesPlaceTotal).toString();
}

(int, int) findDigits(String inputLine, RegExp digitPattern){
  final allMatches = digitPattern.allMatches(inputLine, 0).toList(growable: false);
  if (allMatches.length == 0){
    return (0,0);
  }
  
  // first [index] gets the match from a collection. 
  // second [index] gets the whole Match, but would be nice if there were a property for this.
  final firstMatch = allMatches[0][0];
  final lastMatch = allMatches[allMatches.length -1][0];
  return (convertStringToDigit(firstMatch), convertStringToDigit(lastMatch));
}

int convertStringToDigit(String? number){
    switch(number){
      case '0':
      case 'zero':
        return 0;

      case '1':
      case 'one':
        return 1;

      case '2':
      case 'two':
        return 2;

      case '3':
      case 'three':
        return 3;

      case '4':
      case 'four':
        return 4;

      case '5':
      case 'five':
        return 5;

      case '6':
      case 'six':
        return 6;

      case '7':
      case 'seven':
        return 7;

      case '8':
      case 'eight':
        return 8;

      case '9':
      case 'nine':
        return 9;
      
      default:
       throw FormatException("Not a digit");
    }
}