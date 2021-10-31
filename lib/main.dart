import 'package:flutter/material.dart';
import 'package:garden/useful/useful.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './screens/display_screen.dart';
import './providers/general_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Garden initiated');
    return ChangeNotifierProvider(
      create: (_) => GeneralProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Garden',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: Hive.openBox(nodesBoxName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else
                return Scaffold(body: DisplayScreen());
            } else
              return Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}
