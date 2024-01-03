// message_handler.dart
import 'dart:math';

import 'chat_message.dart';

List<ChatMessage> messages = [];

ChatMessage createMessage(String text, bool isSentByUser, {String sender = 'Default Sender'}) {
  final newMessage = ChatMessage(
    Random().nextInt(1000000).toString(), // Generate a unique identifier
    text,
    isSentByUser,
  );
  messages.add(newMessage);
  return newMessage;
}


void deleteMessage(ChatMessage message) {
  messages.remove(message);
}

void updateMessage(String documentId, String newText) {
  final message = messages.firstWhere((msg) => msg.documentId == documentId);
  message.text = newText;
}

void showStatus(ChatMessage message) {
  print("Status for message: ${message.text}");
}

void showUserProfile(String sender) {
  print("User Profile for: $sender");
}