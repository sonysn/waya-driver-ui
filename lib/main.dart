import 'package:flutter/material.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:waya_driver/screens/homepage.dart';
import 'package:waya_driver/screens/splash_screen.dart';
import 'functions/notification_service.dart';
import 'screens/welcomepage.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Workmanager backWorkmanager = Workmanager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// Get the device's FCM registration token
  FirebaseMessaging.instance.getToken().then((token) {
    print('FCM Token: $token');
  }).catchError((err) {
    print('Failed to get token: $err');
  });

  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  // Workmanager().initialize(
  //   callbackDispatcher, // the callback function to run background tasks
  //   isInDebugMode: true, // enable logging in debug mode
  // );
  // Workmanager().registerPeriodicTask(
  //   "Task Ping Location", // unique name for the task
  //   "Ping Location", // task name
  //   frequency: const Duration(minutes: 15), // execute the task each 30 seconds
  // );
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
      // body: WelcomePage(),
      body: SplashScreen(),
    );
  }
}

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     //use task name here
//     if (taskName == "Ping Location") {
//       locationPingServer();
//     }
//     return Future.value(true);
//   });
// }
