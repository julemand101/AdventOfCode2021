// --- Day 19: Beacon Scanner ---
// https://adventofcode.com/2021/day/19

import 'dart:math';

class Point3d {
  final int x, y, z;

  const Point3d(this.x, this.y, this.z);

  factory Point3d.fromLine(String line) {
    final stringParts = line.split(',');

    return Point3d(
      int.parse(stringParts[0]),
      int.parse(stringParts[1]),
      int.parse(stringParts[2]),
    );
  }

  double distance(Point3d otherPoint) => pow(
        pow(otherPoint.x - x, 2) +
            pow(otherPoint.y - y, 2) +
            pow(otherPoint.z - z, 2),
        0.5,
      ).toDouble();

  int manhattanDistance(Point3d otherPoint) =>
      (x - otherPoint.x).abs() +
      (y - otherPoint.y).abs() +
      (z - otherPoint.z).abs();

  Point3d roll() => Point3d(x, z, -y);
  Point3d turnClockWise() => Point3d(-y, x, z);
  Point3d turnCounterClockWise() => Point3d(y, -x, z);
  Point3d moveBy(int dX, int dY, int dZ) => Point3d(x + dX, y + dY, z + dZ);

  Iterable<Point3d> get allRotations sync* {
    // Very much inspired by: https://stackoverflow.com/a/58471362/1953515
    // def sequence(m):
    //   for roll_index in range(6):
    //     m = roll(m)
    //     yield(m)
    //     for turn_index in range(3):
    //       m = turn_cw(m) if roll_index % 2 == 0 else turn_ccw(m)
    //       yield(m)
    var currentPoint = this;
    for (var rollIndex = 0; rollIndex < 6; rollIndex++) {
      currentPoint = currentPoint.roll();
      yield currentPoint;

      for (var turnIndex = 0; turnIndex < 3; turnIndex++) {
        currentPoint = rollIndex % 2 == 0
            ? currentPoint.turnClockWise()
            : currentPoint.turnCounterClockWise();
        yield (currentPoint);
      }
    }
  }

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object other) =>
      other is Point3d && x == other.x && y == other.y && z == other.z;

  @override
  String toString() => 'Point3d($x, $y, $z)';
}

class Scanner {
  final int id;
  final Point3d center;
  final List<Point3d> points;

  // index = index in points, value = set of distances to other points
  late final List<Set<double>> distancesFromPointIndex = [
    for (final startPoint in points)
      {
        for (final endPoint in points)
          if (!identical(startPoint, endPoint)) startPoint.distance(endPoint)
      }
  ];

  Scanner({required this.id, required this.center, required this.points});

  static final RegExp _scannerIdPattern = RegExp(r'--- scanner (\d+) ---');
  factory Scanner.fromLines(List<String> lines) => Scanner(
        id: int.parse(_scannerIdPattern.firstMatch(lines.first)![1]!),
        center: const Point3d(0, 0, 0),
        points: [for (final line in lines.skip(1)) Point3d.fromLine(line)],
      );

  // empty list = no overlap
  List<OverlappingWithResult> overlappingWith(Scanner otherScanner) => [
        for (var a = 0; a < distancesFromPointIndex.length; a++)
          for (var b = 0; b < otherScanner.distancesFromPointIndex.length; b++)
            if (distancesFromPointIndex[a]
                    .intersection(otherScanner.distancesFromPointIndex[b])
                    .length >
                10)
              OverlappingWithResult(a, b)
      ];

  Iterable<Scanner> get rotations sync* {
    final List<Iterator<Point3d>> rotationIterators = [
      ...points.map((e) => e.allRotations.iterator)
    ];

    for (var i = 0; i < 24; i++) {
      yield Scanner(
        id: id,
        center: center,
        points: [
          for (final iterator in rotationIterators)
            (iterator..moveNext()).current
        ],
      );
    }
  }

  Scanner move(int dX, int dY, int dZ) => Scanner(
        id: id,
        center: center.moveBy(dX, dY, dZ),
        points: [...points.map((p) => p.moveBy(dX, dY, dZ))],
      );
}

class OverlappingWithResult {
  final int indexInScanner1, indexInScanner2;
  const OverlappingWithResult(this.indexInScanner1, this.indexInScanner2);
}

Iterable<Scanner> parseInputToScanners(Iterable<String> lines) sync* {
  final buffer = <String>[];

  for (final line in lines) {
    if (line.isEmpty) {
      yield Scanner.fromLines(buffer);
      buffer.clear();
    } else {
      buffer.add(line);
    }
  }

  if (buffer.isNotEmpty) {
    yield Scanner.fromLines(buffer);
  }
}

int solveA(Iterable<String> input) => solve(input).numberOfBeacons;
int solveB(Iterable<String> input) => solve(input).largestManhattanDistance;

class Result {
  final int numberOfBeacons;
  final int largestManhattanDistance;

  const Result({
    required this.numberOfBeacons,
    required this.largestManhattanDistance,
  });
}

Result solve(Iterable<String> input) {
  final List<Scanner> scanners = [...parseInputToScanners(input)];
  Scanner resultScanner = scanners.removeAt(0);
  Set<Point3d> scannerCenters = {};

  while (scanners.isNotEmpty) {
    final resultScannerPointsSet = resultScanner.points.toSet();

    for (var scannerIndex = 0; scannerIndex < scanners.length; scannerIndex++) {
      final scanner = scanners[scannerIndex];
      final overlap = resultScanner.overlappingWith(scanner);

      if (overlap.isNotEmpty) {
        final s1Index = overlap.first.indexInScanner1;
        final s2Index = overlap.first.indexInScanner2;

        final overlappingPointInResultScanner = resultScanner.points[s1Index];

        for (Scanner movedScanner in scanner.rotations.map((e) => e.move(
              overlappingPointInResultScanner.x - e.points[s2Index].x,
              overlappingPointInResultScanner.y - e.points[s2Index].y,
              overlappingPointInResultScanner.z - e.points[s2Index].z,
            ))) {
          final overlappingPointsCount = movedScanner.points
              .toSet()
              .intersection(resultScannerPointsSet)
              .length;

          if (overlappingPointsCount > 1) {
            resultScanner = Scanner(
              id: resultScanner.id,
              center: resultScanner.center,
              points: [...resultScannerPointsSet..addAll(movedScanner.points)],
            );
            scanners.removeAt(scannerIndex);
            scannerCenters.add(movedScanner.center);
          }
        }
      }
    }
  }

  int largestManhattanDistance = 0;
  for (final centerA in scannerCenters) {
    for (final centerB in scannerCenters) {
      largestManhattanDistance = max(
        largestManhattanDistance,
        centerA.manhattanDistance(centerB),
      );
    }
  }

  return Result(
    numberOfBeacons: resultScanner.points.length,
    largestManhattanDistance: largestManhattanDistance,
  );
}
