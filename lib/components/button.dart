// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class button_primary extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const button_primary(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.accentColor1),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 64.0)),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          buttonText,
          style: GoogleFonts.roboto(
            color: AppColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class button_outline extends StatelessWidget {
  final String buttonText;
  final Color color;
  final Function onPressed;

  const button_outline(
      {super.key, 
      required this.buttonText, 
      required this.color, 
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: color),
            ),
          ),
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 64.0)),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          buttonText,
          style: GoogleFonts.roboto(
            color: color,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
