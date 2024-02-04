import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/pages/chat.dart';
import 'package:mensa_match/pages/chat_overview.dart';

class MatchPopupData {
  final String image;
  final String name;
  final int age;
  final String major;
  final int semester;
  final String date;
  final String time;
  final String location;

  MatchPopupData(
      {required this.image,
      required this.name,
      required this.age,
      required this.major,
      required this.semester,
      required this.date,
      required this.time,
      required this.location});
}

class MatchPopup extends StatelessWidget {
  final MatchPopupData data;

  const MatchPopup({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              //minHeight: constraints.maxHeight,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: AppColors.textColorGray,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                        child: Center(
                          child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Match',
                          style: GoogleFonts.roboto(
                            color: AppColors.accentColor1,
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                          ),
                        ),
                        SizedBox(height: 16),
                        ClipOval(
                          child: Image.network(
                            data.image,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${data.name}, ${data.age}',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          data.major,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${getSemesterString(data.semester)} Semester',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.8 -
                              2 * 20.0, // Subtracting left and right padding,
                          color: AppColors.textColorGray,
                        ),
                        SizedBox(height: 16),
                        Text(
                          data.date,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          data.time,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          data.location,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.8 -
                              2 * 20.0, // Subtracting left and right padding,
                          color: AppColors.textColorGray,
                        ),
                        SizedBox(height: 16),
                        button_primary(
                            buttonText: 'Chat',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagesPage()));
                            }),
                        button_outline(
                            buttonText: 'Cancel Meeting',
                            color: AppColors.dangerColor,
                            onPressed: () {}),
                        SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}


String getSemesterString(int semester) {
  if (semester >= 11 && semester <= 13) {
    return '$semester' 'th';
  }

  switch (semester % 10) {
    case 1:
      return '$semester' 'st';
    case 2:
      return '$semester' 'nd';
    case 3:
      return '$semester' 'rd';
    default:
      return '$semester' 'th';
  }
}