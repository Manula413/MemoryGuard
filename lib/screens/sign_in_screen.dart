import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/form_error.dart';
import '../../screens/forgot_password_screen.dart';
import '../../../components/default_button.dart';
import '../../helper/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  List<String?> errors = [];
  bool circular = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 140),
                Column(
                  children: [
                    Text(
                      "MemoryGuard",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: getRelativeScreenWidth(40),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 140),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: emailFormField(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: passwordFormField(),
                          ),
                          FormError(errors: errors),
                          SizedBox(height: getRelativeScreenHeight(10)),
                          DefaultButton(
                            text: "Login",
                            press: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                KeyboardUtil.hideKeyboard(context);
                                errors = [];
                                setState(() {
                                  circular = true;
                                });
                                try {
                                  UserCredential userCredential =
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  setState(() {
                                    circular = false;
                                  });
                                  DocumentSnapshot userDoc =
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(userCredential.user!.uid)
                                      .get();

                                  if (userDoc.exists) {
                                    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
                                    if (userData['role'] == 'taker') {
                                      Navigator.pushNamed(context, '/map');
                                    } else {
                                      Navigator.pushNamed(context, '/user');
                                    }
                                  } else {
                                    snackBar(scaffoldContext, 'Error fetching user data.');
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    circular = false;
                                  });
                                  if (e.code == 'user-not-found') {
                                    snackBar(scaffoldContext, 'No User Found for this Email.');
                                  } else if (e.code == 'wrong-password') {
                                    snackBar(scaffoldContext, 'Invalid password.');
                                  }
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          circular ? const CircularProgressIndicator() : const Text(''),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(
                              fontSize: getRelativeScreenWidth(16),
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: getRelativeScreenWidth(16),
                                color: Color.fromARGB(255, 41, 124, 233)),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 41, 124, 233),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding passwordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        obscureText: true,
        style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: 'Please Enter your password');
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: "Password",
          hintText: "Enter your password",
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  Padding emailFormField() {
    final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: 'Please Enter your email');
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: 'Please Enter Valid Email');
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: "Email",
          hintText: "Enter email",
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  void snackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
