// --- Day 5: Hydrothermal Venture ---
// https://adventofcode.com/2021/day/5

import 'dart:math';

RegExp inputRegExp = RegExp(r'(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)');

int solveA(Iterable<String> input) => solve(input, partB: false);
int solveB(Iterable<String> input) => solve(input, partB: true);

int solve(Iterable<String> input, {required bool partB}) {
  final oceanFloor = <Point<int>, int>{};

  for (final match in input.map((line) => inputRegExp.firstMatch(line)!)) {
    final x1 = int.parse(match.namedGroup('x1')!);
    final y1 = int.parse(match.namedGroup('y1')!);
    final x2 = int.parse(match.namedGroup('x2')!);
    final y2 = int.parse(match.namedGroup('y2')!);

    if (x1 == x2) {
      final targetY = max(y1, y2);

      for (var y = min(y1, y2); y <= targetY; y++) {
        oceanFloor.incrementLineOverlap(Point(x1, y));
      }
    } else if (y1 == y2) {
      final targetX = max(x1, x2);

      for (var x = min(x1, x2); x <= targetX; x++) {
        oceanFloor.incrementLineOverlap(Point(x, y1));
      }
    } else if (partB) {
      final Point<int> fromPoint, targetPoint;

      if (x1 < x2) {
        fromPoint = Point(x1, y1);
        targetPoint = Point(x2, y2);
      } else {
        fromPoint = Point(x2, y2);
        targetPoint = Point(x1, y1);
      }

      // Because of the limits of the hydrothermal vent mapping system...
      // or a diagonal line at exactly 45 degrees.
      final slopePoint =
          (fromPoint.y - targetPoint.y) ~/ (fromPoint.x - targetPoint.x) == 1
              ? const Point(1, 1)
              : const Point(1, -1);

      for (var point = fromPoint; point != targetPoint; point += slopePoint) {
        oceanFloor.incrementLineOverlap(point);
      }
      // Include the target point
      oceanFloor.incrementLineOverlap(targetPoint);
    }
  }

  return oceanFloor.numberOfPointsWithAtLeastTwoLinesOverlap;
}

extension OceanFloorExtension on Map<Point<int>, int> {
  void incrementLineOverlap(Point<int> point) =>
      update(point, (n) => n + 1, ifAbsent: () => 1);

  int get numberOfPointsWithAtLeastTwoLinesOverlap =>
      values.where((value) => value > 1).length;
}
