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
    try {
      if (authStatus == AuthStatus.authenticated) {
        await _loadUserProfile(); // Ensure _currentUser is initialized

        /*final updatedAge = int.tryParse(_ageController.text);

        if (updatedAge == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid age format: ${_ageController.text}'),
            ),
          );*/
          return;
        }

        await database.updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          bio: _bioController.text,
          course: _courseController.text,
          age: 20,//updatedAge,
          preferences: _preferencesController.text,
        );

        // After updating, reload the user profile
        await _loadUserProfile();
    }
    catch (e) {
      print('Error updating user profile: $e');
      // Handle error as needed
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
          ElevatedButton(
            onPressed: _updateUserProfile,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}