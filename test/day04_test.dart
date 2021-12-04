// --- Day 4: Giant Squid ---
// https://adventofcode.com/2021/day/4

import 'dart:io';
import 'package:advent_of_code_2021/day04.dart';
import 'package:test/test.dart';

final input = File('test/data/day04.txt').readAsLinesSync();
final example = File('test/data/day04_example.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals(4512));
    });
    test('Solution', () {
      expect(solveA(input), equals(65325));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(example), equals(1924));
    });
    test('Solution', () {
      expect(solveB(input), equals(4624));
    });
  });
}
