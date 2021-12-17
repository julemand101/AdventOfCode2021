// --- Day 12: Passage Pathing ---
// https://adventofcode.com/2021/day/12

import 'package:advent_of_code_2021/day12.dart';
import 'package:test/test.dart';

const List<String> input = [
  'lg-GW',
  'pt-start',
  'pt-uq',
  'nx-lg',
  've-GW',
  'start-nx',
  'GW-start',
  'GW-nx',
  'pt-SM',
  'sx-GW',
  'lg-end',
  'nx-SM',
  'lg-SM',
  'pt-nx',
  'end-ve',
  've-SM',
  'TG-uq',
  'end-SM',
  'SM-uq',
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(const [
            'start-A',
            'start-b',
            'A-c',
            'A-b',
            'b-d',
            'A-end',
            'b-end',
          ]),
          equals(10));
    });
    test('Example 2', () {
      expect(
          solveA(const [
            'dc-end',
            'HN-start',
            'start-kj',
            'dc-start',
            'dc-HN',
            'LN-dc',
            'HN-end',
            'kj-sa',
            'kj-HN',
            'kj-dc',
          ]),
          equals(19));
    });
    test('Example 3', () {
      expect(
          solveA(const [
            'fs-end',
            'he-DX',
            'fs-he',
            'start-DX',
            'pj-DX',
            'end-zg',
            'zg-sl',
            'zg-pj',
            'pj-he',
            'RW-he',
            'fs-DX',
            'pj-RW',
            'zg-RW',
            'start-pj',
            'he-WI',
            'zg-he',
            'pj-fs',
            'start-RW',
          ]),
          equals(226));
    });
    test('Solution', () {
      expect(solveA(input), equals(3708));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            'start-A',
            'start-b',
            'A-c',
            'A-b',
            'b-d',
            'A-end',
            'b-end',
          ]),
          equals(36));
    });
    test('Example 2', () {
      expect(
          solveB(const [
            'dc-end',
            'HN-start',
            'start-kj',
            'dc-start',
            'dc-HN',
            'LN-dc',
            'HN-end',
            'kj-sa',
            'kj-HN',
            'kj-dc',
          ]),
          equals(103));
    });
    test('Example 3', () {
      expect(
          solveB(const [
            'fs-end',
            'he-DX',
            'fs-he',
            'start-DX',
            'pj-DX',
            'end-zg',
            'zg-sl',
            'zg-pj',
            'pj-he',
            'RW-he',
            'fs-DX',
            'pj-RW',
            'zg-RW',
            'start-pj',
            'he-WI',
            'zg-he',
            'pj-fs',
            'start-RW',
          ]),
          equals(3509));
    });
    test('Solution', () {
      expect(solveB(input), equals(-1));
    });
  }, skip: true);
}
