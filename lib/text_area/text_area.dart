import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/general_provider.dart';
import '../models/node.dart';
import '../useful/useful.dart';

class TextArea extends StatelessWidget {
  const TextArea({Key? key}) : super(key: key);

  Widget showText(Node? t) {
    if (t == null || t.subjects.isEmpty) return SizedBox(height: 0);
    List<Widget> layout = [];
    for (var s in t.subjects) {
      layout.add(Text(s.title, style: subjectTitleStyle));
      layout.add(SizedBox(height: 10));

      layout.add(Text(s.text, style: textStyle));
      layout.add(SizedBox(height: 20));
      for (var ss in s.subSubjects) {
        layout.add(Text(ss.title, style: subSubjectTitleStyle));
        layout.add(SizedBox(height: 5));

        layout.add(Text(ss.text, style: textStyle));
        layout.add(SizedBox(height: 20));
      }
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: layout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<GeneralProvider>(context);

    return showText(p.selectedNode);
  }
}
