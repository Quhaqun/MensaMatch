import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import '../appwrite/database_api.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/button.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/components/image_picker.dart';
import 'package:mensa_match/constants/interests.dart';

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
    _loadUserProfile();
    ProfilePickLoad();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final AuthAPI appwrite = context.read<AuthAPI>();
      authStatus = appwrite.status;
      appwrite.loadUser();
    });
  }

  ProfilePickLoad() async {
    XFile? image =  await database.loadimage();
    if(image!=null){
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final userData = await database.getCurrentUser();
      print("load userData");
      print(userData["preferences"]);

      setState(() {
        _nameController.text = userData["name"] ?? 'null';
        _emailController.text = userData["email"]  ?? 'null';
        _bioController.text = userData["bio"] ?? 'null';
        _courseController.text = userData["course"] ?? 'null';
        _ageController.text = userData["age"].toString();
        _semesterController.text = userData["semester"].toString();
        _preferencesController.text = userData["preferences"]?.join(', ') ?? [];


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
          if (kDebugMode) {
            print('Invalid age format');
          }
          age = userProfile?.age;
          semester = userProfile?.semester;
        }

        await database.updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          bio: _bioController.text,
          course: _courseController.text,
          age: age,
          preferences: selectedPreferences.join(', '),
          semester: semester,
        );
        database.updateimage(_image!);
        if(_image!=null){
          print("in save not null");
        }

      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
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
                          headerHeight: 150),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          CircularImagePicker(
                              image: _image,
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
                            options: Interests.availableOptions,
                            onSelectionChanged: (onSelectionChanged) {
                              setState(() {
                                selectedPreferences = onSelectionChanged;
                              });
                            },
                          ),
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
