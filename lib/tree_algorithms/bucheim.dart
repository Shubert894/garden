import '../models/node.dart';

class DrawTree {
  int x = -1;
  late int y;

  late Node node;
  List<DrawTree?> ch = [];

  DrawTree? parent;
  DrawTree? thread;

  int mod = 0;
  int depth;
  int number;

  late DrawTree? ancestor;
  int change = 0;
  int shift = 0;

  DrawTree? left() {
    if (thread != null) {
      return thread;
    } else {
      if (ch.length != 0)
        return ch[0];
      else
        return null;
    }
  }

  DrawTree? right() {
    if (thread != null) {
      return thread;
    } else {
      if (ch.length != 0)
        return ch.last;
      else
        return null;
    }
  }

  DrawTree? lbrother() {
    DrawTree? n;
    if (this.parent != null)
      for (var no in parent!.ch)
        if (identical(no, this))
          return n;
        else
          n = no;
    return n;
  }

  DrawTree? get lmostSibling {
    if (parent != null && !identical(this, parent!.ch[0])) return parent!.ch[0];
    return null;
  }

  DrawTree(this.node, [this.parent, this.depth = 0, this.number = 1]) {
    this.y = depth;
    ch = [
      for (int i = 0; i < node.children.length; ++i)
        DrawTree(node.children[i], this, depth + 1, i + 1)
    ];
    this.ancestor = this;
  }
}

Node bucheim(Node n, [int xNodeDist = 1, int yMulti = 1]) {
  print('Drawing algorithm initiated');
  DrawTree dt = firstWalk(DrawTree(n), xNodeDist);
  int min = secondWalk(dt, yMulti);
  if (min < 0) thirdWalk(dt, -min);
  transfer(dt, null);
  return dt.node;
}

void transfer(DrawTree dt, Node? parent) {
  dt.node.x = dt.x;
  dt.node.y = dt.y;
  dt.node.number = dt.number;
  dt.node.depth = dt.depth;
  dt.node.parent = parent;
  for (var w in dt.ch) transfer(w!, dt.node);
}

DrawTree firstWalk(DrawTree v, [int distance = 1]) {
  if (v.ch.length == 0) {
    if (v.lmostSibling != null)
      v.x = v.lbrother()!.x + distance;
    else
      v.x = 0;
  } else {
    DrawTree defaultAncestor = v.ch[0]!;
    for (var w in v.ch) {
      firstWalk(w!, distance);
      defaultAncestor = apportion(w, defaultAncestor, distance);
    }
    executeShifts(v);

    int midpoint = ((v.ch[0]!.x + v.ch.last!.x) * 1.0 / 2).ceil();

    DrawTree? w = v.lbrother();
    if (w != null) {
      v.x = w.x + distance;
      v.mod = v.x - midpoint;
    } else
      v.x = midpoint;
  }
  return v;
}

DrawTree apportion(DrawTree v, DrawTree defaultAncestor, int distance) {
  DrawTree? w = v.lbrother();
  if (w != null) {
    DrawTree? vir = v;
    DrawTree? vor = v;
    DrawTree? vil = w;
    DrawTree? vol = v.lmostSibling!;
    int sir = v.mod;
    int sor = v.mod;
    int sil = vil.mod;
    int sol = vol.mod;

    while (vil!.right() != null && vir!.left() != null) {
      vil = vil.right();
      vir = vir.left();
      vol = vol!.left();
      vor = vor!.right();
      vor!.ancestor = v;
      int shift = (vil!.x + sil) - (vir!.x + sir) + distance;
      if (shift > 0) {
        moveSubtree(ancestor(vil, v, defaultAncestor), v, shift);
        sir = sir + shift;
        sor = sor + shift;
      }
      sil += vil.mod;
      sir += vir.mod;
      sol += vol!.mod;
      sor += vor.mod;
    }
    if (vil.right() != null && vor!.right() == null) {
      vor.thread = vil.right();
      vor.mod += sil - sor;
    } else {
      if (vir!.left() != null && vol!.left() == null) {
        vol.thread = vir.left();
        vol.mod += sir - sol;
      }
      defaultAncestor = v;
    }
  }
  return defaultAncestor;
}

void moveSubtree(DrawTree wl, DrawTree wr, int shift) {
  int subtrees = wr.number - wl.number;
  wr.change -= (shift * 1.0 / subtrees).ceil();
  wr.shift += shift;
  wl.change += (shift * 1.0 / subtrees).ceil();
  wr.x += shift;
  wr.mod += shift;
}

void executeShifts(DrawTree v) {
  int shift = 0;
  int change = 0;
  for (var w in v.ch.reversed) {
    w!.x += shift;
    w.mod += shift;
    change += w.change;
    shift += w.shift + change;
  }
}

DrawTree ancestor(DrawTree vil, DrawTree v, DrawTree defaultAncestor) {
  for (var w in v.parent!.ch)
    if (identical(vil.ancestor, w)) return vil.ancestor!;
  return defaultAncestor;
}

int secondWalk(DrawTree v,
    [int yMulti = 1, int m = 0, int depth = 0, int? min]) {
  v.x += m;
  v.y = depth * yMulti;

  if (min == null || v.x < min) min = v.x;

  for (var w in v.ch) min = secondWalk(w!, yMulti, m + v.mod, depth + 1, min);

  return min!;
}

void thirdWalk(DrawTree v, int n) {
  v.x += n;
  for (var w in v.ch) thirdWalk(w!, n);
}
