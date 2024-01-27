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
            age: int.parse(_ageController.text), // Parse age from text to int
            preferences: _preferencesController.text);
        print("2.3");
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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
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
            ),
          ),
        );
      }),
    );
  }
}
