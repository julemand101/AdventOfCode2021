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
    final parts = input[i].split(',');
    points.add(Point(int.parse(parts[0]), int.parse(parts[1])));
  }

  final parts = firstFoldInstruction!.split('=');
  final value = int.parse(parts[1]);

  if (parts[0] == 'fold along x') {
    final pointsToMove = points.where((point) => point.x > value).toList();
    points
      ..removeAll(pointsToMove)
      ..addAll(pointsToMove
          .map((point) => Point(point.x - (point.x - value) * 2, point.y)));
  } else if (parts[0] == 'fold along y') {
    final pointsToMove = points.where((point) => point.y > value).toList();
    points
      ..removeAll(pointsToMove)
      ..addAll(pointsToMove
          .map((point) => Point(point.x, point.y - (point.y - value) * 2)));
  } else {
    throw Exception('Invalid command: ${parts[0]}');
  }

  return points.length;
}

String solveB(List<String> input) {
  final points = <Point<int>>{};

  for (final line in input.takeWhile((line) => line.isNotEmpty)) {
    final parts = line.split(',');
    points.add(Point(int.parse(parts[0]), int.parse(parts[1])));
  }

  for (final line in input.skipWhile((line) => line.isNotEmpty).skip(1)) {
    final parts = line.split('=');
    final value = int.parse(parts[1]);

    if (parts[0] == 'fold along x') {
      final pointsToMove = points.where((point) => point.x > value).toList();
      points
        ..removeAll(pointsToMove)
        ..addAll(pointsToMove
            .map((point) => Point(point.x - (point.x - value) * 2, point.y)));
    } else if (parts[0] == 'fold along y') {
      final pointsToMove = points.where((point) => point.y > value).toList();
      points
        ..removeAll(pointsToMove)
        ..addAll(pointsToMove
            .map((point) => Point(point.x, point.y - (point.y - value) * 2)));
    } else {
      throw Exception('Invalid command: ${parts[0]}');
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
