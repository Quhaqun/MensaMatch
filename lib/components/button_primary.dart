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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: const Size(double.infinity, 64.0),
          ),
          child: Text(
            buttonText,
            style: GoogleFonts.roboto(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,),
          ),
        ));
  }
}
