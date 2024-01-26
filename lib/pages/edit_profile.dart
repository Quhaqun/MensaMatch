import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import '../appwrite/database_api.dart';
import 'package:mensa_match/pages/user_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final DatabaseAPI database = DatabaseAPI();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  AuthStatus authStatus = AuthStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final AuthAPI appwrite = context.read<AuthAPI>();
      authStatus = appwrite.status;
      appwrite.loadUser();
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      print("1");
      final userProfile = await database.getUserProfile();
      print("2");
      print(userProfile?.user_id);
      setState(() {
        _nameController.text = userProfile!.name;
        _emailController.text = userProfile.email;
        _bioController.text = userProfile.bio;
        _courseController.text = userProfile.course;
        _ageController.text = userProfile.age.toString();
        _preferencesController.text = userProfile.preferences;
      });
    } catch (e) {
      print('Error fetching user profile: $e $authStatus');
      // Handle error as needed
    }
  }

  Future<void> _updateUserProfile() async {
    final userProfile = await database.getUserProfile();
    try {
      print("2.05");
      if (authStatus == AuthStatus.authenticated) {
        print("2.1");
        // Removed redundant _loadUserProfile()
        print("2.2");

        // Parse age from text to int, handle invalid input gracefully
        int? age;
        try {
          age = _ageController.text.isNotEmpty ? int.parse(_ageController.text) : null;
        } catch (e) {
          print('Invalid age format');
          // Handle the error or provide a default value for age
          // For example, you can set age to a default value like 0
          age = userProfile?.age;
        }

        await database.updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          bio: _bioController.text,
          course: _courseController.text,
          age: age,
          preferences: _preferencesController.text,
        );

        print("2.3");
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Handle error as needed
    } finally {
      // Move _loadUserProfile outside of the try-catch block to ensure it always gets called
      await _loadUserProfile();
      print("2.4");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          // Your existing TextFields and UI components
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _bioController,
            decoration: InputDecoration(labelText: 'Bio'),
          ),
          TextField(
            controller: _courseController,
            decoration: InputDecoration(labelText: 'Course'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
          ),
          TextField(
            controller: _preferencesController,
            decoration: InputDecoration(labelText: 'Preferences'),
          ),
          ElevatedButton(
            onPressed: _updateUserProfile,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}