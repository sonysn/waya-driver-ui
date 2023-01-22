import 'package:flutter/material.dart';
import 'screens/welcomepage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Set app orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MaterialApp(
    home: WApp(),
  )));
}


class WApp extends StatelessWidget {
  const WApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomePage(),
    );
  }
}
