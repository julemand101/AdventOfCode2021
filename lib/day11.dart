// --- Day 11: Dumbo Octopus ---
// https://adventofcode.com/2021/day/11

import 'dart:typed_data';

int solveA(Iterable<String> input) {
  final grid = Grid(10, 10)
    ..setAll(input.expand((line) => line.split('')).map(int.parse));
  var sumFlashes = 0;

  for (var step = 1; step <= 100; step++) {
    // First, the energy level of each octopus increases by 1.
    grid.increaseAll();

    final Set<int> flashCache = {};
    bool anyFlashes;

    do {
      anyFlashes = false;
      for (var y = 0; y < 10; y++) {
        for (var x = 0; x < 10; x++) {
          if (grid.get(x, y) > 9 && flashCache.add(grid.getListIndex(x, y))) {
            grid.increaseAdjacentValues(x, y);
            sumFlashes++;
            anyFlashes = true;
          }
        }
      }
    } while (anyFlashes);

    for (final index in flashCache) {
      grid._list[index] = 0;
    }
  }

  return sumFlashes;
}

int solveB(Iterable<String> input) {
  final grid = Grid(10, 10)
    ..setAll(input.expand((line) => line.split('')).map(int.parse));

  // ignore: literal_only_boolean_expressions
  for (var step = 1; true; step++) {
    // First, the energy level of each octopus increases by 1.
    grid.increaseAll();

    final Set<int> flashCache = {};
    bool anyFlashes;

    do {
      anyFlashes = false;
      for (var y = 0; y < 10; y++) {
        for (var x = 0; x < 10; x++) {
          if (grid.get(x, y) > 9 && flashCache.add(grid.getListIndex(x, y))) {
            grid.increaseAdjacentValues(x, y);
            anyFlashes = true;
          }
        }
      }
    } while (anyFlashes);

    if (flashCache.length == grid._list.length) {
      return step;
    }

    for (final index in flashCache) {
      grid._list[index] = 0;
    }
  }
}

class Grid {
  final int xSize;
  final int ySize;
  final Uint8List _list;

  Grid(this.xSize, this.ySize) : _list = Uint8List(xSize * ySize);

  int get(int x, int y) => _list[getListIndex(x, y)];
  int getListIndex(int x, int y) => x + (y * xSize);

  void set(int x, int y, int value) => _list[getListIndex(x, y)] = value;
  void setAll(Iterable<int> values) => _list.setAll(0, values);

  bool isValidCoordinate(int x, int y) =>
      x >= 0 && y >= 0 && x < xSize && y < ySize;

  void increaseIgnoreInvalidCoordinate(int x, int y) {
    if (isValidCoordinate(x, y)) {
      _list[getListIndex(x, y)]++;
    }
  }

  void increaseAdjacentValues(int x, int y) {
    increaseIgnoreInvalidCoordinate(x - 1, y - 1); // Up-Left
    increaseIgnoreInvalidCoordinate(x, y - 1); //     Up
    increaseIgnoreInvalidCoordinate(x + 1, y - 1); // Up-Right
    increaseIgnoreInvalidCoordinate(x - 1, y); //     Left
    increaseIgnoreInvalidCoordinate(x + 1, y); //     Right
    increaseIgnoreInvalidCoordinate(x - 1, y + 1); // Down-Left
    increaseIgnoreInvalidCoordinate(x, y + 1); // Down
    increaseIgnoreInvalidCoordinate(x + 1, y + 1); // Down-Right
  }

  void increaseAll() {
    for (var i = 0; i < _list.length; i++) {
      _list[i]++;
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
