import 'package:flutter/material.dart';

var leftPadding = 25.0;

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
              children: [
                TextButton(
                    child: Text("Button 1"),
                    onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
              ],
            )
        ),
      ),
    ),
  );
}