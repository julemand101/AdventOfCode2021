// --- Day 15: Chiton ---
// https://adventofcode.com/2021/day/15

import 'dart:io';
import 'package:advent_of_code_2021/day15.dart';
import 'package:test/test.dart';

final input = File('test/data/day15.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '1163751742',
            '1381373672',
            '2136511328',
            '3694931569',
            '7463417111',
            '1319128137',
            '1359912421',
            '3125421639',
            '1293138521',
            '2311944581',
          ]),
          equals(40));
    });
    test('Solution', () {
      expect(solveA(input), equals(696));
    });
  });
}
