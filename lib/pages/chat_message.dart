class ChatMessage {
  String documentId;
  String text;
  bool isSentByUser;

  ChatMessage(this.documentId, this.text, this.isSentByUser);

  ChatMessage copyWithNewText(String newText) {
    return ChatMessage(documentId, newText, isSentByUser);
  }

  @override
  String toString() {
    return 'ChatMessage(text: $text, isSentByUser: $isSentByUser)';
  }
}