import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

bool findAnd = false;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Stack(
          children: [
            Container(
              //color: Colors.yellow,
              height: 120,
              decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('offline'),
                      Switch.adaptive(
                          activeTrackColor: Colors.yellow,
                          activeColor: Colors.white,
                          value: findAnd,
                          onChanged: (value) =>
                              setState(() => findAnd = value)),
                      const Text('online')
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
