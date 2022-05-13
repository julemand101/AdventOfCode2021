import 'dart:io';

void main(List<String> args) {
  if (args.length != 2) {
    print('Please call with: <dayNumber> <dayTitle>');
    return;
  }

  final dayNumber = args[0];
  final paddedDayNumber = dayNumber.padLeft(2, '0');
  final dayTitle = args[1];

  // Create lib file
  final dayFileName = 'day$paddedDayNumber.dart';

  File('lib/$dayFileName').writeAsString(
    '''
// --- Day $dayNumber: $dayTitle ---
// https://adventofcode.com/2021/day/$dayNumber

int solveA(Iterable<String> input) {
  return 0;
}
''',
  );

  // Create empty test data file
  final dataPath = 'test/data/day$paddedDayNumber.txt';
  File(dataPath).create();

  // Create unit tests
  File(
    'test/day${paddedDayNumber}_test.dart',
  ).writeAsString(
    '''
// --- Day $dayNumber: $dayTitle ---
// https://adventofcode.com/2021/day/$dayNumber

import 'dart:io';
import 'package:advent_of_code_2021/$dayFileName';
import 'package:test/test.dart';

final input = File('$dataPath').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '<someLine>',
          ]),
          equals(-1));
    });
    test('Solution', () {
      expect(solveA(input), equals(-1));
    });
  });
}
''',
  );
}
