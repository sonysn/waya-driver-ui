import 'package:flutter/material.dart';
import 'package:waya_driver/screens/homepage.dart';
import 'functions/notification_service.dart';
import 'screens/welcomepage.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

Workmanager backWorkmanager = Workmanager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  
  backWorkmanager.initialize(
    callbackDispatcher, // the callback function to run background tasks
    isInDebugMode: true, // enable logging in debug mode
  );
  backWorkmanager.registerPeriodicTask(
    "1", // unique name for the task
    "Fetch Notifications", // task name
    frequency: const Duration(seconds: 30), // execute the task each 30 seconds
  );
    //Set app orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MaterialApp(
    home: WApp(),
  )));
}


class WApp extends StatefulWidget {
  const WApp({Key? key}) : super(key: key);

  @override
  State<WApp> createState() => _WAppState();
}

class _WAppState extends State<WApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomePage(),
    );
  }
}

void callbackDispatcher() {
  backWorkmanager.executeTask((taskName, inputData) async {
    // do your background work here
    print('Running task $taskName...');
    await HomePageState().getSwitchValue();
    return Future.value(true);
  });
}
