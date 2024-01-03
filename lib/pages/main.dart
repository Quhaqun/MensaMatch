import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'toolbar.dart';
import 'custom_app_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
          padding: EdgeInsets.only(top: 20,bottom:20),
          child: ChatScreen(),
        ),
      ),
    );
  }
}
