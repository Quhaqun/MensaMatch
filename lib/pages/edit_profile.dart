import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import '../appwrite/database_api.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/components/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final DatabaseAPI database = DatabaseAPI();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;
  late final TextEditingController _courseController;
  late final TextEditingController _ageController;
  late final TextEditingController _preferencesController;
  late final TextEditingController _semesterController;
  List<String> selectedPreferences = [];
  XFile? _image = null;

  AuthStatus authStatus = AuthStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _courseController = TextEditingController();
    _ageController = TextEditingController();
    _preferencesController = TextEditingController();
    _semesterController = TextEditingController();
    //_initProfile();
    _loadUserProfile(); // Call _loadUserProfile here directly

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final AuthAPI appwrite = context.read<AuthAPI>();
      authStatus = appwrite.status;
      appwrite.loadUser();
    });
  }


  Future<void> _initProfile() async {
    try {
      final userData = await database.getCurrentUser();
      print("userData");
      print(userData);

      setState(() {
        _nameController.text = userData["name"] ?? '';
        _emailController.text = userData["email"]  ?? '';
        _bioController.text = userData["bio"] ?? '';
        _courseController.text = userData["course"] ?? '';
        _ageController.text = userData["age"].toString() ?? '';
        _preferencesController.text = userData["preferences"] ?? '';
        _semesterController.text = userData["semester"] ?? '';
      });
    } catch (e) {
      print('Error fetching user profile: $e $authStatus');
      // Handle error as needed
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final userData = await database.getCurrentUser();
      print("userData");
      print(userData);

      setState(() {
        _nameController.text = userData["name"] ?? '';
        _emailController.text = userData["email"]  ?? '';
        _bioController.text = userData["bio"] ?? '';
        _courseController.text = userData["course"] ?? '';
        _ageController.text = userData["age"].toString() ?? '';
        _preferencesController.text = userData["preferences"] ?? '';
        _semesterController.text = userData["semester"] ?? '';
      });
    } catch (e) {
      print('Error fetching user profile: $e $authStatus');
      // Handle error as needed
    }
  }

  Future<void> _updateUserProfile() async {
    final userProfile = await database.getUserProfile();
    try {
      if (authStatus == AuthStatus.authenticated) {
        // Parse age from text to int, handle invalid input gracefully
        int? age;
        int? semester;
        try {
          semester = _semesterController.text.isNotEmpty ? int.parse(_semesterController.text) : null;
          age = _ageController.text.isNotEmpty ? int.parse(_ageController.text) : null;
        } catch (e) {
          print('Invalid age format');
          // Handle the error or provide a default value for age
          // For example, you can set age to a default value like 0
          age = userProfile?.age;
          semester = userProfile?.semester;
        }

        await database.updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          bio: _bioController.text,
          course: _courseController.text,
          age: age,
          preferences: _preferencesController.text,
          semester: semester
        );
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Handle error as needed
    }
  }

    Widget _buildEditableTextField(
        String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
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
              child: CustomPaint(
                painter: WaveBackgroundPainterShort(baseHeight: 160),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(
                          title: 'Edit Profile',
                          backButton: true,
                          headerHeight: 150, onBackPressed: () {},),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          CircularImagePicker(
                              overlayText: 'Edit',
                              onImageSelected: (selectedImage) {
                                setState(() {
                                  _image = selectedImage;
                                });
                              }),
                          const SizedBox(height: 20),
                          input_textfield(
                              controller: _nameController, labelText: 'Name'),
                          input_textfield(
                              controller: _emailController, labelText: 'Email'),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 4.0),
                                    child: input_textfield(
                                        controller: _ageController,
                                        labelText: 'Age'),
                                  )),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 4.0),
                                    child: input_textfield(
                                        controller: _semesterController,
                                        labelText: 'Semester'),
                                  ))
                            ],
                          ),
                          input_textfield(
                              controller: _courseController,
                              labelText: 'Major'),
                          input_textfield(
                              controller: _bioController,
                              labelText: 'Bio',
                              maxLines: 4),
                          const SizedBox(height: 20),
                          MultiSelectBubbleList(
                              options: const [
                                'Tennis',
                                'Gym',
                                'Programming',
                                'Dogs',
                                'Photography',
                                'Nature',
                                'Travelling',
                                'Cooking',
                                'Environmentalism'
                              ],
                              onSelectionChanged: (onSelectionChanged) {
                                selectedPreferences = onSelectionChanged;
                              }),
                          const SizedBox(height: 10),
                          button_primary(
                              buttonText: 'Save',
                              onPressed: _updateUserProfile),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
