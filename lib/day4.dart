import 'dart:convert';
import 'dart:math';
import 'dart:io';

RegExp whitespace = RegExp(r'\s');

Stream<List<String>> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter())
    .transform<List<String>>(StreamTransformer<String, List<String>>.fromHandlers(
      handleData: (String value, EventSink<List<String>> sink){
        final splitOnce = value.split(":");        
        sink.add([splitOnce[0]] + splitOnce[1].split("|"));  
    }));
  return lines;
}


Future<String> solvePart1(List<String> additionalArgs) async{
    int sumTickets = 0;
    final inputLines = readInputFile(additionalArgs[0]);
    await for (final input in inputLines){
       sumTickets += computeTicketPoints(input);
    }

    return sumTickets.toString();
}

int computeTicketPoints(List<String> line){
  int winCount = -1;
  final ticketNumbers = line[2].split(whitespace);
  final winningNumbers = Map.fromEntries(line[1].split(whitespace).map((number) => MapEntry(number, int.parse(number))));
  for (final ticketNumber in ticketNumbers){
    if (winningNumbers.containsKey(ticketNumber)){
      winCount++;
    }
  }

  return winCount < 0 ? 0 : pow(2, winCount);
}

Future<String> solvePart2(List<String> additionalArgs) async{
  return "";
}

