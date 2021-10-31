import './subjects.dart';

class Node {
  final String id;

  Node? parent;

  int? x;
  int? y;

  int? depth;
  int? number;

  bool isSelected = false;

  List<Node> children = [];

  String title;
  List<Subject> subjects = [];

  Node(
    this.id,
    this.children, {
    this.parent,
    this.depth,
    this.number,
    this.x,
    this.y,
    this.title = '',
  });
}
