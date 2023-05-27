import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waya_driver/functions/location_functions.dart';
import 'package:waya_driver/screens/homepage.dart';
import 'package:waya_driver/screens/splash_screen.dart';
import 'functions/notification_service.dart';
import 'screens/welcomepage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
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

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  ).then((value) {
    runApp(const WApp());
  });
}

class WApp extends StatefulWidget {
  const WApp({Key? key}) : super(key: key);

  @override
  State<WApp> createState() => _WAppState();
}

class _WAppState extends State<WApp> with WidgetsBindingObserver {
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  bool _isSplashScreenShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    initializeApp();
  }

  Future<void> initializeApp() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSplashScreenShown = _prefs.getBool('isSplashScreenShown') ?? false;
      _isInitialized = true;
    });
  }

  Future<void> saveAppState() async {
    await _prefs.setBool('isSplashScreenShown', _isSplashScreenShown);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      saveAppState();
    } else if (state == AppLifecycleState.resumed) {
      restoreAppState();
    }
  }

  Future<void> restoreAppState() async {
    setState(() {
      _isSplashScreenShown = _prefs.getBool('isSplashScreenShown') ?? false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const CircularProgressIndicator();
    }

    Widget homeWidget;
    if (_isSplashScreenShown) {
      homeWidget =  HomePage();
    } else {
      homeWidget =  SplashScreen();
    }

    return MaterialApp(
      title: 'Your App',
      home: Scaffold(
        body: homeWidget,
      ),
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
