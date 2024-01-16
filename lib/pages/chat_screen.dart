import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'chat_bubble.dart';
import 'toolbar.dart';
import 'chat_textfield.dart';
import 'chat_message.dart'; // Import the chat_message file

const String projectID = "657c5f8ee668aff8af1f";
const String databaseId = "657c5fae0ebe939915f8";
const String url = "https://god-did.de/v1";
const String chatCollection = "657c663392ac1f6bfa49";


class ChatScreen extends StatefulWidget {
  static final client = Client();
  static final databases = Databases(client);

  ChatScreen() : super();

@override
_ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  key: Key(message.documentId),
                  index: index,
                  message: message,
                  onDelete: (int index) => deleteMessage(message.documentId),
                  onUpdate: (String documentId, String newText) =>
                      updateMessage(documentId, newText),
                );
              },
            ),
          ),
          ChatTextField(
            onSendMessage: saveMessage,
          ),
          SizedBox(height: 20),
          MyIconToolbar(),
        ],
      ),
    );
  }


  Future<void> saveMessage(String text, bool isSentByUser) async {
    // Remove 'const' here
    final client = Client();
    final databases = Databases(client);


    try {
      final response = null;
      /*final response = await client.createDocument(
        collectionId: chatCollection,
        data: {'text': text, 'isSentByUser': isSentByUser},
      );*/

      final documentId = response.data['\$id'];

      final newMessage = ChatMessage(
        documentId: documentId,
        text: text,
        isSentByUser: isSentByUser,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      setState(() {
        messages.add(newMessage);
      });
    } catch (e) {
      print('Error saving message: $e');
    }
  }


  void deleteMessage(String documentId) {
    print("Deleting message with documentId $documentId");
    final deletedMessage = messages.firstWhere((message) => message.documentId == documentId);

    if (mounted) {
      setState(() {
        messages.removeWhere((message) => message.documentId == documentId);
      });
    }

    print("Deleted Message: $deletedMessage");
    print("Messages after deletion: $messages");
  }

  void updateMessage(String documentId, String newText) {
    final index = messages.indexWhere((message) => message.documentId == documentId);
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
