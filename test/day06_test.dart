// --- Day 6: Lanternfish ---
// https://adventofcode.com/2021/day/6

import 'dart:io';
import 'package:advent_of_code_2021/day06.dart';
import 'package:test/test.dart';

final input = File('test/data/day06.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(const ['3,4,3,1,2']), equals(5934));
    });
    test('Solution', () {
      expect(solveA(input), equals(388419));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(const ['3,4,3,1,2']), equals(26984457539));
    });
    test('Solution', () {
      expect(solveB(input), equals(1740449478328));
    });
  });
}
