import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas_detection/screens/authentication/register_page.dart';
import 'package:gas_detection/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/app_colors.dart';
import '../../widgets/button_style.dar.dart';
import '../../widgets/input_decoration.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController chipID = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loginPressed = false;

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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.8),
                    spreadRadius: 4,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
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
                                  final RegExp emailRegExp =
                                      RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
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
                                final RegExp passwordRegExp =
                                    RegExp(r'^(?=.*[A-Za-z\d])[A-Za-z\d]{6,}$');
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forget Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colours.themeColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      loginPressed = !loginPressed;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: buttonStyle.copyWith(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.black26)),
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
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      loginPressed = !loginPressed;
                                    });
                                    signIn();
                                  },
                                  style: buttonStyle,
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
        ],
      ),
    );
  }

  void signIn() async {
    final formState = formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: chipID.text.toString(),
                password: password.text.toString());
        String uid = userCredential.user!.uid;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('isLoggedIn', true);
        sharedPreferences.setString('uid', uid);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Error: ${error.toString()}"),
          ),
        );
      }
    }
  }
}
