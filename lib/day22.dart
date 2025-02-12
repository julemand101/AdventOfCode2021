// --- Day 22: Reactor Reboot ---
// https://adventofcode.com/2021/day/22

import 'dart:collection';
import 'dart:math';

class Box {
  final Point3d p1;
  final Point3d p2;
  final Set<Point3d> pointsNotPartOfBox = {};

  Box(this.p1, this.p2);

  Box? intersection(Box otherBox) {
    final nP1 = Point3d(
      max(p1.x, otherBox.p1.x),
      max(p1.y, otherBox.p1.y),
      max(p1.z, otherBox.p1.z),
    );

    final nP2 = Point3d(
      min(p2.x, otherBox.p2.x),
      min(p2.y, otherBox.p2.y),
      min(p2.z, otherBox.p2.z),
    );

    if (nP1.x > nP2.x || nP1.y > nP2.y || nP1.z > nP2.z) {
      return null;
    }

    return Box(nP1, nP2);
  }

  int countTurnedOn(Map<Point3d, bool> pointMap) {
    final vol = (p1.x - p2.x).abs() * (p1.y - p2.y).abs() * (p1.z - p2.z).abs();
    return pointsNotPartOfBox.where((point) => pointMap[point] == true).length +
        vol;
  }

  Iterable<Point3d> get points sync* {
    final minX = min(p1.x, p2.x), maxX = max(p1.x, p2.x);
    final minY = min(p1.y, p2.y), maxY = max(p1.y, p2.y);
    final minZ = min(p1.z, p2.z), maxZ = max(p1.z, p2.z);

    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        for (var z = minZ; z <= maxZ; z++) {
          final point = Point3d(x, y, z);

          if (!pointsNotPartOfBox.contains(point)) {
            yield point;
          }
        }
      }
    }
  }

  @override
  String toString() => 'Box($p1, $p2, notPart: $pointsNotPartOfBox)';
}

int solveB(Iterable<String> input) {
  // on x=-20..26,y=-36..17,z=-47..7
  final lineRegExp = RegExp(
    r'(on|off) '
    r'x=(.+)\.\.(.+),'
    r'y=(.+)\.\.(.+),'
    r'z=(.+)\.\.(.+)',
  );

  final boxList = <Box>[];
  final pointMap = <Point3d, bool>{};
  //var turnedOnSum = 0;

  for (final line in input) {
    final match = lineRegExp.firstMatch(line)!;

    final on = match[1] == 'on';
    final xFrom = int.parse(match[2]!);
    final xTo = int.parse(match[3]!);

    final yFrom = int.parse(match[4]!);
    final yTo = int.parse(match[5]!);

    final zFrom = int.parse(match[6]!);
    final zTo = int.parse(match[7]!);

    final newBox = Box(Point3d(xFrom, yFrom, zFrom), Point3d(xTo, yTo, zTo));

    for (final box in boxList) {
      final intersectionBox = newBox.intersection(box);

      if (intersectionBox != null) {
        print('Size of intersection: ${intersectionBox.countTurnedOn({})}');

        if (intersectionBox.countTurnedOn({}) == 138638438242073) {
          print('test');
        }

        for (final point in intersectionBox.points) {
          box.pointsNotPartOfBox.add(point);
          pointMap[point] = on;
        }
      }
    }

    print('Size: ${pointMap.length}');

    if (on) {
      boxList.add(newBox);
    }
  }

  return 0;
}

class Point3d {
  final int x, y, z;

  const Point3d(this.x, this.y, this.z);

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object other) =>
      other is Point3d && x == other.x && y == other.y && z == other.z;

  @override
  String toString() => 'Point3d($x, $y, $z)';
}

int solveA(Iterable<String> input) {
  // on x=-20..26,y=-36..17,z=-47..7
  final lineRegExp = RegExp(r'(on|off) x=(.+),y=(.+),z=(.+)');
  final spaceSet = HashSet<Point3d>();

  for (final line in input) {
    final match = lineRegExp.firstMatch(line)!;

    final on = match[1] == 'on';
    final xRange = [...steps(match[2]!)];
    final yRange = [...steps(match[3]!)];
    final zRange = [...steps(match[4]!)];

    for (final x in xRange) {
      for (final y in yRange) {
        for (final z in zRange) {
          final point3d = Point3d(x, y, z);

          if (on) {
            spaceSet.add(point3d);
          } else {
            spaceSet.remove(point3d);
          }
        }
      }
    }
  }

  return spaceSet.length;
}

RegExp _stepsRegExp = RegExp(r'(.+)\.\.(.+)');

Iterable<int> steps(String input) sync* {
  final parsed = _stepsRegExp.firstMatch(input)!;
  final fromInt = int.parse(parsed[1]!);
  final toInt = int.parse(parsed[2]!);

  for (var i = fromInt; i <= toInt; i++) {
    if (i >= -50 && i <= 50) {
      yield i;
    }
  }
}
