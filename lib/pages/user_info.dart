import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:mensa_match/pages/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/image_picker.dart';
import 'package:mensa_match/pages/match_popup.dart';
import '../appwrite/auth_api.dart'; // Import your DatabaseAPI
import 'package:mensa_match/constants/interests.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import '../appwrite/database_api.dart';

class UserInfo extends StatefulWidget {
  final bool showEditButton;
  final String id;

  const UserInfo({
    Key? key,
    required this.id,
    this.showEditButton = true,
  }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final DatabaseAPI database = DatabaseAPI();
  XFile? _image = null;
  Map<String, dynamic>? userData;
  AuthStatus authStatus = AuthStatus.uninitialized;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    appwrite.loadUser();
    ProfilePickLoad();
    _loadUserData(); // Call _loadUserData in initState
  }

  ProfilePickLoad() async {
    XFile? image = await database.loadimage(pic_id: widget.id);
    if (image.toString().isNotEmpty) {
      setState(() {
        _image = image;
      });
    }
  }

  // Method to load user data
  void _loadUserData() async {
    try {
      final userProfile = await database.getProfile(searchid: widget.id);
      if (userProfile != null) {
        final name = userProfile.name;
        final age = userProfile.age;
        final preferences = userProfile.preferences;
        final bio = userProfile.bio;
        final semester = userProfile.semester;
        final course = userProfile.course;
        final profilePicture = await database.loadimage(pic_id: widget.id);

        setState(() {
          userData = {
            'name': name,
            'age': age,
            'preferences': preferences,
            'bio': bio,
            'semester': semester,
            'course': course,
            'profile_picture': profilePicture,
          };
        });
      } else {
        // Handle case where userProfile is null
        // You can return default values or handle it according to your app's logic
        setState(() {
          userData = {};
        });
      }
    } catch (e) {
      print("Error in getUser(): $e");
      // Throw an exception or handle the error based on your requirement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: _image != null ? null : AppColors.cardColor,
                      image: _image != null
                          ? DecorationImage(
                        image: _image !=null  ? !kIsWeb ? Image.file(File(_image!.path)).image : NetworkImage(_image!.path) : NetworkImage("https://static.wikia.nocookie.net/spongebob/images/5/5c/Spongebob-squarepants.png"),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.0,
                          left: 16.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentColor1,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(12.0),
                              icon: Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        if (widget.showEditButton)
                          Positioned(
                            top: 16.0,
                            right: 16.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentColor1,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.all(16.0),
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfilePage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData?["name"]} , ${userData?["age"].toString()}  ',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          userData?["course"] ?? "null",
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${getSemesterString(userData?["semester"])} Semester',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      userData?["bio"] ?? "null",
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interests',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ReadOnlyBubbleList(
                          availableOptions: Interests.availableOptions,
                          selectedOptions: (userData?["preferences"]
                          as List<String>?) ??
                              [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
