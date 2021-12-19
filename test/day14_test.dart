// --- Day 14: Extended Polymerization ---
// https://adventofcode.com/2021/day/14

import 'dart:io';
import 'package:advent_of_code_2021/day14.dart';
import 'package:test/test.dart';

final input = File('test/data/day14.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            'NNCB',
            '',
            'CH -> B',
            'HH -> N',
            'CB -> H',
            'NH -> C',
            'HB -> C',
            'HC -> B',
            'HN -> C',
            'NN -> C',
            'BH -> H',
            'NC -> B',
            'NB -> B',
            'BN -> B',
            'BB -> N',
            'BC -> B',
            'CC -> N',
            'CN -> C',
          ]),
          equals(1588));
    });
    test('Solution', () {
      expect(solveA(input), equals(4517));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            'NNCB',
            '',
            'CH -> B',
            'HH -> N',
            'CB -> H',
            'NH -> C',
            'HB -> C',
            'HC -> B',
            'HN -> C',
            'NN -> C',
            'BH -> H',
            'NC -> B',
            'NB -> B',
            'BN -> B',
            'BB -> N',
            'BC -> B',
            'CC -> N',
            'CN -> C',
          ]),
          equals(2188189693529));
    });
    test('Solution', () {
      expect(solveB(input), equals(4704817645083));
    });
  });
}
