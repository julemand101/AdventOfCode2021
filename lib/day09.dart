// --- Day 9: Smoke Basin ---
// https://adventofcode.com/2021/day/9

import 'dart:typed_data';

int solveA(List<String> input) {
  final grid = Grid(input.first.length, input.length)
    ..setAll(input.expand((line) => line.split('')).map(int.parse));

  var sum = 0;

  for (var y = 0; y < grid.ySize; y++) {
    for (var x = 0; x < grid.xSize; x++) {
      final value = grid.get(x, y);

      if (grid
          .adjacentLocationValues(x, y)
          .every((adjacentLocationValue) => value < adjacentLocationValue)) {
        sum += value + 1;
      }
    }
  }

  return sum;
}

int solveB(List<String> input) {
  final grid = Grid(input.first.length, input.length)
    ..setAll(input.expand((line) => line.split('')).map(int.parse));

  final basinSizes = <int>[
    for (var y = 0; y < grid.ySize; y++)
      for (var x = 0; x < grid.xSize; x++)
        if (grid.get(x, y) != 9) grid.removeBasinAndGetSize(x, y)
  ]..sort();

  return basinSizes.reversed.take(3).reduce((a, b) => a * b);
}

class Grid {
  final int xSize;
  final int ySize;
  final Uint8List _list;

  Grid(this.xSize, this.ySize) : _list = Uint8List(xSize * ySize);

  int get(int x, int y) => _list[_getPos(x, y)];
  int _getPos(int x, int y) => x + (y * xSize);

  void set(int x, int y, int value) => _list[_getPos(x, y)] = value;
  void setAll(Iterable<int> values) => _list.setAll(0, values);

  Iterable<int> adjacentLocationValues(int x, int y) sync* {
    if (isValidCoordinate(x - 1, y)) yield get(x - 1, y); // Left
    if (isValidCoordinate(x + 1, y)) yield get(x + 1, y); // Right
    if (isValidCoordinate(x, y - 1)) yield get(x, y - 1); // Up
    if (isValidCoordinate(x, y + 1)) yield get(x, y + 1); // Down
  }

  bool isValidCoordinate(int x, int y) =>
      x >= 0 && y >= 0 && x < xSize && y < ySize;

  int removeBasinAndGetSize(int x, int y) {
    if (!isValidCoordinate(x, y) || get(x, y) == 9) {
      return 0;
    }

    // Mark current position as visited by converting it to a "wall"
    set(x, y, 9);

    return 1 +
        removeBasinAndGetSize(x - 1, y) + // Left
        removeBasinAndGetSize(x + 1, y) + // Right
        removeBasinAndGetSize(x, y - 1) + // Up
        removeBasinAndGetSize(x, y + 1); //  Down
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
