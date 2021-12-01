// --- Day 1: Sonar Sweep ---
// https://adventofcode.com/2021/day/1

int solveA(Iterable<String> input) {
  var increases = 0;
  int? lastDepth;

  for (final depth in input.map(int.parse)) {
    if (lastDepth != null && lastDepth < depth) {
      increases++;
    }

    lastDepth = depth;
  }

  return increases;
}

int solveB(Iterable<String> input) {
  final depths = input.map(int.parse).toList(growable: false);
  var increases = 0;
  int? lastDepth;

  for (var i = 0; i < depths.length - 2; i++) {
    final depth = depths[i] + depths[i + 1] + depths[i + 2];

    if (lastDepth != null && lastDepth < depth) {
      increases++;
    }

    lastDepth = depth;
  }

  return increases;
}
