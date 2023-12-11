import 'util/file.dart' show readFileLineByLine;

Future<String> solvePart1(List<String> arguments) async => await solve(arguments[0], 2);
Future<String> solvePart2(List<String> arguments) async => await solve(arguments[0], 1000000);

Future<String> solve(String fileName, int expansionFactor) async{
  Map<int, int> columnCounts = {};
  Map<int, int> rowCounts = {};
  int row = 0;
  await for (final line in readFileLineByLine(fileName)){
    final colIndices = "#".allMatches(line);
    if(colIndices.isNotEmpty){
      rowCounts[row] = colIndices.length;
      colIndices.map((m) => m.start).forEach((i) => columnCounts[i] = (columnCounts[i] ?? 0) + 1);
    }
    row+= colIndices.isEmpty ? expansionFactor : 1;
  }

  final adjustedColumnCounts = adjustColumnCounts(columnCounts, expansionFactor);
  return (calculateDistance(rowCounts) + calculateDistance(adjustedColumnCounts)).toString();
}

int calculateDistance(Map<int, int> rowCounts){
  int totalRowDistance = 0;
  for (final i in rowCounts.keys){
    for (final j in rowCounts.keys.where((key) => key < i)){
      totalRowDistance += rowCounts[i]!*rowCounts[j]!*(i-j);
    }
  }

  return totalRowDistance;
}

Map<int, int> adjustColumnCounts(Map<int, int> columnCounts, int expansionFactor){
  // there's got to be a cleaner way to do this with Map.from(columnCounts.[transformKeys], columnCounts.values)
  var sortedColumns = columnCounts.keys.toList();
  sortedColumns.sort();
  Map<int, int> result = {};
  for (int i = 0; i < sortedColumns.length; i++){
    result[sortedColumns[i] + (sortedColumns[i] - i)*(expansionFactor - 1)] = columnCounts[sortedColumns[i]]!;
  }
  return result;
}