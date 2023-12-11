import 'dart:convert';
import 'dart:async';
import 'dart:io';

RegExp integerRegexp = RegExp(r"\d+");

/// Takes the path to an input file and returns a stream of that file's contents, streamed line by line.
Stream<String> readFileLineByLine (String filePath){
  final lines = utf8.decoder
    .bind(File(filePath).openRead())
    .transform(const LineSplitter());
  return lines;
}

extension StreamHelpers on Stream<String>{


  // Reads integers from a series of strings, ignoring everything else.
  Stream<int> asInts() async*{
    await for (final line in this){
      for (final match in integerRegexp.allMatches(line)){
        yield int.parse(match.group(0)!);
      }
    }
  }

  /// Takes an input file and emits blocks of lines as a string, using the pattern [splitMarkRegex]
  /// to identify when a line separates blocks of interest. The line containing [splitMarkRegex] is discarded.
  Stream<List<String>> chunkBy(RegExp splitMarkRegex) async* {
    List<String> chunkedLines = [];
    await for (final line in this){
      final isBlockSplit = splitMarkRegex.hasMatch(line);
      if (isBlockSplit){
        yield chunkedLines;
        chunkedLines = [];
        continue;
      }
  
      chunkedLines.add(line);      
    }

    yield chunkedLines;
  }
}



