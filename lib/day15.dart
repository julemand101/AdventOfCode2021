// --- Day 15: Chiton ---
// https://adventofcode.com/2021/day/15

import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

int solveA(List<String> input) => solve(parseInputToGrid(input));

int solveB(List<String> input) {
  final smallGrid = parseInputToGrid(input);
  final bigGrid = Grid.uInt8List(smallGrid.xSize * 5, smallGrid.ySize * 5);

  for (var y = 0; y < bigGrid.ySize; y++) {
    for (var x = 0; x < bigGrid.xSize; x++) {
      final value = smallGrid.get(x % smallGrid.xSize, y % smallGrid.ySize) +
          (x ~/ smallGrid.xSize) +
          (y ~/ smallGrid.ySize);
      bigGrid.set(x, y, value <= 9 ? value : value % 9);
    }
  }

  return solve(bigGrid);
}

Grid parseInputToGrid(List<String> input) =>
    Grid.uInt8List(input.first.length, input.length)
      ..setAll(input.expand((line) => line.split('').map(int.parse)));

int solve(Grid riskLevelGrid) {
  final distanceGrid = Grid.uInt16List(riskLevelGrid.xSize, riskLevelGrid.ySize)
    ..setAllValue(-1) // Since we have unsigned numbers = set to max
    ..set(0, 0, 0);

  // Use of sorted SplayTreeSet of points we should consider to visit. The set
  // does not contains points where we have yet to give it a distance since that
  // distance would be infinite and should never be considered as the next point
  // to visit.
  //
  // The set is automatically sorted so the first point is the point with lowest
  // current distance and is therefore the next point to visit. By doing this
  // sorting, it is much more efficient to get the answer to the question:
  // "What point should we visit next".
  final sortedSetOfCandidatesToVisit = SplayTreeSet<Point<int>>((a, b) {
    if (a == b) {
      return 0;
    } else {
      final compareDistance =
          distanceGrid.get(a.x, a.y).compareTo(distanceGrid.get(b.x, b.y));

      if (compareDistance != 0) {
        return compareDistance;
      } else {
        // This is a hellish hack but we need to make sure that we are always
        // sorting in a consistent way but at the same time, we need to make
        // sure that two different points is never going to be equal.
        final compareX = a.x.compareTo(b.x);

        if (compareX != 0) {
          return compareX;
        } else {
          return a.y.compareTo(b.y);
        }
      }
    }
  })
    ..add(const Point(0, 0)); // Add the first point to visit

  // Much cheaper to keep count of unvisited point by using a variable
  var numberOfUnvisitedPoints = distanceGrid.list.length;

  while (numberOfUnvisitedPoints > 0) {
    final minimumPoint = sortedSetOfCandidatesToVisit.first;
    final x = minimumPoint.x;
    final y = minimumPoint.y;
    final currentDistance = distanceGrid.get(x, y);

    // Set point to visited
    sortedSetOfCandidatesToVisit.remove(minimumPoint);
    numberOfUnvisitedPoints--;

    // Update neighbour distances
    void updateDistance(int x, int y) {
      if (riskLevelGrid.isValidCoordinate(x, y)) {
        final newDistance = riskLevelGrid.get(x, y) + currentDistance;

        if (newDistance < distanceGrid.get(x, y)) {
          final point = Point(x, y);

          sortedSetOfCandidatesToVisit.remove(point);
          distanceGrid.set(x, y, newDistance);
          sortedSetOfCandidatesToVisit.add(point);
        }
      }
    }

    updateDistance(x - 1, y); // Left
    updateDistance(x + 1, y); // Right
    updateDistance(x, y - 1); // Up
    updateDistance(x, y + 1); // Down
  }

  // Get the distance to the bottom-right corner
  return distanceGrid.get(distanceGrid.xSize - 1, distanceGrid.ySize - 1);
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
