import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/toolbar.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/home_meeting_card.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/pages/meeting_planner.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/services.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:flutter/widgets.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  late List<Document>? matches = [];
  final database = DatabaseAPI();
  AuthStatus authStatus = AuthStatus.uninitialized;

  static const _widgets = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
    loadFoundMatches();
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  loadFoundMatches() async {
    try {
      final value = await database.getFoundMatches();
      setState(() {
        matches = value.documents;
      });
    } catch (e) {
      print("Error in loadFoundMatches(): $e");
    }
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
              SizedBox(height: 12),
              Container(
                height: 120.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: matches?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Document match = matches![index];
                    return HomeMeetingCard(
                      imageUrl: "https://static.wikia.nocookie.net/spongebob/images/5/5c/Spongebob-squarepants.png", // Update with the correct index for imageUrl
                      name: match.data.values.elementAt(0), // Update with the correct index for name
                      time: '${match.data.values.elementAt(5)}:${match.data.values.elementAt(6)} Uhr', // Assuming the data structure contains hour and minute fields
                      location: match.data.values.elementAt(1), // Update with the correct index for location
                    );
                  },
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
                    HomeMeetingCard(
                        imageUrl:
                            'https://hackspirit.com/wp-content/uploads/2021/06/Copy-of-Rustic-Female-Teen-Magazine-Cover.jpg',
                        name: 'Lara',
                        time: '12:00 Uhr',
                        location: 'Skyline Mensa'),
                    HomeMeetingCard(
                        imageUrl:
                            'https://hackspirit.com/wp-content/uploads/2021/06/Copy-of-Rustic-Female-Teen-Magazine-Cover.jpg',
                        name: 'Lara',
                        time: '12:00 Uhr',
                        location: 'Skyline Mensa'),
                    HomeMeetingCard(
                        imageUrl:
                            'https://hackspirit.com/wp-content/uploads/2021/06/Copy-of-Rustic-Female-Teen-Magazine-Cover.jpg',
                        name: 'Lara',
                        time: '12:00 Uhr',
                        location: 'Skyline Mensa')
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
                            builder: (context) => const MeetingPlanner()));
                  }),
              const SizedBox(height: 10),
            ]),
          )),
      bottomNavigationBar: MyIconToolbar(),
    );
  }
}
