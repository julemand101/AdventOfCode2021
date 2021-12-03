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
    calculateRating(input, keepOneBitList: oxygenGeneratorRatingRule) *
    calculateRating(input, keepOneBitList: co2ScrubberRatingRule);

bool oxygenGeneratorRatingRule(int zeroBitLength, int oneBitLength) =>
    oneBitLength >= zeroBitLength;

bool co2ScrubberRatingRule(int zeroBitLength, int oneBitLength) =>
    oneBitLength < zeroBitLength;

int calculateRating(
  List<String> input, {
  required bool Function(int zeroBitLength, int oneBitLength) keepOneBitList,
}) {
  final numberOfBitsInRow = input.first.length;
  var list = input;

  for (var bit = 0; bit < numberOfBitsInRow && list.length > 1; bit++) {
    final List<String> zeroBitList = [];
    final List<String> oneBitList = [];

    for (final line in list) {
      // 49 = ASCII value for the char "1"
      if (line.codeUnits[bit] == 49) {
        oneBitList.add(line);
      } else {
        zeroBitList.add(line);
      }
    }

    if (keepOneBitList(zeroBitList.length, oneBitList.length)) {
      list = oneBitList;
    } else {
      list = zeroBitList;
    }
  }

  return int.parse(list.first, radix: 2);
}
