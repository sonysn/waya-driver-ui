import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final List<String> messages = []; // Replace with your actual list of messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.black, // S
      ),
      body: messages.isNotEmpty ? buildMessagesList() : buildNoMessages(),
    );
  }

  Widget buildMessagesList() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          title: Text(message),
          // Add any additional message details here
        );
      },
    );
  }

  Widget buildNoMessages() {
    return Center(
      child: Text(
        'You have no messages.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
