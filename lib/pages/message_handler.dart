import 'dart:math';
import 'package:uuid/uuid.dart';
import 'chat_message.dart';

List<ChatMessage> messages = [];
Function() onMessagesChanged = () {}; // Callback for notifying listeners

ChatMessage createMessage(String text, bool isSentByUser, {String sender = 'Default Sender'}) {
  final newMessage = ChatMessage(
    documentId: Uuid().v4(),
    text: 'Your actual text here',
    isSentByUser: true, // or false based on your logic
    timestamp: DateTime.now().millisecondsSinceEpoch,
  );
  messages.add(newMessage);
  onMessagesChanged(); // Notify listeners
  return newMessage;
}

void deleteMessage(ChatMessage message) {
  messages.remove(message);
  onMessagesChanged(); // Notify listeners
}

void updateMessage(String documentId, String newText) {
  final index = messages.indexWhere((message) => message.documentId == documentId);
  if (index != -1) {
    messages[index] = messages[index].copyWithNewText(newText);
    onMessagesChanged(); // Notify listeners
  }
}

void showStatus(ChatMessage message) {
  print("Status for message: ${message.text}");
}

void showUserProfile(String sender) {
  print("User Profile for: $sender");
}
