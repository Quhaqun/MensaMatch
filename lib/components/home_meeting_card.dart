import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/pages/match_popup.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeMeetingCard extends StatelessWidget {
  final XFile? imageUrl;
  final String name;
  final String time;
  final String location;
  final MatchPopupData popupData;

  const HomeMeetingCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.time,
    required this.location,
    required this.popupData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Call the showDialog function to open the popup
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MatchPopup(data: popupData);
            },
          );
        },
        child: Container(
          width: 240,
          margin: EdgeInsets.only(right: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageUrl != null
                          ? !kIsWeb
                          ? Image.file(File(imageUrl!.path)).image
                          : NetworkImage(imageUrl!.path)
                          : NetworkImage("https://static.wikia.nocookie.net/spongebob/images/5/5c/Spongebob-squarepants.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      location,
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorDark,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
