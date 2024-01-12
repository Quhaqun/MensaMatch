import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String text;
  final Color color;

  MySearchBar({Key? key, required this.text, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey, // Background color of the search bar
        borderRadius: BorderRadius.circular(20), // Rounded edges
      ),
      height: 80,
      width: double.infinity, // Spans the width of the screen
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
