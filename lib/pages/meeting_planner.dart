import 'package:flutter/material.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:mensa_match/components/popup_match.dart';

class MeetingPlanner extends StatefulWidget {
  const MeetingPlanner({Key? key}) : super(key: key);

  @override
  _MeetingPlannerState createState() => _MeetingPlannerState();
}

class _MeetingPlannerState extends State<MeetingPlanner> {
  final database = DatabaseAPI();
  TextEditingController place = TextEditingController();
  TextEditingController major = TextEditingController();
  TextEditingController semester = TextEditingController();
  int starthour = 0;
  int startmin = 0;
  int endhour = 0;
  int endmin = 0;
  int _flag = 0;
  AuthStatus authStatus = AuthStatus.uninitialized;
  late List<Document>? matches = [];

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    authStatus = appwrite.status;
  }

  void showCustomPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomPopup(title: title, message: message);
      },
    );
  }

  createMatch() async {
    try {
      if (place.text.isEmpty) {
        showCustomPopup('Error', 'Mensa selection cannot be empty!');
        return;
      }
      if (starthour > endhour) {
        showCustomPopup('Error', 'endtime cannot be befor starttime!');
        return;
      } else {
        if (starthour == endhour) {
          if (startmin > endmin) {
            showCustomPopup('Error', 'endtime cannot be befor starttime!');
            return;
          }
        }
      }

      if (major.text.isEmpty) {
        if (semester.text.isEmpty) {
          await database.addMatch(
              place: place.text,
              starthour: starthour,
              startmin: startmin,
              endhour: endhour,
              endmin: endmin);
        } else {
          await database.addMatch(
              place: place.text,
              semester: int.parse(semester.text),
              starthour: starthour,
              startmin: startmin,
              endhour: endhour,
              endmin: endmin);
        }
      } else {
        if (semester.text.isEmpty) {
          await database.addMatch(
              place: place.text,
              major: major.text,
              starthour: starthour,
              startmin: startmin,
              endhour: endhour,
              endmin: endmin);
        } else {
          await database.addMatch(
              place: place.text,
              major: major.text,
              semester: int.parse(semester.text),
              starthour: starthour,
              startmin: startmin,
              endhour: endhour,
              endmin: endmin);
        }
      }

      place.clear();
      major.clear();
      semester.clear();
      setState(() {
        starthour = 0;
        startmin = 0;
        endhour = 0;
        endmin = 0;
        _flag = 0;
      });
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
  }

  bool flag(int num) {
    if (_flag == num) {
      return false;
    }
    return true;
  }

  showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  loadMatches() async {
    try {
      final value = await database.getMatches();
      setState(() {
        matches = value.documents;
      });
    } catch (e) {
      print("Error in loadMatches(): $e");
    }
  }

  searchMatches() async {
    if (place.text.isEmpty) {
      showCustomPopup('Error', 'Mensa selection cannot be empty!');
      return;
    }
    if (starthour > endhour) {
      showCustomPopup('Error', 'endtime cannot be befor starttime!');
      return;
    } else {
      if (starthour == endhour) {
        if (startmin > endmin) {
          showCustomPopup('Error', 'endtime cannot be befor starttime!');
          return;
        }
      }
    }

    final test = await loadMatches();
    int max_score = 0;
    String bestfind = "";
    int starthour_best = 0;
    int startmin_best = 0;

    matches?.forEach((element) {
      int score = 0;
      int starthour_search = element.data.values.elementAt(5);
      int startmin_search = element.data.values.elementAt(6);
      int endhour_search = element.data.values.elementAt(7);
      int endmin_search = element.data.values.elementAt(8);
      String place_search = element.data.values.elementAt(1);
      bool isintime = true;

      if (starthour_search < starthour) {
        if (starthour < endhour_search) {
          starthour_best = starthour;
          startmin_best = startmin;
        } else {
          if (starthour == endhour_search) {
            if (startmin <= endmin_search) {
              starthour_best = starthour;
              startmin_best = startmin;
            } else {
              isintime = false;
            }
          }
          isintime = false;
        }
      } else {
        if (starthour_search <= endhour) {
          starthour_best = starthour_search;
          startmin_best = startmin_search;
        } else {
          isintime = false;
        }
      }

      if (place_search == place) {
        score = score + 1;
      }

      if (score >= max_score && isintime) {
        bestfind = element.$id;
      }
    });

    if (bestfind != "") {
      connectMatch(bestfind, starthour_best, startmin_best);
      showCustomPopup('Match found', 'Your Match is now in the Homepage!');
    } else {
      createMatch();
      showCustomPopup(
          'No Match found', 'Your Match is now in the waiting line!');
    }
  }

  connectMatch(String id, int starthour_best, int startmin_best) async {
    try {
      print("match found");
      final value = await database.updateMatch(
          id: id, starthour: starthour_best, startmin: startmin_best);
      place.clear();
      major.clear();
      semester.clear();
      setState(() {
        starthour = 0;
        startmin = 0;
        endhour = 0;
        endmin = 0;
        _flag = 0;
      });
    } catch (e) {
      print("Error in connectMatch(): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColorLight,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: CustomPaint(
                  painter: WaveBackgroundPainterShort(baseHeight: 160),
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(
                            title: 'Meeting planner',
                            backButton: false,
                            headerHeight: 150,
                            onBackPressed: () {}),
                        const SizedBox(height: 40),
                        Text(
                          'Select Time Frame:',
                          style:
                              TextStyle(fontSize: 17, color: Color(0XFF6D7F94)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hour Dropdown 1
                            DropdownButton<int>(
                              value: starthour,
                              onChanged: (int? newValue) {
                                // Handle Hour Dropdown 1 change
                                setState(() {
                                  starthour = newValue!;
                                });
                              },
                              items: List.generate(25, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              }),
                            ),

                            // Minute Dropdown 1
                            DropdownButton<int>(
                              value: startmin,
                              onChanged: (int? newValue) {
                                // Handle Minute Dropdown 1 change
                                setState(() {
                                  startmin = newValue!;
                                });
                              },
                              items: List.generate(61, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            '-',
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hour Dropdown 2
                            DropdownButton<int>(
                              value: endhour,
                              onChanged: (int? newValue) {
                                // Handle Hour Dropdown 2 change
                                setState(() {
                                  endhour = newValue!;
                                });
                              },
                              items: List.generate(25, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              }),
                            ),

                            // Minute Dropdown 2
                            DropdownButton<int>(
                              value: endmin,
                              onChanged: (int? newValue) {
                                // Handle Minute Dropdown 2 change
                                setState(() {
                                  endmin = newValue!;
                                });
                              },
                              items: List.generate(61, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              }),
                            ),
                          ],
                        ),
                        // Subtitle
                        Container(
                          child: Text(
                            'Mensa selection',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xFF6D7F94)),
                          ),
                        ),
                        SizedBox(height: 16),
                        // First Row of ElevatedButtons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle Button Press

                                setState(() => _flag = 1);
                                place.text = "Hardenbergstraße";
                                print('Hardenbergstraße pressed');
                              },
                              child: Text('Hardenbergstraße'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flag(1) ? null : Colors.greenAccent,
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Handle Button Press
                                setState(() => _flag = 2);
                                place.text = "Pastaria";
                                print('Pastaria pressed');
                              },
                              child: Text('Pastaria'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flag(2) ? null : Colors.greenAccent,
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Handle Button Press
                                setState(() => _flag = 3);
                                place.text = "MAR";
                                print('MAR pressed');
                              },
                              child: Text('MAR'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flag(3) ? null : Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Second Row of ElevatedButtons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle Button Press
                                setState(() => _flag = 4);
                                place.text = "Skyline";
                                print('Skyline pressed');
                              },
                              child: Text('Skyline'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flag(4) ? null : Colors.greenAccent,
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Handle Button Press
                                setState(() => _flag = 5);
                                place.text = "Veggie";
                                print('Veggie pressed');
                              },
                              child: Text('Veggie'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flag(5) ? null : Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Preferences Section
                        Container(
                          child: Text(
                            'Preferences',
                            style: TextStyle(
                                fontSize: 17, color: Color(0XFF6D7F94)),
                          ),
                        ),
                        SizedBox(height: 16),
                        // TextFields for Major and Semester
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 16),
                            SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  "Major",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(
                                        0xFF6D7F94), // Set the text color to #6D7F94
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: major,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      hintText: 'optional',
                                    ),
                                    onChanged: (text) {
                                      print(major.text);
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Semester",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(
                                        0xFF6D7F94), // Set the text color to #6D7F94
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: semester,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      hintText: 'optional',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (text) {
                                      print('Preferred Semester: $semester');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                        // Time Frame Selection
                        SizedBox(height: 16),
                        button_primary(
                            buttonText: 'Plan new meeting',
                            onPressed: () {
                              searchMatches();
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        bottomNavigationBar: MyIconToolbar());
  }
}
