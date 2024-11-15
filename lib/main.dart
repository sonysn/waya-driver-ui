// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:qunot_driver/screens/homepage.dart';
import 'package:qunot_driver/screens/splash_screen.dart';
import 'package:qunot_driver/functions/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qunot_driver/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:qunot_driver/sockets/sockets.dart';

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

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  // Workmanager().initialize(
  //   callbackDispatcher, // the callback function to run background tasks
  //   isInDebugMode: true, // enable logging in debug mode
  // );
  // Workmanager().registerPeriodicTask(
  //   "Task Ping Location", // unique name for the task
  //   "Ping Location", // task name
  //   frequency: const Duration(minutes: 15), // execute the task each 30 seconds
  // );

  runApp(const MaterialApp(
    home: WApp(),
  ));
}

class WApp extends StatefulWidget {
  const WApp({Key? key}) : super(key: key);

  @override
  State<WApp> createState() => _WAppState();
}

class _WAppState extends State<WApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification click here
      navigateToScreenBasedOnPayload(message.data);
    });
  }

  //TODO: MOVE THIS OUT OF HERE
  void navigateToScreenBasedOnPayload(Map<String, dynamic> data) {
    // Extract the necessary data from the payload and navigate to the appropriate screen
    if (data.containsKey('screen')) {
      String screen = data['screen'];

      // Navigate to the specified screen
      if (screen == 'homepage') {
        // Extract additional data if needed and pass it to the screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(data: data),
          ),
        );
      } else if (screen == 'riderequest') {
        // Extract additional data if needed
        int riderId = data['riderId'];
        String name = data['name'];
        String pickupLocation = data['pickupLocation'];
        String dropoffLocation = data['dropoffLocation'];
        int fare = data['fare'];
        String riderPhoneNumber = data['riderPhoneNumber'];
        List pickupLocationPosition = data['pickupLocationPosition'];
        List dropoffLocationPostion = data['dropoffLocationPostion'];

        // Pass the data to the RideRequestCard widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideRequestCard(
              riderId: riderId,
              name: name,
              pickupLocation: pickupLocation,
              dropoffLocation: dropoffLocation,
              fare: fare,
              riderPhoneNumber: riderPhoneNumber,
              pickupLocationPosition: pickupLocationPosition,
              dropoffLocationPostion: dropoffLocationPostion,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(),
    );
  }
}

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     DartPluginRegistrant.ensureInitialized();
//     //use task name here
//     if (taskName == "Ping Location") {
//       locationPingServer();
//     }
//     return Future.value(true);
//   });
// }
