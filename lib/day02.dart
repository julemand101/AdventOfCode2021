// --- Day 2: Dive! ---
// https://adventofcode.com/2021/day/2

int solveA(Iterable<String> input) {
  var depth = 0, horizontal = 0;

  for (final instructionLine in input) {
    final [instruction, amountString] = instructionLine.split(' ');
    final amount = int.parse(amountString);

    switch (instruction) {
      case 'forward':
        horizontal += amount;
      case 'down':
        depth += amount;
      case 'up':
        depth -= amount;
      default:
        throw Exception('$instruction is not a valid instruction.');
    }
  }

  return depth * horizontal;
}

int solveB(Iterable<String> input) {
  var aim = 0, depth = 0, horizontal = 0;

  for (final instructionLine in input) {
    final [instruction, amountString] = instructionLine.split(' ');
    final amount = int.parse(amountString);

    switch (instruction) {
      case 'forward':
        horizontal += amount;
        depth += aim * amount;
      case 'down':
        aim += amount;
      case 'up':
        aim -= amount;
      default:
        throw Exception('$instruction is not a valid instruction.');
    }
  }

  return depth * horizontal;
}
