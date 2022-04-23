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
    final _x = x;
    if (_x is RegularNumber) {
      if (_x.value >= 10) {
        x = _x.split;
        return true;
      }
    } else if (_x is Pair) {
      if (_x.trySplitFirstFoundRegularNumber()) {
        return true;
      }
    }

    final _y = y;
    if (_y is RegularNumber) {
      if (_y.value >= 10) {
        y = _y.split;
        return true;
      }
    } else if (_y is Pair) {
      if (_y.trySplitFirstFoundRegularNumber()) {
        return true;
      }
    }

    return false;
  }

  ExplosionStatus explode([int nestLevel = 0]) {
    final _x = x, _y = y;

    if (nestLevel == 4) {
      if (_x is! RegularNumber || _y is! RegularNumber) {
        throw Exception('$_x and/or $_y is not regular numbers!');
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

          (left as RegularNumber).value += _x.value;
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

          (right as RegularNumber).value += _y.value;
          break;
        }

        previous = current;
        current = previous.parent;
      }

      return ExplosionStatus.targetExploded;
    } else {
      if (_x is Pair) {
        final status = _x.explode(nestLevel + 1);

        if (status == ExplosionStatus.targetExploded) {
          x = RegularNumber(0);
          return ExplosionStatus.otherTargetExploded;
        } else if (status == ExplosionStatus.otherTargetExploded) {
          return ExplosionStatus.otherTargetExploded;
        }
      }

      if (_y is Pair) {
        final status = _y.explode(nestLevel + 1);

        if (status == ExplosionStatus.targetExploded) {
          y = RegularNumber(0);
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
