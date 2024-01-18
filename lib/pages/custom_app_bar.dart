import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final int age;

  // Add a callback function for the back arrow press
  final VoidCallback onBackPress;

  const CustomAppBar({
    Key? key,
    required this.name,
    required this.age,
    required this.onBackPress,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackPress, // Use the provided callback for back arrow press
      ),
      title: CustomAppBar(
        name: name,
        age: age,
        onBackPress: () {
          // Handle own profile access
          // You might want to navigate to the profile screen or perform a custom action.
        },
      ),
    );
  }
}