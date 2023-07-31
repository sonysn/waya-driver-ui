import 'package:qunot_driver/colorscheme.dart';
import 'package:flutter/material.dart';

class DriverPrivacyPolicyPage extends StatelessWidget {
  const DriverPrivacyPolicyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Privacy Policy'),
        backgroundColor: customPurple,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Information We Collect',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We collect the following information from drivers who use our app:',
              ),
              SizedBox(height: 8.0),
              Text(
                  '- Personal Information: This includes your name, contact information (such as email address and phone number), payment information, and profile information (including profile picture and user preferences).'),
              SizedBox(height: 8.0),
              Text(
                  '- Location Information: We collect your geolocation data to facilitate the provision of our services, such as matching you with riders and navigating to pick-up and drop-off locations.'),
              SizedBox(height: 8.0),
              Text(
                  '- Vehicle Information: We may collect details about the vehicle you use for providing transportation services through our app.'),
              SizedBox(height: 8.0),
              Text(
                  '- Communication Data: We collect communications and interactions between drivers and riders for quality assurance purposes and to ensure a safe and reliable service.'),
              SizedBox(height: 16.0),
              Text(
                'How We Use Your Information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We may use the collected information for the following purposes:',
              ),
              SizedBox(height: 8.0),
              Text(
                  '- To facilitate the matching of drivers with riders and the provision of transportation services.'),
              SizedBox(height: 8.0),
              Text(
                  '- To process and facilitate payment transactions between drivers and riders.'),
              SizedBox(height: 8.0),
              Text(
                  '- To communicate with drivers regarding ride requests, updates, and support.'),
              SizedBox(height: 8.0),
              Text(
                  '- To improve our app, services, and overall user experience.'),
              SizedBox(height: 8.0),
              Text('- To comply with applicable laws and regulations.'),
              SizedBox(height: 16.0),
              Text(
                'How We Share Your Information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We may share your personal information in the following circumstances:',
              ),
              SizedBox(height: 8.0),
              Text(
                  '- With riders who have requested transportation services through our app, such as sharing your name and profile picture to facilitate identification.'),
              SizedBox(height: 8.0),
              Text(
                  '- With third-party service providers who assist us in delivering our services, such as payment processors and mapping/navigation providers.'),
              SizedBox(height: 8.0),
              Text(
                  '- With law enforcement agencies or government authorities as required by applicable laws or regulations.'),
              SizedBox(height: 8.0),
              Text(
                  '- In connection with a merger, acquisition, or sale of all or a portion of our business.'),
              SizedBox(height: 8.0),
              Text(
                  '- With your consent or as otherwise disclosed at the time of data collection.'),
              SizedBox(height: 16.0),
              Text(
                'Data Retention',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We will retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Your Rights and Choices',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'As a driver using our app, you have certain rights and choices regarding the collection and use of your personal information. These may include:',
              ),
              SizedBox(height: 8.0),
              Text(
                  '- The ability to access, update, or delete your personal information.'),
              SizedBox(height: 8.0),
              Text(
                  '- The ability to modify your preferences and settings within the app.'),
              SizedBox(height: 8.0),
              Text(
                  '- The option to opt-out of certain data processing activities.'),
              SizedBox(height: 8.0),
              Text('- The right to withdraw your consent, where applicable.'),
              SizedBox(height: 16.0),
              Text(
                'Security',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We take reasonable measures to protect the security of your personal information. However, no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Updates to this Privacy Policy',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the updated Privacy Policy on our app or by other means of communication. Your continued use of our app after the effective date of the updated Privacy Policy constitutes your acceptance of the changes.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'If you have any questions or concerns about this Privacy Policy or our privacy practices, please contact us at privacy@qunot.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
