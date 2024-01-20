import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/toolbar.dart';

class MeetingPlanner extends StatelessWidget {
  const MeetingPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: CustomPaint(
        painter: WaveBackgroundPainter(),
        child: const Text('Meeting Planner'),
      ),
      bottomNavigationBar: const MyIconToolbar(),
    );
  }
}
