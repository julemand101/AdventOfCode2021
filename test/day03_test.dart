// --- Day 3: Binary Diagnostic ---
// https://adventofcode.com/2021/day/3

import 'dart:io';
import 'package:advent_of_code_2021/day03.dart';
import 'package:test/test.dart';

final input = File('test/data/day03.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '00100',
            '11110',
            '10110',
            '10111',
            '10101',
            '01111',
            '00111',
            '11100',
            '10000',
            '11001',
            '00010',
            '01010',
          ]),
          equals(198));
    });
    test('Solution', () {
      expect(solveA(input), equals(741950));
    });
  });
}
