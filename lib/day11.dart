import 'util/file.dart' show readFileLineByLine;
RegExp integer = RegExp(r'-?\d+');

// distance between (a,b) and (c,d) is (d-b + c-a)
// can avoid negatives by walking them the same order you've found them in the file.
Future<String> solvePart1(List<String> arguments) async{
  Map<int, int> columnCounts = {};
  Map<int, int> rowCounts = {};
  int row = 0;
  await for (final line in readFileLineByLine(arguments[0])){
    final colIndices = "#".allMatches(line);
    if(colIndices.isEmpty){
      row++;        
    }else{
      rowCounts[row] = colIndices.length;
      colIndices.map((m) => m.start).forEach((i) => columnCounts[i] = (columnCounts[i] ?? 0) + 1);
    }
    row++;
  }

  final adjustedColumns = adjustColumns(columnCounts.keys);

  return solveActualProblem(rowCounts, columnCounts, adjustedColumns).toString();
}

Future<String> solvePart2(List<String> arguments) async{
  return "7";
}

int solveActualProblem(Map<int, int> rowCounts, Map<int, int> columnCounts, Map<int, int> adjustedColumns){
  int allDistance = 0;
  for (final i in rowCounts.keys){
    for (final j in rowCounts.keys.where((key) => key < i)){
      allDistance += rowCounts[i]!*rowCounts[j]!*(i-j);
    }
  }

  for (final i in columnCounts.keys){
    for (final j in columnCounts.keys.where((key) => key < i)){
      allDistance += columnCounts[i]!*columnCounts[j]!*(adjustedColumns[i]!-adjustedColumns[j]!);
    }
  }

  return allDistance;
}

Map<int, int> adjustColumns(Iterable<int> nonEmptyColumns){
  var sortedColumns = nonEmptyColumns.toList();
  sortedColumns.sort();
  Map<int, int> result = {};
  for (int i = 0; i < sortedColumns.length; i++){
    result[sortedColumns[i]] = sortedColumns[i] + (sortedColumns[i] - i);
  }
  return result;
}

