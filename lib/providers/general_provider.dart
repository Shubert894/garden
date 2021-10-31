import 'dart:math';

import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import '../models/node.dart';
import '../tree_algorithms/bucheim.dart';
import '../tree_algorithms/tree_operations.dart';
import '../useful/useful.dart';
import '../models/subjects.dart';
import '../tree_algorithms/tree_operations.dart';

class GeneralProvider extends ChangeNotifier {
  double x0 = 0; //global X coordinated of the upper_left corner * scale
  double y0 = 0; //global Y coordinated of the upper_left corner * scale

  Node? tree = null; //bucheim(trees[0]);

  double scale = 100; //difference in pixels between 2 consecutive numbers
  double radiusAsPercentageOfScale = 0.45; //the name says it all

  //visualization parameters
  int xNodeDist = 1;
  int yMulti = 2;

  bool enableCoord = false;

  Node? selectedNode;

  double h1WidthPerc = 0.5;

  void buildT() {
    if (tree != null) {
      tree = bucheim(tree!, xNodeDist, yMulti);
      notifyListeners();
    }
  }

  //--Local Storage----
  void extractLocalData() {
    final nodesBox = Hive.box(nodesBoxName);
    if (nodesBox.isNotEmpty) {
      //transforming box contents into a map
      final Map<String, List<String>> nodesMap = {};
      for (int i = 0; i < nodesBox.length; i++) {
        String key = nodesBox.keyAt(i);
        final List<dynamic> rawList = nodesBox.get(key, defaultValue: []);
        final List<String> list = rawList.cast<String>();
        nodesMap[key] = list;
      }
      print(nodesMap);
      //constructing tree from the map
      Node rawTree =
          _recursiveExtraction(nodesMap, Node(nodesBox.keys.first, []));

      tree = bucheim(rawTree, xNodeDist, yMulti);
    } else
      tree = bucheim(trees[0], xNodeDist, yMulti); //default tree
  }

  Node _recursiveExtraction(Map<String, List<String>> m, Node t) {
    if (m.containsKey(t.id)) {
      final List<String> ch = m.remove(t.id) ?? [];

      ch.forEach((el) {
        t.children.add(_recursiveExtraction(m, Node(el, [])));
      });
    }
    return t;
  }

  void _putNode(String nodeId, String childId) {
    final nodesBox = Hive.box(nodesBoxName);

    List<dynamic> rawList = nodesBox.get(nodeId, defaultValue: []);
    List<String> childrenId = rawList.cast<String>();

    childrenId.add(childId);
    nodesBox.put(nodeId, childrenId);
  }

  void addNode() {
    if (tree == null || selectedNode == null) return;

    final int oldX = selectedNode!.x!;
    final int oldY = selectedNode!.y!;

    Node newNode = Node(genId(), []);

    _putNode(selectedNode!.id, newNode.id);

    selectedNode!.children.add(newNode);

    buildT();
    x0 += (selectedNode!.x! - oldX) * scale;
    y0 += (selectedNode!.y! - oldY) * scale;
  }

  void _deleteFromLocal(String nodeId, String parentId) {
    final nodesBox = Hive.box(nodesBoxName);

    //deletes all the descendants of the node and itself
    _recursiveDelete(nodesBox, nodeId);

    //deletes the reference to the node from the parent's children array
    List<dynamic> rawList = nodesBox.get(parentId, defaultValue: []);
    List<String> childrenId = rawList.cast<String>();

    childrenId.removeWhere((id) => id == nodeId);
    nodesBox.put(parentId, childrenId);
  }

  void _recursiveDelete(Box<dynamic> b, String parentId) {
    List<dynamic> rawList = b.get(parentId, defaultValue: []);
    List<String> childrenId = rawList.cast<String>();
    childrenId.forEach((ch) {
      _recursiveDelete(b, ch);
    });
    b.delete(parentId);
  }

  void removeNode() {
    if (tree == null || selectedNode == null || selectedNode!.parent == null)
      return;
    print('Removing the node');
    print(selectedNode!.id);
    for (int i = 0; i < selectedNode!.parent!.children.length; i++)
      if (selectedNode!.parent!.children[i].id == selectedNode!.id) {
        _deleteFromLocal(selectedNode!.id,
            selectedNode!.parent!.id); //deletes from local memory
        selectedNode!.parent!.children
            .removeAt(i); //deleted from program memory
        buildT();
        return;
      }
  }
  //-------------------

  //---Information in the nodes----
  void addSubject(Node? t,
      {String title = '', String text = '', Subject? subject}) {
    if (t == null) return;
    if (subject != null)
      t.subjects.add(subject);
    else
      t.subjects.add(Subject(title: title, text: text));
    notifyListeners();
  }

  void addSubSubject(Subject s, String title, String text) {
    s.subSubjects.add(SubSubject(title: title, text: text));
    notifyListeners();
  }
  //-------------------------------

  //----User/Tree Interaction------
  void updateSelected(Node? t, double x, double y) {
    if (t == null) return;
    setSelected(t, x, y);
    notifyListeners();
  }

  void setSelected(Node n, double x, double y) {
    final queue = [n];
    bool hasChanged = false;
    while (queue.isNotEmpty) {
      Node t = queue.removeAt(0);
      double dist = sqrt(pow(x - t.x!, 2) + pow(y - t.y!, 2));
      if (dist < radiusAsPercentageOfScale && !t.isSelected) {
        selectedNode = t;
        hasChanged = true;
      } else
        t.isSelected = false;
      for (var child in t.children) queue.add(child);
    }
    if (!hasChanged) selectedNode = null;
    if (selectedNode != null) selectedNode!.isSelected = true;
  }
  //-------------------------------

  //----Playground parameters toggling------
  void setXYScale(double tempX, double tempY, double tempScale) {
    x0 = tempX;
    y0 = tempY;
    scale = tempScale;
    notifyListeners();
  }

  void setEnableCoord(bool a) {
    enableCoord = a;
    notifyListeners();
  }
  //----------------------------------------

  //---Visualization parameters toggling----
  void setXNodeDist(int a) {
    if (a < 1) return;
    xNodeDist = a;
    buildT();
  }

  void setYMulti(int a) {
    if (a < 1) return;
    yMulti = a;
    buildT();
  }
  //----------------------------------------
}
