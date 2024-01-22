import 'package:flutter/material.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:mensa_match/components/page_header.dart';

class MeetingPlanner extends StatelessWidget {
  const MeetingPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColorLight,
        body: CustomPaint(
          painter: WaveBackgroundPainterShort(baseHeight: 160),
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                    title: 'Meeting planner',
                    backButton: false,
                    headerHeight: 150,
                    onBackPressed: () {}),
                const SizedBox(height: 40),
                Text(
                  'Select Time Frame:',
                  style: TextStyle(fontSize: 17, color: Color(0XFF6D7F94)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hour Dropdown 1
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (int? newValue) {
                        // Handle Hour Dropdown 1 change
                        print('Selected Hour 1: $newValue');
                      },
                      items: List.generate(25, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index'),
                        );
                      }),
                    ),

                    // Minute Dropdown 1
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (int? newValue) {
                        // Handle Minute Dropdown 1 change
                        print('Selected Minute 1: $newValue');
                      },
                      items: List.generate(61, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index'),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hour Dropdown 2
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (int? newValue) {
                        // Handle Hour Dropdown 2 change
                        print('Selected Hour 2: $newValue');
                      },
                      items: List.generate(25, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index'),
                        );
                      }),
                    ),

                    // Minute Dropdown 2
                    DropdownButton<int>(
                      value: 0,
                      onChanged: (int? newValue) {
                        // Handle Minute Dropdown 2 change
                        print('Selected Minute 2: $newValue');
                      },
                      items: List.generate(61, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index'),
                        );
                      }),
                    ),
                  ],
                ),
                // Subtitle
                Container(
                  child: Text(
                    'Mensa selection',
                    style: TextStyle(fontSize: 17, color: Color(0xFF6D7F94)),
                  ),
                ),
                SizedBox(height: 16),
                // First Row of ElevatedButtons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Button Press
                        print('Hardenbergstraße pressed');
                      },
                      child: Text('Hardenbergstraße'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Button Press
                        print('Pastaria pressed');
                      },
                      child: Text('Pastaria'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Button Press
                        print('MAR pressed');
                      },
                      child: Text('MAR'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Second Row of ElevatedButtons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Button Press
                        print('Skyline pressed');
                      },
                      child: Text('Skyline'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Button Press
                        print('Veggie pressed');
                      },
                      child: Text('Veggie'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Preferences Section
                Container(
                  child: Text(
                    'Preferences',
                    style: TextStyle(fontSize: 17, color: Color(0XFF6D7F94)),
                  ),
                ),
                SizedBox(height: 16),
                // TextFields for Major and Semester
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 16),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        Text(
                          "Major",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(
                                0xFF6D7F94), // Set the text color to #6D7F94
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: 'optional',
                            ),
                            onChanged: (text) {
                              print('Preferred major: $text');
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Semester",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(
                                0xFF6D7F94), // Set the text color to #6D7F94
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: 'optional',
                            ),
                            onChanged: (text) {
                              print('Preferred Semester: $text');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                // Time Frame Selection
                SizedBox(height: 16),
                button_primary(
                    buttonText: 'Plan new meeting',
                    onPressed: () {
                      print('');
                    })
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyIconToolbar());
  }
}
