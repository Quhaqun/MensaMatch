import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/pages/match_popup.dart';

class MessagesPage extends StatefulWidget {
  final String match_id;

  const MessagesPage({Key? key, required this.match_id}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final database = DatabaseAPI();
  final appwrite  = AuthAPI();
  late List<Document>? messages = [];
  TextEditingController messageTextController = TextEditingController();
  AuthStatus authStatus = AuthStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    loadMessages();
    getUser();
  }

  loadMessages() async {
    try {
      await appwrite.loadUser();
      final value = await database.getMessages(matched_user_id: widget.match_id);
      setState(() {
        messages = value.documents;
      });
    } catch (e) {
      print("Error in loadMessages(): $e");
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      Map<String, dynamic> userData = await database.getUser(searchid: widget.match_id);

      // Extract specific fields from userData
      final name = userData['name'] as String? ?? '';
      final age = userData['age'] as int? ?? 0;
      XFile? profilePicture = await database.loadimage(pic_id: widget.match_id);

      // Return a Map with the extracted values
      return {
        'name': name,
        'age': age,
        'profile_picture': profilePicture,
      };
    } catch (e) {
      print("Error in getUser(): $e");
      // Throw an exception or return an empty Map based on your requirement
      throw Exception("Failed to fetch user data");
    }
  }

  addMessage() async {
    try {
      await database.addMessage(message: messageTextController.text,reciever_id: widget.match_id);
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

  updateMessage(String id) async {
    try {
      await database.updateMessage(id: id);
      loadMessages();
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  Future<bool> isSender(String id) async {
    return database.isSender(id);
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final userMap = snapshot.data;
              XFile? imageUrl = userMap?['profile_picture'];

              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!.path),
                  ),
                  const SizedBox(width: 8.0),
                  Text(userMap?['name'] ?? "User Name"),
                ],
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadMessages();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages?.length ?? 0,
              itemBuilder: (context, index) {
                final reversedIndex = (messages!.length - 1) - index;
                final message = messages![reversedIndex];

                // ...

                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Message'),
                          content: const Text('Are you sure you want to delete this message?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                bool isSenderValue = await isSender(message.$id);
                                if (isSenderValue) {
                                  deleteMessage(message.$id);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<bool>(
                      future: isSender(message.$id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final isSender = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 200.0, // Set a maximum width for the chat bubble
                                  ),
                                  child: Card(
                                    color: isSender ? Colors.blue : Colors.lightBlue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        message.data['text'],
                                        style: TextStyle(
                                          color: isSender ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (authStatus == AuthStatus.authenticated)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    addMessage();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}