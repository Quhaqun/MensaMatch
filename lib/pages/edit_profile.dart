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
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;
  late final TextEditingController _courseController;
  late final TextEditingController _ageController;
  late final TextEditingController _preferencesController;
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

    _loadUserProfile(); // Call _loadUserProfile here directly

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final AuthAPI appwrite = context.read<AuthAPI>();
      authStatus = appwrite.status;
      appwrite.loadUser();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await database.getUserProfile();
      print(userProfile?.user_id);

      setState(() {
        _nameController.text = userProfile?.name ?? '';
        _emailController.text = userProfile?.email ?? '';
        _bioController.text = userProfile?.bio ?? '';
        _courseController.text = userProfile?.course ?? '';
        _ageController.text = userProfile?.age?.toString() ?? '';
        _preferencesController.text = userProfile?.preferences ?? '';
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
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Handle error as needed
    } finally {
      // Move _loadUserProfile outside of the try-catch block to ensure it always gets called
      await _loadUserProfile();
    }
  }

  Widget _buildEditableTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          _buildEditableTextField('Name', _nameController),
          _buildEditableTextField('Email', _emailController),
          _buildEditableTextField('Bio', _bioController),
          _buildEditableTextField('Course', _courseController),
          _buildEditableTextField('Age', _ageController),
          _buildEditableTextField('Preferences', _preferencesController),
          ElevatedButton(
            onPressed: _updateUserProfile,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
