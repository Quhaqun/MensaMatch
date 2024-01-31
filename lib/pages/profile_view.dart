import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:mensa_match/pages/edit_profile.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:provider/provider.dart';

import '../appwrite/auth_api.dart';  // Import your DatabaseAPI

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseAPI database = DatabaseAPI();
  XFile? _image = null;
  late Map<String, dynamic> userData;  // Store user data here
  AuthStatus authStatus = AuthStatus.uninitialized;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    appwrite.loadUser();
  }

  Future<void> _loadUserData() async {
    try {
      final loadedUserData = await database.getCurrentUser();
      print("userData");
      print(loadedUserData);

      setState(() {
        userData = loadedUserData;  // Set instance variable
        isLoading = false;  // Set isLoading to false after loading data
      });
    } catch (e) {
      print('Error fetching user profile: $e $authStatus');
      // Handle error as needed
      setState(() {
        isLoading = false;  // Set isLoading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()  // Show a loading indicator while data is being fetched
        : Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Image with Back and Edit Buttons
                    Container(
                      height: MediaQuery.of(context).size.width, // Aspect ratio 1:1
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userData["profile_picture"] ?? 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?cs=srgb&dl=pexels-andrea-piacquadio-774909.jpg&fm=jpg'), // Set image URL from user data
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Back Button
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
                                  Navigator.pop(context); // Navigate back
                                },
                              ),
                            ),
                          ),
                          // Edit Button (conditionally displayed)
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
                    // Name and Subheadlines
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Replace these lines in the build method of the Profile widget
                          Text(
                            '${userData["name"]}, ${userData["age"].toString()}',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            userData["course"] ?? "",  // Use the null-aware operator and provide a default value
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            userData["semester"].toString() ?? "",  // Use the null-aware operator and provide a default value
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bio Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        userData["bio"] ?? "",
                        style: GoogleFonts.roboto(
                          color: AppColors.textColorGray,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                          const SizedBox(height: 10),
                          ReadOnlyBubbleList(
                            availableOptions: (userData["preferences"] as List<String>?) ?? [],
                            selectedOptions: (userData["selectedPreferences"] as List<String>?) ?? [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
