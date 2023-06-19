import 'package:flutter/material.dart';
import 'package:waya_driver/colorscheme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Qunot'),
        backgroundColor: customPurple, // Custom app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Center(
              child: CircleAvatar(
                backgroundColor: customPurple,
                radius: 64.0,
                child: Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 72.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Qunot',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Last updated: June 1, 2023',
            ),
            SizedBox(height: 16.0),
            Text(
              'About',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Qunot is a leading transportation platform that connects riders and drivers seamlessly. Our mission is to provide safe, reliable, and convenient transportation services to individuals and communities worldwide.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8.0),
                Text(
                  'Email: info@qunot.com',
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.public),
                SizedBox(width: 8.0),
                Text(
                  'Website: www.qunot.com',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
