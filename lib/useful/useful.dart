import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var pC = Paint()
  ..color = Colors.grey
  ..strokeWidth = 1
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.round;

var pNode = Paint()
  ..color = Colors.green
  ..strokeWidth = 3
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.round;

var pLines = Paint()
  ..color = Colors.blue
  ..strokeWidth = 3
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.round;

var pCubicLines = Paint()
  ..color = Colors.pink[200]!
  ..strokeWidth = 2
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

var pSelected = Paint()
  ..color = Colors.red
  ..strokeWidth = 3
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.round;

Color scfBack = Color.fromRGBO(30, 30, 30, 1);
final double percentageOfTopCubicLine = 0.9;
final double percentageOfBottomCubicLine = 0.6;
final String nodesBoxName = 'nodesBox4';

TextStyle subjectTitleStyle = GoogleFonts.openSans(
    color: Color.fromRGBO(230, 230, 230, 1),
    fontSize: 40,
    fontWeight: FontWeight.w500);
TextStyle subSubjectTitleStyle = GoogleFonts.openSans(
    color: Color.fromRGBO(230, 230, 230, 1),
    fontSize: 25,
    fontWeight: FontWeight.w400);
TextStyle textStyle = GoogleFonts.openSans(
    color: Color.fromRGBO(230, 230, 230, 1),
    fontSize: 16,
    fontWeight: FontWeight.w400);

String genId() {
  return DateTime.now().microsecondsSinceEpoch.toString();
}
