// --- Day 13: Transparent Origami ---
// https://adventofcode.com/2021/day/13

import 'dart:io';
import 'package:advent_of_code_2021/day13.dart';
import 'package:test/test.dart';

final input = File('test/data/day13.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            '6,10',
            '0,14',
            '9,10',
            '0,3',
            '10,4',
            '4,11',
            '6,0',
            '6,12',
            '4,1',
            '0,13',
            '10,12',
            '3,4',
            '3,0',
            '8,4',
            '1,10',
            '2,14',
            '8,10',
            '9,0',
            '',
            'fold along y=7',
            'fold along x=5',
          ]),
          equals(17));
    });
    test('Solution', () {
      expect(solveA(input), equals(693));
    });
  });
  group('Part One', () {
    test('Solution', () {
      expect(solveB(input), equals(r'''
█  █  ██  █    ████ ███   ██  ████ █  █
█  █ █  █ █       █ █  █ █  █    █ █  █
█  █ █    █      █  █  █ █  █   █  █  █
█  █ █    █     █   ███  ████  █   █  █
█  █ █  █ █    █    █ █  █  █ █    █  █
 ██   ██  ████ ████ █  █ █  █ ████  ██ 
'''));
    });
  });
}
