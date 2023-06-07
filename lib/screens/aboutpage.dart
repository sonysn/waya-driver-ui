import 'package:flutter/material.dart';
import '../../../colorscheme.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Center(
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
            const SizedBox(height: 16.0),
            const Text(
              'Qunot',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Last updated: June 1, 2023',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Qunot is a leading transportation platform that connects riders and drivers seamlessly. Our mission is to provide safe, reliable, and convenient transportation services to individuals and communities worldwide.',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: const [
                Icon(Icons.email),
                SizedBox(width: 8.0),
                Text(
                  'Email: info@qunot.com',
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: const [
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
