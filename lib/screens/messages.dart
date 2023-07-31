import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qunot_driver/api/actions.dart';
import 'package:qunot_driver/colorscheme.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List messages = []; // Replace with your actual list of messages
  List reversedMessages = [];

  Future _getDriverNotifications() async {
    final response = await getDriverNotifications();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        messages.addAll(data);
        //bring the data in reverse order to show the most recent notifications first
        reversedMessages = messages.reversed.toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDriverNotifications();
  }

  @override
  void dispose() {
    messages.clear();
    reversedMessages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.black, // S
      ),
      body: RefreshIndicator(
          color: Colors.orangeAccent,
          backgroundColor: customPurple,
          onRefresh: _getDriverNotifications,
          child: messages.isNotEmpty ? buildMessagesList() : buildNoMessages()),
    );
  }

  Widget buildMessagesList() {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // final message = messages[index];
        return ListTile(
          title: Text(
            reversedMessages[index]['Title'],
          ),
          subtitle: Text(reversedMessages[index]['Message']),
          // Add any additional message details here
        );
      },
    );
  }

  Widget buildNoMessages() {
    return const Center(
      child: Text(
        'You have no messages.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
