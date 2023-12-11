import 'util/file.dart' show readFileLineByLine;
RegExp integer = RegExp(r'-?\d+');

Future<String> solvePart1(List<String> arguments) async => solve(arguments[0]);

Future<String> solvePart2(List<String> arguments) async => solve(arguments[0], -1);

Future<String> solve(String filePath, [int? next_x = null]) async{
  final total = await readFileLineByLine(filePath)
    .map((line) => integer.allMatches(line).map((s) => int.parse(s[0]!)).toList())
    .fold(0, (total, line) => total + lagrangeInterpolate(line, next_x));

  return total.toString();
}

// Lagrange interpolation.
// Points: The values to interpolate, 
// n: which term in the sequence to produce, defaults to one after the last term in the list.
int lagrangeInterpolate (List<int> points, [int? n = null]){
   n = n ?? points.length;
   num y = 0;
   // outer loop runs over Lagrange polynomials
   for (int j = 0; j < points.length; j++){
     num sub_result = points[j];
     // inner loop runs over factors of a Lagrange poly
     for(int k = 0; k < points.length; k++){
       if (j == k) continue;
       sub_result *= ((n - k)/(j - k));
     }
     y += sub_result;
   }

   return y.round();
}