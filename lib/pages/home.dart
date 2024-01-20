import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/toolbar.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const _widgets = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: CustomPaint(
          painter: WaveBackgroundPainterShort(baseHeight: 160),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PageHeader(
                  title: 'Home',
                  backButton: false,
                  headerHeight: 150,
                  onBackPressed: () {}),
              const SizedBox(height: 40),
              Text(
                'Upcoming Lunch Meetings',
                style: GoogleFonts.roboto(
                  color: AppColors.textColorGray,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ]),
          )),
      bottomNavigationBar: MyIconToolbar(),
    );
  }
}
