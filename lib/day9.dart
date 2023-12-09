import 'util/file.dart' show readFileLineByLine;
RegExp integer = RegExp(r'-?\d+');

Future<String> solvePart1(List<String> arguments) async => solve(arguments[0]);

Future<String> solvePart2(List<String> arguments) async => solve(arguments[0], -1);

Future<String> solve(String filePath, [int? next_x = null]) async{
  final total = await readFileLineByLine(filePath)
    .map((line) => integer.allMatches(line).map((s) => int.parse(s[0]!)).toList())
    .fold(0, (total, line) => total + interpolateNext(line, next_x));

  return total.toString();
}

// Lagrange interpolation. Points: The values to interpolate, n: which term in the sequence to produce.
int interpolateNext (List<int> points, [int? n = null]){
   int next_n = n ?? points.length;
   num next_y = 0;
   for (int lagrange_index = 0; lagrange_index < points.length; lagrange_index++){
     num sub_result = points[lagrange_index];
     for(int i = 0; i < points.length; i++){
       if (lagrange_index == i) continue;
       sub_result *= ((next_n - i)/(lagrange_index - i));
     }
     next_y += sub_result;
   }

   return next_y.round();
}