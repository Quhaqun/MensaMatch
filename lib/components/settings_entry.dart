import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsBox extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;

  const SettingsBox({
    Key? key,
    required this.title,
    required this.onTap,
    this.icon, 
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.textColorAccent,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: color
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  color: AppColors.textColorDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.dividerGray,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
