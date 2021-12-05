// --- Day 5: Hydrothermal Venture ---
// https://adventofcode.com/2021/day/5

import 'dart:io';
import 'package:advent_of_code_2021/day05.dart';
import 'package:test/test.dart';

final input = File('test/data/day05.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '0,9 -> 5,9',
            '8,0 -> 0,8',
            '9,4 -> 3,4',
            '2,2 -> 2,1',
            '7,0 -> 7,4',
            '6,4 -> 2,0',
            '0,9 -> 2,9',
            '3,4 -> 1,4',
            '0,0 -> 8,8',
            '5,5 -> 8,2',
          ]),
          equals(5));
    });
    test('Solution', () {
      expect(solveA(input), equals(3990));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            '0,9 -> 5,9',
            '8,0 -> 0,8',
            '9,4 -> 3,4',
            '2,2 -> 2,1',
            '7,0 -> 7,4',
            '6,4 -> 2,0',
            '0,9 -> 2,9',
            '3,4 -> 1,4',
            '0,0 -> 8,8',
            '5,5 -> 8,2',
          ]),
          equals(12));
    });
    test('Solution', () {
      expect(solveB(input), equals(21305));
    });
  });
}
