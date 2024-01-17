class ChatMessage {
  String documentId;
  String text;
  bool isSentByUser;
  int timestamp;

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
      timestamp: timestamp,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(text: $text, isSentByUser: $isSentByUser, timestamp: $timestamp)';
  }
}

// Constants related to Appwrite
const String APPWRITE_PROJECT_ID = "657c5f8ee668aff8af1f";
const String APPWRITE_DATABASE_ID = "657c5fae0ebe939915f8";
const String APPWRITE_URL = "https://god-did.de/v1";
const String USERS_COLLECTION = "65947d7d72246768b9ea9a";