import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/toolbar.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/home_meeting_card.dart';
import 'package:mensa_match/components/button.dart';
import 'package:mensa_match/pages/meeting_planner.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/services.dart';
import 'package:mensa_match/pages/match_popup.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mensa_match/appwrite/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:mensa_match/pages/user_profile.dart';

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
  XFile? futurpic = null;

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

  Future<List<Object>> loadProfilAsync(String found_id) async{
    //print("found_id: $found_id");
    XFile? mom = await database.loadimage(pic_id: found_id);

    UserProfile? profil_return = await database.getUserProfile(searchid: found_id);

    if(mom==null){
      return [profil_return!];
    }
    return [profil_return!, mom];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                    child: CustomPaint(
                  painter: WaveBackgroundPainterShort(baseHeight: 160),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageHeader(
                              title: 'Home',
                              backButton: false,
                              headerHeight: 150),
                          const SizedBox(height: 40),
                          Text(
                            'Upcoming Lunch Meetings',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: matches?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                Document match = matches![index];
                                String found_id = "";
                                if (database.auth.userid == match.data['user_id']) {
                                  found_id = match.data['matcher_id'];
                                } else {
                                  found_id = match.data['user_id'];
                                }

                                return FutureBuilder<List<Object>>(
                                  future: loadProfilAsync(found_id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        DateTime now = DateTime.now();
                                        DateTime dateTime = DateTime.parse(match.data['Date']);
                                        if(dateTime.year > now.year || (dateTime.year == now.year && (dateTime.month > now.month || (dateTime.month == now.month && (dateTime.day > now.day || (dateTime.day == now.day && (match.data['Endhour'] > now.hour || (match.data['Endhour'] == now.hour && match.data['Endmin'] > now.minute)))))))){
                                          UserProfile found_profil = snapshot.data!.first as UserProfile;
                                          return HomeMeetingCard(
                                            imageUrl: snapshot.data!.length<2 ? null : snapshot.data!.elementAt(1) as XFile, // Update with the correct index for imageUrl
                                            name: found_profil.name, // Update with the correct index for name
                                            time:'${match.data['Starthour']}:${match.data['Startmin']} Uhr', // Assuming the data structure contains hour and minute fields
                                            location: match.data.values.elementAt(1),
                                            popupData: MatchPopupData(
                                                doc_id: match.$id,
                                                match_id: found_id,
                                                image: snapshot.data!.length<2 ? null : snapshot.data!.elementAt(1) as XFile,
                                                name: found_profil.name,
                                                age: found_profil.age,
                                                major: found_profil.course,
                                                semester: found_profil.semester,
                                                date: 'Today',
                                                time: '${match.data['Starthour']}:${match.data['Startmin']} Uhr',
                                                location: match.data['Place']),
                                          );
                                        }else{
                                          return Container();
                                        }
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                    }
                                    // By default, show a loading spinner
                                    return CircularProgressIndicator();
                                  },
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
                          SizedBox(
                            height: 120.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: matches?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                Document match = matches![index];
                                String found_id = "";
                                if (database.auth.userid == match.data['user_id']) {
                                  found_id = match.data['matcher_id'];
                                } else {
                                  found_id = match.data['user_id'];
                                }

                                return FutureBuilder<List<Object>>(
                                  future: loadProfilAsync(found_id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        DateTime now = DateTime.now();
                                        DateTime dateTime = DateTime.parse(match.data['Date']);
                                        if(!(dateTime.year > now.year || (dateTime.year == now.year && (dateTime.month > now.month || (dateTime.month == now.month && (dateTime.day > now.day || (dateTime.day == now.day && (match.data['Endhour'] > now.hour || (match.data['Endhour'] == now.hour && match.data['Endmin'] > now.minute))))))))){
                                          UserProfile found_profil = snapshot.data!.first as UserProfile;
                                          return HomeMeetingCard(
                                            imageUrl: snapshot.data!.length<2 ? null : snapshot.data!.elementAt(1) as XFile, // Update with the correct index for imageUrl
                                            name: found_profil.name, // Update with the correct index for name
                                            time:'${match.data['Starthour']}:${match.data['Startmin']} Uhr', // Assuming the data structure contains hour and minute fields
                                            location: match.data.values.elementAt(1),
                                            popupData: MatchPopupData(
                                                doc_id: match.$id,
                                                match_id: found_id,
                                                image: snapshot.data!.length<2 ? null : snapshot.data!.elementAt(1) as XFile,
                                                name: found_profil.name,
                                                age: found_profil.age,
                                                major: found_profil.course,
                                                semester: found_profil.semester,
                                                date: 'Today',
                                                time: '${match.data['Starthour']}:${match.data['Startmin']} Uhr',
                                                location: match.data['Place']), // Update with the correct index for location
                                          );
                                        }else{
                                          return Container();
                                        }
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                    }
                                    // By default, show a loading spinner
                                    return CircularProgressIndicator();
                                  },
                                );
                              },
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
                                        builder: (context) =>
                                            const MeetingPlanner()));
                              }),
                          const SizedBox(height: 10),
                        ]),
                  ),
                ))));
      }),
      bottomNavigationBar: const MyIconToolbar(),
    );
  }
}
