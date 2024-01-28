import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class input_textfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines; // Added for multiline support

  const input_textfield({
    Key? key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1 ? 64 : null, // Adjust height for textarea
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: AppColors.accentColor2, width: 2.0),
          ),
          filled: true,
          fillColor: AppColors.white,
          labelStyle: GoogleFonts.roboto(
            color: AppColors.textColorGray,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
