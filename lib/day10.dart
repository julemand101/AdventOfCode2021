// --- Day 10: Syntax Scoring ---
// https://adventofcode.com/2021/day/10

const Map<String, String> matchingBrackets = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>',
};

int solveA(Iterable<String> input) {
  const Map<String, int> pointsForIllegalCharacter = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  };
  var sum = 0;

  for (final line in input) {
    // Keep track of the order we should expect closing brackets
    final stack = <String>[];

    for (var i = 0; i < line.length; i++) {
      final currentCharacter = line[i];
      final matchingBracket = matchingBrackets[currentCharacter];

      if (matchingBracket != null) {
        // Found a new opening bracket
        stack.add(matchingBracket);
      } else if (stack.removeLast() != currentCharacter) {
        // Found invalid closing bracket
        sum += pointsForIllegalCharacter[currentCharacter]!;
        break;
      }
    }
  }

  return sum;
}

int solveB(Iterable<String> input) {
  const Map<String, int> pointsForClosingCharacter = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
  };
  final scores = <int>[];

  lineLoop:
  for (final line in input) {
    // Keep track of the order we should expect closing brackets
    final stack = <String>[];

    for (var i = 0; i < line.length; i++) {
      final currentCharacter = line[i];
      final matchingBracket = matchingBrackets[currentCharacter];

      if (matchingBracket != null) {
        // Found a new opening bracket
        stack.add(matchingBracket);
      } else if (stack.removeLast() != currentCharacter) {
        // Found invalid closing bracket
        continue lineLoop;
      }
    }

    scores.add(stack.reversed
        .map((closingCharacter) => pointsForClosingCharacter[closingCharacter]!)
        .fold(0, (score, points) => (score * 5) + points));
  }

  // "The winner is found by sorting all of the scores and then taking the
  // middle score. (There will always be an odd number of scores to consider.)"
  return (scores..sort())[scores.length ~/ 2];
}
