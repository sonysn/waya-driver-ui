import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<Map<String, String>> faqItems = [
    {
      'question': 'How do I request a ride?',
      'answer': 'To request a ride, open the app and enter your destination. Then, confirm your pickup location and select the type of ride you want. Tap "Request" to find a driver near you.'
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept various payment methods including credit cards, debit cards, and digital wallets. You can add or update your payment methods in the app settings.'
    },
    {
      'question': 'How can I change my pickup location?',
      'answer': 'You can change your pickup location by tapping on the current pickup address during the ride booking process. You can also drag and drop the pickup pin on the map to a new location.'
    },
    {
      'question': 'What should I do if I left an item in the vehicle?',
      'answer': 'If you left an item in the vehicle, you can contact your driver directly through the app. Go to the "Your Trips" section, select the specific trip, and tap on "Contact driver" to get in touch with them.'
    },
    // Add more FAQ items here
  ];

  void _openWebsite() {
    // Add your website URL here
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
        title: Text(
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
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    faqItems[index]['question']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(Icons.public),
              title: Text(
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
