import 'package:flutter/material.dart';
import 'package:waya_driver/colorscheme.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal'),
        backgroundColor: customPurple,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome to Qunot! These Terms of Service ("Terms") govern your use of our app and services. By accessing or using our app, you agree to be bound by these Terms. If you do not agree with any part of these Terms, you may not use our app.',
              ),
              SizedBox(height: 24.0),
              Text(
                '1. Account Registration',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'To use our app, you must create an account. You are responsible for maintaining the confidentiality of your account information and are liable for all activities that occur under your account.',
              ),
              SizedBox(height: 16.0),
              Text(
                '2. User Conduct',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'You agree to use our app in compliance with applicable laws and regulations. You must not engage in any activity that may harm, disrupt, or interfere with the app or its users.',
              ),
              SizedBox(height: 16.0),
              Text(
                '3. Intellectual Property',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'All content and materials available in our app, including but not limited to text, graphics, logos, images, and software, are the property of Qunot Inc. or its licensors and are protected by intellectual property laws.',
              ),
              SizedBox(height: 16.0),
              Text(
                '4. Limitation of Liability',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Qunot Inc. shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of our app or services.',
              ),
              SizedBox(height: 24.0),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Our Privacy Policy explains how we collect, use, and protect your personal information. By using our app, you acknowledge that you have read and understood our Privacy Policy and consent to the collection, use, and disclosure of your personal information as described therein.',
              ),
              SizedBox(height: 24.0),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'If you have any questions, concerns, or feedback regarding these Terms, our Privacy Policy, or our app in general, please contact us at support@qunot.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
