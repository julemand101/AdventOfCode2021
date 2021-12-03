// --- Day 3: Binary Diagnostic ---
// https://adventofcode.com/2021/day/3

int solveA(List<String> input) {
  final numberOfBitsInRow = input.first.length;
  final inputLengthDividedByTwo = input.length ~/ 2;

  // Strategy is to first generate a sumList which contains number of "1" bits
  // for each position. Then we check if the number of bits in a column is the
  // majority by checking if we have counted more bits than the half of the
  // input size.
  final gammaRate = input.fold<List<int>>(
    List.filled(numberOfBitsInRow, 0, growable: false),
    (sumList, row) {
      final rowCodeUnits = row.codeUnits;

      for (var i = 0; i < rowCodeUnits.length; i++) {
        // 49 = ASCII value for the char "1"
        if (rowCodeUnits[i] == 49) {
          sumList[i]++;
        }
      }

      return sumList;
    },
  ).fold<int>(
    0,
    (gammaRate, sumBit) =>
        (gammaRate << 1) ^ (sumBit > inputLengthDividedByTwo ? 1 : 0),
  );

  // Epsilon rate are the bitwise inverse of gamma rate
  final mask = ~((~0) << numberOfBitsInRow);
  final epsilonRate = (gammaRate & ~mask) | (~gammaRate & mask);

  return gammaRate * epsilonRate;
}

int solveB(List<String> input) =>
    calculateRating(input: input, keepOneBitList: oxygenGeneratorRatingRule) *
    calculateRating(input: input, keepOneBitList: co2ScrubberRatingRule);

bool oxygenGeneratorRatingRule(int zeroBitLength, int oneBitLength) =>
    oneBitLength >= zeroBitLength;

bool co2ScrubberRatingRule(int zeroBitLength, int oneBitLength) =>
    oneBitLength < zeroBitLength;

int calculateRating({
  required List<String> input,
  required bool Function(int zeroBitLength, int oneBitLength) keepOneBitList,
}) {
  final numberOfBitsInRow = input.first.length;
  var list = input;

  for (var bit = 0; bit < numberOfBitsInRow && list.length > 1; bit++) {
    final split = SplitByBit(list, checkBit: bit);

    if (keepOneBitList(split.zeroBitList.length, split.oneBitList.length)) {
      list = split.oneBitList;
    } else {
      list = split.zeroBitList;
    }
  }

  return int.parse(list.first, radix: 2);
}

class SplitByBit {
  final List<String> zeroBitList;
  final List<String> oneBitList;

  factory SplitByBit(List<String> input, {required int checkBit}) {
    final zeroBitList = <String>[];
    final oneBitList = <String>[];

    for (final line in input) {
      // 49 = ASCII value for the char "1"
      if (line.codeUnits[checkBit] == 49) {
        oneBitList.add(line);
      } else {
        zeroBitList.add(line);
      }
    }

    return SplitByBit._(zeroBitList, oneBitList);
  }

  const SplitByBit._(this.zeroBitList, this.oneBitList);
}
