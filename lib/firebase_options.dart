// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByezWR3Y4wOg_J-KzNUoCdmVZo9dp6QgI',
    appId: '1:1036220183878:web:b6af131a873cdb6484a147',
    messagingSenderId: '1036220183878',
    projectId: 'waya-a837f',
    authDomain: 'waya-a837f.firebaseapp.com',
    storageBucket: 'waya-a837f.appspot.com',
    measurementId: 'G-WEGSPE20YY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_NgQb6mLT9ZUOnye_aYebjjM1HvtBEe0',
    appId: '1:1036220183878:android:a96c6095bd5d993684a147',
    messagingSenderId: '1036220183878',
    projectId: 'waya-a837f',
    storageBucket: 'waya-a837f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpJQDC1kP_5GF2NeMW6vGRaVXenDzGoUk',
    appId: '1:1036220183878:ios:d9208daeba81f96784a147',
    messagingSenderId: '1036220183878',
    projectId: 'waya-a837f',
    storageBucket: 'waya-a837f.appspot.com',
    iosClientId: '1036220183878-abqjegj7j0ihhd096kn8vtv6eggojmk1.apps.googleusercontent.com',
    iosBundleId: 'com.example.wayadriver.wayaDriver',
  );
}
