import 'package:flutter/material.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/components/toolbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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