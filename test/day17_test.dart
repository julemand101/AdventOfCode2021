// --- Day 17: Trick Shot ---
// https://adventofcode.com/2021/day/17

import 'package:advent_of_code_2021/day17.dart';
import 'package:test/test.dart';

const input = 'target area: x=185..221, y=-122..-74';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA('target area: x=20..30, y=-10..-5'), equals(45));
    });
    test('Solution', () {
      expect(solveA(input), equals(7381));
    });
  });
}
