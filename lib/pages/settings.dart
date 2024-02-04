import 'package:flutter/material.dart';

import 'package:mensa_match/components/settings_entry.dart';
import 'package:mensa_match/components/settings_social_entry.dart';
import 'package:mensa_match/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';

import 'package:provider/provider.dart';
import 'package:mensa_match/appwrite/auth_api.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: CustomPaint(
              painter: WaveBackgroundPainterShort(baseHeight: 160),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(
                        title: 'Settings',
                        backButton: false,
                        headerHeight: 180,
                      ),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      SettingsBox(
                        title: 'Account',
                        icon: Icons.account_circle,
                        color: const Color(0xFFFF2929),
                        onTap: () {
                          // Aktion für Account-Einstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Privacy & Security',
                        icon: Icons.lock,
                        color: const Color(0xFF11A917),
                        onTap: () {
                          // Aktion für Datenschutz- und Sicherheitseinstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Language',
                        icon: Icons.language,
                        color: const Color(0xFFFFA800),
                        onTap: () {
                          // Aktion für Spracheinstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Notifications',
                        icon: Icons.notifications,
                        color: const Color(0xFFFF5C00),
                        onTap: () {
                          // Aktion für Benachrichtigungseinstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Feedback',
                        icon: Icons.feedback,
                        color: const Color(0xFF00A3FF),
                        onTap: () {
                          // Aktion für Feedback-Einstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Help',
                        icon: Icons.help,
                        color: const Color(0xFF7D7D7D),
                        onTap: () {
                          // Aktion für Hilfeeinstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Sign Out',
                        icon: Icons.exit_to_app,
                        color: const Color(0xFFFF2929),
                        onTap: () {
                          // Aktion für Hilfeeinstellungen
                          final AuthAPI appwrite = context.read<AuthAPI>();
                          appwrite.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Follow Us!',
                        style: GoogleFonts.roboto(
                          color: AppColors.textColorGray,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),
                      SettingsBox(
                        title: 'Instagram',
                        icon: Icons.camera_alt,
                        color: const Color(0xFFFF5C00),
                        onTap: () {
                          // Aktion für Benachrichtigungseinstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'Facebook',
                        icon: Icons.face,
                        color: const Color(0xFF00A3FF),
                        onTap: () {
                          // Aktion für Feedback-Einstellungen
                        },
                      ),
                      SettingsBox(
                        title: 'X',
                        icon: Icons.whatshot,
                        color: const Color(0xFF7D7D7D),
                        onTap: () {
                          // Aktion für Hilfeeinstellungen
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: const MyIconToolbar(),
    );
  }
}

Widget _buildSearchBar() {
  return Container(
    height: 40, // Set the height of the search bar
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: AppColors.cardColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const TextField(
      // controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(vertical: 9), // Adjust vertical padding
          child: Icon(
            Icons.search,
            color:
                AppColors.textColorGray, // Change the color of the search icon
          ),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 8), // Set to 0
      ),
    ),
  );
}
