import 'package:flutter/material.dart';

Widget input_password({
  required TextEditingController controller,
  required String labelText,
  bool obscureText = false, // Add the obscureText parameter with a default value of false
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText, // Set the obscureText property
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}