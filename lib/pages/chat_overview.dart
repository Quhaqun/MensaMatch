//import 'dart:ffi';

import 'package:appwrite/models.dart';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/chat_overview_element.dart';
import 'package:mensa_match/pages/chat.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;




class ChatOverview extends StatefulWidget {
  const ChatOverview({Key? key}) : super(key: key);

  @override
  _ChatOverviewState createState() => _ChatOverviewState();
}

class _ChatOverviewState extends State<ChatOverview> {
  int _selectedIndex = 0;
  List<Document> matches = [];
  final appwrite = AuthAPI();
  final database = DatabaseAPI();
  XFile? _image = null;
  AuthStatus authStatus = AuthStatus.uninitialized;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
    //final AuthAPI appwrite = context.read<AuthAPI>();
    //authStatus = appwrite.status;
    loadFoundMatches();
    //ProfilePickLoad();
  }

  ProfilePickLoad(String user_id) async {
    await appwrite.loadUser();
    XFile? image = await database.loadimage(pic_id: user_id);
    if (image
        .toString()
        .isNotEmpty) {
      setState(() {
        _image = image;
      });
    }
  }

  loadFoundMatches() async {
    //try {
      await appwrite.loadUser();
      final value = await database.getFoundMatches();
      setState(() {
        matches = value.documents;
      });
    //} catch (e) {
    //  print("Error in loadFoundMatches(): $e");
    //}
  }

  Future<String> getLastMessage(String matchedUserId) async {
    //try {
      await appwrite.loadUser();
      final documentList = await database.getMessages(matched_user_id: matchedUserId);

      // Assuming each document has a 'message' field
      if (documentList.documents.isNotEmpty) {
        // Extracting the message from the last document
        String message = documentList.documents.last.data.values.first;
        return message;
      } else {
        // Return a default message or throw an error if no messages found
        throw Exception('No messages found for user $matchedUserId');
      }
    //} catch (e) {
      // Handle errors appropriately (printing to console is okay for debugging)
    //  print("Error in getLastMessage(): $e");
      // Re-throw the error to be handled elsewhere if needed
      //throw e;
    //}
  }


  Future<Map<String, dynamic>> getUser(String match_id) async {
   // try {
      await appwrite.loadUser();
      Map<String, dynamic> userData = await database.getUser(
          searchid: match_id);

      // Extract specific fields from userData
      final name = userData['name'] as String? ?? '';
      final age = userData['age'] as int? ?? 0;
      XFile? profilePicture = await database.loadimage(pic_id: match_id);

      // Return a Map with the extracted values
      return {
        'name': name,
        'age': age,
        'profile_picture': profilePicture,
      };
    //} catch (e) {
     // print("Error in getUser(): $e");
      // Throw an exception or return an empty Map based on your requirement
     // throw Exception("Failed to fetch user data");
    //}
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Filter chat data based on the search query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: CustomPaint(
              painter: WaveBackgroundPainterShort(baseHeight: 160),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      title: 'Chats',
                      backButton: false,
                      headerHeight: 150,
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildChatList(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: const MyIconToolbar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40, // Set the height of the search bar
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            // Adjust vertical padding
            child: Icon(
              Icons.search,
              color: AppColors
                  .textColorGray, // Change the color of the search icon
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8), // Set to 0
        ),
      ),
    );
  }


  Widget _buildChatList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        String senderId = "";//match.data["matcher_id"];
        if (database.auth.userid == match.data['user_id']) {
          senderId = match.data['matcher_id'];
        } else {
          senderId = match.data['user_id'];
        }
        return FutureBuilder<Map<String, dynamic>>(
          future: getUser(senderId),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (userSnapshot.hasError) {
              return Text("Error: ${userSnapshot.error}");
            } else {
              final userData = userSnapshot.data;
              io.File placeholderImage = io.File('assets/assets/placeholder_image.png');
              XFile placeholderXImage = new XFile((placeholderImage.path));
              return FutureBuilder<String>(
                future: getLastMessage(senderId),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (messageSnapshot.hasError) {
                    return Text("Error: ${messageSnapshot.error}");
                  } else {
                    final lastMessage = messageSnapshot.data;
                    return GestureDetector(
                      onTap: () {
                        // Open MessagesPage with the selected user's data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessagesPage(match_id: senderId),
                          ),
                        );
                      },
                      child: chatOverviewElement(
                        image:userData?['profile_picture'] ??  placeholderXImage,
                        name: userData?['name'] ?? 'Unknown',
                        message_preview: lastMessage ??
                            'this could be your first message',
                        match_id: senderId,
                      ),
                    );
                  }
                },
              );
            }
          },
        );
      },
    );
  }
}
