import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../providers/general_provider.dart';
import './tree_grid_painter.dart';
import '../models/subjects.dart';

class PanTree extends StatelessWidget {
  void react(BuildContext context, RawKeyEvent event) {
    print('Key Pressed');
    final p = Provider.of<GeneralProvider>(context, listen: false);
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp))
      p.setYMulti(p.yMulti + 1);
    else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown))
      p.setYMulti(p.yMulti - 1);
    else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft))
      p.setXNodeDist(p.xNodeDist - 1);
    else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight))
      p.setXNodeDist(p.xNodeDist + 1);
    else if (event.isKeyPressed(LogicalKeyboardKey.keyC))
      p.setEnableCoord(!p.enableCoord);
    else if (event.isKeyPressed(LogicalKeyboardKey.keyN))
      p.addNode();
    else if (event.isKeyPressed(LogicalKeyboardKey.keyD))
      p.removeNode();
    else if (event.isKeyPressed(LogicalKeyboardKey.keyR))
      p.setXYScale(
          -MediaQuery.of(context).size.width * 0.5 + p.tree!.x! * p.scale,
          -100,
          p.scale);
    else if (event.isKeyPressed(LogicalKeyboardKey.keyS))
      for (var s in rSubjects) p.addSubject(p.selectedNode, subject: s);
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<GeneralProvider>(context);
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        react(context, event);
      },
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          p.setXYScale(
            p.x0 - details.delta.dx,
            p.y0 - details.delta.dy,
            p.scale,
          );
        },
        onTapUp: (TapUpDetails details) {
          double xActualGlobal = (p.x0 + details.globalPosition.dx) / p.scale;
          double yActualGlobal = (p.y0 + details.globalPosition.dy) / p.scale;
          p.updateSelected(p.tree, xActualGlobal, yActualGlobal);
        },
        child: Listener(
          onPointerSignal: (PointerSignalEvent event) {
            if (event is PointerScrollEvent) {
              double xActualGlobal = (p.x0 + event.position.dx) / p.scale;
              double yActualGlobal = (p.y0 + event.position.dy) / p.scale;

              double auxScale = p.scale + (-event.scrollDelta.dy / 10);
              if (auxScale < 5) auxScale = 5;
              if (auxScale > 300) auxScale = 300;

              p.setXYScale(
                xActualGlobal * auxScale - event.position.dx,
                yActualGlobal * auxScale - event.position.dy,
                auxScale,
              );
            }
          },
          child: CustomPaint(
            child: Container(),
            painter: TreeGrid(context),
          ),
        ),
      ),
    );
  }
}
