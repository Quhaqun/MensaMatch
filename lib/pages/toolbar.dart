import 'package:flutter/material.dart';

class MyIconToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconWithText(icon: Icons.home_outlined, text: "Home"),
        IconWithText(icon: Icons.chat_outlined, text: "Chat"),
        IconWithText(icon: Icons.add_box_sharp, text: "New Meeting"),
        IconWithText(icon: Icons.person_2_outlined, text: "Profile"),
        IconWithText(icon: Icons.settings_outlined, text: "Settings")
      ],
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  IconWithText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 50,color:Colors.blueGrey),
        SizedBox(height: 8),
        Text(text,
            style: TextStyle(
                fontSize: 12,
              color: Colors.blueGrey
            )),
      ],
    );
  }
}
