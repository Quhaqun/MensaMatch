import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Placeholder values, replace them with actual data
    String name = "Max";
    int age = 24;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back arrow action
          // You might want to navigate back or perform a custom action.
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.account_circle,size: 50,),
                onPressed: () {
                  // Handle own profile access
                  // You might want to navigate to the profile screen or perform a custom action.
                },
              ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Age: $age',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Spacer(), // This widget takes up the available space
          IconButton(
            icon: Icon(Icons.account_circle, size: 50),
            onPressed: () {
              // Handle own profile access
              // You might want to navigate to the profile screen or perform a custom action.
            },
          ),
        ],
      ),
    );
  }
}