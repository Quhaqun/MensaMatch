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
import 'package:mensa_match/components/time_picker.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/components/input_textfield.dart';

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
  DateTime date = DateTime.now();
  int starthour = 0;
  int startmin = 0;
  int endhour = 0;
  int endmin = 0;
  List<String> selectedOptions = [];
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
        date = DateTime.now();
        starthour = 0;
        startmin = 0;
        endhour = 0;
        endmin = 0;
        selectedOptions = [];
      });
    } on AppwriteException catch (e) {
      showAlert(title: 'Error', text: e.message.toString());
    }
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
        date = DateTime.now();
        starthour = 0;
        startmin = 0;
        endhour = 0;
        endmin = 0;
        selectedOptions = [];
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      child: BubbleElement(
                                        buttonText: getDateButtonText(date),
                                        onPressed: () async {
                                          DateTime? selectedDateTime =
                                              await showDatePickerDialog(
                                                  context);
                                          if (selectedDateTime != null) {
                                            setState(() {
                                              date = selectedDateTime;
                                            });
                                          } else {
                                            print('User canceled the picker');
                                          }
                                        },
                                        isSelected: false,
                                      ))),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      child: BubbleElement(
                                        buttonText: starthour == 0 &&
                                                startmin == 0
                                            ? 'Start'
                                            : '${formatTime(starthour)}:${formatTime(startmin)}',
                                        onPressed: () async {
                                          TimeOfDay? selectedStartTime =
                                              await showTimePickerDialog(
                                                  context);
                                          if (selectedStartTime != null) {
                                            setState(() {
                                              starthour =
                                                  selectedStartTime.hour;
                                              startmin =
                                                  selectedStartTime.minute;
                                            });
                                          } else {
                                            print('User canceled the picker');
                                          }
                                        },
                                        isSelected: false,
                                      ))),
                              Container(
                                width: 10,
                                height: 2,
                                color: AppColors.textColorGray,
                                margin: const EdgeInsets.only(bottom: 10.0),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: BubbleElement(
                                        buttonText: endhour == 0 && endmin == 0
                                            ? 'End'
                                            : '${formatTime(endhour)}:${formatTime(endmin)}',
                                        onPressed: () async {
                                          TimeOfDay? selectedStartTime =
                                              await showTimePickerDialog(
                                                  context);
                                          if (selectedStartTime != null) {
                                            setState(() {
                                              endhour = selectedStartTime.hour;
                                              endmin = selectedStartTime.minute;
                                            });
                                          } else {
                                            print('User canceled the picker');
                                          }
                                        },
                                        isSelected: false,
                                      ))),
                            ]),
                        // Subtitle
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            'Mensa Selection',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Second Row of ElevatedButtons
                        MultiSelectBubbleList(
                          options: const [
                            'Hardenbergstr.',
                            'Pasteria',
                            'MAR',
                            'Skyline',
                            'Veggie'
                          ],
                          onSelectionChanged: (selectedItems) {
                            setState(() {
                              selectedOptions = selectedItems;
                            });
                          },
                        ),
                        SizedBox(height: 6),
                        // Preferences Section
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            'Preferences',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            'Major',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        input_textfield(
                            controller: major,
                            labelText: "Optional"),
                        Container(
                          child: Text(
                            'Semester',
                            style: GoogleFonts.roboto(
                              color: AppColors.textColorGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        input_textfield(
                            controller: semester,
                            labelText: "Optional"),
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
