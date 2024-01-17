import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'chat_bubble.dart';
import 'chat_message.dart';
import 'package:mensa_match/pages/login_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  void sendMessage() {
    final authAPI = Provider.of<AuthAPI>(context, listen: false);
    final databaseAPI = Provider.of<DatabaseAPI>(context, listen: false);

    if (authAPI.status == AuthStatus.authenticated) {
      databaseAPI.addMessage(message: messageController.text);
      messageController.clear();
    } else {
      // Handle case when the user is not authenticated
      // Example:
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthAPI>(create: (_) => AuthAPI()),
        ChangeNotifierProvider<DatabaseAPI>(create: (_) => DatabaseAPI()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<DatabaseAPI>(
                builder: (context, databaseAPI, child) {
                  return FutureBuilder<DocumentList>(
                    future: databaseAPI.getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<ChatMessage> chatMessages = snapshot.data!.documents
                            .map((document) {
                          var data = document.data;
                          return ChatMessage(
                            documentId: document.$id,
                            text: data['text'],
                            isSentByUser: data['user_id'] == Provider.of<AuthAPI>(context, listen: false).userid,
                            timestamp: data['timestamp'],
                          );
                        })
                            .toList();

                        return ListView.builder(
                          itemCount: chatMessages.length,
                          itemBuilder: (context, index) {
                            final message = chatMessages[index];

                            return ChatBubble(
                              key: UniqueKey(),
                              index: index,
                              message: message,
                              onDelete: (int index) {
                                // Handle delete functionality here
                              },
                              onUpdate: (String documentId, String newText) {
                                // Handle update functionality here
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}