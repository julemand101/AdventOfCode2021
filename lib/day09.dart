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
          .adjacentLocations(x, y)
          .every((adjacentLocationValue) => value < adjacentLocationValue)) {
        sum += value + 1;
      }
    }
  }

  return sum;
}

class Grid {
  final int xSize;
  final int ySize;
  final Int8List _list;

  Grid(this.xSize, this.ySize) : _list = Int8List(xSize * ySize);

  int get(int x, int y) => _list[_getPos(x, y)];
  int _getPos(int x, int y) => x + (y * xSize);

  void set(int x, int y, int value) => _list[_getPos(x, y)] = value;
  void setAll(Iterable<int> values) => _list.setAll(0, values);

  Iterable<int> adjacentLocations(int x, int y) sync* {
    // Up
    if (validCoordinate(x, y - 1)) yield get(x, y - 1);
    // Right
    if (validCoordinate(x + 1, y)) yield get(x + 1, y);
    // Down
    if (validCoordinate(x, y + 1)) yield get(x, y + 1);
    // Left
    if (validCoordinate(x - 1, y)) yield get(x - 1, y);
  }

  bool validCoordinate(int x, int y) =>
      x >= 0 && y >= 0 && x < xSize && y < ySize;

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
