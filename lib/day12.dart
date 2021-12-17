// --- Day 12: Passage Pathing ---
// https://adventofcode.com/2021/day/12

int solveA(Iterable<String> input) {
  final nodeMap = <String, Node>{};

  for (final line in input) {
    final list = line.split('-');
    final nodeA = nodeMap.getNode(list[0]);
    final nodeB = nodeMap.getNode(list[1]);

    nodeA.neighbours.add(nodeB);
    nodeB.neighbours.add(nodeA);
  }

  return nodeMap['start']!.countPathsToEnd({});
}

int solveB(Iterable<String> input) {
  final nodeMap = <String, Node>{};

  for (final line in input) {
    final list = line.split('-');
    final nodeA = nodeMap.getNode(list[0]);
    final nodeB = nodeMap.getNode(list[1]);

    nodeA.neighbours.add(nodeB);
    nodeB.neighbours.add(nodeA);
  }

  var sum = 0;

  for (final smallCave in nodeMap.values
      .where((node) => node.isSmallCave)
      .where((node) => node.name != 'start' && node.name != 'end')) {
    print(sum);
    smallCave.allowSecondVisit = true;
    sum += nodeMap['start']!.countPathsToEnd({});
    smallCave.allowSecondVisit = false;

    nodeMap.values.forEach((node) => node.visitedBefore = false);
  }

  return sum;
}

class Node {
  final String name;
  final List<Node> neighbours = [];
  final bool isSmallCave;
  bool allowSecondVisit = false;
  bool visitedBefore = false;

  Node(this.name) : isSmallCave = name.toLowerCase() == name;

  int countPathsToEnd(Set<Node> previouslyVisitedSmallCaves) {
    if (name == 'end') {
      return 1;
    }

    if (isSmallCave) {
      if (allowSecondVisit) {
        if (visitedBefore) {
          previouslyVisitedSmallCaves.add(this);
        } else {
          visitedBefore = true;
        }
      } else {
        previouslyVisitedSmallCaves.add(this);
      }
    }

    final sum = neighbours
        .where((neighbour) => !previouslyVisitedSmallCaves.contains(neighbour))
        .fold<int>(
            0,
            (sum, neighbour) =>
                sum + neighbour.countPathsToEnd(previouslyVisitedSmallCaves));

    if (isSmallCave) {
      previouslyVisitedSmallCaves.remove(this);
    }

    return sum;
  }
}

extension NodeExtensionOnMap on Map<String, Node> {
  Node getNode(String name) => putIfAbsent(name, () => Node(name));
}
