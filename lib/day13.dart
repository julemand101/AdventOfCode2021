// --- Day 13: Transparent Origami ---
// https://adventofcode.com/2021/day/13

import 'dart:math';

int solveA(List<String> input) {
  final points = <Point<int>>{};
  String? firstFoldInstruction;

  for (var i = 0; i < input.length; i++) {
    if (input[i].isEmpty) {
      firstFoldInstruction = input[i + 1];
      break;
    }
    final [x, y] = input[i].split(',').map(int.parse).toList(growable: false);
    points.add(Point(x, y));
  }

  switch (firstFoldInstruction!.split('=')) {
    case ['fold along x', final valueString]:
      final value = int.parse(valueString);
      final pointsToMove = points.where((point) => point.x > value).toList();

      points
        ..removeAll(pointsToMove)
        ..addAll(pointsToMove
            .map((point) => Point(point.x - (point.x - value) * 2, point.y)));
    case ['fold along y', final valueString]:
      final value = int.parse(valueString);
      final pointsToMove = points.where((point) => point.y > value).toList();

      points
        ..removeAll(pointsToMove)
        ..addAll(pointsToMove
            .map((point) => Point(point.x, point.y - (point.y - value) * 2)));
    case [final command, ...]:
      throw Exception('Invalid command: $command');
  }

  return points.length;
}

String solveB(List<String> input) {
  final points = <Point<int>>{};

  for (final [x, y] in input
      .takeWhile((line) => line.isNotEmpty)
      .map((line) => line.split(',').map(int.parse).toList(growable: false))) {
    points.add(Point(x, y));
  }

  for (final line in input.skipWhile((line) => line.isNotEmpty).skip(1)) {
    switch (line.split('=')) {
      case ['fold along x', final valueString]:
        final value = int.parse(valueString);
        final pointsToMove = points.where((point) => point.x > value).toList();

        points
          ..removeAll(pointsToMove)
          ..addAll(pointsToMove
              .map((point) => Point(point.x - (point.x - value) * 2, point.y)));
      case ['fold along y', final valueString]:
        final value = int.parse(valueString);
        final pointsToMove = points.where((point) => point.y > value).toList();

        points
          ..removeAll(pointsToMove)
          ..addAll(pointsToMove
              .map((point) => Point(point.x, point.y - (point.y - value) * 2)));
      case [final command, ...]:
        throw Exception('Invalid command: $command');
    }
  }

  var maxX = 0, maxY = 0;
  for (final point in points) {
    maxX = max(maxX, point.x);
    maxY = max(maxY, point.y);
  }

  final stringBuffer = StringBuffer();
  for (var y = 0; y <= maxY; y++) {
    for (var x = 0; x <= maxX; x++) {
      stringBuffer.write(points.contains(Point(x, y)) ? '█' : ' ');
    }
    stringBuffer.writeln();
  }

  return stringBuffer.toString();
}
