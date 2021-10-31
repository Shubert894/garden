import 'package:flutter/material.dart';
import 'package:garden/providers/general_provider.dart';
import 'package:provider/provider.dart';
import '../useful/useful.dart';
import '../drawing/pan_zoom.dart';
import '../text_area/text_area.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final p = Provider.of<GeneralProvider>(context, listen: false);
    p.extractLocalData();
    p.x0 = -MediaQuery.of(context).size.width * 0.5 + p.tree!.x! * p.scale;
    p.y0 = -100;
    return Scaffold(
      backgroundColor: scfBack,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: size.height,
                color: Color.fromRGBO(20, 20, 20, 1),
                child: PanTree(),
              ),
            ),
            //Container(width: 2, height: size.height, color: scfBack),
            // Expanded(
            //   child: Container(
            //       height: size.height,
            //       color: Color.fromRGBO(40, 40, 40, 1),
            //       child: TextArea()),
            // ),
          ],
        ),
      ),
    );
  }
}
