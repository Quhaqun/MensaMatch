import 'package:mensa_match/pages/chat.dart';
import 'package:mensa_match/pages/login.dart';
import 'package:mensa_match/pages/home.dart';
import 'package:mensa_match/pages/settings.dart';
import 'package:mensa_match/pages/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mensa_match/constants/colors.dart';

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
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: AppColors.primaryColor,
          secondary: AppColors.accentColor1,
          surface: AppColors.cardColor,
          background: AppColors.backgroundColorLight,
          error: AppColors.dangerColor,
          onPrimary: AppColors.accentColor1,
          onSecondary: AppColors.accentColor2,
          onSurface: AppColors.accentColor1,
          onBackground: AppColors.textColorDark,
          onError: AppColors.white,
          brightness: Brightness.light,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryColor,
        ),
      ),
      title: 'Mensa Match',
      debugShowCheckedModeBanner: false,
      home: value == AuthStatus.uninitialized
          ? const Scaffold(
        body: SizedBox(
          height: 50.0,
          width: 50.0,
          child: Center(
              child: CircularProgressIndicator()
          ),
        ),
      )
          : value == AuthStatus.authenticated
          ? const Home()
          : const LoginPage(),
    );
  }
}
