import 'package:appwrite/appwrite.dart';
import 'package:mensa_match/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:mensa_match/components/button_primary.dart';
import 'package:mensa_match/components/input_textfield.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mensa_match/appwrite/database_api.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/pages/home.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'dart:io';
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
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(),
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
      await database.createUser(nameController.text, emailTextController.text, studyProgramController.text);
      if(image!=null){
        await database.saveimage(image: image!);
      }
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      appwrite.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
        body: SingleChildScrollView(
            child: CustomPaint(
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
                                builder: (context) => const LoginPage()));
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
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: image !=null  ? !kIsWeb ? Image.file(File(image!.path)).image: NetworkImage(image!.path) : NetworkImage("https://static.wikia.nocookie.net/spongebob/images/5/5c/Spongebob-squarepants.png"),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: ()  async{
                        final ImagePicker picker =  ImagePicker();
                        XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            image = pickedImage;
                          });
                        };
                    },
                    child: Text('Pick an image'),
                  ),
                  input_textfield(
                      controller: nameController, labelText: 'Name'),
                  input_textfield(
                      controller: studyProgramController,
                      labelText: 'Study Program'),
                  input_textfield(
                      controller: emailTextController, labelText: 'Email'),
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
  }
}
