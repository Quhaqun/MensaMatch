import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'chat_screen.dart';

void main() {
  final client = Client()
      .setEndpoint('https://god-did.de/v1') // Set your Appwrite endpoint
      .setProject('657c5f8ee668aff8af1f') // Set your Appwrite project ID
      .setSelfSigned();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final Client client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),  // Remove 'client:'
    );
  }
}



Future<void> initializeAppwrite(Client client) async {
    // Add any Appwrite initialization logic here
    // For example: Authenticate the user, initialize databases, etc.
    // You can use 'client' to interact with Appwrite services.
  }
