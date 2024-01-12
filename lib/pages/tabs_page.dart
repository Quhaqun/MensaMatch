import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'toolbar.dart';

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
        body: Center(
          child: TextButton(
            onPressed: (){
              signOut();
            },
            child: const Text("sign out"),
          ),
        ),
      bottomNavigationBar: MyIconToolbar(),
    );
  }
}