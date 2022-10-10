// --- Day 20: Trench Map ---
// https://adventofcode.com/2021/day/20

import 'dart:io';
import 'package:advent_of_code_2021/day20.dart';
import 'package:test/test.dart';

final input = File('test/data/day20.txt').readAsLinesSync();
final inputExample = File('test/data/day20_example.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(inputExample), equals(35));
    });
    test('Solution', () {
      expect(solveA(input), equals(5432));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(inputExample), equals(3351));
    });
    test('Solution', () {
      expect(solveB(input), equals(16016));
    });
  });
}
