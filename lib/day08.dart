// --- Day 8: Seven Segment Search ---
// https://adventofcode.com/2021/day/8

int solveA(Iterable<String> input) => input
    .expand((line) => line.split(' | ').last.split(' '))
    .where((part) => part.length != 5 && part.length != 6)
    .length;
