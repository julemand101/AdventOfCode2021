// --- Day 20: Trench Map ---
// https://adventofcode.com/2021/day/20

import 'dart:math';

int solveA(List<String> input) => solve(input, enhanceIterations: 2);
int solveB(List<String> input) => solve(input, enhanceIterations: 50);

int solve(List<String> input, {required int enhanceIterations}) {
  List<bool> imageEnhancementAlgorithm = [
    ...input.first.split('').map((e) => e == '#')
  ];
  var image = Image();

  for (MapEntry<int, String> lineEntry in input.asMap().entries.skip(2)) {
    final y = lineEntry.key - 2;
    final line = lineEntry.value;

    for (var x = 0; x < line.length; x++) {
      image.set(x, y, line[x] == '#');
    }
  }

  for (var i = 0; i < enhanceIterations; i++) {
    final newImage = Image();

    if (imageEnhancementAlgorithm[0] == true) {
      newImage.reversed = !image.reversed;
    }

    for (var y = image.minY - 2; y <= image.maxY + 2; y++) {
      for (var x = image.minX - 2; x <= image.maxX + 2; x++) {
        newImage.set(x, y, imageEnhancementAlgorithm[image.getAddress(x, y)]);
      }
    }

    image = newImage;
  }

  return image.pixels.length;
}

class Image {
  Set<Point<int>> pixels = {};
  bool reversed = false;
  int minX = 0, maxX = 0;
  int minY = 0, maxY = 0;

  void set(int x, int y, bool value) {
    final point = Point(x, y);

    if (value ^ reversed) {
      pixels.add(point);

      minX = min(minX, x);
      maxX = max(maxX, x);
      minY = min(minY, y);
      maxY = max(maxY, y);
    }
  }

  bool get(int x, int y) => pixels.contains(Point(x, y)) ^ reversed;

  int getAddress(int centerX, int centerY) {
    int number = 0;

    for (var y = centerY - 1; y <= centerY + 1; y++) {
      for (var x = centerX - 1; x <= centerX + 1; x++) {
        number <<= 1;
        number ^= get(x, y) ? 1 : 0;
      }
    }

    return number;
  }
}
