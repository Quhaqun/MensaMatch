import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/pages/chat.dart';

class chatOverviewElement extends StatelessWidget {
  final String image;
  final String name;
  final String message_preview;

  const chatOverviewElement(
      {super.key,
      required this.image,
      required this.name,
      required this.message_preview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MessagesPage()));
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
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      color: AppColors.textColorDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      message_preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.dividerGray,
              size: 34.0, 
            ),
          ],
        ),
      ),
    );
  }
}
