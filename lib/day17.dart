// --- Day 17: Trick Shot ---
// https://adventofcode.com/2021/day/17

import 'dart:math';

final regExpPatternForInput = RegExp(
    r'x=(?<minX>-?\d+)..(?<maxX>-?\d+), y=(?<minY>-?\d+)..(?<maxY>-?\d+)');

int solveA(String input) {
  final regExpMatch = regExpPatternForInput.firstMatch(input)!;

  final minX = int.parse(regExpMatch.namedGroup('minX')!);
  final maxX = int.parse(regExpMatch.namedGroup('maxX')!);
  final minY = int.parse(regExpMatch.namedGroup('minY')!);
  final maxY = int.parse(regExpMatch.namedGroup('maxY')!);

  var maxHeight = 0;

  for (var x = 0; x < maxX; x++) {
    for (var y = 0; y < 1000; y++) {
      maxHeight = max(
          maxHeight,
          isTargetHit(
            xVelocityStart: x,
            yVelocityStart: y,
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
          ));
    }
  }

  return maxHeight;
}

int isTargetHit({
  required int xVelocityStart,
  required int yVelocityStart,
  required int minX,
  required int maxX,
  required int minY,
  required int maxY,
}) {
  // Start
  var x = 0;
  var y = 0;
  var xVelocity = xVelocityStart;
  var yVelocity = yVelocityStart;
  var maxHeight = 0;

  do {
    // Step
    x += xVelocity;
    y += yVelocity;
    maxHeight = max(maxHeight, y);

    if (xVelocity != 0) {
      xVelocity += xVelocity > 0 ? -1 : 1;
    }

    yVelocity--;
    if (x >= minX && x <= maxX && y >= minY && y <= maxY) {
      // Point inside the box
      return maxHeight;
    }
  } while (yVelocity > 0 || y >= min(minY, maxY));

  return -1;
}
