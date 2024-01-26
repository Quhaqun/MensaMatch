import 'package:appwrite/appwrite.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/pages/home.dart';
import 'package:mensa_match/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading = false;

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                ]),
          );
        });

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home())
      );
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  signInWithProvider(String provider) {
    try {
      context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: CustomPaint(
        painter: WaveBackgroundPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Text(
                        "[M]",
                        style: TextStyle(fontSize: 78),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'MensaMatch',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Email textfield
                input_textfield(
                    controller: emailTextController, labelText: "Email"),
                // Password textfield
                input_textfield(
                    controller: passwordTextController, labelText: "Password"),
                // Sign In button
                button_primary(buttonText: "Sign In", onPressed: signIn),
                // OR
                Center(
                  child: Text(
                    "or",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColorGray,
                    ),
                  ),
                ),
                // Register textfield
                button_primary(
                    buttonText: "Register",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}