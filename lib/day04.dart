// --- Day 4: Giant Squid ---
// https://adventofcode.com/2021/day/4

int solveA(List<String> input) => solve(input, partA: true);
int solveB(List<String> input) => solve(input, partA: false);

int solve(List<String> input, {required bool partA}) {
  // First row of input contains drawn numbers
  final numbers = input.first.split(',').map(int.parse);
  final bingoBoards = BingoBoard.parseBoards(input.skip(2));

  for (final number in numbers) {
    for (final bingoBoard in bingoBoards) {
      if (bingoBoard.isBingoAfterAdding(number) &&
          (partA || bingoBoards.length == 1)) {
        return bingoBoard.unmarkedNumbers.reduce((a, b) => a + b) * number;
      }
    }
    bingoBoards.removeWhere((bingoBoard) => bingoBoard.foundBingo);
  }

  throw Exception('No winner found!');
}

class BingoBoard {
  final List<Set<int>> rows = <Set<int>>[];
  final List<Set<int>> columns =
      List.generate(5, (_) => <int>{}, growable: false);
  bool foundBingo = false;

  BingoBoard(Iterable<String> input) {
    for (final rowString in input) {
      final rowNumbers = rowString
          .trim()
          .split(_splitNumberPattern)
          .map(int.parse)
          .toList(growable: false);

      rows.add(rowNumbers.toSet());
      for (var i = 0; i < rowNumbers.length; i++) {
        columns[i].add(rowNumbers[i]);
      }
    }
  }

  bool isBingoAfterAdding(int number) {
    for (final row in rows) {
      if (row.remove(number)) {
        if (row.isEmpty) {
          foundBingo = true;
          return true;
        } else {
          break;
        }
      }
    }

    for (final column in columns) {
      if (column.remove(number)) {
        if (column.isEmpty) {
          foundBingo = true;
          return true;
        } else {
          break;
        }
      }
    }

    return false;
  }

  // We just use the rows since we are always removing from rows first. So in
  // case of a bingo, found by removing a number from a column, we know the
  // number are already being removed from the rows.
  Iterable<int> get unmarkedNumbers => rows.expand((row) => row);

  static List<BingoBoard> parseBoards(Iterable<String> input) {
    final bingoBoards = <BingoBoard>[];
    final lineBuffer = <String>[];

    for (final line in input) {
      if (line.isEmpty) {
        bingoBoards.add(BingoBoard(lineBuffer));
        lineBuffer.clear();
      } else {
        lineBuffer.add(line);
      }
    }

    if (lineBuffer.isNotEmpty) {
      bingoBoards.add(BingoBoard(lineBuffer));
    }

    return bingoBoards;
  }

  static final RegExp _splitNumberPattern = RegExp(r' +');
}
