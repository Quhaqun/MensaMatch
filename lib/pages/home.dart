import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/home_meeting_card.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/pages/meeting_planner.dart';
import 'package:mensa_match/constants/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

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
    return Consumer<AuthAPI>(
      builder: (context, authApi, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColorLight,
          body: CustomPaint(
            painter: WaveBackgroundPainterShort(baseHeight: 160),
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'Home',
                    backButton: false,
                    headerHeight: 150,
                    onBackPressed: () {},
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Upcoming Lunch Meetings',
                    style: GoogleFonts.roboto(
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 120.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        HomeMeetingCard(
                          imageUrl: 'https://example.com/image.jpg',
                          name: authApi.currentUser.name,
                          time: '12:00 Uhr',
                          location: 'Skyline Mensa',
                        ),
                        // Add more HomeMeetingCard widgets as needed
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Past Lunch Meetings',
                    style: GoogleFonts.roboto(
                      color: AppColors.textColorGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 120.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Add HomeMeetingCard widgets for past meetings
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 10),
                  button_primary(
                    buttonText: 'Plan new meeting',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeetingPlanner(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          bottomNavigationBar: MyIconToolbar(),
        );
      },
    );
  }
}