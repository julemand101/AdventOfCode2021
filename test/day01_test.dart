// --- Day 1: Report Repair ---
// https://adventofcode.com/2020/day/1

import 'dart:io';
import 'package:advent_of_code_2021/day01.dart';
import 'package:test/test.dart';

final input = File('test/data/day01.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(const ['1721', '979', '366', '299', '675', '1456']),
          equals(514579));
    });
    test('Solution', () {
      expect(solveA(input), equals(972576));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(const ['1721', '979', '366', '299', '675', '1456']),
          equals(241861950));
    });
    test('Solution', () {
      expect(solveB(input), equals(199300880));
    });
  });
}
