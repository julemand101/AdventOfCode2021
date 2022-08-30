// --- Day 7: The Treachery of Whales ---
// https://adventofcode.com/2021/day/7

import 'dart:math';

typedef FuelCalculator = int Function(int distance);

int solveA(Iterable<String> input) =>
    solve(input, getFuelUsage: (distance) => distance);
int solveB(Iterable<String> input) =>
    solve(input, getFuelUsage: (distance) => (distance * (distance + 1)) ~/ 2);

int solve(Iterable<String> input, {required FuelCalculator getFuelUsage}) {
  final numbers = input.first.split(',').map(int.parse).toList(growable: false);
  final maxNumber = numbers.reduce(max);

  return Iterable<int>.generate(maxNumber).fold(
    0,
    (minimumFuel, candidate) => minimumFuel != 0
        ? min(minimumFuel, calculateFuel(numbers, candidate, getFuelUsage))
        : calculateFuel(numbers, candidate, getFuelUsage),
  );
}

int calculateFuel(List<int> list, int target, FuelCalculator getFuelUsage) =>
    list.fold(
        0,
        (sumFuel, currentPosition) =>
            sumFuel + getFuelUsage((currentPosition - target).abs()));
