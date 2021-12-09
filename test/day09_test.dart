// --- Day 9: Smoke Basin ---
// https://adventofcode.com/2021/day/9

import 'dart:io';
import 'package:advent_of_code_2021/day09.dart';
import 'package:test/test.dart';

final input = File('test/data/day09.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '2199943210',
            '3987894921',
            '9856789892',
            '8767896789',
            '9899965678',
          ]),
          equals(15));
    });
    test('Solution', () {
      expect(solveA(input), equals(631));
    });
  });
}
