import 'dart:io' as io;
import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/pages/match_popup.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/pages/profile_view.dart';
import 'package:mensa_match/pages/user_info.dart';

class MessagesPage extends StatefulWidget {
  final String match_id;

  const MessagesPage({Key? key, required this.match_id}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final database = DatabaseAPI();
  final appwrite = AuthAPI();
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
      final value =
          await database.getMessages(matched_user_id: widget.match_id);
      setState(() {
        messages = value.documents;
      });
    } catch (e) {
      print("Error in loadMessages(): $e");
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      Map<String, dynamic> userData =
          await database.getUser(searchid: widget.match_id);

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
      await database.addMessage(
          message: messageTextController.text, reciever_id: widget.match_id);
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
      backgroundColor: AppColors.backgroundColorLight,
      body: Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // Header
              // ==========================================
              CustomPaint(
                painter: WaveBackgroundPainterShort(baseHeight: 140),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: getUser(),
                      builder: (context, snapshot) {
                        io.File placeholderImage =
                            io.File('assets/assets/placeholder_image.png');
                        XFile placeholderXImage =
                            new XFile((placeholderImage.path));
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final userMap = snapshot.data;
                          XFile? imageUrl =
                              userMap?['profile_picture'] ?? placeholderXImage;
                          userMap?['profile_picture'] ??
                              'default_image_url'; // Replace 'default_image_url' with your default image URL

                          return Container(
                            height: 120,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.chevron_left,
                                          size: 30.0,
                                          color: AppColors.white,
                                        ),
                                        Text(
                                          'Back',
                                          style: GoogleFonts.roboto(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage:
                                            NetworkImage(imageUrl!.path),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        userMap?['name'] ?? 'null',
                                        style: GoogleFonts.roboto(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: AppColors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => UserInfo(showEditButton: false,id: widget.match_id)));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              // ==========================================
              // Messages
              // ==========================================
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    final reversedIndex = (messages!.length - 1) - index;
                    final message = messages![reversedIndex];

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Message'),
                              content: const Text(
                                  'Are you sure you want to delete this message?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool isSenderValue =
                                        await isSender(message.$id);
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
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: FutureBuilder<bool>(
                          future: isSender(message.$id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              final isSender = snapshot.data!;

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  mainAxisAlignment: isSender
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: isSender
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      ),
                                      child: Card(
                                        color: isSender
                                            ? AppColors.messageSender
                                            : AppColors.cardColor,
                                        elevation: 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            message.data['text'],
                                            style: GoogleFonts.roboto(
                                              color: isSender
                                                  ? AppColors.white
                                                  : AppColors.textColorDark,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
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

              const SizedBox(height: 10.0),

              // ==========================================
              // Send message bar
              // ==========================================
              if (authStatus == AuthStatus.authenticated)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: TextField(
                            controller: messageTextController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.cardColor,
                              hintText: 'Type a message',
                              contentPadding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: const CircleAvatar(
                          backgroundColor: AppColors
                              .accentColor1, // Set your desired background color here
                          child: Icon(
                            Icons.send,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ]),
      ),
    );
  }
}
