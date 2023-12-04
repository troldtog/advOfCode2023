import 'dart:convert';
import 'dart:async';
import 'dart:io';

RegExp symbol = RegExp(r'[^\.\d]');
RegExp digit = RegExp(r'\d');
bool isSymbol(String s) => s.length == 1 && symbol.hasMatch(s);
bool isDigit(String s) => s.length == 1 && digit.hasMatch(s);

Future<List<List<String>>> readInputFile (String path) async{
  final lines = utf8.decoder
    .bind(File(path).openRead())
    .transform(const LineSplitter())
    .transform<String>(StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
        sink.add("."+value+".");
    }))
    .transform<List<String>>(StreamTransformer<String, List<String>>.fromHandlers(
      handleData: (String value, EventSink<List<String>> sink){
        final asList = value.split("");        
        sink.add(asList);  
    }));

  // really don't like this part.
  // ideally could work on several lines in chunks
  // while still using the stream/await for model
  // but if that's possible it'd take writing a full StreamController class
  // and it seems like there should be something more concise than that.
  List<List<String>> wholeInput = [];
    await for (final line in lines){
      wholeInput.add(line);
  }

  List<String> allDots = List<String>.filled(wholeInput[0].length, ".");
  return [allDots] + wholeInput + [allDots]; 
}

Future<String> solvePart1(List<String> additionalArgs) async{
    final input = await readInputFile(additionalArgs[0]);
    int total = 0;
    for (var row = 1; row < input.length - 1; row++){
      for (var col = 1; col < input[row].length - 1; col++){
        if (isSymbol(input[row][col])){
          total += sumAdjacentNumbers(row,col,input);
        }
      }
    }
    return total.toString();
}


Future<String> solvePart2(List<String> additionalArgs) async{
  final input = await readInputFile(additionalArgs[0]);
  int total = 0;
  for (var row = 1; row < input.length - 1; row++){
    for (var col = 1; col < input[row].length - 1; col++){
      if ("*" == input[row][col]){
        total += computeGearRatio(row,col,input);
      }
    }
  }
  return total.toString();
}


int computeGearRatio(int row, int col, List<List<String>> input){
  final nearbyNumbers = findNearbyNumbers(row, col, input, false);
  if (nearbyNumbers.length == 2){
    return nearbyNumbers[0]*nearbyNumbers[1];
  }

  return 0;
}

int sumAdjacentNumbers(int row, int col, List<List<String>> input){
  final nearbyNumbers = findNearbyNumbers(row, col, input, true);
  nearbyNumbers.add(0);
  return nearbyNumbers.reduce((value, number) => value + number);
}

List<int> findNearbyNumbers(int row, int col, List<List<String>> input, bool clearAfterFound){
  List<int> foundNumbers = [];
  foundNumbers.addAll(findNumbersOnAdjacentLine(input[row - 1], col, clearAfterFound));
  foundNumbers.addAll(findNumbersOnSameLine(input[row], col, clearAfterFound));
  foundNumbers.addAll(findNumbersOnAdjacentLine(input[row + 1], col, clearAfterFound));
  return foundNumbers;
}

List<int> findNumbersOnAdjacentLine(List<String> line, int index, bool clearAfterFound){
 if (isDigit(line[index])){
   return [extractNumber(line, index, clearAfterFound)];
 }

 // misnomer, but once you identify that the spot directly above a symbol isn't a number the logic is the same.
 return findNumbersOnSameLine(line, index, clearAfterFound);
}

List<int> findNumbersOnSameLine(List<String> line, int index, bool clearAfterFound){
 List<int> adjacentResults = [];
 if (isDigit(line[index - 1])){
   adjacentResults.add(extractNumber(line, index - 1, clearAfterFound));
 }

 if (isDigit(line[index + 1])){
   adjacentResults.add(extractNumber(line, index + 1, clearAfterFound));
 }

 return adjacentResults;
}

int extractNumber(List<String> line, int col, bool clearAfterFound){
  int numberIndexStart = col;
  int numberIndexEnd = col + 1;
  while (isDigit(line[numberIndexStart - 1])){
    numberIndexStart--;
  }
  while(isDigit(line[numberIndexEnd])){
    numberIndexEnd++;
  }

  int foundNumber = 0;
  for (int i = numberIndexStart; i < numberIndexEnd; i++){
    foundNumber *= 10;
    foundNumber += int.parse(line[i]);
    
    if (clearAfterFound){
      //numbers can be adjacent to multiple symbols so after it is read, set it to "." so it is not found twice.
      line[i]=".";
    }
  }
  
  return foundNumber;
}
