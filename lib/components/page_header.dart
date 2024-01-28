import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool backButton;
  final double headerHeight;

  const PageHeader({
    super.key,
    required this.title,
    required this.backButton,
    required this.headerHeight,
  });

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
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      size: 30.0,
                      color: AppColors.white,
                    ),
                    Text(
                      'Back',
                      style: GoogleFonts.roboto(
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),
                  ],
                )),
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
