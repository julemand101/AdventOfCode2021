// --- Day 11: Dumbo Octopus ---
// https://adventofcode.com/2021/day/11

import 'dart:typed_data';

int solveA(Iterable<String> input) =>
    solve(input, unlimitedSteps: false).sumOfFlashes;

int solveB(Iterable<String> input) =>
    solve(input, unlimitedSteps: true).stepsUntilSync;

Result solve(Iterable<String> input, {required bool unlimitedSteps}) {
  final grid = Grid(10, 10)
    ..setAll(input.expand((line) => line.split('')).map(int.parse));
  var sumOfFlashes = 0;

  for (var step = 1; unlimitedSteps || step <= 100; step++) {
    // First, the energy level of each octopus increases by 1.
    grid.increaseAll();

    // Then, any octopus with an energy level greater than 9 flashes. This
    // increases the energy level of all adjacent octopuses by 1, including
    // octopuses that are diagonally adjacent. If this causes an octopus to
    // have an energy level greater than 9, it also flashes. This process
    // continues as long as new octopuses keep having their energy level
    // increased beyond 9. (An octopus can only flash at most once per step.)
    final Set<int> flashedIndexes = {};
    bool anyFlashes;

    do {
      anyFlashes = false;
      for (var y = 0; y < grid.ySize; y++) {
        for (var x = 0; x < grid.xSize; x++) {
          if (grid.get(x, y) > 9 &&
              flashedIndexes.add(grid.listIndexOf(x, y))) {
            grid.increaseAdjacentValues(x, y);
            anyFlashes = true;
            sumOfFlashes++;
          }
        }
      }
    } while (anyFlashes);

    // In part B, we want to stop if all positions in the grid ends up flashing.
    // We therefore check if the number of flashed points is the same as the
    // number of all elements in the grid.
    if (flashedIndexes.length == grid.list.length) {
      return Result(step, sumOfFlashes);
    }

    // Finally, any octopus that flashed during this step has its energy level
    // set to 0, as it used all of its energy to flash.
    for (final index in flashedIndexes) {
      grid.list[index] = 0;
    }
  }

  return Result(100, sumOfFlashes);
}

class Result {
  final int stepsUntilSync;
  final int sumOfFlashes;

  Result(this.stepsUntilSync, this.sumOfFlashes);
}

class Grid {
  final int xSize;
  final int ySize;
  final Uint8List list;

  Grid(this.xSize, this.ySize) : list = Uint8List(xSize * ySize);

  int get(int x, int y) => list[listIndexOf(x, y)];
  int listIndexOf(int x, int y) => x + (y * xSize);

  void set(int x, int y, int value) => list[listIndexOf(x, y)] = value;
  void setAll(Iterable<int> values) => list.setAll(0, values);

  bool isValidCoordinate(int x, int y) =>
      x >= 0 && y >= 0 && x < xSize && y < ySize;

  void increaseAndIgnoreInvalidCoordinate(int x, int y) {
    if (isValidCoordinate(x, y)) {
      list[listIndexOf(x, y)]++;
    }
  }

  void increaseAdjacentValues(int x, int y) {
    increaseAndIgnoreInvalidCoordinate(x - 1, y - 1); // Up-Left
    increaseAndIgnoreInvalidCoordinate(x, y - 1); //     Up
    increaseAndIgnoreInvalidCoordinate(x + 1, y - 1); // Up-Right
    increaseAndIgnoreInvalidCoordinate(x - 1, y); //     Left
    increaseAndIgnoreInvalidCoordinate(x + 1, y); //     Right
    increaseAndIgnoreInvalidCoordinate(x - 1, y + 1); // Down-Left
    increaseAndIgnoreInvalidCoordinate(x, y + 1); //     Down
    increaseAndIgnoreInvalidCoordinate(x + 1, y + 1); // Down-Right
  }

  void increaseAll() {
    for (var i = 0; i < list.length; i++) {
      list[i]++;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    for (var y = 0; y < ySize; y++) {
      for (var x = 0; x < xSize; x++) {
        buffer.write(get(x, y));
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
