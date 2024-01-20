import 'package:mensa_match/pages/login.dart';
import 'package:mensa_match/pages/home.dart';
import 'package:mensa_match/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appwrite/auth_api.dart';

void main() {
  // runApp(const MyApp());
  runApp(ChangeNotifierProvider(
      create: ((context) => AuthAPI()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final value = context.watch<AuthAPI>().status;
    print('TOP CHANGE Value changed to: $value!');

    return MaterialApp(
      title: 'Mensa Match',
      debugShowCheckedModeBanner: false,
      home: value == AuthStatus.uninitialized
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : value == AuthStatus.authenticated
              ? const Home()
              : const Home(),
    );
  }
}
