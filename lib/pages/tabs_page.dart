import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  static const _widgets = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), label: "Messages"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: "Account")
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
       body: Center(
         child: TextButton(
           onPressed: (){
             signOut();
           },
           child: const Text("sign out"),
         ),
       )
    );
  }
}