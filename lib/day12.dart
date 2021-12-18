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

  return nodeMap['start']!.getPathsToEnd([], {}).length;
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

  final routes = <String>{};

  for (final smallCave in nodeMap.values
      .where((node) => node.isSmallCave)
      .where((node) => node.name != 'start' && node.name != 'end')) {
    smallCave.allowSecondVisit = true;
    routes.addAll(nodeMap['start']!.getPathsToEnd([], {}));
    smallCave.allowSecondVisit = false;
  }

  return routes.length;
}

class Node {
  final String name;
  final List<Node> neighbours = [];
  final bool isSmallCave;
  bool allowSecondVisit = false;
  bool visitedBefore = false;

  Node(this.name) : isSmallCave = name.toLowerCase() == name;

  Iterable<String> getPathsToEnd(
      List<Node> currentRoute, Set<Node> previouslyVisitedSmallCaves) sync* {
    currentRoute.add(this);

    bool crapA = false;
    bool crapB = false;

    if (name == 'end') {
      yield currentRoute.map((e) => e.name).join(',');
    } else {
      if (isSmallCave) {
        if (allowSecondVisit) {
          if (visitedBefore) {
            crapA = true;
            previouslyVisitedSmallCaves.add(this);
          } else {
            crapB = true;
            visitedBefore = true;
          }
        } else {
          previouslyVisitedSmallCaves.add(this);
        }
      }

      for (final neighbour in neighbours.where(
          (neighbour) => !previouslyVisitedSmallCaves.contains(neighbour))) {
        yield* neighbour.getPathsToEnd(
            currentRoute, previouslyVisitedSmallCaves);
      }

      if (isSmallCave) {
        if (allowSecondVisit) {
          if (crapA) {
            previouslyVisitedSmallCaves.remove(this);
          }

          if (crapB) {
            visitedBefore = false;
          }
        } else {
          previouslyVisitedSmallCaves.remove(this);
        }
      }
    }

    currentRoute.removeLast();
  }
}

extension NodeExtensionOnMap on Map<String, Node> {
  Node getNode(String name) => putIfAbsent(name, () => Node(name));
}
