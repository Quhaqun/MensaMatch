import 'package:flutter/material.dart';
import 'package:mensa_match/pages/home.dart';
import 'package:mensa_match/pages/chat.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/pages/meeting_planner.dart';
import 'package:mensa_match/pages/settings.dart';
import 'package:mensa_match/pages/profile_view.dart';

class MyIconToolbar extends StatefulWidget {
  const MyIconToolbar({Key? key}) : super(key: key);

  @override
  _MyIconToolbarState createState() => _MyIconToolbarState();
}

class _MyIconToolbarState extends State<MyIconToolbar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: AppColors.backgroundColor, width: 1.0))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined), label: "Chat"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_sharp), label: "New Meeting"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textColorGray,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          selectedIconTheme: IconThemeData(size: 30.0),
          unselectedIconTheme: IconThemeData(size: 30.0),
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MessagesPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MeetingPlanner()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Settings()));
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
