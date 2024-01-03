import 'package:flutter/material.dart';
import 'my_button.dart';
import 'my_box.dart';

var leftPadding = 25.0;

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
              children: [
                MyButton(text: "Button 1",color: Colors.grey),
              ],
            )
        ),
      ),
    ),
  );
}