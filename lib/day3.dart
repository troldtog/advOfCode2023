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

int sumAdjacentNumbers(int row, int col, List<List<String>> input){
  int subtotal = 0;  
  for ((int, int) neighbor in [(-1,-1), (-1,0), (-1,1), (0,-1),(0,1),(1,-1),(1,0),(1,1)]){
    final (dx, dy) = neighbor;
    var line = input[row+dy];
    if (isDigit(line[col+dx])){
      subtotal += extractNumber(line, col+dx);
    }
  }
  return subtotal;
}

int extractNumber(List<String> line, int col){
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

    //numbers can be adjacent to multiple symbols so after it is read, set it to "." so it is not found twice.
    line[i]=".";
  }
  
  print(foundNumber);
  return foundNumber;
}


Future<String> solvePart2(List<String> additionalArgs) async{
    return "";
}