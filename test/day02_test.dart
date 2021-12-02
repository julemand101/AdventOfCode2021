// --- Day 2: Dive! ---
// https://adventofcode.com/2021/day/2

import 'dart:io';
import 'package:advent_of_code_2021/day02.dart';
import 'package:test/test.dart';

final input = File('test/data/day02.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            'forward 5',
            'down 5',
            'forward 8',
            'up 3',
            'down 8',
            'forward 2',
          ]),
          equals(150));
    });
    test('Solution', () {
      expect(solveA(input), equals(2147104));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            'forward 5',
            'down 5',
            'forward 8',
            'up 3',
            'down 8',
            'forward 2',
          ]),
          equals(900));
    });
    test('Solution', () {
      expect(solveB(input), equals(2044620088));
    });
  });
}
