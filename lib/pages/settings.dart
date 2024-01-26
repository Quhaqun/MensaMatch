import 'package:flutter/material.dart';

import 'package:mensa_match/components/settings_entry.dart';
import 'package:mensa_match/components/settings_social_entry.dart';

import 'package:provider/provider.dart';
import 'package:mensa_match/appwrite/auth_api.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Einstellungen'),
        ),
        body: SingleChildScrollView(child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SettingsBox(
                title: 'Account',
                icon: Icons.account_circle,
                onTap: () {
                  // Aktion für Account-Einstellungen
                },
              ),
              SettingsBox(
                title: 'Privacy & Security',
                icon: Icons.lock,
                onTap: () {
                  // Aktion für Datenschutz- und Sicherheitseinstellungen
                },
              ),
              SettingsBox(
                title: 'Language',
                icon: Icons.language,
                onTap: () {
                  // Aktion für Spracheinstellungen
                },
              ),
              SettingsBox(
                title: 'Notifications',
                icon: Icons.notifications,
                onTap: () {
                  // Aktion für Benachrichtigungseinstellungen
                },
              ),
              SettingsBox(
                title: 'Feedback',
                icon: Icons.feedback,
                onTap: () {
                  // Aktion für Feedback-Einstellungen
                },
              ),
              SettingsBox(
                title: 'Help',
                icon: Icons.help,
                onTap: () {
                  // Aktion für Hilfeeinstellungen
                },
              ),
              SettingsBox(
                title: 'Sign Out',
                icon: Icons.help,
                onTap: () {
                  // Aktion für Hilfeeinstellungen
                  final AuthAPI appwrite = context.read<AuthAPI>();
                  appwrite.signOut();
                },
              ),
              SizedBox(height: 16),
              const Text(
                'Follow Us:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const FollowUsBox(
                title: 'Instagram',
                link: 'https://www.instagram.com/',
                icon: Icons.camera_alt,
              ),
              const FollowUsBox(
                title: 'Facebook',
                link: 'https://www.facebook.com/',
                icon: Icons.face,
              ),
              const FollowUsBox(
                title: 'X',
                link: 'https://www.example.com/',
                icon: Icons.clear, // Icons.clear als Platzhalter für "X"
              ),
            ],
          ),
        ),
        ));
  }
}