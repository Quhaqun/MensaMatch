import 'package:appwrite/appwrite.dart';
import '../appwrite/auth_api.dart';
import '../appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState  createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  List<Message>? messages;
  final database = DatabaseAPI();
  TextEditingController messageTextController = TextEditingController();
  AuthStatus authStatus = AuthStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    loadMessages();
  }

  loadMessages() async {
    try {
      final value = await database.getMessages();
      setState(() {
        messages = value.documents.map((doc) => Message.fromDocument(doc)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  addMessage() async {
    try {
      await database.addMessage(message: messageTextController.text);
      const snackbar = SnackBar(content: Text('Message added!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      messageTextController.clear();
      loadMessages();
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  deleteMessage(String id) async {
    try {
      await database.deleteMessage(id: id);
      loadMessages();
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              authStatus == AuthStatus.authenticated
                  ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      addMessage();
                    },
                    icon: const Icon(Icons.send),
                    label: const Text("Send"),
                  ),
                ],
              )
                  : const Center(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = messages?[index];
                    return Card(
                      child: ListTile(
                        title: Text(message?.text ?? ''),
                        trailing: IconButton(
                          onPressed: () {
                            if (message?.documentId != null) {
                              deleteMessage(message!.documentId);
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
