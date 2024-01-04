class ChatMessage {
  String documentId;
  String text;
  bool isSentByUser;
  int timestamp; // Add this field

  final String APPWRITE_PROJECT_ID = "657c5f8ee668aff8af1f";
  final String APPWRITE_DATABASE_ID = "657c5fae0ebe939915f8";
  final String APPWRITE_URL = "https://god-did.de/v1";
  final String USERS_COLLECTION = "65947d7d72246768b9ea9a";

  ChatMessage({
    required this.documentId,
    required this.text,
    required this.isSentByUser,
    required this.timestamp,
  });

  ChatMessage copyWithNewText(String newText) {
    return ChatMessage(
      documentId: documentId,
      text: newText,
      isSentByUser: isSentByUser,
      timestamp: timestamp, // Include timestamp in the copy
    );
  }

  @override
  String toString() {
    return 'ChatMessage(text: $text, isSentByUser: $isSentByUser, timestamp: $timestamp)';
  }
}
