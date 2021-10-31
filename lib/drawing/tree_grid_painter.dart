import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/node.dart';
import '../providers/general_provider.dart';
import '../useful/useful.dart';
import 'dart:math';

class TreeGrid extends CustomPainter {
  BuildContext context;

  GeneralProvider? p;

  TreeGrid(this.context) {
    p = Provider.of<GeneralProvider>(context);
    pLines.strokeWidth = p!.scale / 20;
  }

  void drawStraightLines(Canvas canvas, Node n, Offset sp, Offset ep) {
    for (var w in n.children) {
      canvas.drawLine(Offset(n.x! * p!.scale - sp.dx, n.y! * p!.scale - sp.dy),
          Offset(w.x! * p!.scale - sp.dx, w.y! * p!.scale - sp.dy), pLines);
      drawStraightLines(canvas, w, sp, ep);
    }
  }

  void drawCubicLines(Canvas canvas, Node n, Offset sp, Offset ep) {
    var path = Path();
    final queue = [n];
    while (queue.isNotEmpty) {
      Node t = queue.removeAt(0);
      for (var child in t.children) {
        final double x1 = t.x! * p!.scale - sp.dx;
        final double y1 = t.y! * p!.scale - sp.dy;
        final double cX1 = t.x! * p!.scale - sp.dx;
        final double cY1 = t.y! * p!.scale -
            sp.dy +
            ((child.y! - t.y!) * p!.scale) * percentageOfTopCubicLine;
        final double cX2 = child.x! * p!.scale - sp.dx;
        final double cY2 = child.y! * p!.scale -
            sp.dy -
            ((child.y! - t.y!) * p!.scale) * percentageOfBottomCubicLine;
        final double x2 = child.x! * p!.scale - sp.dx;
        final double y2 = child.y! * p!.scale - sp.dy;
        path.moveTo(x1, y1);
        path.cubicTo(cX1, cY1, cX2, cY2, x2, y2);
        queue.add(child);
      }
    }
    canvas.drawPath(path, pCubicLines);
  }

  void drawNodes(Canvas canvas, Node n, Offset sp, Offset ep) {
    if (n.x! > (sp.dx - p!.scale) / p!.scale &&
        n.x! < (ep.dx + p!.scale) / p!.scale &&
        n.y! > (sp.dy - p!.scale) / p!.scale &&
        n.y! < (ep.dy + p!.scale) / p!.scale) {
      Offset center = Offset(n.x! * p!.scale - sp.dx, n.y! * p!.scale - sp.dy);
      double radius = p!.radiusAsPercentageOfScale * p!.scale;

      canvas.drawCircle(center, radius, n.isSelected ? pSelected : pNode);
    }
    for (var w in n.children) {
      drawNodes(canvas, w, sp, ep);
    }
  }

  void drawTree(Canvas canvas, Node? n, Offset sp, Offset ep) {
    if (n == null || n.x == null || n.y == null) return;

    drawCubicLines(canvas, n, sp, ep);
    drawNodes(canvas, n, sp, ep);
  }

  void drawCoordinates(Canvas canvas, Size size) {
    var path = Path();
    for (int i = -1; i <= size.width / p!.scale + 1; i++)
      for (int j = -1; j <= size.height / p!.scale + 1; j++) {
        double cX = p!.scale * i + 1 - p!.x0 % p!.scale;
        double cY = p!.scale * j + 1 - p!.y0 % p!.scale;
        Offset center = Offset(cX, cY);
        path.addOval(Rect.fromCircle(center: center, radius: p!.scale / 40));
      }
    canvas.drawPath(path, pC);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (p!.enableCoord) drawCoordinates(canvas, size);
    drawTree(canvas, p!.tree, Offset(p!.x0, p!.y0),
        Offset(p!.x0 + size.width, p!.y0 + size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
