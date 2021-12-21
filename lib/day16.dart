// --- Day 16: Packet Decoder ---
// https://adventofcode.com/2021/day/16

import 'dart:typed_data';

int solveA(String input) => getVersionSum(BitsTransmission.fromInput(input));
int solveB(String input) => getVersionSum(BitsTransmission.fromInput(input));

int getVersionSum(BitsTransmission bitsTransmission) {
  final version = bitsTransmission.readBitsAsInt(3);
  final typeId = bitsTransmission.readBitsAsInt(3);
  var versionSum = version;

  if (typeId == 4) {
    // Literal value
    final numberBits = <int>[];
    Uint8List bits;

    do {
      bits = bitsTransmission.readBits(5);
      numberBits.addAll(bits.skip(1));
    } while (bits[0] == 1);

    //final number = BitsTransmission.convertBitsToInt(numberBits);
  } else {
    // Operator
    final lengthTypeId = bitsTransmission.readBits(1).first;

    if (lengthTypeId == 0) {
      final totalLengthInBits = bitsTransmission.readBitsAsInt(15);
      final oldCount = bitsTransmission.counter;

      do {
        versionSum += getVersionSum(bitsTransmission);
      } while (bitsTransmission.counter - oldCount < totalLengthInBits);
    } else {
      final numberOfSubPackets = bitsTransmission.readBitsAsInt(11);

      for (var i = 0; i < numberOfSubPackets; i++) {
        versionSum += getVersionSum(bitsTransmission);
      }
    }
  }

  return versionSum;
}

class BitsTransmission {
  int counter = 0;
  final Uint8List bitList;

  BitsTransmission(this.bitList);
  BitsTransmission.fromInput(String input)
      : this(Uint8List(input.length * 4)
          ..setAll(
              0, input.codeUnits.expand((char) => _hexLetterToBits[char]!)));

  Uint8List readBits(int nBits) => bitList.sublist(counter, counter += nBits);
  int readBitsAsInt(int nBits) => convertBitsToInt(readBits(nBits));

  static int convertBitsToInt(Iterable<int> bits) =>
      bits.fold(0, (val, bit) => (val << 1) ^ bit);

  static final Map<int, List<int>> _hexLetterToBits = {
    '0'.codeUnits.first: const [0, 0, 0, 0],
    '1'.codeUnits.first: const [0, 0, 0, 1],
    '2'.codeUnits.first: const [0, 0, 1, 0],
    '3'.codeUnits.first: const [0, 0, 1, 1],
    '4'.codeUnits.first: const [0, 1, 0, 0],
    '5'.codeUnits.first: const [0, 1, 0, 1],
    '6'.codeUnits.first: const [0, 1, 1, 0],
    '7'.codeUnits.first: const [0, 1, 1, 1],
    '8'.codeUnits.first: const [1, 0, 0, 0],
    '9'.codeUnits.first: const [1, 0, 0, 1],
    'A'.codeUnits.first: const [1, 0, 1, 0],
    'B'.codeUnits.first: const [1, 0, 1, 1],
    'C'.codeUnits.first: const [1, 1, 0, 0],
    'D'.codeUnits.first: const [1, 1, 0, 1],
    'E'.codeUnits.first: const [1, 1, 1, 0],
    'F'.codeUnits.first: const [1, 1, 1, 1],
  };
}
