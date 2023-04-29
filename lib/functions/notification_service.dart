import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String data) async {
    //for android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'New Notification', // The title of the notification
            'Shows a notification when new data is received',
            // The description of the notification
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    //for ios
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            subtitle: 'Shows a notification when new data is received',
            sound: 'default',
            badgeNumber: 1);

    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'New Ride received', data, platformChannelSpecifics,
        payload: 'new_notification');
  }
}
