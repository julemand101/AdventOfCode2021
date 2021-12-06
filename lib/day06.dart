// --- Day 6: Lanternfish ---
// https://adventofcode.com/2021/day/6

int solveA(Iterable<String> input) => solve(input, simulateDays: 80);
int solveB(Iterable<String> input) => solve(input, simulateDays: 256);

int solve(Iterable<String> input, {required int simulateDays}) {
  final lanternFishList = input.first.split(',').map(int.parse).fold<List<int>>(
      List.generate(9, (_) => 0, growable: false), (list, daysBeforeNewFish) {
    list[daysBeforeNewFish]++;
    return list;
  });

  for (var day = 0; day < simulateDays; day++) {
    lanternFishList[(day + 7) % lanternFishList.length] +=
        lanternFishList[day % lanternFishList.length];
  }

  return lanternFishList.reduce((a, b) => a + b);
}
