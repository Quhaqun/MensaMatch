// chat_textfield.dart
import 'package:flutter/material.dart';


class ChatTextField extends StatelessWidget {
  final Function(String, bool) onSendMessage;

  ChatTextField({
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey, // Customize the background color
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  // You can perform some actions as the user types
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_outlined, size: 50,),
            onPressed: () {
              // Call the onSendMessage callback with the entered text
              onSendMessage(textController.text, true);
              textController.clear(); // Clear the text field after sending the message
            },
          ),
        ],
      ),
    );
  }
}
