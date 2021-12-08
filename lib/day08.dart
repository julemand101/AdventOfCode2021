// --- Day 8: Seven Segment Search ---
// https://adventofcode.com/2021/day/8

int solveA(Iterable<String> input) => input
    .expand((line) => line.split(' | ').last.split(' '))
    .where((part) => part.length != 5 && part.length != 6)
    .length;

int solveB(Iterable<String> input) {
  var sum = 0;

  for (final line in input) {
    final _parts = line.split(' | ');

    // Each number is represented as a list of individually letters
    final List<List<String>> randomNumbers =
        _parts.first.split(' ').map((e) => e.split('')).toList(growable: false);
    final List<List<String>> outputNumbers =
        _parts.last.split(' ').map((e) => e.split('')).toList(growable: false);

    // Array position to display segment mapping:
    // Source: https://en.wikipedia.org/wiki/Seven-segment_display
    //
    //  0000
    // 5    1
    // 5    1
    //  6666
    // 4    2
    // 4    2
    //  3333
    //
    // When starting, all letters is a valid candidate for each display segment
    final displaySegmentCandidates =
        List.generate(7, (_) => {'a', 'b', 'c', 'd', 'e', 'f', 'g'});

    // Go though numbers using 2, 4, or 3 segments and use this information to
    // remove segments from the parts which is not used. E.g. if we know the
    // number 1 is using "a" and "b", we can remove these letters from all other
    // segment positions as candidates.
    //
    // We ignore the number 8 since it does just enable all segments and can
    // therefore not be used to remove any candidates.
    for (final numberSegments in randomNumbers) {
      switch (numberSegments.length) {
        case 2: // Found: 1
          displaySegmentCandidates[0].removeAll(numberSegments);
          displaySegmentCandidates[3].removeAll(numberSegments);
          displaySegmentCandidates[4].removeAll(numberSegments);
          displaySegmentCandidates[5].removeAll(numberSegments);
          displaySegmentCandidates[6].removeAll(numberSegments);
          break;
        case 4: // Found: 4
          displaySegmentCandidates[0].removeAll(numberSegments);
          displaySegmentCandidates[3].removeAll(numberSegments);
          displaySegmentCandidates[4].removeAll(numberSegments);
          break;
        case 3: // Found: 7
          displaySegmentCandidates[3].removeAll(numberSegments);
          displaySegmentCandidates[4].removeAll(numberSegments);
          displaySegmentCandidates[5].removeAll(numberSegments);
          displaySegmentCandidates[6].removeAll(numberSegments);
          break;
      }
    }

    // Generate all possible mappings based on our current found candidates
    // and test each of them if any of them can be used to map all random input
    // numbers (getNumberFromMapping returns -1 in case of invalid mapping).
    //
    // There should only be one valid mapping and we use it as soon as we find
    // it.
    final validMapping = generateMappings(displaySegmentCandidates, map: {})
        .where(
          (displayMapping) => randomNumbers.every(
            (randomNumber) =>
                getNumberFromMapping(displayMapping, randomNumber) != -1,
          ),
        )
        .first;

    // Use the found valid mapping to generate each digit of a number
    sum += int.parse(outputNumbers
        .map((segments) => getNumberFromMapping(validMapping, segments))
        .join());
  }

  return sum;
}

Iterable<Map<String, int>> generateMappings(
  List<Set<String>> displaySegmentCandidates, {
  required Map<String, int> map,
  int pos = 0,
}) sync* {
  if (pos < displaySegmentCandidates.length) {
    for (final candidate in displaySegmentCandidates[pos]) {
      if (!map.containsKey(candidate)) {
        yield* generateMappings(
          displaySegmentCandidates,
          map: map..[candidate] = pos,
          pos: pos + 1,
        );

        // Yeah, I reuse the same `Map` instance since I know the caller of
        // generateMappings is not saving the `Map` between iterations.
        map.remove(candidate);
      }
    }
  } else {
    yield map;
  }
}

int getNumberFromMapping(Map<String, int> displayMapping, List<String> parts) {
  // Initialize the display with all segments turned off
  final display = List.generate(7, (_) => false, growable: false);

  // Use displayMapping to turn on segments of the display
  for (final displayPartTurnedOn in parts.map((e) => displayMapping[e]!)) {
    display[displayPartTurnedOn] = true;
  }

  // Mapping of turned on segments in display and what number it represents:
  // Index 0 = Number 0, Index 1 = Number 1, ... Index 9 = Number 9
  // https://en.wikipedia.org/wiki/Seven-segment_display#Hexadecimal
  return [0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B]
      .indexOf(boolListToInt(display)); // -1 returned if no number found
}

// Convert a iterable of booleans, representing bits, to an integer
int boolListToInt(Iterable<bool> booleans) {
  var val = 0;

  for (final boolean in booleans) {
    val ^= boolean ? 1 : 0;
    val <<= 1;
  }

  return val >> 1;
}
