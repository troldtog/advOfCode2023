import 'dart:convert';
import 'dart:io';

Stream<String> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter());
  return lines;
}

Future<String> solve(List<String> additionalArgs) async{
    final inputPath = additionalArgs[0];
    RegExp digitPattern = RegExp(r'\d');
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