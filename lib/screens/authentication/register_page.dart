import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/app_colors.dart';
import '../../widgets/button_style.dar.dart';
import '../../widgets/input_decoration.dart';
import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController chipID = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool loginPressed = false;
  bool isRegistering = false;

  @override
  void dispose() {
    chipID.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black26,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Gas Detection System',
            style: TextStyle(
              color: Colours.fontColor2,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.7),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(1, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colours.fontColor2,
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: SizedBox(
                                width: 290,
                                height: loginPressed ? 70 : 50,
                                child: TextFormField(
                                  controller: chipID,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  decoration: inputDecoration("Email"),
                                  validator: (value) {
                                    final RegExp emailRegExp = RegExp(
                                        r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email address';
                                    } else if (!emailRegExp.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            SizedBox(
                              width: 290,
                              height: loginPressed ? 70 : 50,
                              child: TextFormField(
                                obscureText: true,
                                controller: password,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                decoration: inputDecoration("Password"),
                                validator: (value) {
                                  final RegExp passwordRegExp = RegExp(
                                      r'^(?=.*[A-Za-z\d])[A-Za-z\d]{6,}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (!passwordRegExp.hasMatch(value)) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 290,
                              height: loginPressed ? 70 : 50,
                              child: TextFormField(
                                obscureText: true,
                                controller: confirmPassword,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                decoration: inputDecoration("Confirm Password"),
                                validator: (value) {
                                  if (value != password.text) {
                                    return 'The Password Doesn\'t match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LogInScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Back To Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colours.themeColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    loginPressed = !loginPressed;
                                  });
                                  Navigator.pushNamed(
                                      context, 'register_screen');
                                },
                                style: buttonStyle,
                                child: const Text(
                                  "SignUp",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void registerUser() {
    if (formKey.currentState!.validate()) {
      setState(() {
        loginPressed = true;
        isRegistering = true;
      });
      // Register user with email and password
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: chipID.text, password: password.text)
          .then((authResult) async {
        // Save user details to Firestore
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('uid', authResult.user!.uid);

        // Navigate to the Questionnaire Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LogInScreen(),
          ),
        );
      }).catchError((error) {
        // Display registration error using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Error: ${error.toString()}"),
          ),
        );
      }).whenComplete(() {
        setState(() {
          isRegistering = false;
        });
      });
    }
  }
}
