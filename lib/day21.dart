// --- Day 21: Dirac Dice ---
// https://adventofcode.com/2021/day/21

import 'dart:collection';
import 'dart:math';

class Dice {
  int countRolls = 0;

  int roll() => (countRolls++ % 100) + 1;
  int roll3() => roll() + roll() + roll();
}

class PlayerPosition {
  int _countPosition;
  int get countPosition => _countPosition + 1;

  PlayerPosition({required int startPosition})
      : _countPosition = startPosition - 1;

  int move(int value) =>
      (_countPosition = ((_countPosition += value) % 10)) + 1;

  @override
  String toString() => 'Position: $countPosition';
}

int solveA({
  required int player1StartingPosition,
  required int player2StartingPosition,
}) {
  final dice = Dice();
  var player1Position = PlayerPosition(startPosition: player1StartingPosition);
  var player2Position = PlayerPosition(startPosition: player2StartingPosition);
  var player1Score = 0;
  var player2Score = 0;

  while (player2Score <= 1000) {
    player1Score += player1Position.move(dice.roll3());

    if (player1Score >= 1000) {
      break;
    }

    player2Score += player2Position.move(dice.roll3());
  }

  return min(player1Score, player2Score) * dice.countRolls;
}

// key = rollSum, value = how often we get this sum when rolling the dice
const Map<int, int> distribution = {
  3: 1,
  4: 3,
  5: 6,
  6: 7,
  7: 6,
  8: 3,
  9: 1,
};

int solveB({
  required int player1StartingPosition,
  required int player2StartingPosition,
}) {
  final outcome = nextStep(
    outcomeCache: HashMap<int, Outcome>(),
    player1Position: PlayerPosition(startPosition: player1StartingPosition),
    player2Position: PlayerPosition(startPosition: player2StartingPosition),
  );

  return max(outcome.player1Wins, outcome.player2Wins);
}

int createKey({
  required int player1Position,
  required int player1Score,
  required int player2Position,
  required int player2Score,
  required bool player1Turn,
}) =>
    (player1Position) +
    (player1Score << 16) +
    (player2Position << 32) +
    (player2Score << 48) * (player1Turn ? 1 : -1);

Outcome nextStep({
  required Map<int, Outcome> outcomeCache,
  required PlayerPosition player1Position,
  required PlayerPosition player2Position,
  int player1Score = 0,
  int player2Score = 0,
  bool player1Turn = true,
}) {
  final outcomeKey = createKey(
    player1Position: player1Position.countPosition,
    player1Score: player1Score,
    player2Position: player2Position.countPosition,
    player2Score: player2Score,
    player1Turn: player1Turn,
  );

  final cacheValue = outcomeCache[outcomeKey];

  if (cacheValue != null) {
    return cacheValue;
  }

  if (player1Score >= 21) {
    return outcomeCache[outcomeKey] = const Outcome(1, 0);
  }

  if (player2Score >= 21) {
    return outcomeCache[outcomeKey] = const Outcome(0, 1);
  }

  var newOutcome = const Outcome(0, 0);

  if (player1Turn) {
    for (final move in distribution.entries) {
      final stepsToMove = move.key;
      final numberOfTimes = move.value;

      final newPositionValue = player1Position.move(stepsToMove);
      newOutcome += (nextStep(
            outcomeCache: outcomeCache,
            player1Position: player1Position,
            player2Position: player2Position,
            player1Score: player1Score + newPositionValue,
            player2Score: player2Score,
            player1Turn: false,
          ) *
          numberOfTimes);
      player1Position.move(-stepsToMove);
    }
  } else {
    for (final move in distribution.entries) {
      final stepsToMove = move.key;
      final likelihood = move.value;

      final newPositionValue = player2Position.move(stepsToMove);
      newOutcome += (nextStep(
            outcomeCache: outcomeCache,
            player1Position: player1Position,
            player2Position: player2Position,
            player1Score: player1Score,
            player2Score: player2Score + newPositionValue,
            player1Turn: true,
          ) *
          likelihood);
      player2Position.move(-stepsToMove);
    }
  }

  return outcomeCache[outcomeKey] = newOutcome;
}

class Outcome {
  final int player1Wins;
  final int player2Wins;

  const Outcome(this.player1Wins, this.player2Wins);

  Outcome operator *(int factor) => Outcome(
        player1Wins * factor,
        player2Wins * factor,
      );

  Outcome operator +(Outcome other) => Outcome(
        player1Wins + other.player1Wins,
        player2Wins + other.player2Wins,
      );

  @override
  String toString() => '(Player1Wins: $player1Wins, Player2Wins: $player2Wins)';
}
