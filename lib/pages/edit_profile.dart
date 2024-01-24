import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart'; // Stelle sicher, dass der richtige Pfad importiert wird
import 'package:provider/provider.dart';

import '../appwrite/database_api.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Hier könntest du die aktuellen Benutzerdaten in die Controller setzen
    _nameController.text = context.read<AuthAPI>().currentUser.name ?? '';
    _emailController.text = context.read<AuthAPI>().currentUser.email ?? '';
    //_bioController.text = context.read<AuthAPI>().currentUser.prefs?['bio'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            //SizedBox(height: 16.0),
            //TextField(
            //  controller: _emailController,
            //  decoration: InputDecoration(labelText: 'E-Mail'),
            //),
            SizedBox(height: 16.0),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Biografie'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthAPI>().updateProfile(
                  new_name: _nameController.text,
                  //new_email: _emailController.text,
                  new_bio: _bioController.text
                );
                Navigator.pop(context); // Zurück zur vorherigen Seite
              },
              child: Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}