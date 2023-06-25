import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  List<Map<String, String>> faqItems = [
    {
      'question': 'How do I sign up as a driver?',
      'answer':
          "To sign up as a driver, download the driver app and follow the registration process. Enter your personal information, upload the required documents such as your driver's license and proof of insurance, and agree to the terms and conditions. Once your information is verified, you will be able to start accepting ride requests."
    },

    {
      'question': 'How do I set my availability as a driver?',
      'answer':
          'To set your availability as a driver, open the driver app and toggle the online button'
    },

    {
      'question': "How do I navigate to a passenger's pickup location?",
      'answer':
          "When a ride request is accepted, the driver app will provide you with the passenger's pickup location. To navigate there, simply tap on the 'Navigate' button within the app. It will open your preferred navigation app (such as Google Maps) with the destination pre-filled. Follow the directions provided to reach the pickup location."
    },

    {
      'question': 'How do I start a trip with a passenger?',
      'answer':
          "To start a trip with a passenger, ensure that you have arrived at the pickup location. Once you have confirmed the passenger's presence, tap on the 'Start Trip' button within the driver app. This will begin the trip, and the app will start tracking the distance and time for the fare calculation."
    },

    {
      'question': 'How do I receive payment as a driver?',
      'answer':
          "As a driver, you will receive payment through the app. After completing a trip, the app will automatically calculate the fare based on distance and time. The passenger's payment will be charged to their selected payment method, and you will receive your earnings."
    },
    // Add more FAQ items here
  ];

  void _openWebsite() {
    // Add your website URL here
    //TODO: remove ignore: unused_local_variable when this is used
    // ignore: unused_local_variable
    String websiteUrl = 'https://www.example.com';

    // Open the website URL in a web browser
    // (You can use other packages like url_launcher for more options)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Help',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    faqItems[index]['question']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(faqItems[index]['answer']!),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: ListTile(
              leading: const Icon(Icons.public),
              title: const Text(
                'Visit Our Website',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _openWebsite,
            ),
          ),
        ],
      ),
    );
  }
}
