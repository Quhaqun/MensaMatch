import 'package:flutter/material.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMeetingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String time;
  final String location;

  const HomeMeetingCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.time,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      height: 120.0,
      margin: EdgeInsets.only(right: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
