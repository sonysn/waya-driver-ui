import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Allow Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive real-time push notifications'),
              onTap: () {
                // Handle push notifications preference
              },
            ),
            ListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive notifications via email'),
              onTap: () {
                // Handle email notifications preference
              },
            ),
            ListTile(
              title: const Text('SMS Notifications'),
              subtitle: const Text('Receive notifications via SMS'),
              onTap: () {
                // Handle SMS notifications preference
              },
            ),
          ],
        ),
      ),
    );
  }
}
