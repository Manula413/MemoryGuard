import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dementia_care/components/default_button.dart';
import 'package:dementia_care/components/snackbar.dart';
import 'package:dementia_care/helper/enums.dart';
import 'package:dementia_care/helper/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/coustom_bottom_nav_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkxController = TextEditingController();
  final checkyController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: const Color.fromARGB(48, 0, 0, 0),
          centerTitle: true,
          title: const Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(height: 40),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Email",
                        hintText: "Enter email",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Password",
                        hintText: "Enter password",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Name",
                        hintText: "Enter name",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: contactController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Contact",
                        hintText: "Enter close contact",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: checkxController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Address",
                        hintText: "Enter longitude coordination",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter longitude coordination';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: checkyController,
                      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        labelText: "Address",
                        hintText: "Enter latitude coordination",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                        hintStyle: const TextStyle(color: Color.fromARGB(88, 94, 90, 90)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter latitude coordination';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DefaultButton(
                  text: "Register",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        User? user = userCredential.user;

                        // save the email of the user in user_data collection
                        DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('user').doc(user?.uid);

                        await docRef.set({
                          'email': user?.email,
                          'role': "patient",
                          'name': nameController.text,
                          'contact': contactController.text,
                          'x': double.parse(checkxController.text),
                          'y': double.parse(checkyController.text),
                          'care': userId,
                          'latitude': 0,
                          'longitude': 0,
                          'timestamp': 0,
                          'sos': false,
                          'uid': user?.uid,
                        });

                        snackBar(context, 'Registered successfully');
                      } on FirebaseAuthException catch (e) {
                        snackBar(context, e.message!);
                      } catch (e) {
                        print(e);
                        snackBar(context, 'An error occurred. Please try again later.');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.register),
    );
  }
}
