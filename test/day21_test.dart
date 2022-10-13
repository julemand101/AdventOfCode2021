// --- Day 21: Dirac Dice ---
// https://adventofcode.com/2021/day/21

import 'package:advent_of_code_2021/day21.dart';
import 'package:test/test.dart';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
        solveA(
          player1StartingPosition: 4,
          player2StartingPosition: 8,
        ),
        equals(739785),
      );
    });
    test('Solution', () {
      expect(
        solveA(
          player1StartingPosition: 7,
          player2StartingPosition: 5,
        ),
        equals(798147),
      );
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
        solveB(
          player1StartingPosition: 4,
          player2StartingPosition: 8,
        ),
        equals(444356092776315),
      );
    });
    test('Solution', () {
      expect(
        solveB(
          player1StartingPosition: 7,
          player2StartingPosition: 5,
        ),
        equals(809953813657517),
      );
    });
  });
}
