// --- Day 17: Trick Shot ---
// https://adventofcode.com/2021/day/17

import 'dart:math';

int solveA(String input) {
  var maxHeight = 0;

  solve(input, (result) {
    maxHeight = max(maxHeight, result);
  });

  return maxHeight;
}

int solveB(String input) {
  var count = 0;

  solve(input, (result) {
    if (result != -1) {
      count++;
    }
  });

  return count;
}

final regExpPatternForInput = RegExp(r'x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)');

void solve(String input, void Function(int result) handleResult) {
  final regExpMatch = regExpPatternForInput.firstMatch(input)!;

  final minX = int.parse(regExpMatch[1]!);
  final maxX = int.parse(regExpMatch[2]!);
  final minY = int.parse(regExpMatch[3]!);
  final maxY = int.parse(regExpMatch[4]!);

  for (var x = 0; x <= maxX; x++) {
    for (var y = -500; y < 500; y++) {
      handleResult(isTargetHit(
        xVelocityStart: x,
        yVelocityStart: y,
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
      ));
    }
  }
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
