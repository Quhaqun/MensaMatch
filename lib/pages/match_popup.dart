import 'package:flutter/material.dart';

class MatchPopup extends StatelessWidget {
  const MatchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 828,
        width: 1792,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Your Match",
                style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF345573),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Jonas, 26',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              SizedBox(height: 8),
              CircleAvatar(
                radius: 40, // Set the radius as needed
                backgroundImage: AssetImage(
                    'your_image_path.jpg'), // Replace with the path to your image
              ),
              SizedBox(height: 16),
              Text(
                "M.Sc. Computer Science",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6D7F94),
                ),
              ),
              Text(
                "3rd semester",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6D7F94),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 2,
                width: 200,
                color: Color(0xFF6D7F94),
              ),
              SizedBox(height: 16),
              Text(
                "Today",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6D7F94),
                ),
              ),
              Text(
                '12:30',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Text(
                "Skyline Mensa",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6D7F94),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 2,
                width: 200,
                color: Color(0xFF6D7F94),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle Chat
                  print('Chat pressed');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF345573),
                  onPrimary: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                child: Text(
                  'Chat',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle Cancel meeting
                  print('Cancel meeting pressed');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.red,
                  minimumSize: Size(200, 50),
                  side: BorderSide(color: Colors.red),
                ),
                child: Text(
                  'Cancel meeting',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}