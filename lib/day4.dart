import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:io';

RegExp whitespace = RegExp(r"\s+");
RegExp cardNumber = RegExp(r"Card\s+(?<cardNum>\d+)");
typedef Game = (int, Set<String>, Set<String>);

Stream<Game> readInputFile (String path){
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter())
    .transform<List<String>>(StreamTransformer<String, List<String>>.fromHandlers(
      handleData: (String value, EventSink<List<String>> sink){
        final splitOnce = value.split(":");
        sink.add([splitOnce[0]] + splitOnce[1].split("|"));  
    }))
    .transform<Game>(StreamTransformer<List<String>, Game>.fromHandlers(
      handleData: (List<String> value, EventSink<Game> sink){

        final gameNumberString = cardNumber.firstMatch(value[0])!.namedGroup("cardNum")!;
        final gameNumber = int.parse(gameNumberString);

        final winners = Set<String>.from(value[1].trim().split(whitespace));
        final picks = Set<String>.from(value[2].trim().split(whitespace));
        sink.add((gameNumber, winners, picks));
      }));
  return lines;
}

Future<String> solvePart1(List<String> additionalArgs) async{
    int pointsTotal = 0;
    final inputLines = readInputFile(additionalArgs[0]);
    await for (final input in inputLines){
       pointsTotal += computeTicketPoints(input);
    }
    print(pointsTotal);
    return pointsTotal.toString();
}

Future<String> solvePart2(List<String> additionalArgs) async{
    int sumTickets = 0;
    Map<int, int> ticketCopyCount = Map();
    Map<int, int> ticketTradeInValue = Map();
    final inputLines = readInputFile(additionalArgs[0]);
    await for (final game in inputLines){
        recomputeTicketHaul(ticketCopyCount, ticketTradeInValue, game);
    }
    
    int godAwfulTicketTotal = ticketCopyCount.values.reduce((value, elt) => value + elt);
    return godAwfulTicketTotal.toString();
}

void recomputeTicketHaul(Map<int, int> ticketCopyCount, Map<int, int> ticketTradeInValue, Game game){
    final (index, winners, picks) = game;
    ticketCopyCount[index] = (ticketCopyCount[index] ?? 0) + 1;
    ticketTradeInValue[index] = countWinningNumbers(winners, picks);
    for (int i = index + 1; i <= index + ticketTradeInValue[index]!; i++){
      ticketCopyCount[i] = (ticketCopyCount[i] ?? 0) + ticketCopyCount[index]!;
    }
}

int countWinningNumbers(Set<String> winners, Set<String> picks){
  return winners.intersection(picks).length;
}

int computeTicketPoints(Game game){
  final (index, winners, picks) = game;
  int winCount = countWinningNumbers(winners, picks) - 1;

  // compiler error without round even though pow's documentation says if you supply it int arguments it returns type int :/
  return winCount < 0 ? 0 : pow(2, winCount).round();
}