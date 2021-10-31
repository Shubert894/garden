import 'dart:math';

import '../models/node.dart';
import '../useful/useful.dart';

List<Node> trees = [Node(genId(), [])];

Node generateProbTree(int height,
    [List<int> pr = const [10, 90], int depth = 0]) {
  if (depth >= height) return Node('node', []);
  Random rng = Random();
  int r = rng.nextInt(101);
  int n = pr.length;
  int sum = 0;
  for (int i = 0; i < pr.length; i++) {
    sum += pr[i];
    if (r <= sum) {
      n = i;
      break;
    }
  }
  return Node('node',
      [for (int i = 1; i <= n; i++) generateProbTree(height, pr, depth + 1)]);
}
