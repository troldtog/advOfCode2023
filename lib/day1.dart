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
    final searchPattern = "\\\d|zero|one|two|three|four|five|six|seven|eight|nine|ten";
    var result = await solve(inputPath, searchPattern);
    return result;
}

Future<String> solve(String inputPath, String searchPattern) async{
    RegExp digitPattern = RegExp(searchPattern);
    final lines = readInputFile(inputPath);
    int tensPlaceTotal = 0;
    int onesPlaceTotal = 0;

    await for (final line in lines){
        var firstDigitIndex = line.indexOf(digitPattern);
        var lastDigitIndex = line.lastIndexOf(digitPattern);
        tensPlaceTotal += int.parse(line[firstDigitIndex]);
        onesPlaceTotal += int.parse(line[lastDigitIndex]);
    }

    return (10*tensPlaceTotal + onesPlaceTotal).toString();
}