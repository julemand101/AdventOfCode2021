// --- Day 18: Snailfish ---
// https://adventofcode.com/2021/day/18

import 'dart:io';
import 'package:advent_of_code_2021/day18.dart';
import 'package:test/test.dart';

final input = File('test/data/day18.txt').readAsLinesSync();

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(const ['[[1,2],[[3,4],5]]']), equals(143));
    });
    test('Example 2', () {
      expect(solveA(const ['[[[[0,7],4],[[7,8],[6,0]]],[8,1]]']), equals(1384));
    });
    test('Example 3', () {
      expect(solveA(const ['[[[[1,1],[2,2]],[3,3]],[4,4]]']), equals(445));
    });
    test('Example 4', () {
      expect(solveA(const ['[[[[3,0],[5,3]],[4,4]],[5,5]]']), equals(791));
    });
    test('Example 5', () {
      expect(solveA(const ['[[[[5,0],[7,4]],[5,5]],[6,6]]']), equals(1137));
    });
    test('Example 6', () {
      expect(
          solveA(
              const ['[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]']),
          equals(3488));
    });
    test('Example 7', () {
      expect(
          solveA(const [
            '[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]',
            '[[[5,[2,8]],4],[5,[[9,9],0]]]',
            '[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]',
            '[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]',
            '[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]',
            '[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]',
            '[[[[5,4],[7,7]],8],[[8,3],8]]',
            '[[9,3],[[9,9],[6,[4,9]]]]',
            '[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]',
            '[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]'
          ]),
          equals(4140));
    });
    test('Solution', () {
      expect(solveA(input), equals(3793));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(const [
            '[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]',
            '[[[5,[2,8]],4],[5,[[9,9],0]]]',
            '[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]',
            '[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]',
            '[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]',
            '[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]',
            '[[[[5,4],[7,7]],8],[[8,3],8]]',
            '[[9,3],[[9,9],[6,[4,9]]]]',
            '[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]',
            '[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]'
          ]),
          equals(3993));
    });
    test('Solution', () {
      expect(solveB(input), equals(4695));
    });
  });
}