import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool backButton;
  final double headerHeight;
  final Function onBackPressed;

  const PageHeader(
      {super.key,
      required this.title,
      required this.backButton,
      required this.headerHeight,
      required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (backButton)
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: onBackPressed(),
            ),
          if (backButton) const SizedBox(height: 16.0),
          Text(
            title,
            style: GoogleFonts.roboto(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 48,
            ),
          ),
        ],
      ),
    );
  }
}
