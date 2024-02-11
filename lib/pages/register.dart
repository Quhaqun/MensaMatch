import 'package:appwrite/appwrite.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:mensa_match/components/button.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'dart:io';
import 'package:mensa_match/components/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final database = DatabaseAPI();
  XFile? image = null;

  createAccount() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Center(
                        child: CircularProgressIndicator()
                    ),
                  ),
                ]),
          );
        });
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createUser(
        name: nameController.text,
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      await database.createUser(nameController.text, emailTextController.text,
          studyProgramController.text);
      if (image != null) {
        await database.saveimage(image: image!);
      }
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      appwrite.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Account creation failed', text: e.message.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColorLight,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: CustomPaint(
                      painter: WaveBackgroundPainterShort(baseHeight: 160),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PageHeader(
                                title: 'Register',
                                backButton: true,
                                headerHeight: 150),
                            const SizedBox(height: 40),
                            Text(
                              'Create your new account, we are glad you are joining us',
                              style: GoogleFonts.roboto(
                                color: AppColors.textColorGray,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Container(
                                  child: CircularImagePicker(
                                      imageSize: 140,
                                      image: image,
                                      onImageSelected: (selectedImage) {
                                        setState(() {
                                          image = selectedImage;
                                        });
                                      }),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Column(
                                    children: [
                                      input_textfield(
                                          controller: nameController,
                                          labelText: 'Name'),
                                      input_textfield(
                                          controller: studyProgramController,
                                          labelText: 'Study Program'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            input_textfield(
                                controller: emailTextController,
                                labelText: 'Email'),
                            input_textfield(
                                controller: passwordTextController,
                                labelText: 'Password'),
                            input_textfield(
                                controller: repeatPasswordTextController,
                                labelText: 'Repeat Password'),
                            button_primary(
                                buttonText: 'Sign up', onPressed: createAccount)
                          ],
                        ),
                      ),
                    ),
                  )));
        }));
  }
}
