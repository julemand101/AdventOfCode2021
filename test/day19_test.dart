// --- Day 19: Beacon Scanner ---
// https://adventofcode.com/2021/day/19

import 'dart:io';
import 'package:advent_of_code_2021/day19.dart';
import 'package:test/test.dart';

final input = File('test/data/day19.txt').readAsLinesSync();
final exampleInput = File('test/data/day19_example.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(exampleInput), equals(79));
    });
    test('Solution', () {
      expect(solveA(input), equals(381));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(exampleInput), equals(3621));
    });
    test('Solution', () {
      expect(solveB(input), equals(12201));
    });
  });
}
