// --- Day 18: Snailfish ---
// https://adventofcode.com/2021/day/18

import 'dart:math';

int solveA(Iterable<String> input) =>
    input.map(SnailfishNumber.parse).reduce((a, b) => a + b).magnitude;

int solveB(List<String> input) {
  var maxMagnitude = 0;

  for (final a in input) {
    for (final b in input) {
      if (!identical(a, b)) {
        maxMagnitude = max(maxMagnitude,
            (SnailfishNumber.parse(a) + SnailfishNumber.parse(b)).magnitude);
      }
    }
  }

  return maxMagnitude;
}

abstract class SnailfishNumber {
  Pair? parent;

  SnailfishNumber();

  factory SnailfishNumber.parse(String input) {
    if (input.length == 1) {
      return RegularNumber(int.parse(input));
    } else {
      var bracketCount = 0;

      for (var i = 1; i < input.length; i++) {
        final char = input[i];

        if (char == '[') {
          bracketCount++;
        } else if (char == ']') {
          bracketCount--;
        } else if (char == ',' && bracketCount == 0) {
          return Pair(
            SnailfishNumber.parse(input.substring(1, i)),
            SnailfishNumber.parse(input.substring(i + 1, input.length - 1)),
          );
        }
      }
    }

    throw Exception('Could not parse: $input');
  }

  int get magnitude;
  Pair operator +(SnailfishNumber other) => Pair(this, other)..reduce();
}

enum ExplosionStatus { noExplosion, targetExploded, otherTargetExploded }

class Pair extends SnailfishNumber {
  SnailfishNumber _x, _y;

  SnailfishNumber get x => _x;
  set x(SnailfishNumber x) => (_x = x).parent = this;

  SnailfishNumber get y => _y;
  set y(SnailfishNumber y) => (_y = y).parent = this;

  Pair(this._x, this._y) {
    _x.parent = this;
    _y.parent = this;
  }

  void reduce() {
    bool anyReduction;

    do {
      anyReduction = false;
      final explosionStatus = explode();

      if (explosionStatus == ExplosionStatus.otherTargetExploded ||
          explosionStatus == ExplosionStatus.targetExploded) {
        anyReduction = true;
      } else {
        anyReduction = trySplitFirstFoundRegularNumber();
      }
    } while (anyReduction);
  }

  bool trySplitFirstFoundRegularNumber() {
    switch (this.x) {
      case RegularNumber(value: final value) && final x when value >= 10:
        this.x = x.split;
        return true;
      case Pair() && final x when x.trySplitFirstFoundRegularNumber():
        return true;
    }

    switch (this.y) {
      case RegularNumber(value: final value) && final y when value >= 10:
        this.y = y.split;
        return true;
      case Pair() && final y when y.trySplitFirstFoundRegularNumber():
        return true;
    }

    return false;
  }

  ExplosionStatus explode([int nestLevel = 0]) {
    final x = this.x;
    final y = this.y;

    if (nestLevel == 4) {
      if (x is! RegularNumber || y is! RegularNumber) {
        throw Exception('$x and/or $y is not regular numbers!');
      }

      // LEFT
      Pair previous = this;
      Pair? current = previous.parent;

      while (current != null) {
        SnailfishNumber left = current.x;

        if (!identical(left, previous)) {
          // Then RIGHT
          while (left is Pair) {
            left = left.y;
          }

          (left as RegularNumber).value += x.value;
          break;
        }

        previous = current;
        current = previous.parent;
      }

      // RIGHT
      previous = this;
      current = previous.parent;

      while (current != null) {
        SnailfishNumber right = current.y;

        if (!identical(right, previous)) {
          // Then LEFT
          while (right is Pair) {
            right = right.x;
          }

          (right as RegularNumber).value += y.value;
          break;
        }

        previous = current;
        current = previous.parent;
      }

      return ExplosionStatus.targetExploded;
    } else {
      if (x is Pair) {
        final status = x.explode(nestLevel + 1);

        if (status == ExplosionStatus.targetExploded) {
          this.x = RegularNumber(0);
          return ExplosionStatus.otherTargetExploded;
        } else if (status == ExplosionStatus.otherTargetExploded) {
          return ExplosionStatus.otherTargetExploded;
        }
      }

      if (y is Pair) {
        final status = y.explode(nestLevel + 1);

        if (status == ExplosionStatus.targetExploded) {
          this.y = RegularNumber(0);
          return ExplosionStatus.otherTargetExploded;
        } else if (status == ExplosionStatus.otherTargetExploded) {
          return ExplosionStatus.otherTargetExploded;
        }
      }

      return ExplosionStatus.noExplosion;
    }
  }

  @override
  int get magnitude => (x.magnitude * 3) + (y.magnitude * 2);

  @override
  String toString() => '[$x,$y]';
}

class RegularNumber extends SnailfishNumber {
  int value;

  RegularNumber(this.value);

  Pair get split {
    final newValue = value / 2;

    return Pair(
      RegularNumber(newValue.floor()),
      RegularNumber(newValue.ceil()),
    );
  }

  @override
  int get magnitude => value;

  @override
  String toString() => value.toString();
}
