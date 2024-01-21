import 'package:flutter/material.dart';

class FollowUsBox extends StatelessWidget {
  final String title;
  final String link;
  final IconData? icon;

  const FollowUsBox({
    Key? key,
    required this.title,
    required this.link,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aktion für "Follow Us" (zum Beispiel zum Öffnen von Social-Media-Seiten)
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Text linksbündig
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 30.0,
              ),
            SizedBox(width: 16.0), // Abstand zwischen Icon und Text
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
