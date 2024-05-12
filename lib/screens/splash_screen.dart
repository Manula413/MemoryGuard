import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Introduce a delay before navigating to SignInScreen()
    Timer(
      const Duration(seconds: 2), // Change the duration as needed
          () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo2.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
