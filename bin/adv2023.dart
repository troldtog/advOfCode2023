import 'package:args/args.dart';
import 'package:adv2023/day1.dart' as day1;
import 'package:adv2023/day2.dart' as day2;
const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addOption(
      'problemToSolve',
      abbr: 'p',
      mandatory: true,
    );
}

Future solveProblem (String? problemNumber, List<String> additionalArgs) async {
  var result = "ERROR: solver never run!";
  switch (problemNumber){
    case "1":
      result = await day1.solvePart1(additionalArgs);
    case "2":
          result = await day1.solvePart2(additionalArgs);
    case "3":
          result = await day2.solvePart1(additionalArgs);
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
    case "10":
    case "11":
    case "12":
    case "13":
    case "14":
    case "15":
    case "16":
    case "17":
    case "18":
    case "19":
    case "20":
    case "21":
    case "22":
    case "23":
    case "24":
    case "25":
    default:
      // WOULD BE NICE IF WE COULD VALIDATE THIS AS AN OPTION BUT WE CANNOT FOR SOME REASON?
      // I.E., allowed ["1","2"] recognizes problemToSolve=1 but errors on problemToSolve=2
      //It is late so that may be something to figure out on day 2
      throw FormatException('Invalid problem number. Problems are numbered 1 through 25.');
  }
  print(result);
}

void printUsage(ArgParser argParser) {
  print('Usage: dart adv2023.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('adv2023 version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }
    
    await solveProblem(results['problemToSolve'], results.rest);

  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
