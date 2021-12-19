// --- Day 14: Extended Polymerization ---
// https://adventofcode.com/2021/day/14

import 'dart:collection';

import 'dart:math';

int solveA(List<String> input) {
  final polymerTemplate = LinkedList<LetterEntry>()
    ..addAll(input.first.split('').map((letter) => LetterEntry(letter)));
  final pairInsertionRules = <String, Map<String, String>>{};

  for (final line in input.skip(2)) {
    // Example of line:
    // CH -> B
    // 0123456 <- index position in line
    pairInsertionRules
        .putIfAbsent(line[0], () => {})
        .putIfAbsent(line[1], () => line[6]);
  }

  for (var step = 0; step < 10; step++) {
    for (var letterEntry = polymerTemplate.first.next;
        letterEntry != null;
        letterEntry = letterEntry.next) {
      final letterToInsert =
          pairInsertionRules[letterEntry.previous!.letter]?[letterEntry.letter];
      if (letterToInsert != null) {
        letterEntry.insertBefore(LetterEntry(letterToInsert));
      }
    }
  }

  final letterCountMap = polymerTemplate.fold<Map<String, int>>(
      <String, int>{},
      (map, letterEntry) => map
        ..update(letterEntry.letter, (value) => value + 1, ifAbsent: () => 1));

  return letterCountMap.values.reduce(max) - letterCountMap.values.reduce(min);
}

class LetterEntry extends LinkedListEntry<LetterEntry> {
  final String letter;

  LetterEntry(this.letter);

  @override
  String toString() => letter;
}
