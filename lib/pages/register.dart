import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final repeatPasswordTextController = TextEditingController();
  final nameController = TextEditingController();
  final studyProgramController = TextEditingController();

  bool isLoading = false;

  Future<void> createAccount() async {
    try {
      showLoadingDialog();
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createUser(
        name: nameController.text,
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      await createUserInDatabase();
      hideLoadingDialog();
      showSnackBar('Account created!');
    } on AppwriteException catch (e) {
      hideLoadingDialog();
      showAlert(title: 'Account creation failed', text: e.message.toString());
    } finally {
      hideLoadingDialog();
    }
  }

  Future<void> createUserInDatabase() async {
    final DatabaseAPI database = DatabaseAPI();
    await database.createUser();
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 34),
                  ),
                ),
                const SizedBox(height: 2),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create your new account, we are glad you are joining us',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                  },
                  child: Text('Pick an image'),
                ),
                input_textfield(
                  controller: nameController,
                  labelText: 'Name',
                ),
                input_textfield(
                  controller: studyProgramController,
                  labelText: 'Study Program',
                ),
                input_textfield(
                  controller: emailTextController,
                  labelText: 'Email',
                ),
                input_textfield(
                  controller: passwordTextController,
                  labelText: 'Password',
                ),
                input_textfield(
                  controller: repeatPasswordTextController,
                  labelText: 'Repeat Password',
                ),
                button_primary(
                  buttonText: 'Sign up',
                  onPressed: createAccount,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}