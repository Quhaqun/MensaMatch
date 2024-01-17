import 'appwrite/models.dart';

class Message {
  String documentId;
  String text;
  bool isSentByUser;
  int timestamp;

  Message({
    required this.documentId,
    required this.text,
    required this.isSentByUser,
    required this.timestamp,
  });

  factory Message.fromDocument(Document doc) {
    return Message(
      documentId: doc.$id ?? '',
      text: doc.data?['text'] ?? '',
      isSentByUser: doc.data?['isSentByUser'] ?? false,
      timestamp: doc.data?['timestamp'] ?? 0,
    );
  }

  Message copyWithNewText(String newText) {
    return Message(
      documentId: documentId,
      text: newText,
      isSentByUser: isSentByUser,
      timestamp: timestamp,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(text: $text, isSentByUser: $isSentByUser, timestamp: $timestamp)';
  }
}