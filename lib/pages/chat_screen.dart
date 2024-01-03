import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import 'toolbar.dart';
import 'chat_textfield.dart';
import 'chat_message.dart'; // Import the chat_message file
import 'message_handler.dart'; // Import the message handling functions

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ChatBubble(
                key: Key(message.documentId), // Use a unique key for each ChatBubble
                index: index,
                message: message,
                onDelete: deleteMessage,
                onUpdate: updateMessage,
              );
            },
          )
        ),
        ChatTextField(
          onSendMessage: saveMessage,
        ),
        SizedBox(height: 20),
        MyIconToolbar(),
      ],
    );
  }


  // Implement the saveMessage method using functions from message_handler.dart
  Future<void> saveMessage(String text, bool isSentByUser) async {
    // Add your logic to save the message
    final newMessage = createMessage(text, isSentByUser);
    messages.add(newMessage);
    setState(() {});
  }

  void deleteMessage(int index) {
    print("Deleting message at index $index");
    final deletedMessage = messages.removeAt(index);
    print("Deleted Message: $deletedMessage");
    setState(() {});
    print("Messages after deletion: $messages");
  }

  void updateMessage(String documentId, String newText) {
    final index = messages.indexWhere((message) =>
    message.documentId == documentId);
    if (index != -1) {
      print("Updating message at index $index with text: $newText");
      final updatedMessage = messages[index];
      setState(() {
        messages[index] = updatedMessage.copyWithNewText(newText);
      });
      print("Updated Message: $updatedMessage");
      print("Messages after update: $messages");
    } else {
      print("Message with documentId $documentId not found for update.");
    }
  }
}
