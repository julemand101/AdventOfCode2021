// --- Day 1: Sonar Sweep ---
// https://adventofcode.com/2021/day/1

import 'dart:io';
import 'package:advent_of_code_2021/day01.dart';
import 'package:test/test.dart';

final input = File('test/data/day01.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '199',
            '200',
            '208',
            '210',
            '200',
            '207',
            '240',
            '269',
            '260',
            '263',
          ]),
          equals(7));
    });
    test('Solution', () {
      expect(solveA(input), equals(1390));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            '199',
            '200',
            '208',
            '210',
            '200',
            '207',
            '240',
            '269',
            '260',
            '263',
          ]),
          equals(5));
    });
    test('Solution', () {
      expect(solveB(input), equals(1457));
    });
  });
}
