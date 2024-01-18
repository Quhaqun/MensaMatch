import 'package:flutter/material.dart';
import 'package:mensa_match/pages/tabs_page.dart';
import 'package:mensa_match/pages/chat_screen.dart';

class MyIconToolbar extends StatefulWidget {
  const MyIconToolbar({Key? key}) : super(key: key);

  @override
  _MyIconToolbarState createState() => _MyIconToolbarState();
}


class _MyIconToolbarState extends State<MyIconToolbar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: _selectedIndex, //New
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    switch(index){
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TabsPage()
            )
        );
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessagesPage()
            )
        );
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}