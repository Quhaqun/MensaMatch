import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'values/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'values/app_constants.dart';
import 'values/app_routes.dart';

import 'package:provider/provider.dart';
import 'package:mensa_match/appwrite/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
    (_) => runApp(ChangeNotifierProvider(
        create: ((context) => AuthAPI()), child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>().status;
    print('TOP CHANGE Value changed to: $value!');

    Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mensa Match',
      theme: AppTheme.themeData,
      initialRoute: AppRoutes.loginScreen,
      navigatorKey: AppConstants.navigationKey,
      routes: {
        AppRoutes.loginScreen: (context) => const LoginPage(),
        AppRoutes.registerScreen: (context) => const RegisterPage(),
      },
    );
  }
}
