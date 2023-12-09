import 'util/fileIo.dart' show readFileLineByLine;
RegExp integer = RegExp(r'-?\d+');

Future<String> solvePart1(List<String> arguments) async => solve(arguments[0]);

Future<String> solvePart2(List<String> arguments) async => solve(arguments[0], -1);

Future<String> solve(String filePath, [int? next_x = null]) async{
  final total = await readFileLineByLine(filePath)
    .map((line) => integer.allMatches(line).map((s) => int.parse(s[0]!)).toList())
    .fold(0, (total, line) => total + interpolateNext(line, next_x));

  return total.toString();
}

// uses lagrange interpolation to find the next value in the sequence
int interpolateNext (List<int> points, [int? x = null]){
   int next_x = x ?? points.length;
   num next_y = 0;
   for (int lagrange_index = 0; lagrange_index < points.length; lagrange_index++){
     num sub_result = points[lagrange_index];
     for(int i = 0; i < points.length; i++){
       if (lagrange_index == i) continue;
       sub_result *= ((next_x - i)/(lagrange_index - i));
     }
     next_y += sub_result;
   }

   return next_y.round();
}