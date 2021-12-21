// --- Day 16: Packet Decoder ---
// https://adventofcode.com/2021/day/16

import 'dart:io';
import 'package:advent_of_code_2021/day16.dart';
import 'package:test/test.dart';

final input = File('test/data/day16.txt').readAsLinesSync().first;

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA('8A004A801A8002F478'), equals(16));
    });
    test('Example 2', () {
      expect(solveA('620080001611562C8802118E34'), equals(12));
    });
    test('Example 3', () {
      expect(solveA('C0015000016115A2E0802F182340'), equals(23));
    });
    test('Example 4', () {
      expect(solveA('A0016C880162017C3686B18A3D4780'), equals(31));
    });
    test('Solution', () {
      expect(solveA(input), equals(960));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB('C200B40A82'), equals(3));
    });
    test('Example 2', () {
      expect(solveB('04005AC33890'), equals(54));
    });
    test('Example 3', () {
      expect(solveB('880086C3E88112'), equals(7));
    });
    test('Example 4', () {
      expect(solveB('CE00C43D881120'), equals(9));
    });
    test('Example 5', () {
      expect(solveB('D8005AC2A8F0'), equals(1));
    });
    test('Example 6', () {
      expect(solveB('F600BC2D8F'), equals(0));
    });
    test('Example 7', () {
      expect(solveB('9C005AC2F8F0'), equals(0));
    });
    test('Example 8', () {
      expect(solveB('9C0141080250320F1802104A08'), equals(1));
    });
    test('Solution', () {
      expect(solveB(input), equals(-1));
    });
  }, skip: true);
}
