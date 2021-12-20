// --- Day 15: Chiton ---
// https://adventofcode.com/2021/day/15

import 'dart:math';
import 'dart:typed_data';

int solveA(List<String> input) {
  final riskLevelGrid = Grid.uInt8List(input.first.length, input.length)
    ..setAll(input.expand((line) => line.split('').map(int.parse)));

  final distanceGrid = Grid.uInt16List(riskLevelGrid.xSize, riskLevelGrid.ySize)
    ..setAllValue(-1)
    ..set(0, 0, 0);

  final visitedGrid = Grid.uInt8List(riskLevelGrid.xSize, riskLevelGrid.ySize);
  var numberOfUnvisitedPoints = visitedGrid.list.length;

  while (numberOfUnvisitedPoints != 0) {
    final minimumPoint = findMinDistance(distanceGrid, visitedGrid);
    final x = minimumPoint.x;
    final y = minimumPoint.y;
    final currentDistance = distanceGrid.get(x, y);

    // Set point to visited
    visitedGrid.set(minimumPoint.x, minimumPoint.y, 1);
    numberOfUnvisitedPoints--;

    // Update neighbour distances
    final void Function(int, int) updateDistance = (int x, int y) {
      if (riskLevelGrid.isValidCoordinate(x, y)) {
        final newDistance = riskLevelGrid.get(x, y) + currentDistance;

        if (newDistance < distanceGrid.get(x, y)) {
          distanceGrid.set(x, y, newDistance);
        }
      }
    };

    updateDistance(x - 1, y);
    updateDistance(x + 1, y);
    updateDistance(x, y - 1);
    updateDistance(x, y + 1);
  }

  // Get the distance to the bottom-right corner
  return distanceGrid.get(distanceGrid.xSize - 1, distanceGrid.ySize - 1);
}

// Finding the minimum distance
Point<int> findMinDistance(Grid distanceGrid, Grid visitedGrid) {
  int? minDistance;
  Point<int>? minDistancePoint;

  for (var y = 0; y < distanceGrid.ySize; y++) {
    for (var x = 0; x < distanceGrid.xSize; x++) {
      if (visitedGrid.get(x, y) == 0) {
        final newDistance = distanceGrid.get(x, y);

        if (minDistance == null || newDistance < minDistance) {
          minDistance = newDistance;
          minDistancePoint = Point(x, y);
        }
      }
    }
  }

  return minDistancePoint!;
}

class Grid {
  final int xSize;
  final int ySize;
  final List<int> list;

  Grid.uInt8List(this.xSize, this.ySize) : list = Uint8List(xSize * ySize);
  Grid.uInt16List(this.xSize, this.ySize) : list = Uint16List(xSize * ySize);

  int get(int x, int y) => list[listIndexOf(x, y)];
  int listIndexOf(int x, int y) => x + (y * xSize);

  void set(int x, int y, int value) => list[listIndexOf(x, y)] = value;
  void setAll(Iterable<int> values) => list.setAll(0, values);
  void setAllValue(int value) => list.fillRange(0, list.length, value);

  bool isValidCoordinate(int x, int y) =>
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
