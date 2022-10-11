// --- Day 21: Dirac Dice ---
// https://adventofcode.com/2021/day/21

import 'dart:math';

int solveA({
  required int player1StartingPosition,
  required int player2StartingPosition,
}) {
  final dice = Dice();
  var player1Position = PlayerPosition(startPosition: player1StartingPosition);
  var player2Position = PlayerPosition(startPosition: player2StartingPosition);
  var player1Score = 0;
  var player2Score = 0;

  while (player1Score <= 1000 || player2Score <= 1000) {
    player1Score += player1Position.move(dice.roll3());
    if (player1Score >= 1000) {
      break;
    }
    player2Score += player2Position.move(dice.roll3());
  }

  return min(player1Score, player2Score) * dice.countRolls;
}

class Dice {
  int countRolls = 0;

  int roll() => (countRolls++ % 100) + 1;
  int roll3() => roll() + roll() + roll();
}

class PlayerPosition {
  int countPosition;

  PlayerPosition({required int startPosition})
      : countPosition = startPosition - 1;

  int move(int value) => ((countPosition += value) % 10) + 1;
}
