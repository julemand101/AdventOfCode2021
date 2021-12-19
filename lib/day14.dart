// --- Day 14: Extended Polymerization ---
// https://adventofcode.com/2021/day/14

import 'dart:math';

int solveA(List<String> input) => solve(input, steps: 10);
int solveB(List<String> input) => solve(input, steps: 40);

int solve(List<String> input, {required int steps}) {
  var pairCount = <String, int>{};
  for (final pair in input.first.pairs) {
    pairCount.addInt(pair, 1);
  }

  final letterCountMap = <String, int>{};
  for (final letter in input.first.letters) {
    letterCountMap.addInt(letter, 1);
  }

  final pairInsertionRules = <String, LetterPair>{};

  for (final line in input.skip(2)) {
    // Example of line:
    // CH -> B
    // 0123456 <- index position in line
    pairInsertionRules[line.substring(0, 2)] = LetterPair(line);
  }

  for (var step = 0; step < steps; step++) {
    final newPairCount = <String, int>{};

    for (final entry in pairCount.entries) {
      final pair = entry.key;
      final count = entry.value;
      final pairInsertionRule = pairInsertionRules[pair]!;

      newPairCount
        ..addInt(pairInsertionRule.firstPair, count)
        ..addInt(pairInsertionRule.secondPair, count);
      letterCountMap.addInt(pairInsertionRule.insertedLetter, count);
    }

    pairCount = newPairCount;
  }

  return letterCountMap.values.reduce(max) - letterCountMap.values.reduce(min);
}

class LetterPair {
  final String firstPair;
  final String secondPair;
  final String insertedLetter;

  // Example of line:
  // CH -> B
  // 0123456 <- index position in line
  LetterPair(String line)
      : firstPair = line[0] + line[6],
        secondPair = line[6] + line[1],
        insertedLetter = line[6];
}

extension StringExtension on String {
  Iterable<String> get pairs sync* {
    for (var i = 1; i < length; i++) {
      yield substring(i - 1, i + 1);
    }
  }

  Iterable<String> get letters => split('');
}

extension MapExtension on Map<String, int> {
  void addInt(String key, int addValue) =>
      update(key, (value) => value + addValue, ifAbsent: () => addValue);
}
