// --- Day 22: Reactor Reboot ---
// https://adventofcode.com/2021/day/22

import 'dart:collection';

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
